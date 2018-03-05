function  Status = zGetUpdate()
% zGetUpdate - Perform update on the current lens in the ZEMAX DDE buffer.
%
% Usage : Status = zGetUpdate
%
% This function causes ZEMAX to update the lens, which means ZEMAX recomputes all pupil positions, solves,
% and index data. If the lens can be updated, ZEMAX returns the Status 0, otherwise, it returns -1. If the
% zGetUpdate returns -1, no ray tracing can be performed. Returns -998 if the command times out.
%
% See also zGetRefresh and zPushLens.
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
Reply = ddereq(ZemaxDDEChannel, 'GetUpdate', [1 1], ZemaxDDETimeout);
if (Reply)
    Status = str2num(Reply);
else
    Status = -998;
end;


