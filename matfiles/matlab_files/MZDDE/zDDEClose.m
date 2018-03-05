function Status = zDDEClose()
% zDDEClose - Close the DDEchannel to ZEMAX.
%
% Usage : Reply = zDDEClose
% Returns zero on success.
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
Status = ddeterm(ZemaxDDEChannel);

