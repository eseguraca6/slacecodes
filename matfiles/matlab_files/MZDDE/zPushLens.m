function Status = zPushLens(Timeout, UpdateFlag)
% zPushLens - Copy lens in the ZEMAX DDE server into the Lens Data Editor (LDE).
%
% Usage : 
% >> Status = zPushLens(Timeout);
% or
% >> Status = zPushLens(Timeout, UpdateFlag);

% zPushLens will take the lens currently loaded in the server's memory and push it into the Lens Data Editor.
% In older version of ZEMAX, a dialog box will appear from the ZEMAX main window asking the user for permission 
% to accept the lens data being pushed by the client. 
% More recent versions of ZEMAX will reject all zPushLens attempts (return value -999) unless permission is
% granted via a checkbox on the Editors tab of the general ZEMAX preferences dialog.
% The client will wait Timeout seconds before returning a timeout error.
% If the lens data in the LDE has not been saved, an additional dialog box may appear asking
% if the old data should be saved first. The returned string is the same as for the zGetUpdate function; after updating the
% newly pushed lens file. If a value other than 0 is returned, the Update failed, if -999 is returned, the lens could not
% be pushed into the LDE. If -998 is returned, the function timed out.
%
% If the UpdateFlag value is zero or is omitted, the open windows are not updated. If the flag value is 1, then all open
% analysis windows are updated.
%
% See also zGetPath, zGetRefresh, zLoadFile, zGetUpdate and zSaveFile.
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

global ZemaxDDEChannel

if nargin == 1
    Reply = ddereq(ZemaxDDEChannel, 'PushLens', [1 1], Timeout * 1000);
    if (Reply==0)
       Status = -998;
       return;
    else
       Status = str2num(Reply);
    end
else
    DDECommand = sprintf('PushLens,%s',num2str(UpdateFlag));
    Reply = ddereq(ZemaxDDEChannel, DDECommand, [1 1], Timeout * 1000);
    if (Reply==0)
       Status = -998;
       return;
    else
       Status = str2num(Reply);
    end
end
    


