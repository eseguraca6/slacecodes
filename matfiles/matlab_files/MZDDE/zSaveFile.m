function Status = zSaveFile(FileName)
% zSaveFile - Save the lens in the ZEMAX DDE server to a file.
%
% Usage : Status = zSaveFile(FileName)
% Saves the lens currently loaded in the server to a ZEMAX file. The file name to be used for the save
% must include the full path. For example: zSaveFile('C:\ZEMAX\SAMPLES\COOKE.ZMX'). The returned string 
% is the same as for the zGetUpdate item; after updating the newly saved
% lens file. If a value other than 0 is returned, the Update failed, if -999 is returned, the file could not be saved. 
% The value -998 is returned if the command times out.
%
% See also zGetPath, zGetRefresh, zLoadFile, and zPushLens.
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
DDECommand = sprintf('SaveFile,%s',FileName);
Reply = ddereq(ZemaxDDEChannel, DDECommand, [1 1], ZemaxDDETimeout);
if (Reply)
    Status = str2num(Reply);
else
    Status = -998;
end;
