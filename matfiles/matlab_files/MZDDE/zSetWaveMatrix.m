function oWaveDataMatrix = zSetWaveMatrix(iWaveDataMatrix)
% zSetWaveMatrix - Sets wavelength and weight data from a matrix.
%
% Usage : oWaveDataMatrix = zSetWaveMatrix(iWaveDataMatrix)
%
% The wavelengths are set from column 1 of the matrix iWaveDataMatrix, and the weights are set from
% column 2. The primary wavelength is assumed to be wavelength 1. To change the primary wavelength,
% use zSetWavePrimary.
%
% Returns a matrix having colummns wavelength and weight for all defined wavelengths.
%
% See also zGetWave, zSetWave, zSetWavePrimary
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
WaveCount = size(iWaveDataMatrix,1);
zSetWave(0,1,WaveCount); % Set the primary wavelength to 1 and the number of wavelengths to the rows of iWaveDataMatrix.
for iii = 1:WaveCount
  DDECommand = sprintf('SetWave,%i,%1.20g,%1.20g',iii, iWaveDataMatrix(iii, 1), iWaveDataMatrix(iii, 2));
  Reply = ddereq(ZemaxDDEChannel, DDECommand, [1 1], ZemaxDDETimeout);
  [col, count, errmsg] = sscanf(Reply, '%f,%f');
  oWaveDataMatrix(iii, 1) = col(1);
  oWaveDataMatrix(iii, 2) = col(2);
end

