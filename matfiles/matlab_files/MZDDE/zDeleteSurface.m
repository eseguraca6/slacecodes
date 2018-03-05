function Status = zDeleteSurface(SurfaceNumber)
% zDeleteSurface - Delete a lens surface in the ZEMAX DDE server.
%
% Usage : Status = zDeleteSurface(SurfaceNumber)
% 
% Deletes the given surface number. Returns 0 for success or -998 if the command
% times out. Attempts to delete non-existant surfaces will also return 0.
% See also zInsertSurface
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
DDECommand = sprintf('DeleteSurface,%i',SurfaceNumber);
Reply = ddereq(ZemaxDDEChannel, DDECommand, [1 1], ZemaxDDETimeout);
if (Reply)
    Status = str2num(Reply);
else
    Status = -998;
end;
