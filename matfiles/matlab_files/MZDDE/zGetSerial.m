function SerialNumber = zGetSerial()
% zGetSerial - Returns the serial number of the ZEMAX harware lock.
%
% Usage : SerialNumber = zGetSerial
%
% Returns the serial number unless the command times out, in which case NaN (Not-a-Number) is returned.

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
Reply = ddereq(ZemaxDDEChannel, 'GetSerial', [1 1], ZemaxDDETimeout);
if (Reply), SerialNumber = str2num(Reply); else SerialNumber = NaN; end;

