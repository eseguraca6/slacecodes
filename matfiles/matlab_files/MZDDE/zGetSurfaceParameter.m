function ParameterData = zGetSurfaceParameter(SurfaceNumber,ParameterNumber)
% zGetSurfaceParameter - extracts surface parameter data.
%
% Usage : ParameterData = zGetSurfaceParameter(SurfaceNumber,ParameterNumber)
%
% For example, to get the parameter 5 data for surface 8, the call should be
% GetSurfaceParameter(8,5)
%
% Returns NaN (Not-a-Number) if the command times out.
%
% See also zGetSurfaceData and zSetSurfaceParameter
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
DDECommand = sprintf('GetSurfaceParameter,%i,%i',SurfaceNumber,ParameterNumber);
Reply = ddereq(ZemaxDDEChannel, DDECommand, [1 1], ZemaxDDETimeout);
if (Reply), ParameterData = str2num(Reply); else ParameterData = NaN; end;

