function AddressLine = zGetAddress(LineNumber)
% zGetAddress - Requests the address information from the Zemax DDE Server. The address is set in Zemax
%               in the Preferences/Address dialog. Specify the line you want (1 to 5).
%
% Usage : AddressLine = zGetAddress(AddressLineNumer)
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
DDECommand = sprintf('GetAddress,%i',LineNumber);
AddressLine = ddereq(ZemaxDDEChannel, DDECommand, [1 1], ZemaxDDETimeout);
