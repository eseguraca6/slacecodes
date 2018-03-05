% Calculate the relative spectral radiance of an integrating sphere.
% The "relative spectral radiance" of the sphere is understood to mean the
% spectral radiance of the exit port relative to the spectral flux injected
% into the sphere. The units of relative spectral radiance are /cm^2/sr.
% The relative spectral radiance can be computed by injecting 1 W/micron of
% spectral flux across the whole spectrum and then computing the output 
% spectral radiance of the sphere.

% This file is subject to the conditions of the BSD Licence. See the file
% BSDlicence.txt for further details.

% $Author: DGriffith $
% $Id: IntSphereExample1.m 221 2009-10-30 07:07:07Z DGriffith $
% %Revision:$

% Assume the sphere is made of Spectralon (sintered PTFE aka "Teflon")
[ThePath TheFile] = fileparts(which('IntSphere')); % Find MZDDE installation
load([ThePath '\Materials\Spectralon.mat']); % load Spectralon reflectivity data


% There are 11 samples of the Spectralon reflectivity - take the mean of
% all 11.
SpectralonReflectivity = mean(SpectralonReflectivity')'/100; % data was given as percentage
% The wavelength for the spectralon reflectivity are in the variable
% SpectralonWavelengths

% Define the wavelength region
minWv = 0.4; % microns
maxWv = 2.4; % microns
% The sphere has a diameter of 5 cm
SphereDia = 5; % cm
% There is one entrance port of diameter 1 cm, and one exit port of
% diameter 2 cm. The reflectivity of the ports is zero.
InputPortDia = 1; % cm
OutputPortDia = 2; % cm

% Radiant and reflectance quantities must be specified as two columns with
% wavelength (in microns) in the first column and the radiant or
% reflectance quantity in the second column.

% The initial reflectance is reflectance of the first surface seen by the
% injected flux - assume this is spectralon as well
InitialReflectance = [SpectralonWavelengths SpectralonReflectivity];
% Rest of sphere is also Spectralon.
SphereReflectance = [SpectralonWavelengths SpectralonReflectivity];

SpectralFlux = [minWv 1; maxWv 1]; % Uniform spectral flux over entire wavelength region
PortAreas = pi * ([InputPortDia OutputPortDia]./2).^2; % approximate areas of the ports in cm^2

% Ports both have zero reflectivity over the whole band
PortReflectance = [minWv 0 0; maxWv 0 0]; 

% The wavelengths at which the result is desired are defined next
WavelengthStep = 0.01; % microns
Wavelengths = [minWv:WavelengthStep:maxWv]';
Interp = 'linear'; % Use linear interpolation


% Here follows the call to IntSphere to compute the relative radiance
RelSpectralRadiance = IntSphere(SpectralFlux, SphereDia, PortAreas, InitialReflectance, ...
                                PortReflectance, SphereReflectance, Wavelengths, Interp);
   
% Convert relative spectral radiance to /m^2 instead of /cm^2
RelSpectralRadiance = RelSpectralRadiance * 10000; % there are 10000 cm^2 in 1 m^2
                            
% Plot the relative spectral radiance of the sphere
figure;
plot(Wavelengths, RelSpectralRadiance);
grid
title('Relative Spectral Radiance of 5 cm Spectralon Integrating Sphere');
xlabel('Wavelength (\mum)');
ylabel('Relative Spectral Radiance (/m^2/sr)');


