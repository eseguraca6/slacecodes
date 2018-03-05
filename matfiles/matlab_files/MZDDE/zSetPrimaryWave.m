function WaveData = zSetPrimaryWave(PrimaryWaveNumber)
% zSetPrimaryWave - Set the primary wavelength number in ZEMAX.
%
% Usage : WaveData = zSetPrimaryWave(PrimaryWaveNumber)
%
% Sets the primary wavelength number to PrimaryWaveNumber.
% The returned data is the same as for zGetWave(WaveNumber), namely a row vector containing the
% primary wavelength number and the number of defined wavelengths.
%
% See also zGetWave, zSetWave, zSetWaveMatrix, zGetWaveMatrix
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
WaveData = zGetWave(0);
DDECommand = sprintf('SetWave,0,%i,%i',PrimaryWaveNumber, WaveData(2));
Reply = ddereq(ZemaxDDEChannel, DDECommand, [1 1], ZemaxDDETimeout);
[col, count, errmsg] = sscanf(Reply, '%f,%f');
WaveData = col';
