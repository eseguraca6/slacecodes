function ConfigData = zGetConfig()
% zGetConfig - Requests basic lens configuration data from the Zemax DDE server.
%
% Usage : ConfigData = zGetConfig
% This function extracts the current configuration number and the number of configurations
% The returned row vector is formatted as follows: CurrentConfig, NumberConfig
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
Reply = ddereq(ZemaxDDEChannel, 'GetConfig', [1 1], ZemaxDDETimeout);
[col,count,errmsg] = sscanf(Reply, '%i,%i');
ConfigData = col';

