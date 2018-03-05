function Reply = zGetMetaFile(MetaFileName, AnalysisType, SettingsFileName, Flag)
% zGetMetaFile -  Request ZEMAX to save a Windows Metafile of any ZEMAX graphical analysis plot.
%
% Usage : Reply = zGetMetaFile(MetaFileName, AnalysisType, SettingsFileName, Flag)
%
% The MetaFileName is the name of the file to be created including the full path, name, and extension for the metafile.
% The AnalysisType argument is a 3 character case-sensitive label that indicates the type of analysis to be performed.
% The 3 letter labels are identical to those used for the button bar in ZEMAX. A list of codes may be obtained by typing
% "help zemaxbuttons" at the Matlab prompt. The labels are case sensitive. If no label is provided or
% recognized, a 3D Layout plot will be generated.
% If a valid file name is used for the "settingsfilename" argument, ZEMAX will use or save the settings used to
% compute the metafile graphic, depending upon the value of the flag parameter.
% If the flag value is 0, then the default settings will be used for the graphic.
% If the flag value is 1, then the settings provided in the settings file, if valid, will be used to generate the graphic.
% If the data in the settings file is in anyway invalid, then the default settings will be used to generate the graphic.
% If the flag value is 2, then the settings provided in the settings file, if valid, will be used and the settings box for
% the requested feature will be displayed. After the user makes any changes to the settings the graphic will then be
% generated using the new settings.
% No matter what the flag value is, if a valid file name is provided for the settingsfilename, the settings used will
% be written to the settings file, overwriting any data in the file.
% Only graphic, and not text files, are supported by zGetMetaFile.
%
% Returns the string 'OK' if the function completes within the timeout period, otherwise returns 0.
%
% NB : The analysis is performed on the lens in the LDE, not the lens in the DDE server.
%
% See also zGetTextFile, zOpenWindow.
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
DDECommand = sprintf('GetMetaFile,"%s",%s,"%s",%i',MetaFileName, AnalysisType, SettingsFileName, Flag);
Reply = ddereq(ZemaxDDEChannel, DDECommand, [1 1], ZemaxDDETimeout);


