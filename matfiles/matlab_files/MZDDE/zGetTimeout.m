function Timeout = zGetTimeout()
% zGetTimeout - Get the timeout in seconds for all ZEMAX DDE calls.
%
% Usage : Timeout = zGetTimeout
% 
% See also : zDDEInit, zDDEStart, zSetTimeout
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

global ZemaxDDETimeout
Timeout = ZemaxDDETimeout/1000;

