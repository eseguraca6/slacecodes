function ASR = SQEtoASR(SQE)
% SQEtoASR : Converts detector spectral quantum efficiency to absolute spectral response.
%
% Usage example : 
% >> ASR = SQEtoASR(SQE);
% Where the input is the spectral quantum efficiency (SQE) and the output is the
% absolute spectral response in amperes per watt.
% Spectral quantum efficiency is a number from 0 to 1 that quantifies the fraction of
% photons incident on the detector that are converted to photoelectrons.
% The absolute spectral response (ASR) of a detector is given in amperes per watt of
% incident optical power.
% The input SQE must be a two column matrix with wavelength in the first column and
% spectral quantum efficiency (in the range 0 to 1) in the second column. The wavelength
% should be given in microns, but if the wavelengths given exceed the value 25, then they
% are assumed to be given in nanometres.
%
% The conversion is performed through the Planck relation
% E = h * nu
% Where E is the photon energy, h is planck's constant and nu is the
% optical frequency of the photon.
% In terms of optical wavelength in a vacuum, the Planck relation is
% E = h * c / lambda
% Where c is the speed of light and lambda is the wavelength.
%
% See also : ASRtoSQE
%

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

waves = SQE(:,1); % First column

if (size(SQE,2) ~= 2) || (min(SQE(:,2)) < 0) || (max(SQE(:,2)) > 1) || any(waves <= 0)
    error('SQEtoASR:SQE must have two columns with positive wavelength in first column and quantum efficiency (0 to 1) in second column.');
end


h = 6.626069311e-34; % planck's constant in Joule seconds
c = 299792458;  % speed of light in metres per second
e = 1.6021765314e-19; % charge on electron in coulombs


if max(waves) > 25
    waves = waves * 1e-9; % Assume waves are in nanometres and convert to metres
else
    waves = waves * 1e-6; % Assume waves are in microns and convert to metres
end

% Get the quantum energy at the given wavelengths

E = h * c ./ waves;

% Consider an optical power of 1 W, then photocurrent is QE / E (electrons per second)

ASR(:,1) = SQE(:,1); % Wavelengths are returned in original units
photocurrent = SQE(:,2) ./ E; % electrons per second per watt of optical power

% Convert current to amperes by multiplying by the charge on the electron
ASR(:,2) = photocurrent * e;

