function ESF = ESF(Lambda, F, x)
% ESF(Wavelengths, Focal_Ratio, X-Coordinates)
%
% Computes the monochromatic diffraction-limited edge spread function at
% the given wavelengths (rows) at the coordinates given by x.
% x (a vector) can be computed at any values, but must have the same units as the wavelength.
% Lambda (the wavelengths at which to compute the ESF) must be a vector, and F (the focal ratio) must be a positive scalar.
%
% The ESF is computed using a numerical implementation of the Generalized Hypergeometric Function (see genHyper.m).
% The returned matrix has Lambda varying from row to row and x varying along the columns.

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

% The genHyper routine diverges at large values. This routine is only valid for abs(ux) < 256

% Ensure that Lambda is a column vector

els = size(Lambda,1) * size(Lambda,2);
if (els == size(Lambda,2))
    Lambda = Lambda';
end
if (els ~= size(Lambda,1))
    Lambda = Lambda(:,1);
end

% Ensure that x is a row vector
els = size(x,1) * size(x,2);
if (els == size(x,2))
    x = x';
end
if (els ~= size(x,1))
    x = x(:,1);
end

% Ensure F scalar, positive
F=abs(F(1));


% Mesh the wavelength and the x-coordinates
[X,L] = meshgrid(x,Lambda);

% Compute (half) the argument to the Struve Function
ux = pi * X ./ (F * L);

% Find any places where the argument is zero, avoid evaluating genHyper at 0
i = find(ux==0);
ux(i)=.1;

% Compute the Hypergeometric Function
ESF = zeros(size(ux));

% Unfortunately, the genHyper.m routine is not vectorized, so we have to call it
% for each site in the ux matrix. This may require some patience.
for ii=1:size(ux,1)
    for jj=1:size(ux,2)
        if abs(ux(ii,jj))>256
            ESF(ii,jj)=sign(ux)*0.5 + 0.5;
        else
            ESF(ii,jj) = 2 * ux(ii,jj) * genHyper([1,1/2],[3/2,3/2,5/2],-ux(ii,jj)^2)/(pi * sqrt(pi) * gamma(5/2)) + 0.5;
        end
    end
end

% Fill in values at ux=0
ESF(i) = 0.5;
