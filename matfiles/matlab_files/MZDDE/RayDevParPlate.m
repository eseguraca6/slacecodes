function d = RayDevParPlate(n, np, eye, t)
% RayDevParPlate - Calculates lateral deviation of a ray passing through a plane parallel plate.
%
% Usage : d = RayDevParPlate(MediumRefractiveIndex, PlateRefractiveIndex, AngleOfIncidence, PlateThickness)
% where MediumRefractiveIndex is the refractive index of the medium surrounding the plate,
%       PlateRefractiveIndex  is the refractive index of the plate,
%       AngleOfIncidence is the angle of incidence of the ray striking the plate (in radians) and
%       PlateThickness is the thickness of the plate in any linear units.
% The returned value is in the same units as the plate thickness.

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
eyep = (asin(n * sin(eye) / np));
d = t * sin(eye - eyep) / cos(eyep);
