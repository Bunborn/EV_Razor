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
%% HV Parameters
% Based on the A123 LiFePO4 26650 ANR26650M1B

%% Motor Parameters
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
