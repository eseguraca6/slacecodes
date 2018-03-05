function Status = zuiSaveFile()
% zuiSaveFile - Save a lens file from the ZEMAX DDE server, using File Save As dialog.
%
% Usage : Status = zuiSaveFile
%
% Identical to zSaveFile, except that the filename is obtained from the user through a dialog box.
%
% The status is returned as -999 if the user presses cancel, or the file could not be saved.
% A status of -998 is returned if the command times out.
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
[fn, pn] = uiputfile('*.zmx', 'Save ZEMAX Lens File');
FileName = [pn fn];
if (fn==0)
   Status = -999;
   return;
end
DDECommand = sprintf('SaveFile,%s',FileName);
Reply = ddereq(ZemaxDDEChannel, DDECommand, [1 1], ZemaxDDETimeout);
if (Reply)
    Status = str2num(Reply);
else
    Status = -998;
end;




