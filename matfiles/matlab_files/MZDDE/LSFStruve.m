function LSF = LSFStruve(Lambda, F, x)
% LSFStruve(Wavelengths, Focal_Ratio, X-Coordinates)
%
% Computes the monochromatic diffraction-limited line spread function at
% the given wavelengths (rows) at the coordinates given by x.
% x (a vector) can be computed at any values, but must have the same units as the wavelength.
% Lambda (the wavelengths at which to compute the LSF) must be a vector, and F (the focal ratio) must be a positive scalar.
%
% The LSF is computed using a numerical implementation of the Struve Function (see Struve1.m).
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

% The struve function divided by half the square of it's argument converges to 8/(3*pi) as the argument tends to zero.

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

% Find any places where the argument is zero
i = find(ux==0);
% Replace with any finite value.
ux(i) = 1;

% Compute the Struve Function
LSF = Struve1(2 * ux) ./ (ux .^2);

% Replace values at zero with the limit
LSF(i) = 8/(3*pi);

% Normalize
LSF = 3 * pi * LSF /8;
