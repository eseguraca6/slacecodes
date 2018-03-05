function NSCSettings = zGetNSCSettings()
% zGetNSCData - Requests NSC settings from ZEMAX.
%
% Usage : NSCSettings = zGetNSCSettings
% Returns a row vector of numerics in the following order
% MaxIntersections, MaxSegments, MaxNesting, MinAbsoluteIntensity, MinRelativeIntensity, GlueDistance, MissRayLength
% These items are the maximum number of ray intersections, segments, nesting level, minimum absolute intensity,
% minimum relative intensity, and glue distance used for NSC ray tracing.
%
% See also zSetNSCSettings
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
Reply = ddereq(ZemaxDDEChannel, 'GetNSCSettings', [1 1], ZemaxDDETimeout);
[col, count, errmsg] = sscanf(Reply, '%f,%f,%f,%f,%f,%f,%f');
NSCSettings = col';
