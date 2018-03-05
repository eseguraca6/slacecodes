function SpectralIrrad = SonyIllumCondIrrad(CCT, Luminance, FocalRatio)
% SonyIllumCond1Irrad : Compute faceplate irradiance for Sony Illumination Condition
%
% Sony illumination conditions are general conditions under which Sony
% tests the sensitivity of their CCDs.
% Usually it involves using a uniform source with a tungsten lamp of
% particular correlated colour temperature (often 3200 K) having a certain
% luminance (typically 706 cd/m^2).
% The CCD is then illuminated via an IR cut filter (typically Hoya CM500S 
% thickness 1 mm) and a lens of specified focal ratio (typically F/5.6).
%
% Usage :
%   >> SpectralIrrad = SonyIllumCondIrrad(CCT, Luminance, FocalRatio)
%
% Where :
%  CCT is the correlated colour temperature in K. Defaults to 3200 K.
%
%  Luminance is the luminance of the source in cd/m^2 (nit). Defaults to
%    706 cd/m^2.
%
%  FocalRatio is the focal ratio of the lens used for source projection onto
%    the focal plane array. Defaults to F/5.6.
%
%  The input defaults are assigned if the inputs are empty or omitted.
%
%  The output SpectralIrrad is the spectral irradiance of the focal plane array.
%    There are two columns in this output. The first column is wavelength
%    in nm. The second column is spectral irradiance in W/m^2/nm.
%
%
% Note : Spectral transmission of the lens is assumed to be unity across
% the whole spectrum. Sony does not specify this usually, so watch out.
%
% See Also : SpecIrradFromIllum, PhotometricFromRadiometric
%
% Example :
%  >> s = SonyIllumCondIrrad; % Get default, 3200 K, 706 cd/m^2, F/5.6
%  >> plot(s(:,1), s(:,2)); % Plot it
%  >> xlabel('Wavelength (nm)');
%  >> ylabel('Faceplate Spectral Irradiance (W/m^2/sr/nm)');
%  >> title('Faceplate Spectral Irradiance for Sony Illumination Condition I');


%% BSD Licence
% This file is subject to the terms and conditions of the BSD licence.
% For further details, see the file BSDlicence.txt
%%
% Contact : dgriffith@csir.co.za
% 
% $Date: 2009-10-30 09:07:07 +0200 (Fri, 30 Oct 2009) $
% $Revision: 221 $
% $Author: DGriffith $

%% Check inputs
if ~exist('CCT', 'var') || isempty(CCT) || CCT <= 0
    CCT = 3200;
end
if ~exist('Luminance') || isempty(luminance) || Luminance <=0
    Luminance = 706;
end
if ~exist('FocalRatio', 'var') || isempty(FocalRatio) || FocalRatio <=0
    FocalRatio = 5.6;
end

%% Compute the source spectral radiance and filter by Hoya E-CM500S
SpecRad = SpecIrradFromIllum(CCT, 706); % Note CIE 10 deg observer used here
SpecRad(:,1) = SpecRad(:,1) * 1000; % Convert to nm
SpecRad(:,2) = SpecRad(:,2) / 1000; % Convert to per nm

% Get the filter transmission percentage and multiply
Direc = fileparts(which('SonyIllumCondIrrad'));

HoyaECM500S = xlsread([Direc '\Materials\Hoya1mmE-CM500S.xls'], 'A2:B56');

HoyaECM500S(:,1) = HoyaECM500S(:,1)*1000; % Convert to nm
HoyaECM500S(:,2) = HoyaECM500S(:,2)/100; % Convert from %

% Interpolate the hoya filter to the spectral radiance wavelengths
Hoya = interp1(HoyaECM500S(:,1),HoyaECM500S(:,2), SpecRad(:,1), 'linear');

% Multiply radiance by transmittance of 1 mm filter - Hoya gives the
% original data for 1 mm thickness

SpecRad(:,2) = SpecRad(:,2) .* Hoya;

% Finally take lens focal ratio into account to get irradiance
SpectralIrrad(:,1) = SpecRad(:,1); % same wavelengths
SpectralIrrad(:,2) = pi * SpecRad(:,2)./(4 * FocalRatio .^2);


