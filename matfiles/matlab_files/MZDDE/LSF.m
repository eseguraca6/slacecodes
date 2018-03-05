function LSF = LSF(Lambda, F, x)
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

% Have dumped the old routine that was wrong - use the Struve Function instead
LSF = LSFStruve(Lambda,F,x);
