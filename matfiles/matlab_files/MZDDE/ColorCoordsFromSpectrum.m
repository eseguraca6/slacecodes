function [coord1, coord2, coord3] = ColorCoordsFromSpectrum(Wv, Spectrum, WhichType)
% ColorCoordsFromSpectrum : Compute color coordinates from spectrum
%
% Usage :
%  >> [coord1, coord2, coord3] = ColorCoordsFromSpectrum(Wavelengths, Spectrum)
%  >> [coord1, coord2, coord3] = ColorCoordsFromSpectrum(Wavelengths, Spectrum, WhichType)
% Where :
%   Wavelengths are the wavelengths at which the spectrum is given.
%     This must be a vector of wavelengths in nm.
%   Spectrum is the relative power spectrum.
%   WhichType is the set of color matching functions to use and color space
%     in which to return the result. Currently the only options are
%       CIE2XYZ    - returns integrals over CIE 2 degree observer in XYZ color space
%              The above is the default if WhichType is not given
%       CIE10XYZ   - returns integrals over CIE 10 degree observer in XYZ color space
%       CIE2xyY    - returns 2 degree observer in xyY space
%       CIE10xyY   - returns 10 degree observer in xyY space
%  CIE 1960 uv color space http://en.wikipedia.org/wiki/CIE_1960_color_space
%       CIE2uv     - returns CIE 1960 uv coordinates (2 deg) 
%       CIE10uv    - returns CIE 1960 uv coordinates (10 deg)
%
% Examples :
%   See ColorCoordsFromSpectrumExample1.m

%% Copyright 2002-2009, DPSS, CSIR
% This file is subject to the terms and conditions of the BSD Licence.
% For further details, see the file BSDlicence.txt
%
% Contact : dgriffith@csir.co.za
% 
% 
%
%


% $Date: 2009-10-30 09:07:07 +0200 (Fri, 30 Oct 2009) $
% $Revision: 221 $
% $Author: DGriffith $

%% Load CIE data if not already loaded
% The following CIE variables are required, only load them if not populated already
persistent CIExyzLambda CIEx10 CIEy10 CIEz10 CIEx2 CIEy2 CIEz2

% Check if need to load CIE variables
if isempty(CIExyzLambda) % could choose any one of the variables
    ReadCIE; % load all CIE stuff
end

%% Perform some input checking
if ~exist('Wv', 'var') || ~isfloat(Wv) || ~isvector(Wv) || min(Wv) > max(CIExyzLambda) || max(Wv) < min(CIExyzLambda)
    error('ColorCoordsFromSpectrum:BadWaves', ['Wavelengths input parameter must be floating point vector\n' ...
          ' which overlaps the photometric range of 380 nm to 780 nm']);
end
Wv = Wv(:); % Force to column vector

if ~exist('Spectrum', 'var') || ~isfloat(Spectrum) || size(Spectrum,1) ~= length(Wv)
    error('ColorCoordsFromSpectrum:BadSpectrum', ['Spectrum input quantity must be a floating point matrix\n' ...
          ' in which the number of rows is equal to the length of the Wavelengths input vector.']);
end

if ~exist('WhichType', 'var')
    WhichType = 'CIE2XYZ';
elseif ~ischar(WhichType)
    error('ColorCoordsFromSpectrum:BadType', 'WhichType input parameter must be char naming the matching functions.')
    
end

% The approach is to merge the wavelengths in the input with the CIE wavelength, sort the resulting matrix
% on wavelength, and then perform the integration. Linear interpolation is used, and extrapolation
% values are assumed to be zero.
switch WhichType
    case {'', 'CIE2xyY', 'CIE2XYZ', 'CIE2uv'}
        MatchWv = CIExyzLambda; % Must be a column vector
        Match1 = CIEx2;
        Match2 = CIEy2;
        Match3 = CIEz2;
    case {'CIE10xyY', 'CIE10XYZ', 'CIE10uv'}
        MatchWv = CIExyzLambda; % Must be a column vector
        Match1 = CIEx10;
        Match2 = CIEy10;
        Match3 = CIEz10;
    otherwise
        error('ColorCoordsFromSpectrum:BadType', ['Unknown matching functions WhichType = ' WhichType]);
end

% Interpolate the values of the input spectrum onto the matching function wavelengths
% Duplicate the wavelengths to the same number of columns as the spectrum input
Match1AtSpectrumWv = interp1(MatchWv, Match1, Wv, 'linear', 0);
Match2AtSpectrumWv = interp1(MatchWv, Match2, Wv, 'linear', 0);
Match3AtSpectrumWv = interp1(MatchWv, Match3, Wv, 'linear', 0);

if length(Wv) == 1 % If a single wavelength, simply return the matching function values at that wavelength
    c1 = Match1AtSpectrumWv * Spectrum;
    c2 = Match2AtSpectrumWv * Spectrum;
    c3 = Match3AtSpectrumWv * Spectrum;
else

    SpectrumAtMatchWv = interp1(Wv, Spectrum, MatchWv,  'linear', 0);
    % Duplicate the columns of the matchine functions data for both wavelength sets

    Match1 = repmat(Match1, 1, size(Spectrum,2));
    Match2 = repmat(Match2, 1, size(Spectrum,2));
    Match3 = repmat(Match3, 1, size(Spectrum,2));

    Match1AtSpectrumWv = repmat(Match1AtSpectrumWv, 1, size(Spectrum, 2));
    Match2AtSpectrumWv = repmat(Match2AtSpectrumWv, 1, size(Spectrum, 2));
    Match3AtSpectrumWv = repmat(Match3AtSpectrumWv, 1, size(Spectrum, 2));

    % Compute the colorimetric data by multiplying the matching function data by the spectrum
    c1 = [Match1AtSpectrumWv .* Spectrum; Match1 .* SpectrumAtMatchWv];
    c2 = [Match2AtSpectrumWv .* Spectrum; Match2 .* SpectrumAtMatchWv];
    c3 = [Match3AtSpectrumWv .* Spectrum; Match3 .* SpectrumAtMatchWv];

    % The colorimetric data is now computed and merged.
    % What remains is to sort the data by wavelength. Removal of duplicates does not seem to be necessary
    % Merge the wavelengths ...
    AllWv = [Wv; MatchWv];
    [AllWv, SortIndex] = sort(AllWv);
    c1 = c1(SortIndex, :);
    c2 = c2(SortIndex, :);
    c3 = c3(SortIndex, :);

    % Finally, perform the integration
    c1 = trapz(AllWv, c1);
    c2 = trapz(AllWv, c2);
    c3 = trapz(AllWv, c3);
end
% Lastly transform into the output color space
switch WhichType
    case {'', 'CIE2xyY', 'CIE10xyY'}
        % Perform the standard transformation to xy
        coord1 = c1 ./ (c1 + c2 + c3);
        coord2 = c2 ./ (c1 + c2 + c3);
        coord3 = c2;
    case {'CIE2XYZ', 'CIE10XYZ'}
        % Simply assign X, Y and Z
        coord1 = c1;
        coord2 = c2;
        coord3 = c3;
    case {'CIE2uv', 'CIE10uv'} % CIE 1960 uv
        % Transform from XYZ to xy to CIE 1960 uv
        % u = 4X / (X + 15Y + 3Z) 
        % v = 6Y / (X + 15Y + 3Z) 
        coord1 = 4 * c1 ./ (c1 + 15*c2 + 3*c3); 
        coord2 = 6 * c2 ./ (c1 + 15*c2 + 3*c3);
        coord3 = [];
    otherwise
        error('ColorCoordsFromSpectrum:BadType', ['Unknown matching functions WhichType = ' WhichType]);
end
