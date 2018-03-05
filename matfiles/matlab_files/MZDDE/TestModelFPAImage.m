% Test the ModelFPAImage function
% Set up the object

clear Waves Obj Atm Lens FPA
%Waves = [0.45 0.55 0.65];
Waves = 0.55;

Obj.Samples = imread('D:\Derek\Faces\yaleB07_P07A+000E+00.jpg');
Obj.Pitch = 0.7; % mm per pixel

%Obj.Samples = imread('D:\Derek\NumberPlates\ds_ef-aa212.jpg');
%Obj.Pitch = 1.7; % mm per pixel
Obj.Range = 800; % metres

Atm = []; % Don't consider any atmospheric effects

% Set up the lens
Lens.EFL = 1200; % mm
Lens.F = 8; % focal ratio
Lens.Obs = 0.3; % obscuration
Lens.SmearRate = 35e-3; % 35 milliradians per second, say from aicraft at 80 knots, no FMC
Lens.SmearOrient = 45; % degrees
Lens.RMSJitter = 10e-3; % 10 mrad of jitter

% Set up FPA parameters
FPA.PitchX = 0.0064;
FPA.ApertureX = 0.0064; % 100% fill factor
% The sample origin is a number between 0 and 1 as a fraction
% of the FPA pixel pitch
FPA.OffsetX = 0.5; % Sample offset/origin in the X direction
FPA.OffsetY = 0.5;
FPA.ExpTime = 0.001; % 1 millisecond


[I1, I2] = ModelFPAImage(Waves, Obj, Atm, Lens, FPA);
I1 = I1/max(max(max(I1)));
I2 = I2/max(max(max(I2)));

