function ParameterVector = zSetSurfaceParamVector(SurfaceNumber, ParamVector)
% zSetSurfaceParamVector - Sets all lens surface parameter data from a 13 column row vector.
%
% Usage : ParameterVector = zSetSurfaceParamVector(SurfaceNumber, ParamVector)
%
% If the vector passed has fewer than 13 columns, missing columns on the right will be set to zero.
% If DDE requests to ZEMAX time out, the function will return NaN
% (not-a-number).
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
ParamCols = size(ParamVector,2);
if ParamCols < 13,
    for iii = (ParamCols+1):13, ParamVector(1,iii) = 0; end;
end
for ParameterNumber = 0:12
  DDECommand = sprintf('SetSurfaceParameter,%i,%i,%1.20g',SurfaceNumber,ParameterNumber,ParamVector(1,ParameterNumber+1));
  Reply = ddereq(ZemaxDDEChannel, DDECommand, [1 1], ZemaxDDETimeout);
  if (Reply), ParameterVector(1,ParameterNumber+1) = str2double(Reply); else ParameterVector = [NaN]; return; end;
end


