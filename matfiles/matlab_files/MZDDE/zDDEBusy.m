function Status = zDDEBusy()
% zDDEBusy - Checks to see if the ZEMAX DDE server is still busy with a function.
%
% Usage example : while (zDDEBusy) end;
%
% Will return immediately with the value 0 if the ZEMAX DDE server is available
% Returns 1 after the DDE timeout period if the server is busy.;
%
% See also : zSetTimeout, zGetTimeout
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
if (zGetDate)
    Status = 0;
else
    Status = 1;
end
