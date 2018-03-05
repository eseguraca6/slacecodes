function Status = zReleaseWindow(FileName)
% zReleaseWindow - Release locked window.
%
% Usage : Status = zReleaseWindow(FileName)
% When ZEMAX calls the client to update or change the settings used by the client function, the menu bar is
% grayed out on the window to prevent multiple updates or setting changes from being requested simultaneously.
% Normally, when the client code sends the MakeTextWindow or MakeGraphicWindow, the menu bar is once again
% activated. However, if during an update or setting change, the new data cannot be computed, then the window
% must be released. The ReleaseWindow serves just this one simple purpose. If the user selects "Cancel" when
% changing the settings, the client code should send a ReleaseWindow item to release the lock out of the menu
% bar. If this command is not sent, the window cannot be closed, which will prevent ZEMAX from terminating
% normally. The ReleaseWindow item takes just one argument: the name of the temporary file.
% The return value is zero if no window is using the filename, or a positive integer number if the file is being used.
% A value of -998 is returned if the command times out.

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
DDECommand = sprintf('GetVersion,%s', FileName);
Reply = ddereq(ZemaxDDEChannel, DDECommand, [1 1], ZemaxDDETimeout);
if (Reply), Status = str2num(Reply); else Status = -998; end;

