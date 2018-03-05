function WriteZemaxWaveFile(File, WaveMatrix, Primary)
% WriteZemaxWaveFile - Writes a list of wavelengths formatted for ZEMAX
%
% Usage example : 
% >> WriteZemaxWaveFile(File, WaveMatrix, Primary)
% File is the file to write (full pathname unless in current directory).
% WaveMatrix is a matrix of wavelengths and weights (one each per row).
% Primary is the primary wavelength number.
%
% See also : ReadZemaxWaveFile, zSetWaveMatrix, zGetWaveMatrix

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


fid = fopen(File, 'w');
if (fid == -1)
    disp('WriteZemaxWaveFile:Cannot Open Specified File.');
    return;
end

fprintf(fid, '%i\r\n', Primary);
for i = 1:size(WaveMatrix,1)
    fprintf(fid, '%f %f\r\n', WaveMatrix(i,1), WaveMatrix(i,2));
end
fclose(fid);
