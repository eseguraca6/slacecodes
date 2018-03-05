function LensName = zSetName(NewName)
% zSetName - Set the title of the lens in ZEMAX.
%
% Usage : Name = zSetName(NewName)
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
DDECommand = sprintf('SetName,%s', NewName);
LensName = ddereq(ZemaxDDEChannel, DDECommand, [1 1]);

