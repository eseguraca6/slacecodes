function PMTF = PMTFobs(Lambda, w, F, e, f)
% PMTFobs(Wavelengths, Wavelength_Weights, Focal_Ratio, Obscuration_Ratio, Spatial_Frequencies)
%
% Computes the polychromatic diffraction-limited MTF for the given wavelengths
% summed with the given weights for a diffraction-limited lens of the given focal 
% ratio and with a central obscuration of the given ratio. This computation is only valid
% for centred circular apertures and obscurations. Wavelengths must be given in inverse units
% of the spatial frequencies i.e. if wavelengths are in mm, then the frequencies must be given 
% in cycles per mm.
%
% Example : MyPMTFobs = PMTFobs([0.0005 0.0006], [1.0 0.8], 1, 0.5, [0:20:2000])
%           Computes polychromatic obscured MTF for wavelengths of 500nm and 600nm, weighted at
%           1 and 0.8 respectively, where the focal ratio is 1, the obscuration ratio is 50% and
%           where the modulation is computed for spatial frequencies of 0 to 2000 cycles per mm in
%           steps of 20 cycles per mm.
%
% See also : MTF, PMTF, MTFobs

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

% First ensure the wavlengths are a column vector
els = size(Lambda,1) * size(Lambda,2);
if (els == size(Lambda,2))
    Lambda = Lambda';
end
if (els ~= size(Lambda,1))
    Lambda = Lambda(:,1);
end
% Similar for the weights
els = size(w,1) * size(w,2);
if (els == size(w,2))
    w = w';
end
if (els ~= size(w,1))
    w = w(:,1);
end

% Ensure that weights and Lambda are same length
if size(w,1) < size(Lambda,1)
    w = cat(1, w, ones(size(Lambda,1)-size(w,1),1));
end
if size(w,1) > size(Lambda,1)
    w = w(1:1:size(Lambda,1));
end


% Compute the monochromatic obscured MTFs
mMTFobs = MTFobs(Lambda, F, e, f);

% Create matrix of weights
Weights = repmat(w, 1, size(mMTFobs, 2));

% Weigh and sum over wavelengths
PMTF = sum(Weights .* mMTFobs, 1);

% Finally the result is normalised
PMTF = PMTF / max(PMTF);
