%% Vehicle Parameters
igi0 = 7.0518; % Overall gear ratio
Cr = 0.011; % Rolling resistance coefficient
Cd = 0.23; % Aerodynamic drag coefficient
rd = 0.325; % wheel radius (rim and tire), m
mass = 1757.67; % mass (kg)
Av = 2.37; % frontal area, m^2
%% Environment Parameters
rho    = 1.20; % kg/m^3
g      = 9.81; % m/s^2
alpha  = 0; % grade %
%% HV Battery Parameters
% Based on the A123 LiFePO4 26650 ANR26650M1B

%% Generate Battery LUT
% Taken from the datasheet: Constant Power Discharge Characteristics at 23 C curve
DOD_BrkPts = [0, 5, 10, 20, 30, 40, 50, 60, 70, 80, 90, 95, 100];
%SOC_BrkPts = [100, 95, 90, 80, 70, 60, 50, 40, 30, 20, 10, 5, 0];
discCurveV_20W = [3.4, 3.25, 3.22, 3.2, 3.19, 3.17, 3.155, 3.145, 3.12, 3.05, 2.72, 2.3, 2.0];
discCurveV_60W = [3.4, 3.08, 3.05, 3.03, 3.03, 3.015, 3.0, 2.975, 2.95, 2.9, 2.78, 2.55, 2.0];
discCurveV_100W = [3.4, 2.92, 2.89, 2.86, 2.86, 2.855, 2.84, 2.81, 2.8, 2.76, 2.7, 2.6, 2.0];
discCurveV_140W = [3.4, 2.76, 2.71, 2.7, 2.695, 2.69, 2.685, 2.67, 2.65, 2.64, 2.575, 2.35, 2.0];
discCurveV_180W = [3.3, 2.6, 2.51, 2.49, 2.5, 2.5, 2.5, 2.5, 2.52, 2.51, 2.37, 2.2, 1.9];
% Based on the Parker GVM210-300R
Max_Mot_Trq = 527; % Nm
Mot_Base_Spd = 415.11; % Rad/sec
Mot_Max_Spd = 837; % Rad/sec
Mot_Peak_Power = 246000; % Watts
MotEff = 0.95; % Percent

Lambda_M = 0.125; % Vs, Flux Linkage
Phase_Resistance = 0.04; % Ohms
Phase_Inductance = 0.5; % mH
NumPoles = 6; % Makes 3 pole pairs!
%% Generate Motor LUT
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
