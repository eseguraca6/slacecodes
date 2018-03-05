function Status = zPushLensPermission()
% zPushLensPermission - Establish if ZEMAX extensions are allowed to push
% lenses in the LDE.
%
% Usage : Status = zPushLensPermission
%
% The return value is 1 if ZEMAX is set to accept zPushLens commands, or 0 if extensions 
% are not allowed to use zPushLens. The zPushLens data item can only succeed if the user 
% has set the appropriate permissions in ZEMAX.
% To allow a DDE extension to use zPushLens, the option "Allow Extensions To Push Lenses" 
% must be checked. This option is found under File, Preferences on the Editors tab, and 
% is described in the Editors section of the manual. The proper use of zPushLens is to first 
% call zPushLensPermission. If the return value is 0, then the client should display
% a dialog box instructing the user to turn on the "Allow Extensions To Push Lenses" 
% option before proceeding.
%
% See also : zPushLens, zGetRefresh

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
Status = str2num(ddereq(ZemaxDDEChannel, 'PushLensPermission', [1 1], ZemaxDDETimeout));

