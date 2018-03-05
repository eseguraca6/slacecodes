function zsSurfaceDataVector = zsGetSurfaceDataVector()
% zsGetSurfaceData - Get a vector of structures containing all the basic lens surface data.
%
% Usage : zsSurfaceDataVector = zsGetSurfaceDataVector
% Returns a vector of structures having the following fields.
% type (string), comment (string), curvature (numeric), thickness (numeric), glass (string),
% semidia (numeric), conic (numeric), coating (string)
%
% Beware, ZEMAX numbers surface from 0 (object surface). The returned structure has data for the
% object surface at position 1, so that each surface is displaced upwards by 1.
%
% See also zsSetSurfaceData, zSetSurfaceData, zGetSurfaceData

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
  zsSurfaceDataVector(SurfaceNumber+1) = struct('type', zGetSurfaceData(SurfaceNumber, 0), 'comment', zGetSurfaceData(SurfaceNumber, 1), 'curvature', zGetSurfaceData(SurfaceNumber, 2),'thickness',   zGetSurfaceData(SurfaceNumber, 3), 'glass', zGetSurfaceData(SurfaceNumber, 4), 'semidia', zGetSurfaceData(SurfaceNumber, 5), 'conic', zGetSurfaceData(SurfaceNumber, 6), 'coating', zGetSurfaceData(SurfaceNumber, 7));
end
                
