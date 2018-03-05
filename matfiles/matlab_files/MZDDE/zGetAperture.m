function ApertureInfo = zGetAperture(SurfaceNumber)
% zGetAperture - Requests information on a surface aperture from the Zemax DDE server.
%
% zGetAperture(SurfaceNumber)
%
% Returns a row vector containing aperture type, min, max, xdecenter, ydecenter.
% This function returns the type as an integer code; 0 for no aperture, 1 for circular aperture, 2 for circular
% obscuration, 3 for spider, 4 for rectangular aperture, 5 for rectangular obscuration, 6 for elliptical aperture, 7 for
% elliptical obscuration, 8 for user defined aperture, 9 for user defined obscuration, and 10 for floating aperture. The
% min and max values have different meanings for the elliptical, rectangular, and spider apertures than for circular
% apertures; see the Editors Menu chapter in the Zemax Manual for details. 
%
% See also zSetAperture.
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
DDECommand = sprintf('GetAperture,%i',SurfaceNumber);
Reply = ddereq(ZemaxDDEChannel, DDECommand, [1 1], ZemaxDDETimeout);
[col, count, errmsg] = sscanf(Reply, '%f,%f,%f,%f,%f');
ApertureInfo = col';

