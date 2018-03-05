function Timeset = zSetTimeout(Time)
% zSetTimeout - Set the timeout in seconds for all ZEMAX DDE calls.
%
% Usage : zSetTimeout(Time)
% where Time is given in seconds.
% 
% See also : zDDEInit, zDDEStart
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
ZemaxDDETimeout = round(Time*1000);
