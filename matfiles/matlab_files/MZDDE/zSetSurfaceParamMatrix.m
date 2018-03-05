function ParameterMatrix = zSetSurfaceParamMatrix(ParamMatrix)
% zSetSurfaceParamMatrix - Sets all lens surface parameter data from a 13 column matrix.
%
% Usage : ParameterMatrix = zSetSurfaceParamMatrix(ParamMatrix)
%
% If the matrix passed has fewer than 13 columns, missing columns on the right will be set to zero.
% Returns NaN (not-a-number) if data requests to ZEMAX time out.
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
ParamCols = size(ParamMatrix,2);
if ParamCols < 13,
    for iii = (ParamCols+1):13, ParamMatrix(:,iii) = zeros(size(ParamMatrix,1),13); end;
end
for SurfaceNumber = 0:(size(ParamMatrix,1)-1)
  for ParameterNumber = 0:12
    DDECommand = sprintf('SetSurfaceParameter,%i,%i,%1.20g',SurfaceNumber,ParameterNumber,ParamMatrix(SurfaceNumber+1,ParameterNumber+1));
    Reply = ddereq(ZemaxDDEChannel, DDECommand, [1 1], ZemaxDDETimeout);
    if (Reply), ParameterMatrix(SurfaceNumber+1,ParameterNumber+1) = str2double(Reply); else ParameterMatrix = [NaN]; return; end;
  end
end


