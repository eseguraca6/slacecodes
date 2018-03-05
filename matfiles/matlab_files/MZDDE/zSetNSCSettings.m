function NSCSettings = zSetNSCSettings(MaxInt, MaxSeg, MaxNest, MinAbsI, MinRelI, GlueDist, MissRayDist)
% zSetNSCSettings - Sets NSC settings in ZEMAX.
%
% Usage : NSCSettings = zSetNSCSettings(MaxInt, MaxSeg, MaxNest, MinAbsI, MinRelI, GlueDist, MissRayDist)
% Returns a row vector of the new settings in the following order
% MaxInt, MaxSeg, MaxNes, MinAbsI, MinRelI, GlueDist, MissRayDist
% These items are the maximum number of ray intersections, segments, nesting level, minimum absolute intensity,
% minimum relative intensity, and glue distance used for NSC ray tracing.
%
% See also zGetNSCSettings
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
DDECommand = sprintf('SetNSCSettings,%i,%i,%i,%1.20g,%1.20g,%1.20g,%1.20g', MaxInt, MaxSeg, MaxNest, MinAbsI, MinRelI, GlueDist, MissRayDist);
Reply = ddereq(ZemaxDDEChannel, DDECommand, [1 1], ZemaxDDETimeout);
[col, count, errmsg] = sscanf(Reply, '%f,%f,%f,%f,%f,%f,%f');
NSCSettings = col';
