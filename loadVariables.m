%% Clear workspace
clear
clc
close all
%% Vehicle Parameters
igi0 = 7.0518; % Overall gear ratio
Cr = 0.011; % Rolling resistance coefficient
Cd = 0.23; % Aerodynamic drag coefficient
rd = 0.325; % wheel radius (rim and tire), m
mass = 2266.4; % mass (kg) - As calculated from chassis + system weights
Av = 2.37; % frontal area, m^2
TransaxleEff = 0.859; % Percentage
%% Environment Parameters
rho    = 1.20; % kg/m^3
g      = 9.81; % m/s^2
alpha  = 0; % grade %
%% HV Battery Parameters
% Based on the A123 LiFePO4 26650 ANR26650M1B
numCellsSeries = 203;
numCellsParallel = 40;
batteryCapacity = 64.96; % kwHr
initBatteryCapacity = 0.8499 * batteryCapacity; % kwHr
initSOC = initBatteryCapacity/batteryCapacity * 100; % Percentage
Coul_eff = 0.981; % Percentage - https://www.osti.gov/pages/servlets/purl/1409737
%% Inverter Parameters
% Based on the Rinehart RMS PM250DZ (800 V, 250 kW motor)
InvEff = 0.96; % Percentage - https://www.osti.gov/pages/servlets/purl/1409737
%% Generate Battery LUT
% Taken from the datasheet: Constant Power Discharge Characteristics at 23 C curve
DOD_BrkPts = [0, 5, 10, 20, 30, 40, 50, 60, 70, 80, 90, 95, 100];
discCurveV_20W = [3.33, 3.25, 3.22, 3.2, 3.19, 3.17, 3.155, 3.145, 3.12, 3.05, 2.72, 2.3, 2.0];
discCurveV_60W = [3.32, 3.08, 3.05, 3.03, 3.03, 3.015, 3.0, 2.975, 2.95, 2.9, 2.78, 2.55, 2.0];
discCurveV_100W = [3.31, 2.92, 2.89, 2.86, 2.86, 2.855, 2.84, 2.81, 2.8, 2.76, 2.7, 2.6, 2.0];
discCurveV_140W = [3.3, 2.76, 2.71, 2.7, 2.695, 2.69, 2.685, 2.67, 2.65, 2.64, 2.575, 2.35, 2.0];
discCurveV_180W = [3.3, 2.6, 2.51, 2.49, 2.5, 2.5, 2.5, 2.5, 2.52, 2.51, 2.37, 2.2, 1.9];
%% Motor Parameters
% Based on the Parker GVM210-300R
Max_Mot_Trq = 527; % Nm
Mot_Base_Spd = 415.11; % Rad/sec
Mot_Max_Spd = 837; % Rad/sec -This is the max continous speed, not peak spd
Mot_Peak_Power = 246000; % Watts
MotEff = 0.85; % Percent

Lambda_M = 0.2087; % Vs, Flux Linkage
Phase_Resistance = 0.045; % Ohms
Phase_Inductance = 0.55 / 1000; % H
NumPolePairs = 3; % Makes 6 poles!
%% Generate Motor Trq LUT
MotSpdBrkPts = linspace(0, Mot_Max_Spd, 100); % 100 Break Points
MotTrqPts = [];
for i = MotSpdBrkPts
    if i > Mot_Base_Spd % Power Limited
        TorqueVal = Mot_Peak_Power / i;
        if TorqueVal > Max_Mot_Trq % Saturate if above max trq val
            TorqueVal = Max_Mot_Trq;
        end
        MotTrqPts = [MotTrqPts, TorqueVal];
    else % Torque limited
        MotTrqPts = [MotTrqPts, Max_Mot_Trq];
    end
end
%% Generate Motor Eff LUT
% To calculate a LUT, basic it from the typical eff. plot from
% The BorgWarner hvh250-115
Eff_MotSpdBrkPts = linspace(0, Mot_Max_Spd, 5); % 5 Break Points
Eff_MotTrqBrkPts = linspace(0, Max_Mot_Trq, 5); % 5 Break Points
% Each row corresponds to a speed break point
Eff_MotorMap = [0.74, 0.74, 0.74, 0.74, 0.74; ...
    0.74, 0.958, 0.94, 0.9, 0.89; ...
    0.74, 0.958, 0.958, 0.92, 0.88; ...
    0.74, 0.935, 0.9, 0.5, 0.5; ...
    0.74, 0.9, 0.5, 0.5, 0.5];
