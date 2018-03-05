function WaveDataMatrix = zGetWaveMatrix()
% zGetWaveMatrix - Gets data on all defined wavelengths from the Zemax DDE server.
%
% Usage : WaveDataMatrix = zGetWaveMatrix
%
% Returns a matrix having colummns wavelength and weight for all defined wavelengths.
%
% See also zGetWave, zSetWave
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
WaveCount = zGetWave(0);
WaveCount = WaveCount(2);
for iii = 1:WaveCount
  DDECommand = sprintf('GetWave,%i',iii);
  Reply = ddereq(ZemaxDDEChannel, DDECommand, [1 1], ZemaxDDETimeout);
  [col, count, errmsg] = sscanf(Reply, '%f,%f');
  WaveDataMatrix(iii, 1) = col(1);
  WaveDataMatrix(iii, 2) = col(2);
end



