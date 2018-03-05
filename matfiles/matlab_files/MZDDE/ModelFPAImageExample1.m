% Test the ModelFPAImage function
% Set up the object

% $Author: DGriffith $
% $Revision: 221 $

clear Waves Obj Atm Lens FPA
Waves = [0.65 0.55 0.45];
%Waves = 0.55;

% Obj.Samples = imread('D:\Derek\Faces\yaleB07_P07A+000E+00.jpg');
% Obj.Pitch = 0.7; % mm per pixel

Obj.Samples = imread('D:\Surveillance\NumberPlates\ds_ef-aa212.jpg');
Obj.Pitch = 1.7; % mm per pixel
Obj.Range = 800; % metres

Atm.Radiance = [50 50 50]; % W/m^2/sr/nm Atmospheric path radiance

% Set up the lens
Lens.EFL = 1200; % mm
Lens.F = 8; % focal ratio
Lens.Trans = [1 1 1];
Lens.Obs = 0.3; % obscuration ratio
Lens.SmearRate = 35e-3; % 35 milliradians per second, say from aicraft at 80 knots, no FMC
Lens.SmearOrient = 45; % degrees
Lens.RMSJitter = 10e-3; % 10 mrad rms of jitter
%Lens.Defocus = 0.07; % mm

% Set up FPA parameters
FPA.PitchX = 0.0064; % mm
FPA.ApertureX = 0.0064; % 100% fill factor
% The sample origin is a number between 0 and 1 as a fraction
% of the FPA pixel pitch
FPA.OffsetX = 0.5; % Sample offset/origin in the X direction
FPA.OffsetY = 0.5;
FPA.ExpTime = 0.001; % seconds
FPA.ASR = [0.8 0.9 0.7]; % amperes per watt of incident light
%FPA.PRNU = 3; % This is the photo-response non-uniformity expressed as a percentage 
              % standard deviation of the absolute spectral response FPA.ASR
%FPA.PRNUSeed = 1000;
FPA.DarkCurrent = 5e-2; % amperes per pixel
FPA.StdevDarkCurr = 20; % percent
FPA.DarkCurrentSeed = 2000; % Seed for repeating the same FPN every call
%FPA.ReadoutNoise = 10; % 10 electrons RMS on-chip amplifier white noise
FPA.SpecIntegrate = 1; % Integrate over wavelength please
FPA.WellCapacity = 150000; % electrons pixel well capacity
FPA.DigitalResponse = 3; % electrons per digital number (DN)
Results = ModelFPAImage(Waves, Obj, Atm, Lens, FPA);
imagesc(abs(Results.FPASignal));
