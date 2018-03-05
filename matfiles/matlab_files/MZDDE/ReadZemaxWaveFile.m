function [WaveMatrix, PrimaryWave] = ReadZemaxWaveFile(File)
% ReadZemaxWaveFile - Reads a list of wavelengths from a ZEMAX wavelength/weight file.
%
% Usage : 
% >> [WaveMatrix, PrimaryWave] = ReadZemaxWaveFile(File)
% File is the file to read from (full pathname unless in current directory)
% WaveMatrix is a matrix of wavelengths and weights (one each per row).
% PrimaryWave is the primary wavelength number.
%
% Example :
% >> [WaveMatrix, PrimaryWave] = ReadZemaxWaveFile('Schott1.wav');
%
% See also: zGetWaveMatrix, zSetWaveMatrix, WriteZemaxWaveFile
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


if ~exist(File, 'file')
    error('ReadZemaxWaveFile:Cannot Find Specified File.');
end

[Waves, Weights] = textread(File, '%f %f', 'headerlines', 1);
WaveMatrix = [Waves Weights];

if nargout == 2
    PrimaryWave = textread(File, '%f', 1);
end

