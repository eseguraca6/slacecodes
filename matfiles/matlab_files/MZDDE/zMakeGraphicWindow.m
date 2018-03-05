function Reply = zMakeGraphicWindow(FileName, ModuleName, WinTitle, TextFlag, SettingsData)
% zMakeGraphicWindow -  notifies ZEMAX that graphic data has been written to a file and may now be displayed as a ZEMAX
% child window.
%
% Usage : Reply = zMakeGraphicWindow(FileName, ModuleName, WinTitle, TextFlag, SettingsData)
%
% The primary purpose of this item is to implement user defined features in a client application, that
% look and act like native ZEMAX features. 
% FileName is the full path and file name to the temporary file that holds the graphic data. This must be the
% same name as passed to the client executable in the command line arguments, if any. The ModuleName is the
% full path and executable name of the client program that created the graphic data. The WinTitle is the string which
% defines the title ZEMAX should place in the top bar of the window.
% The TextFlag should be 1 if the client can also generate a text version of the data. Since the current data is a
% graphic display (it must be if the call is to zMakeGraphicWindow) ZEMAX wants to know if the "Text" menu option
% should be available to the user, or if it should be grayed out. If the text flag is 0, ZEMAX will gray out the "Text"
% menu option and will not attempt to ask the client to generate a text version of the data.
% The settings data is a string of values delimited by spaces (not commas) which are used by the client to define
% how the data was generated. These values are only used by the client, not by ZEMAX. The settings data string
% holds the options and data that would normally appear in a ZEMAX "settings" style dialog box. The settings data
% should be used to recreate the data if required. See "How ZEMAX calls the client" for details on the settings data.
% A sample call might look like this:
% zMakeGraphicWindow('C:\TEMP\ZGF001.TMP','C:\ZEMAX\FEATURES\CLIENT.EXE','ClientWindow',1, '0 1 2 12.55');
% This item indicates that ZEMAX should open a graphic window, display the data stored in the file
% C:\TEMP\ZGF001.TMP, and that any updates or setting changes can be made by calling the client module
% C:\ZEMAX\FEATURES\CLIENT.EXE. This client can generate a text version of the graphic, and the settings data
% string (used only by the client) is '0 1 2 12.55'.
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
DDECommand = sprintf('MakeGraphicWindow,%s,%s,%i,%s',FileName, ModuleName, WinTitle, TextFlag, SettingsData);
Reply = ddereq(ZemaxDDEChannel, DDECommand, [1 1], ZemaxDDETimeout);



