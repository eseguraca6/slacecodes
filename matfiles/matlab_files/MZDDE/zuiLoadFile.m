function Status = zuiLoadFile()
% zuiLoadFile - Load a lens file into the ZEMAX DDE server, using Open File dialog.
%
% Usage : Status = zuiLoadFile
%
% Identical to zLoadFile, except that the filename is obtained from the user through a dialog box.
% Note that loading a file does not change the data displayed in the LDE;
% the server process has a separate copy of the lens data. The returned value is 
% the same as for the zGetUpdate item; after updating the newly loaded lens file. If a value other
% than 0 is returned, the Update failed, if -999 is returned, the file could not be loaded. 
% Status of -998 is returned if the command times out.
%
% See also zGetPath, zSaveFile, zPushLens, zLoadFile
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
[fn, pn] = uigetfile('*.zmx', 'Open ZEMAX Lens File');
FileName = [pn fn];
if (fn==0)
   Status = -999;
   return;
end
DDECommand = sprintf('LoadFile,%s',FileName);
Reply = ddereq(ZemaxDDEChannel, DDECommand, [1 1], ZemaxDDETimeout);
if (Reply)
    Status = str2num(Reply);
else
    Status = -998;
end;



