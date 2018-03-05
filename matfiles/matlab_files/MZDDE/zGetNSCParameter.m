function NSCParameter = zGetNSCParameter(SurfaceNumber, ObjectNumber, ParameterNumber)
% zGetNSCParameter - Requests parameter data for NSC objects present in ZEMAX.
%
% Usage : Parameter = zGetNSCParameter(SurfaceNumber, ObjectNumber, ParameterNumber)
% SurfaceNumber and ObjectNumber refer to the surface number and object number, and ParameterNumber is the 
% integer parameter number. The numerical parameter value is returned. If the command times out the value NaN is
% returned (Not-a-Number).
%
% See also zSetNSCParameter
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
DDECommand = sprintf('GetNSCParameter,%i,%i,%i',SurfaceNumber, ObjectNumber, ParameterNumber);
Reply = ddereq(ZemaxDDEChannel, DDECommand, [1 1], ZemaxDDETimeout);
if (Reply), NSCParameter = str2num(Reply); else NSCParameter = NaN; end;




