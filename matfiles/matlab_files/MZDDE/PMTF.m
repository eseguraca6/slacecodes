function PMTF=PMTF(Lambda, w, F, f)
% PMTF(Wavelengths, Wavelength_Weights, Focal_Ratio, Spatial_Frequencies)
%
% Computes the polychromatic diffraction-limited MTF for the given wavelengths
% summed with the given weights.

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


% Compute the monochromatic MTFs
mMTF = MTF(Lambda, F, f);

% Create matrix of weights
Weights = repmat(w, 1, size(mMTF,2));

% Weigh and sum over wavelengths
PMTF = sum(Weights .* mMTF,1);

% Finally the result is normalised
PMTF = PMTF / max(PMTF);
