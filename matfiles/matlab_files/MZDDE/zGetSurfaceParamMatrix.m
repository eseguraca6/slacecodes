function ParameterMatrix = zGetSurfaceParamMatrix()
% zGetSurfaceParamMatrix - Gets all parameter data for all surfaces.
%
% Usage : ParameterMatrix = zGetSurfaceParamMatrix
%
% Returns a matrix of all parameter values at all surfaces.
% Returns NaN (not-a-number) if a ZEMAX DDE timeout occurs.
%
% See also zGetSurfaceData, zSetSurfaceParameter, zGetSurfaceParamVector
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
lensys = zsGetSystem;
SurfaceCount = lensys.numsurfs;
for SurfaceNumber = 0:SurfaceCount
  for ParameterNumber = 0:12
    DDECommand = sprintf('GetSurfaceParameter,%i,%i',SurfaceNumber,ParameterNumber);
    Reply = ddereq(ZemaxDDEChannel, DDECommand, [1 1], ZemaxDDETimeout);
    if (Reply), ParameterMatrix(SurfaceNumber+1,ParameterNumber+1) = str2double(Reply); else ParameterMatrix = [NaN]; return; end;
  end
end

