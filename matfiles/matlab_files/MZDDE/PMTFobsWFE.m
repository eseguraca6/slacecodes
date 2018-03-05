function PMTF = PMTFobsWFE(Lambda, w, F, e, f, WFE)
% PMTFobsWFE : Computes polychromatic MTF for circular lens with circular central obscuration,
% taking account of wavefront errors.
%
% myPMTF = PMTFobsWFE(Wavelengths, Wavelength_Weights, Focal_Ratio, Obscuration_Ratio, Spatial_Frequencies, RMSWavefront_Errors)
%
% The call is as for the PMTFobs function, except that additionally the wavefront errors for each of
% the wavelengths must be specified.
% Wavelengths, Wavelength_Weights and RMSWavefront_Errors must be vectors of the same length.
% Focal_Ratio and Obscuration_Ratio must be scalars.
% Spatial frequencies must be expressed in the reciprocal units of the Wavelengths. i.e if
% Wavelengths are in mm, then the Spatial_Frequencies must be in cycles per mm.

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
els = size(WFE,1) * size(WFE,2);
if (els == size(WFE,2))
    WFE = WFE';
end
if (els ~= size(WFE,1))
    WFE = WFE(:,1);
end

% Similar for the weights
els = size(w,1) * size(w,2);
if (els == size(w,2))
    w = w';
end
if (els ~= size(w,1))
    w = w(:,1);
end
% wavefront errors, weights and wavelengths must be same length

if (length(Lambda) ~= length(WFE)) || (length(Lambda) ~= length(w))
    error('PMTFobsWFE:Wavelengths, weights and wavefront errors must be same length vectors');
end


% Next ensure frequencies are a row vector
els = size(f,1) * size(f,2);
if (els == size(f,1))
    f=f';
end
if (els ~= size(f,2))
    f=f(:,1);
end

% Ensure F, e scalar, positive
F = abs(F(1));
e = abs(e(1));

% Compute the monochromatic obscured MTFs
mMTFobs = MTFobs(Lambda, F, e, f);

% Compute the degradations due to wavefront errors
badness = ATF(Lambda, F, WFE, f);

% Apply the MTF degradation to the data
mMTFobs = mMTFobs .* badness;

% Create matrix of spectral weights from the vector by replication
Weights = repmat(w, 1, size(mMTFobs, 2));

% Weigh and sum over wavelengths
PMTF = sum(Weights .* mMTFobs, 1);

% Finally the result is normalised
PMTF = PMTF / max(PMTF);



