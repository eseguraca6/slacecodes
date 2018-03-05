function zmxOTF = zGetMTF(DataFile, SettingsFile)
% zmxOTF = zGetMTF(DataFile, SettingsFile)
%
% Requests ZEMAX to compute the thru-frequency MTF analysis for the current lens and configuration.
% The text data is written to Datafile, and the settings for the analysis are read from SettingsFile.
% The DataFile name must be in single quotes and include the full path, name, and
% extension for the file to be created. To use default settings, give the
% SettingsFile as ''.
%
% The data is returned as for ReadZemaxOTF.
%
% Example :
% >> zDDEInit;  % Start up the DDE connection
% >> zMTF = zGetMTF('c:\data\tempMTF.dat', ''); % Compute MTF and store
%                                                 data in the file
%                                                 c:\data\tempMTF.dat.
%                                                 Use the default settings.                
% >> plotZemaxOTF(zMTF); % Plot the MTF


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

zGetTextFile(DataFile, 'Mtf', SettingsFile, 1);
zmxOTF = ReadZemaxOTF(DataFile);

