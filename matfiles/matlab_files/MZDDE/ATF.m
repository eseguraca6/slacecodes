function ATF = ATF(Lambda, F, RMSWFE, f)
% ATF - Compute the MTF degradation factor for a lens operating at the given wavelengths with the
% given RMS wavefront error at each of the wavelengths. 
%
% MyATF = ATF(Wavelenths, FocalRatio, RMSWavefrontError, SpatialFrequencies)
% 
% Wavelength dependency goes down rows, while spatial frequency varies across columns.
%
% Example : MyATF = ATF([0.0005 0.0006], 1, [0.12 0.15], 0:10:2000);   % Computes the MTF degradation factors for
% wavelengths of 500nm and 600nm where the RMS wavefront errors are 0.12 and 0.15 waves
% respectively. The focal ratio is 1. The spatial frequencies must also be given in reciprocal units to the wavelengths.
% i.e. if the wavelengths are in mm, the frequencies must be in cycles per mm.
%
% Reference : Shannon, R.R., Handbook of Optics, Volume 1, 2nd Edition, Chapter 35 - Optical
% Specifications. "This is an appoximation, however, and it becomes progressively less accurate as
% the amount of the rms wavefront error exceeds about 0.18 wavelength."
%
% See also : PMTFobsWFE
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

% Copyright 2006, DPSS, CSIR
% $Revision: 221 $

% First ensure wavelengths are a column vector
els = size(Lambda,1) * size(Lambda,2);
if (els == size(Lambda,2))
    Lambda = Lambda';
end
if (els ~= size(Lambda,1))
    Lambda = Lambda(:,1);
end

% Ensure wavefront errors are also a column vector
els = size(RMSWFE,1) * size(RMSWFE,2);
if (els == size(RMSWFE,2))
    RMSWFE = RMSWFE';
end
if (els ~= size(RMSWFE,1))
    RMSWFE = RMSWFE(:,1);
end
% Force positive
RMSWFE = abs(RMSWFE);

% This computation only valid up to about 0.3 RMS wavefront error (see Shannon)
if max(RMSWFE) > 0.3
    warning('ATF:This computation is only valid up to RMS wavefront error of about 0.3.');
end

% wavefront errors and wavelengths must be same length

if length(Lambda) ~= length(RMSWFE)
    error('ATF:Wavelength and wavfront errors must be same length vectors');
end

% Next ensure frequencies are a row vector
els = size(f,1) * size(f,2);
if (els == size(f,1))
    f=f';
end
if (els ~= size(f,2))
    f=f(:,1);
end

% Ensure F scalar, positive
F = abs(F(1));

% Find the cutoff frequencies at all wavelengths
cutoff = 1./(F .* Lambda);

% Replicate the cutoff frequencies for all spatial frequencies
cutoff = repmat(cutoff, 1, length(f));

% Replicate the frequencies for all wavelengths
f = repmat(f, length(Lambda), 1);

% Compute the spatial frequencies as a fraction of the cutoff
nu = f ./ cutoff;

% Replicate the wavelengths for all spatial frequencies
lambda = repmat(Lambda, 1, size(nu, 2));

% Expand the RMSWFE to the same size by replication along columns
RMSWFE = repmat(RMSWFE, 1, size(nu, 2));

% Finally, compute the ATF according to Shannon
ATF = 1 - ((RMSWFE / 0.18).^2) .* (1 - 4 * (nu - 0.5).^2);

% Clobber values above 1
ATF(ATF > 1) = 1.0;

% Clobber values below zero
% Decided to take this out - values below 0 may be representative of phase reversal
% ATF(ATF < 0) = 0.0;
