function TolCount = zGetTolCount()
% zGetTolCount - Get the total number of tolerance operands in the current ZEMAX lens.
%
% Usage: TolCount = zGetTolCount
%
% See also zGetTol
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
Reply = ddereq(ZemaxDDEChannel, 'GetTol,0', [1 1], ZemaxDDETimeout);
[TolCount, count, errmsg] = sscanf(Reply, '%i');




