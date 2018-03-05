function ParameterVector = zGetSurfaceParamVector(SurfaceNumber)
% zGetSurfaceParamVector - Gets all parameter data for a single surface.
%
% Usage : ParameterVector = zGetSurfaceParamVector(SurfaceNumber)
%
% Returns a row vector of all parameter values at surface number
% SurfaceNumber.
% Returns NaN (not-a-number) if a timeout occurs.
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
for ParameterNumber = 0:12
  DDECommand = sprintf('GetSurfaceParameter,%i,%i',SurfaceNumber,ParameterNumber);
  Reply = ddereq(ZemaxDDEChannel, DDECommand, [1 1], ZemaxDDETimeout);
  if (Reply), ParameterVector(1,ParameterNumber+1) = str2double(Reply); else ParameterVector = [NaN]; return; end;
end

