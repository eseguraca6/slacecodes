function [Waves, EquivReflect, Ver] = ROLOLunarEquivReflect(g, theta, phi, Phi, inWaves, Smoothing)
% ROLOLunarEquivReflect : ROLO Lunar equivalent disk spectral reflectance
%
% Calculates the equivalent spectral reflectance of the lunar disk according
% to the data and functions presented in 
% Hugh H. Kieffer and Thomas C. Stone, "The Spectral Irradiance of the Moon",
% The Astronomical Journal, 129:2887–2901, 2005 June.
% This function implements equation 10 in the above paper.
%
% Usage :
%
% [Waves, EquivReflect] = ROLOLunarEquivReflect(AbsPhase, ObsSelenoLat, ObsSelenoLong, SunSelenoLong)
% [Waves, EquivReflect, Version] = ROLOLunarEquivReflect(AbsPhase, ObsSelenoLat, ObsSelenoLong, SunSelenoLong)
% [Waves, EquivReflect] = ROLOLunarEquivReflect(AbsPhase, ObsSelenoLat, ObsSelenoLong, SunSelenoLong, inWaves)
% [Waves, EquivReflect] = ROLOLunarEquivReflect(AbsPhase, ObsSelenoLat, ObsSelenoLong, SunSelenoLong, ...
%                            inWaves, Smoothing)
%
% Where inputs are
%   AbsPhase is the absolute lunar phase angle in radians.
%   ObsSelenoLat is the selenographic latitude of the observer in radians.
%   ObsSelenoLong is the selenographic longitude of the observer in radians.
%   SunSelenoLong is the solar selenographic longitude in radians.
%     Any of the above 4 angles that are not scalar must have the
%     same size. 
%     Selenocentric longitudes must be in the range -2 pi to 2 pi.
%     revolutions to bring selenocentric longitude into this range.
%   inWaves is a vector of wavelengths in nm at which to interpolate
%     spectral reflectance. Linear interpolation is used. These 
%     wavelengths must lie within the ROLO range of 360 nm and 2383.6 nm.
%   Smoothing is a smoothing factor to apply to the data. Smoothing of 0
%     is the same as a linear fit and smoothing of 1 is a cubic spline
%     fit. Experiment with very small values of Smoothing (1e-6 to 1e-7).
%     The spline toolbox function "csaps" is used to perform
%     smoothing, 1 column at a time. If csaps is not available, the
%     included function "smooth.m" by Per A. Brodtkorb is used. This
%     function (smooth.m) seems to provide roughly the same amount of
%     smoothing given the same Smoothing parameter as what csaps provides.
% Outputs are
%   Waves - the ROLO default wavelengths in nm, or inWaves if given.
%   EquivReflect is the lunar disk equivalent spectral reflectance.
%     There is one column of output per set of angle inputs
%     (AbsPhase, ObsSelenoLat, ObsSelenoLong, SunSelenoLong).
%   Version is the ROLO model version.
%
% This function is implemented in order to enable the computation of lunar
% exoatmospheric irradiance. The ultimate goal is to make use of
% exoatmospheric lunar irradiance as an input to the SMARTS model for
% the purpose of computing direct and diffuse lunar irradiance on
% a planar target of arbitrary orientation on a specific julian date
% at a specific earth location.
% The general method employed for this purpose is as follows :
% 1) Compute the lunar equivalent disk spectral reflectance using this
%    function.
% 2) Multiply the spectral reflectance by an exoatmospheric solar
%    spectral irradiance and dividing by pi steradians to obtain
%    an equivalent lunar disk spectral radiance. 
% 3) Compute the size of the lunar disk from the observer location in
%    steradians.
% 4) Multiply the lunar equivalent disk radiance by the lunar disk
%    size to get a lunar spectral irradiance. This is equation
%    8 in the above reference.
% 5) Run SMARTS with the resulting lunar spectral irradiance as a user-
%    defined "solar" exoatmospheric irradiance.
%
% See also : ExoLunarIrradiance, selenog, MoshierMoon
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
% $Author: DGriffith $

% if any inputs are non-scalar, the number of elements must be the same

% Check classes
if ~isfloat(g) || ~isfloat(theta) || ~isfloat(phi) || ~isfloat(Phi)
    error('All input parameters must be float/double.')
end
% Make sure above 4 inputs are row vectors
g = reshape(g, 1, numel(g));
theta = reshape(theta, 1, numel(theta));
phi = reshape(phi, 1, numel(phi));
Phi = reshape(Phi, 1, numel(Phi));
% Check the ranges of the selenographic longitudes (phi and Phi)
phi(phi > pi) = phi(phi > pi) - 2*pi;
phi(phi < -pi) = phi(phi < -pi) + 2*pi;
Phi(Phi > pi) = Phi(Phi > pi) - 2*pi;
Phi(Phi < -pi) = Phi(Phi < -pi) + 2*pi;

Sizes = [numel(g) numel(theta) numel(phi) numel(Phi)];
MaxSize = max(Sizes);

if ~all(Sizes == 1 | Sizes == MaxSize)
    error('First four input parameters must be either scalar or have the same number of elements.')
end



% The following variables are initialised on the first call to this
% function and thereafter remain in memory
persistent Wv a0 a1 a2 a3 b1 b2 b3 d1 d2 d3 c1 c2 c3 c4 p1 p2 p3 p4 Version
% Wv, a*, b*, c* are all 32 by 1 vectors, p* are scalar

if isempty(Wv)
    [PathStr] = fileparts(which('ROLOLunarEquivReflect'));
    load([PathStr '\ROLOLunarEquivReflectV311g.mat']);
end
nRows = size(Wv,1);
g = repmat(g, nRows, MaxSize - numel(g) + 1);
theta = repmat(theta, nRows, MaxSize - numel(theta) + 1);
phi = repmat(phi, nRows, MaxSize - numel(phi) + 1);
Phi = repmat(Phi, nRows, MaxSize - numel(Phi) + 1);

% Resize the constants in the model
a0 = repmat(a0(:,1), 1, MaxSize);
a1 = repmat(a1(:,1), 1, MaxSize);
a2 = repmat(a2(:,1), 1, MaxSize);
a3 = repmat(a3(:,1), 1, MaxSize);
b1 = repmat(b1(:,1), 1, MaxSize);
b2 = repmat(b2(:,1), 1, MaxSize);
b3 = repmat(b3(:,1), 1, MaxSize);
c1 = repmat(c1(:,1), 1, MaxSize);
c2 = repmat(c2(:,1), 1, MaxSize);
c3 = repmat(c3(:,1), 1, MaxSize);
c4 = repmat(c4(:,1), 1, MaxSize);
d1 = repmat(d1(:,1), 1, MaxSize);
d2 = repmat(d2(:,1), 1, MaxSize);
d3 = repmat(d3(:,1), 1, MaxSize);
p1 = p1(1) * ones(nRows, MaxSize);
p2 = p2(1) * ones(nRows, MaxSize);
p3 = p3(1) * ones(nRows, MaxSize);
p4 = p4(1) * ones(nRows, MaxSize);


% Implement equation 10
lnAk = a0 + g.*a1 + g.^2.*a2 + g.^3.*a3 + Phi.*b1 + Phi.^3.*b2 + Phi.^5.*b3 + ...
           theta.*c1 + phi.*c2 + Phi.*theta.*c3 + Phi.*phi.*c4 + ...
           exp(-g./p1).*d1 + exp(-g./p2).*d2 + cos((g-p3)./p4).*d3;

% Deal with evaluation at wavelengths other than ROLO default       
if exist('inWaves', 'var') && ~isempty(inWaves) && isfloat(inWaves) 
    if isfloat(inWaves) && isvector(inWaves) && min(inWaves) >= min(Wv) && max(inWaves) <= max(Wv)
      % Interpolate at the requested wavelength using linear interpolation
      inWaves = reshape(inWaves,length(inWaves),1); % Makes column vector
      if exist('Smoothing', 'var')
          if isscalar(Smoothing) && Smoothing >= 0 && Smoothing <= 1
              lnAk = smooth(Wv, lnAk, Smoothing, inWaves);
          else
              error('Input Smoothing must be scalar value between 0 and 1.')
          end
      else
        lnAk = interp1(Wv, lnAk, inWaves, 'linear');  
      end
      
      Waves = inWaves;
    else
      error('inWaves input must be floating point vector within ROLO spectral range of 360 nm to 2383.6 nm.')
    end
else
    Waves = Wv;
end
% Perform smoothing if a smoothing factor was given
% It seems to be necessary to smooth 1 column at a time
if exist('Smoothing', 'var') && isempty(inWaves)
    if isscalar(Smoothing) && Smoothing >= 0 && Smoothing <= 1
        if exist('csaps') == 2
            for iCol = 1:size(lnAk, 2)
              lnAk(:,iCol) = csaps(Wv, lnAk(:,iCol), Smoothing, Wv);
            end
        else
            for iCol = 1:size(lnAk, 2)
              lnAk(:,iCol) = smooth(Wv, lnAk(:,iCol), Smoothing, Wv);
            end
        end
    else
        error('Input Smoothing must be scalar value between 0 and 1.')
    end
end

EquivReflect = exp(lnAk);
Ver = Version;
