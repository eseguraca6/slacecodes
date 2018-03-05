function WaveData = zGetWave(WaveNumber)
% zGetWave - Requests data on defined wavelengths from the Zemax DDE server.
%
% zGetWave(WaveNumber)
% Returns a row vector for wavelength number WaveNumber. The vector contains wavelength, weight
% If the WaveNumber is given as 0, the data returned is a 2-element row vector containing PrimaryWave, NumberWave
% where PrimaryWave is the primary wavelength number and NumberWave is the number of defined wavelengths.
%
% See also zSetWave.
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
DDECommand = sprintf('GetWave,%i',WaveNumber);
Reply = ddereq(ZemaxDDEChannel, DDECommand, [1 1], ZemaxDDETimeout);
if WaveNumber == 0
   [col, count, errmsg] = sscanf(Reply, '%i,%i');
else
   [col, count, errmsg] = sscanf(Reply, '%f,%f');
end
WaveData = col';


