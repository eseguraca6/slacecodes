function SpecIrrad = SpecIrradFromIllum(RelSpecIrrad, Illum)
% SpecIrradFromIllum: Computes absolute spectral irradiance from relative spectral irradiance and illuminance
%
% This routine is useful for computing the scaling factor required to obtain
% a certain measured illuminance (lux) level when the relative spectral
% distribution (spectrum) of the source is known and the absolute spectral 
% irradiance is desired.
%
% For this computation to be possible the given spectrum must have
% substantial overlap with the photopic spectral range (400 nm to 700 nm).
%
% For example, suppose the source is known to be a black body at 2856 K
% (CIE illuminant A), and the illuminance (lux) level is measured to be 
% 500 lux in a certain plane. This routine will give you the absolute
% spectral irradiance.
%
% This routine also works for flux quantities i.e. you can give luminous
% flux in lumens, this function will return radiometric spectral flux.
%
% Usage:
% >> AbsSpecIrrad = SpecIrradFromIllum(RelSpecIrrad, Illum) % for irradiance
% >> AbsSpecFlux = SpecIrradFromIllum(RelSpecFlux, LuminousFlux) % for flux
% 
% Where
%   RelSpecIrrad is the relative spectral distribution (e.g. daylight or blackbody)
%     Must ge given as a two column matrix. The first column is the wavelength
%     in units of microns. The second column must be the relative spectral
%     irradiance or spectral flux, which is unitless (only the shape of the 
%     curve matters, not the actual scaling - this routine is precisely for 
%     the purpose of rescaling the curve to absolute units). RelSpecIrrad 
%     can also be given as 'D65' for CIE illuminant D65 (daylight) or as 
%     'A' for CIE illuminant A (black body at 2856 K). If RelSpecIrrad is 
%     a scalar, it is interpreted as being a black body temperature in Kelvin.
%     If RelSpecIrrad is specified spectrally, it is assumed to have zero
%     irradiance outside the limits of the given wavelengths. If the spectrum
%     is specified as a black body temperature or CIE illuminant, the returned
%     spectral range is 0.3 to 0.83 microns in steps of 0.005 microns (5 nm).
%     If RelSpecIrrad is a single row vector with a wavelength and a weight
%     (arbitrary weight), then this function provides a computation for
%     monochromatic (e.g. laser) illuminance/irradiance.
%   Illum is the illuminance in lux, or the flux in lumens.
%
%   AbsSpecIrrad is the absolute spectral irradiance in W/m^2/micron, also
%     returned as a two column matrix with wavelength in the first column
%     in microns and absolute spectral irradiance in the second. If luminous
%     flux was given instead of illuminance, then this quantity will be
%     spectral flux in W/micron.
%
% Examples:
%   >> AbsSpecIrrad = SpecIrradFromIllum(3000, 10); % Compute absolute spectral irradiance
%      from black body at 3000 K, where the measured illuminance is 10 lux
%   >> AbsSpecIrrad = SpecIrradFromIllum('D65', 2000); % Compute absolute spectral irradiance
%      from CIE illuminant D65 (daylight) where the measured illuminance is
%      2000 lux.
%
% Notes :
%  The photometric scaling factor is computed using a spectral integral
%  in which the V(lambda) function appears. The 10 degree CIE
%  V(lambda) curve is used.

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
    % Convert CIE wavelengths to microns
    CIEsLambda = CIEsLambda/1000;
    CIExyzLambda = CIExyzLambda/1000;
end

%% Check inputs
% Deal with RelSpecIrrad input
if isfloat(RelSpecIrrad)
    if isscalar(RelSpecIrrad) % black body at RelSpecIrrad K
        % Generate black body curve at all CIEsLambda wavelengths
        T = RelSpecIrrad; % Temperature has been given
        RelSpecIrrad = [];
        RelSpecIrrad(:,1) = CIEsLambda;
        RelSpecIrrad(:,2) = Planck(CIEsLambda, T);
    else % Must be two column matrix
        if size(RelSpecIrrad,2) ~= 2
            error('SpecIrradFromIllum:RelSpecIrrad input must be 2 columns.')
        end
        % Make sure there is minimum overlap with photometric range
        if min(RelSpecIrrad(:,1)) > 0.77 || max(RelSpecIrrad(:,1)) < 0.38
            error('SpecIrradFromIllum:Spectral range does not have minimal overlap with spectral range (0.38 to 0.77 micron)')
        end
        if size(RelSpecIrrad,1) == 1 % single row
            % This is a monochromatic calculation - no integration required
            % Just do it quickly and return
            LumEffic = 683.002 * interp1(CIExyzLambda, CIEy10, RelSpecIrrad(1,1));
            SpecIrrad = [RelSpecIrrad(1,1) Illum / LumEffic];
            return;
        end
    end
else
    if ischar(RelSpecIrrad)
        switch RelSpecIrrad
            case 'D65'
              RelSpecIrrad = [CIEsLambda CIEsid65];
            case 'A'
              RelSpecIrrad = [CIEsLambda CIEsia];
            otherwise % error
              error('SpecIrradFromIllum:Invalid text specifier for relative spectral irradiance (RelSpecIrrad)');
        end
    end
end

%% Resample to CIExyzLambda wavelengths, integrate over CIE Y curve and find scaling factor
yRelSpecIrrad = interp1(RelSpecIrrad(:,1), RelSpecIrrad(:,2), CIExyzLambda, 'linear', 0); % Extrapolate 0

% Calculate what illuminance would be if the given relative spectral irradiance were absolute
% Not sure if the 2 degress (CIEy2) or the 10 degree (CIEy10) should be used
Illum2 = 683.002 * trapz(CIExyzLambda, yRelSpecIrrad .* CIEy2);
Illum10 = 683.002 * trapz(CIExyzLambda, yRelSpecIrrad .* CIEy10);

SpecIrrad = [RelSpecIrrad(:,1) Illum * RelSpecIrrad(:,2) ./ Illum10];
