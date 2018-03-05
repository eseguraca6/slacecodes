function ConfigData = zSetConfig(ConfigNumber)
% zSetConfig - Sets the configuration and updates the lens.
%
% Usage : ConfigData = zSetConfig(ConfigNumber)
%
% This function switches the current configuration number and updates the system. 
% For example, to switch to configuration 3, the call is zSetConfig(3)
% The returned row vector is formatted as follows:
% currentconfig, numberconfig, error
% The currentconfig is the new configuration number, which will be between 1 and the value of numberconfig.
% Normally, this will be the desired configuration requested in the item name, as long as it was a valid configuration
% number. The error code is the same as returned by the zGetUpdate item, and will be zero if the new current
% configuration is traceable. 
%
% See also zGetConfig
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
DDECommand = sprintf('SetConfig,%i', ConfigNumber);
Reply = ddereq(ZemaxDDEChannel, DDECommand, [1 1]);
[col,count,errmsg] = sscanf(Reply, '%i,%i,%i');
ConfigData = col';


