function Planck = Planck(wv, T)
% Planck(Wavelength, Temperature)
%
% Returns spectral radiance of a Black Body
% in watts per square centimetre per steradian per micron of spectral bandwidth
% Parameters are wavelength and temperature
% Wavelength is in microns
% Temperature is in Kelvins (Celsius + 273)
% Both wavelength and temperature can be vectors.
% 
% Returns a matrix with wavelength varying from row to row and T varying from column to column
% 
% See Also : dPlanckdT

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

% Now compute the black body data set
Planck = 1.191066e4 * ones(size(wv)) ./ (wv .^ 5 .* (exp(1.43879e4 * ones(size(wv)) ./ (wv .* T)) - 1));

% Duarte's expression L = 1.191066e4*ones(size(lambda))./(lambda.^5.*(exp(1.43883e4*ones(size(lambda))./(lambda*T)) - 1));
