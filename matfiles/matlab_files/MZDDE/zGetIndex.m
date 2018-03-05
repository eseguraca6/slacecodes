function IndexData = zGetIndex(SurfaceNumber)
% zGetIndex - Requests refractive index data on a lens surface in ZEMAX.
%
% Usage : IndexData = zGetIndex(SurfaceNumber)
% zGetIndex(SurfaceNumber) returns a numeric column vector having the following n1, n2, n3 ...
% where the index values correspond to the refractive index at each defined wavelength, in order.
%
% If the specified surface is not valid, or is gradient index, the returned vector is empty.
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
% First Have to establish how many wavelengths there are
WaveData = zGetWave(0);
NumberWaves = WaveData(2);
DDECommand = sprintf('GetIndex,%i', SurfaceNumber);
Reply = ddereq(ZemaxDDEChannel, DDECommand, [1 1], ZemaxDDETimeout);
[IndexData, count, errmsg] = sscanf(Reply, '%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f', NumberWaves);


