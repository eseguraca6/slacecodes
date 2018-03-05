function ApertureInfo = zSetAperture(SurfaceNumber, Type, Min, Max, xDecenter, yDecenter, ApertureFile)
% zSetAperture - Set aperture details at a ZEMAX lens surface.
%
% Usage : ApertureInfo = zSetAperture(SurfaceNumber, Type, Min, Max, xDecenter, yDecenter, ApertureFile)
%
% The returned row vector is formatted as follows:
% Type, Min, Max, xDecenter, yDecenter
%
% This function uses an integer code for the surface aperture type; 0 for no aperture, 1 for circular aperture, 2 for
% circular obscuration, 3 for spider, 4 for rectangular aperture, 5 for rectangular obscuration, 6 for elliptical aperture,
% 7 for elliptical obscuration, 8 for user defined aperture, 9 for user defined obscuration, and 10 for floating aperture.
% The min and max values have different meanings for the elliptical, rectangular, and spider apertures than for
% circular apertures; see 'Aperture type and other aperture controls' in the ZEMAX manual for details.
% If zSetAperture is used to set user defined apertures or obscurations, the ApertureFile must be the name of a
% file which lists the x, y, coordinates of the user defined aperture file in a two column format. For more information
% on user defined apertures, see 'User defined apertures and obscurations' in the ZEMAX manual.
%
% See also zGetAperture.
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

global ZemaxDDEChannel ZemaxDDETimeout
DDECommand = sprintf('SetAperture,%i,%i,%1.20g,%1.20g,%1.20g,%1.20g,%s',SurfaceNumber, Type, Min, Max, xDecenter, yDecenter, ApertureFile);
Reply = ddereq(ZemaxDDEChannel, DDECommand, [1 1], ZemaxDDETimeout);
[col, count, errmsg] = sscanf(Reply, '%f,%f,%f,%f,%f');
ApertureInfo = col';


