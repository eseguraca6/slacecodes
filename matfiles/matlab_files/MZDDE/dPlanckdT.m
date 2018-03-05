function dPdT = dPlanckdT(wv, T)
% dPlanckdT(Wavelength, Temperature)
%
% Returns partial derivative of spectral radiance of a Black Body with
% respect to temperature.
% Output is in watts per square centimetre per steradian per micron of 
% spectral bandwidth per degree kelvin.
% Parameters are wavelength and temperature
% Wavelength is in microns
% Temperature is in Kelvins (Celsius + 273)
% Both wavelength and temperature can be vectors.
% 
% Returns a matrix with wavelength varying from row to row and T varying from column to column
% 
% See Also : Planck

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


if ~isvector(wv) || ~isvector(T) || ~isnumeric(wv) || ~isnumeric(T)
    error('dPlanckdT: Inputs wavelength and temperature must be numeric scalar or vector.');
end

% First meshgrid the data
[T,wv] = meshgrid(T,wv);
C1 = 1.191066e4 * ones(size(wv));
C2 = 1.43879e4 * ones(size(wv));
% Now compute the black body data set
% Planck = C1 ./ (wv .^ 5 .* (exp(C2 ./ (wv .* T)) - 1));

% Compute the derivative
dPdT = C1 .* C2 .* exp(C2 ./ (wv .* T)) ./ ((wv.^6 .* T.^2) .* (exp(C2 ./ (wv .* T)) - 1).^2);

% Duarte's expression L = 1.191066e4*ones(size(lambda))./(lambda.^5.*(exp(1.43883e4*ones(size(lambda))./(lambda*T)) - 1));
