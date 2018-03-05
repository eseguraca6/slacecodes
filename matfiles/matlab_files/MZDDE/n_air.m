function n_air = n_air(lambda, T, P)
% n_air(lambda, T, P) returns the refractive index of air computed using the same formula used by ZEMAX
% See the section on Index of Refraction Computation in the Thermal Analysis chapter of the ZEMAX manual.
% 
% lambda is wavelength in microns.
% T is temperature in Celsius.
% P is relative air pressure.
% This function returns a matrix with lambda varying from row to row, temperature varying from column to column
% and pressure varying in the depth dimension.
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

% Meshgrid the data 
[T, lambda, P] = meshgrid(T, lambda, P);

% Compute the reference refractive indices across the wavelengths
n_ref = 1 + (6432.8 + (2949810 * lambda.^2) ./ (146 * lambda.^2 - 1) + (25540 * lambda.^2) ./ (41 * lambda.^2 - 1)) * 1e-8;

% Finally, compute the full (potentially 3D) data set
n_air = 1 + ((n_ref - 1) .* P) ./ (1 + (T - 15) * 3.4785e-3);
