function PPSF = PPSF(Lambda, w, F, r, e)
% PPSF(Wavelengths, Wavelength_Weights, Focal_Ratio, Radial_Image_Coordinates, Central_Obscuration_Ratio)
%
% Computes the polychromatic Diffraction Point Spread Function for a number of wavelengths, weights and radial image coordinates.
% The radial image coordinate will be in the same length units as that used for the wavelength.
% The focal ratio is the ratio of the focal length to the lens diameter.
% The central obscuration ratio is the ratio of the diameter of the central obscuration to the total clear diameter.
%
% A matrix is returned with the results corresponding to varying radial image coordinate along the columns,
% and the results corresponding to varying wavelength along the rows.

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


% First compute all the monochromatic PSFs

mPSF = PSF(Lambda, F, r, e);

% Now weigh and sum the results down the rows

% First check that the size of Lambda and w is good
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

if size(w,1) < size(Lambda,1)
    w = cat(1, w, ones(size(Lambda,1)-size(w,1),1));
end

if size(w,1) > size(Lambda,1)
    w = w(1:1:size(Lambda,1));
end

% Create matrix of weights
Weights = repmat(w, 1, size(mPSF,2));

% Weigh and sum over wavelengths
PPSF = sum(Weights .* mPSF, 1);

% Finally the result is normalised
PPSF = PPSF / max(PPSF);

