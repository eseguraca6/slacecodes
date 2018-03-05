function AM = Airmass(Elevation, Method)
% Airmass : Compute the airmass for a particular elevation angle using various formulae
%
% Usage :
%  >> AM = Airmass(Elevation, Method)
%
% Where
%  Elevation is the elevation angle of the source object above the horizon in degrees.
%   Note : Zenith angle is 90 degrees minus the elevation angle.
%   Due to atmospheric refraction, there is a difference between the apparent and true
%   zenith angles (or the apparent and true elevation angles). Some methods use the
%   true value and some use the apparent value. For accurate calculation at larger
%   zenith angles, be sure to give the appropriate (true or apparent) elevation input.
%   The true zenith angle can be up to about 34 minutes of arc larger than the apparent
%     zenith angle near the horizon.
%
%  Method is the formula used to calculate airmass. Method can be one of the following:
%     'secant'  : airmass is calculated as the secant of the zenith angle. This method is 
%                 acceptable up to zenith angles of 60 to 75 degrees, depending on the
%                 application. At these elevations, atmospheric refraction is not very
%                 large.
%     'young67' : Requires the true elevation angle, good up to 80 degrees zenith angle.
%     'hardie'  : Requires apparent elevation angle, good up to 85 degrees zenith angle.
%     'rozenbg' : Requires apparent elevation anlge, good up to 90 degrees zenith angle.
%     'kasten'  : Requires apparent elevation angle, good up to 90 degrees zenith angle.
%     'young94' : Requires the true elevation angle, good up to 90 degrees zenith angle. 
%
% If the method is not given, the default is 'kasten'
%
% If in doubt, use kasten for apparent elevation angles and young94 for true elevation.
%
%  Reference : http://en.wikipedia.org/wiki/Airmass
%
% Example : see AirmassTest.m

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

% Convert Elevation to radians and calculate the zenith angle
ElevationRadians = Elevation * pi / 180;     % Source elevation angle in radians
ZenithDegrees = 90 - Elevation;
ZenithRadians = pi/2 - ElevationRadians;       % Source zenith angle in radians

% Compute airmass using the requested method
if ~exist('Method', 'var') || ~ischar(Method)
    Method = 'kasten'; % Default to the Kasten formula
end
if any(ZenithDegrees(:) < 0)
    warning('Airmass:Elevation angles above 90 degrees were given.')
end
switch Method
  case 'secant'
    if any(ZenithDegrees(:) > 60)
      warning('Airmass:secant formula may be inaccurate above zenith angle of 60 degrees');
    end
    SecZ = sec(ZenithRadians);
    AM = SecZ;
  case 'young67'
    if any(ZenithDegrees(:) > 80)
      warning('Airmass:young67 formula may be incorrect above true zenith angle of 80 degrees');
    end
    SecZ = sec(ZenithRadians);
    AM = SecZ .* (1 - 0.0012 * (SecZ.^2 - 1));
  case 'hardie'
    if any(ZenithDegrees(:) > 85)
      warning('Airmass:hardie formula may be incorrect above apparent zenith angle of 85 degrees');
    end
    SecZ = sec(ZenithRadians);
    AM = SecZ - 0.0018167 * (SecZ - 1) - 0.002875 * (SecZ - 1).^2 - 0.0008083 * (SecZ - 1).^3;
  case 'rozenbg'
    if any(ZenithDegrees(:) > 90)
      warning('Airmass:rozenbg formula may be incorrect above apparent zenith angle of 90 degrees');
    end
    CosZ = cos(ZenithRadians);
    AM = (CosZ + 0.025 * exp(-11 * CosZ)).^(-1);
  case 'kasten'
    if any(ZenithDegrees(:) > 90)
      warning('Airmass:kasten formula may be incorrect above apparent zenith angle of 90 degrees');
    end
    AM = (cos(ZenithRadians) + 0.50572 * (96.07995 - ZenithDegrees).^(-1.6364)).^(-1);  
  case 'young94'
    if any(ZenithDegrees(:) > 90.6)
      warning('Airmass:young94 formula may be incorrect above true zenith angle of 90.6 degrees');
    end
    CosZ = cos(ZenithRadians);
    AM = (1.002432 * CosZ.^2 + 0.148386 * CosZ + 0.0096467) ./ (CosZ.^3 + 0.149864 * CosZ.^2 + 0.0102963 * CosZ + 0.000303978);   
  otherwise
    error(['Airmass:Unknown airmass formula ' Method ' requested.']);
end
