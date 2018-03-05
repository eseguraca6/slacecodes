function Status = zDDEInit()
% zDDEInit - Establish DDE link with the Zemax server.
%
% Usage : Status = zDDEInit
%
% Returns 0 if a DDE channel to ZEMAX was opened successfully. If not, -1
% is returned. If ZEMAX is not running, -1 will be returned.
% This function also sets the timeout value for all ZEMAX DDE calls to 3 seconds.
%
% See also zDDEClose, zDDEStart, zSetTimeout
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
ZemaxDDEChannel = ddeinit('zemax', '');
if (ZemaxDDEChannel)
    Status = 0;
else
    Status = -1;
end
ZemaxDDETimeout = 3000; % The default timeout.
