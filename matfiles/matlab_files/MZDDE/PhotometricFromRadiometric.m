function [Photo, MergedWv, MergedRadio] = PhotometricFromRadiometric(Wv, Radio, WhichType)
% PhotometricFromRadiometric : Compute photometric quantities from radiometric
%
% Usage :
%  >> Photometric = PhotometricFromRadiometric(Wavelengths, Radiometric)
%  >> Photometric = PhotometricFromRadiometric(Wavelengths, Radiometric, WhichType)
%
% Where :
%   Wavelengths are the wavelengths at which the radiometric quantity is given.
%     This must be a vector of wavelengths in nm.
%   Radiometric is the radiometric quantity to convert.
%    This could be spectral flux in W/nm, spectral radiance
%    in W/m^2/sr/nm, spectral irradiance in W/m^2 or spectral
%    intensity (pointance) in W/sr. In each case the radiometric flux
%    will be converted to a photometric flux (lumens). This spectral
%    flux will be converted to photometric flux in lm, spectral radiance
%    to luminance in cd/m^2, spectral irradiance to illuminance in lux, 
%    and spectral intensity to photometric intensity in lm/sr (candela - cd).
%    The Radiometric input must be a column vector of the same lengtht as the
%      Wavelengths input, or multiple columns, in which case the output will
%      be a row vector of photometric quantities.
%
%  WhichType is the luminous efficacy function to use. Currently, the CIE
%     2 degree and 10 degree observers are available. Use WhichType = 'CIE10'
%     and WhichType = 'CIE2' for these two functions. If WhichType is not given
%     or empty, 'CIE2' is assumed.
%
% Examples :
%  The following example gets luminous efficacy at 555 nm
%  i.e. the number of lumens per watt of radiometric power
%  >> Lumens = PhotometricFromRadiometric(555, 1)
%
%  The following example computes the illuminance in lux for
%   a spectral source of 1 W/nm over a bandwidth of 100 nm
%   from 600 nm to 700 nm. 
%  >> Illum = PhotometricFromRadiometric([599.999 600 700 700.001], [0; 1; 1; 0])
%   By specifying the irradiance as zero very close to the band edge, a more
%   accurate result can be obtained i.e. the band edges are sharper.
%   Check this against the following ...
%  >> Illum = PhotometricFromRadiometric([600 700], [1; 1])
%
%  The above behaviour is due to the wavelength sampling grid on the CIE data.
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


% $Date: 2009-10-30 09:07:07 +0200 (Fri, 30 Oct 2009) $
% $Revision: 221 $
% $Author: DGriffith $

%% Load CIE data if not already loaded
% The following CIE variables are required, only load them if not populated already
persistent CIEsLambda CIExyzLambda CIEsid65 CIEy10 CIEy2 CIEsia

% Check if need to load CIE variables
if isempty(CIEsLambda) % could choose any one of the variables
    ReadCIE; % load all CIE stuff
end

%% Perform some input checking
if ~exist('Wv', 'var') || ~isfloat(Wv) || ~isvector(Wv) || min(Wv) >= max(CIExyzLambda) || max(Wv) <= min(CIExyzLambda)
    error('PhotometricFromRadiometric:BadWaves', ['Wavelengths input parameter must be floating point vector\n' ...
          ' which overlaps the photometric range of 380 nm to 780 nm']);
end
Wv = Wv(:); % Force to column vector

if ~exist('Radio', 'var') || ~isfloat(Radio) || size(Radio,1) ~= length(Wv)
    error('PhotometricFromRadiometric:BadRadio', ['Radiometric input quantity must be a floating point matrix\n' ...
          ' in which the number of rows is equal to the length of the Wavelengths input vector.']);
end

if ~exist('WhichType', 'var')
    WhichType = 'CIE2';
elseif ~ischar(WhichType)
    error('PhotometricFromRadiometric:BadType', 'WhichType input parameter must be char naming the luminous efficacy function.')
    
end

% The approach is to merge the wavelengths in the input with the CIE wavelength, sort the resulting matrix
% on wavelength, and then perform the integration. Linear interpolation is used, and extrapolation
% values are assumed to be zero.
switch WhichType
    case {'', 'CIE2'}
        LumWv = CIExyzLambda; % Must be a column vector
        LumEff = 683.002 * CIEy2;
    case 'CIE10'
        LumWv = CIExyzLambda; % Must be a column vector
        LumEff = 683.002 * CIEy10;
    otherwise
        error('PhotometricFromRadiometric:BadType', ['Unknown luminous efficacy function WhichType = ' WhichType]);
end

% Interpolate the values of the input spectrum onto the luminous efficacy function wavelengths
% Duplicate the wavelengths to the same number of columns as the radiometric input
LumAtRadioWv = interp1(LumWv, LumEff, Wv, 'linear', 0);
if length(Wv) == 1 % If a single wavelength, simply return the efficacy values at that wavelength
    Photo = LumAtRadioWv * Radio;
    return;
end
RadioAtLumWv = interp1(Wv, Radio, LumWv,  'linear', 0);
% Duplicate the columns of the luminous efficacy function data for both wavelength sets

LumEff = repmat(LumEff, 1, size(Radio,2));
LumAtRadioWv = repmat(LumAtRadioWv, 1, size(Radio, 2));

% Compute the photometric data by multiplying the luminous efficacy data by the radiometric data
Photo = [LumAtRadioWv .* Radio; LumEff .* RadioAtLumWv];
% The photometric data is now computed and merged.
% What remains is to sort the data by wavelength. Removal of duplicates does not seem to be necessary
% Merge the wavelengths ...
AllWv = [Wv; LumWv];
[AllWv, SortIndex] = sort(AllWv);
Photo = Photo(SortIndex, :);
MergedWv = AllWv;
MergedRadio = Photo;
% Finally, perform the integration
Photo = trapz(AllWv, Photo);
