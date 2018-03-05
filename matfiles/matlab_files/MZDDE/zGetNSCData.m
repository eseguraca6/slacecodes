function NSCData = zGetNSCData(SurfaceNumber, Code)
% zGetNSCData - Requests data for NSC groups present in ZEMAX.
%
% Usage : zGetNSCData(SurfaceNumber, Code)
% SurfaceNumber refers to the surface number of the NSC group, use 1 if the program mode is Non-Sequential. Currently
% only Code = 0 is supported, in which case the returned data is the number of objects in the NSC group.

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
DDECommand = sprintf('GetNSCData,%i,%i',SurfaceNumber,Code);
Reply = ddereq(ZemaxDDEChannel, DDECommand, [1 1], ZemaxDDETimeout);
[NSCData, count, errmsg] = sscanf(Reply, '%i');




