function theMTF = MTFobs(Lambda, F, e, f)
% MTFobs(Wavelengths, Focal_Ratio, Obscuration_Ratio, Frequencies)
%
% Returns the diffraction limited monochromatic MTF for an annular (obscured) aperture 
% for each of the wavelengths given (rows)
% and for each of the frequencies given (columns).
% 
% If the frequencies are given in cycles per millimetre, the wavelengths should also be in mm.
% The obscuration ratio is the ratio of the radius of the obscuration to the radius of the aperture.
%
% See also : PMTFobs, MTF, PMTF
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

% First ensure wavelengths are a column vector
els = size(Lambda,1) * size(Lambda,2);
if (els == size(Lambda,2))
    Lambda = Lambda';
end
if (els ~= size(Lambda,1))
    Lambda = Lambda(:,1);
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

% if the obscuration ratio is zero, default to the ordinary MTF calculation
if e == 0
    theMTF = MTF(Lambda, F, f);
    return;
end

% Now mesh the wavelengths and the frequencies
[xi,lambda]=meshgrid(f, Lambda);

% Calculate w at each of the matrix sites
w = 2 * F * xi .* lambda;

theMTF = (ACCircle(1,w)- 2 * CCCircle(e,w) + ACCircle(e,w)) / (pi*(1-e^2));

