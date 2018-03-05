function Status = zExportCheck()
% zExportCheck - Checks whether Zemax DDE server is still busy exporting CAD data.
% 
% The return value is 1 if still running, otherwise 0. A return value of -998 indicates that the command has timed out.
% Example :
% while zExportCheck, end;
%
% This will cause MATLAB to loop indefinitely until the CAD export is completed.
%
% See zExportCAD.
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
Reply = ddereq(ZemaxDDEChannel, 'ExportCheck', [1 1], ZemaxDDETimeout);
if (Reply)
    Status = str2num(Reply);
else
    Status = -998;
end;

