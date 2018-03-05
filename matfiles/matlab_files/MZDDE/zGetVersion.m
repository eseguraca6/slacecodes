function Version = zGetVersion()
% zGetVersion - Get the current version of ZEMAX which is running.
%
% Usage : Version = zGetVersion
% Returns a numerical version number.
% Returns -998 if the command times out.

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
Reply = ddereq(ZemaxDDEChannel, 'GetVersion', [1 1], ZemaxDDETimeout);
if (Reply), Version = str2num(Reply); else Version = -998; end;
