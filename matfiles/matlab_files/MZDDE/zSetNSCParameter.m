function NSCParameter = zSetNSCParameter(SurfaceNumber, ObjectNumber, ParameterNumber, ParameterValue)
% zGetNSCParameter - Sets numerical parameter data for NSC objects present in ZEMAX.
%
% Usage : NSCParameter = zSetNSCParameter(SurfaceNumber, ObjectNumber, ParameterNumber, ParameterValue)
% SurfaceNumber and ObjectNumber refer to the surface number and object number, and ParameterNumber is the 
% integer parameter number. ParameterValue is the new value to which the parameter must be set.
%
% The newly set numerical parameter value is returned.
% If the command times out, NaN (not-a-number) is returned.
%
% See also zGetNSCParameter
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
DDECommand = sprintf('SetNSCParameter,%i,%i,%i,%1.20g',SurfaceNumber, ObjectNumber, ParameterNumber, ParameterValue);
Reply = ddereq(ZemaxDDEChannel, DDECommand, [1 1], ZemaxDDETimeout);
if (Reply), NSCParameter = str2double(Reply); else NSCParameter = NaN; end;
