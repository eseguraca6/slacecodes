function SurfaceDatum = zGetSurfaceData(SurfaceNumber, Code, Arg2)
% zGetSurfaceData - Gets various data on a sequential lens surface.
%
% Usage : SurfaceDatum = zGetSurfaceData(SurfaceNumber, Code)
%     or  SurfaceDatum = zGetSurfaceData(SurfaceNumber, Code, Arg2)
% Returns a single numeric or string depending on the code according to the following table.
% Codes above 70 use the Arg2 parameter.
% Code      - Datum returned by zGetSurfaceData
% 0         - Surface type name. ( 8 character string)
% 1         - Comment. (string)
% 2         - Curvature (numeric).
% 3         - Thickness. (numeric)
% 4         - Glass. (string)
% 5         - Semi-Diameter. (numeric)
% 6         - Conic. (numeric)
% 7         - Coating. (string)
% 9         - User-defined .dll if present (string)
% 51        - Tilt, Decenter order before surface; 0 for Decenter then Tilt, 1 for Tilt then
%             Decenter.
% 52        - Decenter x 
% 53        - Decenter y 
% 54        - Tilt x before surface
% 55        - Tilt y before surface
% 56        - Tilt z before surface
% 60        - Status of Tilt/Decenter after surface. 0 for explicit, 1 for pickup current surface, 
%             2 for reverse current surface, 3 for pickup previous surface, 4 for reverse previous surface,
%             etc.
% 61        - Tilt, Decenter order after surface; 0 for Decenter then Tile, 1 for Tilt then
%             Decenter.
% 62        - Decenter x after surface
% 63        - Decenter y after surface
% 64        - Tilt x after surface
% 65        - Tilt y after surface
% 66        - Tilt z after surface
% 70        - Use Layer Multipliers and Index Offsets. Use 1 for true, 0 for false.
% 71        - Layer Multiplier value. The coating layer number is defined by Arg2.
% 72        - Layer Multiplier status. Use 0 for fixed, 1 for variable, or n+1 for pickup from layer n. 
%             The coating layer number is defined by Arg2.
% 73        - Layer Index Offset value. The coating layer number is defined by Arg2.
% 74        - Layer Index Offset status. Use 0 for fixed, 1 for variable, or n+1 for pickup from layer n. 
%             The coating layer number is defined by Arg2.
% 75        - Layer Extinction Offset value. The coating layer number is defined by Arg2.
% 76        - Layer Extinction Offset status. Use 0 for fixed, 1 for variable, or n+1 for pickup 
%             from layer n. The coating layer number is defined by Arg2.
% Other     - Reserved for future expansion of this feature.
%
% See also : zSetSurfaceData and ZemaxSurfTypes

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
if exist('Arg2', 'var')
  DDECommand = sprintf('GetSurfaceData,%i,%i,%1.20g',SurfaceNumber,Code,Arg2);
else
  if Code > 70
      warning('zGetSurfaceData:Arg2Required','The Arg2 parameter may be required for this Code item.');
  end
  DDECommand = sprintf('GetSurfaceData,%i,%i',SurfaceNumber,Code);
end
Reply = ddereq(ZemaxDDEChannel, DDECommand, [1 1], ZemaxDDETimeout);
switch Code
  case {0,1,4,7,9}, SurfaceDatum = deblank(Reply); % A string is returned
  otherwise, SurfaceDatum = str2double(Reply); % Default to numeric
end


