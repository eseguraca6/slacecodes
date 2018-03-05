function Status = zGetRefresh()
% zGetRefresh - Copy lens data from lenseditor to the ZEMAX DDE server lens buffer.
%
% Usage : Status = zGetRefresh
%
% This function causes ZEMAX to copy the lens data from the LDE into the stored copy of the server. The lens
% is then updated, which means ZEMAX recomputes all pupil positions, solves, and index data. If the lens can be
% updated, ZEMAX returns the value 0, otherwise, it returns -1. If the zGetUpdate returns -1, no ray tracing can
% be performed. Returns -2 if the command times out.
% All subsequent commands will now affect or be executed upon the newly copied lens data. The old lens data,
% if any, cannot be recovered. 
%
% See also zGetUpdate and zPushLens.
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
Reply = ddereq(ZemaxDDEChannel, 'GetRefresh', [1 1], ZemaxDDETimeout);
if (Reply) 
    Status = str2num(Reply);
else
    Status = -2;
end

    

