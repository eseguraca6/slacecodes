function MTF = MTF(Lambda, F, f)
% MTF(Wavelengths, Focal_Ratio, Frequencies)
%
% Returns the diffraction limited monochromatic MTF for each of the wavelengths given (rows)
% and for each of the frequencies given (columns).
% 
% If the frequencies are given in cycles per millimetre, the wavelengths should also be in mm.
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

% Ensure F scalar, positive
F = abs(F(1));

% Now mesh the wavelengths and the frequencies
[x,y]=meshgrid(f, Lambda);
% Find frequencies above the cutoff

cutoffs = ones(size(Lambda,1),1)./(F * Lambda);
% For each row, set any frequencies exceeding cutoff to cutoff
for i=1:(size(Lambda,1))
    j = find(x(i,:) > cutoffs(i));
    x(i,j) = cutoffs(i);
end


% Compute Lambda * frequency * Focal_ratio for each site in the matrix
phi = acos(F * x.*y);
csphi = cos(phi) .* sin(phi);
MTF = 2.0 * (phi - csphi) / pi;


