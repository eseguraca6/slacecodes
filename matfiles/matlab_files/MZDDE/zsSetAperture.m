function zsApertureData = zsSetAperture(SurfaceNumber, ApertureData)
% zsSetAperture - Sets aperture information at a surface from a Matlab structure.
%
% Usage : zsApertureData = zsSetAperture(SurfaceNumber, ApertureData)
% The ApertureData parameter must be a structure with the following fields.
% type, min, max, xdec, ydec
% The type is an integer code; 0 for no aperture, 1 for circular aperture, 2 for circular
% obscuration, 3 for spider, 4 for rectangular aperture, 5 for rectangular obscuration, 6 for elliptical aperture, 7 for
% elliptical obscuration, 8 for user defined aperture, 9 for user defined obscuration, and 10 for floating aperture. The
% min and max values have different meanings for the elliptical, rectangular, and spider apertures than for circular
% apertures; see the Editors Menu chapter in the Zemax Manual for details. 
%
% See also zSetAperture, zsSetAperture, zGetAperture

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

zSetAperture(SurfaceNumber, ApertureData.type, ApertureData.min, ApertureData.max, ApertureData.xdec, ApertureData.ydec, '');
