function WaveData = zSetWave(WaveNumber, Wavelength, Weight)
% zSetWave - Define wavelengths and weights in ZEMAX.
%
% Usage : WaveData = zSetWave(WaveNumber, Wavelength, Weight)
% or    : WaveData = zSetWave(0, PrimaryWavelength, NumberOfWavelengths)
% If the value for WaveNumber is zero, then the primary wavelength number and the total number of wavelengths is set to
% the new integer values. If WaveNumber is a valid wavelength number (between 1 and the number of wavelengths, inclusive)
% then the wavelength in microns and the wavelength weight are both set. The returned data
% is the same as for zGetWave(WaveNumber)
%
% See also zGetWave
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
if WaveNumber == 0
   DDECommand = sprintf('SetWave,0,%i,%i',Wavelength,Weight);
else
   DDECommand = sprintf('SetWave,%i,%1.20g,%1.20g',WaveNumber, Wavelength, Weight);
end
Reply = ddereq(ZemaxDDEChannel, DDECommand, [1 1], ZemaxDDETimeout);
if WaveNumber == 0
   [col, count, errmsg] = sscanf(Reply, '%i,%i');
else
   [col, count, errmsg] = sscanf(Reply, '%f,%f');
end
WaveData = col';

