function Reply = zuiGetMetaFile(AnalysisType, SettingsFileName, Flag)
% zGetMetaFile -  Request ZEMAX to save a Windows Metafile of any ZEMAX graphical analysis plot.
%
% Usage : zuiGetMetaFile(AnalysisType, SettingsFileName, Flag)
%
% Identical to zGetMetaFile, except that a dialog File Save As box is opened to get the file name.
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
[fn, pn] = uiputfile('*.emf', 'Save Windows Metafile As');
MetaFileName = [pn fn];
DDECommand = sprintf('GetMetaFile,"%s",%s,"%s",%i',MetaFileName, AnalysisType, SettingsFileName, Flag);
Reply = ddereq(ZemaxDDEChannel, DDECommand, [1 1], ZemaxDDETimeout);



