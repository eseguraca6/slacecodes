function SpectralRadiance = IntSphere(SpectralFlux, SphereDia, PortAreas, InitialReflectance, PortReflectance, SphereReflectance, Wavelengths, Interp)
% Compute the spectral radiance of an integrating sphere.
% 
% Usage : SpectralRadiance = IntSphere(SpectralFlux, SphereDia, PortAreas, InitialReflectance, PortReflectance, SphereReflectance, Wavelengths, Interp)
%
% SpectralRadiance is the spectral radiance of the sphere in units of watts per steradian per square centimetre per micron of wavelength.
% SpectralFlux is the radiant spectral flux injected into the sphere in units of Watts per micron of wavelength.
% SphereDia is the diameter of the sphere in cm.
% PortAreas is a row vector of the areas of the input and output ports in square cm.
% InitialReflectance is the spectral reflectance of the surface which diffuses the flux into the sphere (possibly the inner sphere surface itself).
% PortReflectance is an array (one column per port) of port reflectances for all input and output ports in the same order as
% in the PortAreas vector.
% SphereReflectance is the spectral reflectance of the general interior of the sphere. If SphereReflectance has a single row,
% then the relectance is assumed to have this value across the entire spectral band.
% Wavelength is a column vector of wavelengths at which to compute SpectralRadiance given in microns.
% Interp is the method to use for interpolation of values. The options are 
% 'nearest' - Nearest neighbor interpolation
% 'linear' - Linear interpolation (default)
% 'spline' - Cubic spline interpolation
% 'pchip' - Piecewise cubic Hermite interpolation
% 'cubic' - (Same as 'pchip')
% 'v5cubic' - Cubic interpolation used in MATLAB 5
% See interp1.
%
% Except for PortAreas, all input parameters must be supplied with associated wavelength data in microns in the first column.
% All wavelength data must be monotonically increasing.
% 
% The output data will be computed at the wavelengths given in the Wavelengths vector, which must be a column vector.
% The wavelength data for all input parameters must span the range of the output Wavelengths, otherwise an error is
% generated.
%
% Reference : Integrating Sphere Radiometry and Photometry, Labsphere Corporation, http://www.labsphere.com

%% Copyright 2002-2009, DPSS, CSIR
% This file is subject to the terms and conditions of the BSD Licence.
% For further details, see the file BSDlicence.txt
%
% Contact : dgriffith@csir.co.za
% 
% 
%
%
%


% $Revision: 221 $

if ~isscalar(SphereDia)
    error('IntSphere:SphereDiaNotScalar','SphereDia must be scalar.');
end

As = 4 * pi * (SphereDia/2)^2; % Compute the surface area of the inside of the sphere in square centimetres.

% Check integrity of Wavelengths input parameter
numWaves = length(Wavelengths);
if size(Wavelengths,1) ~= numWaves
    error('IntSphere:WavesNotCol','Wavelengths must be a column vector.');
end
if min(diff(Wavelengths)) <= 0
    error('Wavelengths must be monotonically increasing.')
end
minWave = Wavelengths(1);
maxWave = Wavelengths(numWaves);

% Check integrity of SpectralFlux input parameter
sizeSpectralFlux = size(SpectralFlux);
if sizeSpectralFlux(2) ~= 2
    error('SpectralFlux input must have 2 columns.');
end
minSFWave = SpectralFlux(1,1);
numSFWaves = sizeSpectralFlux(1);
maxSFWave = SpectralFlux(numSFWaves,1);
if min(diff(SpectralFlux(:,1))) <= 0
    error('Spectral Flux Wavelengths must be monotonically increasing.');
end
if (minSFWave > minWave) || (maxSFWave < maxWave)
    error('Spectral Flux Wavelengths must span Wavelengths.');
end


% Check integrity of PortAreas input parameter
numPorts = length(PortAreas);
if size(PortAreas,2) ~= numPorts
    error('Port Areas must be a row vector.');
end

% Check integrity of InitialReflectance input parameter
sizeIReflectance = size(InitialReflectance);
if sizeIReflectance(2) > 2
    error('InitialReflectance may not have more than two columns');
end
if any(InitialReflectance(:,2) > 1) || any(InitialReflectance(:,2) < 0)
    error('Reflectance values must be from 0 to 1.');
end

if sizeIReflectance(2) == 2 % There is wavelength data
    % Check the wavelength data
    numIRWaves = sizeIReflectance(1);
    minIRWave = InitialReflectance(1,1);
    maxIRWave = InitialReflectance(numIRWaves,1);
    if min(diff(InitialReflectance(:,1))) <= 0
      error('Initial Reflectance Wavelengths must be monotonically increasing.');
      return;
    end
    if (minIRWave > minWave) || (maxIRWave < maxWave)
      error('Initial Reflectance Wavelengths must span Wavelengths.');
    end
else % There is no wavelength data
    error('There must be two columns in Initial Reflectance');
end

% Check integrity of PortReflectance input parameter
sizePReflectance = size(PortReflectance);
if sizePReflectance(2) > (numPorts + 1)
    error('PortReflectance may not have more columns than (number of ports + 1)');
end
if any(PortReflectance(:,2) > 1) || any(PortReflectance(:,2) < 0)
    error('Port Reflectance values must be from 0 to 1.');
end
if sizePReflectance(2) == (numPorts + 1) % There is wavelength data
    % Check the wavelength data
    numPRWaves = sizePReflectance(1);
    minPRWave = PortReflectance(1,1);
    maxPRWave = PortReflectance(numPRWaves,1);
    if min(diff(PortReflectance(:,1))) <= 0
      error('Port Reflectance Wavelengths must be monotonically increasing.');
    end
    if (minPRWave > minWave) || (maxPRWave < maxWave)
      error('Port Reflectance Wavelengths must span Wavelengths.');
    end
else
    error('Insufficient columns in Port Reflectance data to match number of ports.');
end

% Check integrity of SphereReflectance input parameter
sizeSReflectance = size(SphereReflectance);
if sizeSReflectance(2) > 2
    error('SphereReflectance may not have more than two columns');
end
if any(SphereReflectance(:,2) > 1) || any(SphereReflectance(:,2) < 0)
    error('Reflectance values must be from 0 to 1.');
end
if sizeSReflectance(2) == 2 % There is wavelength data
    % Check the wavelength data
    numSRWaves = sizeSReflectance(1);
    minSRWave = SphereReflectance(1,1);
    maxSRWave = SphereReflectance(numSRWaves,1);
    if min(diff(SphereReflectance(:,1))) <= 0
      error('Sphere Reflectance Wavelengths must be monotonically increasing.');
    end
    if (minSRWave > minWave) || (maxSRWave < maxWave)
      error('Sphere Reflectance Wavelengths must span Wavelengths.');
    end
else % There is no wavelength data
    error('There must be two columns in Sphere Reflectance');
end

% Resample everything to output Wavelengths
% Rely on error checking of interp1 to check Interp value - know this does not always work, but the default is 'linear'
SFlux = interp1(SpectralFlux(:,1), SpectralFlux(:,2), Wavelengths, Interp); % Resample Spectral flux
IReflectance = interp1(InitialReflectance(:,1), InitialReflectance(:,2), Wavelengths, Interp);
PReflectance = interp1(PortReflectance(:,1), PortReflectance(:,2:end), Wavelengths, Interp);
SReflectance = interp1(SphereReflectance(:,1), SphereReflectance(:,2), Wavelengths, Interp);

f = PortAreas / As; % fractional port areas

Ones = ones(numWaves,1); % Simplifies following expression

Mden = Ones - SReflectance .* ((1 - sum(f)) * Ones) - sum(PReflectance .* repmat(f,numWaves,1),2); % Denominator of the M factor (sphere multiplier)

M = IReflectance ./ Mden; % Calculater sphere multiplier - this is very sensitive to f and reflectances

SpectralRadiance = M .* SFlux / (pi * As); % All done

