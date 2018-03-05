function [PositionData, Material] = zGetNSCPosition(SurfaceNumber, ObjectNumber)
% zGetNSCPosition - Requests data on NSC object position from the ZEMAX DDE server.
%
% Usage : [PositionData, Material] = zGetNSCPosition(SurfaceNumber, ObjectNumber)
% 
% SurfaceNumber and ObjectNumber refer to the surface number and object number. The returned data contains the following
% PositionData is a row vector with x, y, z, tilt-x, tilt-y, tilt-z
% Material is a string containing the name of the material.
%
% See also zSetNSCPosition.
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
DDECommand = sprintf('GetNSCPosition,%i,%i',SurfaceNumber, ObjectNumber);
Reply = ddereq(ZemaxDDEChannel, DDECommand, [1 1], ZemaxDDETimeout);
[col, count, errmsg] = sscanf(Reply, '%f,%f,%f,%f,%f,%f,%*s');
PositionData = col';
[Material, count, errmsg] = sscanf(Reply, '%*f,%*f,%*f,%*f,%*f,%*f,%s');





