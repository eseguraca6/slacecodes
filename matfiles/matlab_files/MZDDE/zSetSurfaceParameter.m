function ParameterData = zSetSurfaceParameter(SurfaceNumber, ParameterNumber, NewValue)
% zSetSurfaceParameter - Sets lens surface parameter data.
%
% Usage : ParameterData = zSetSurfaceParameter(SurfaceNumber, ParameterNumber, NewValue)
%
% For example, to set the parameter 5 data for surface 8 to 22.5, the call should be
% zSetSurfaceParameter(8,5,22.5). The value 22.5 would be returned by the function.
%
% Returns NaN (not-a-number) if the function times out.
%
% See also zGetSurfaceData and zGetSurfaceParameter
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
DDECommand = sprintf('SetSurfaceParameter,%i,%i,%1.20g',SurfaceNumber,ParameterNumber,NewValue);
Reply = ddereq(ZemaxDDEChannel, DDECommand, [1 1], ZemaxDDETimeout);
if (Reply), ParameterData = str2double(Reply); else ParameterData = NaN; end;

