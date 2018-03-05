function Status = zLoadFile(FileName, Append)
% zLoadFile - Load a lens file into the ZEMAX DDE server.
%
% Usage : Status = zLoadFile(FileName)
%
% Note that loading a file does not change the data displayed in the LDE;
% the server process has a separate copy of the lens data. The file name to be loaded is appended to the LoadFile
% item name, and must include the full path. For example: zLoadFile('C:\ZEMAX\SAMPLES\COOKE.ZMX'). 
%
% The value Append may be omitted. If present and greater than zero, then the new file is appended to the current
% file starting at the surface number defined by the value Append.
%
% The returned value is the same as for the zGetUpdate item; after updating the newly loaded lens file. If a value other
% than 0 is returned, the Update failed, if -999 is returned, the file could not be loaded. 
% If -998 is returned, the command timed out.
%
% See also zGetPath, zSaveFile, zPushLens, zuiLoadFile
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

if nargin == 1
  DDECommand = sprintf('LoadFile,%s',FileName);
  Reply = ddereq(ZemaxDDEChannel, DDECommand, [1 1], ZemaxDDETimeout);
else
  DDECommand = sprintf('LoadFile,%s,%i',FileName,Append);
  Reply = ddereq(ZemaxDDEChannel, DDECommand, [1 1], ZemaxDDETimeout);
end

if (Reply), Status = str2num(Reply); else Status = -998; end;

