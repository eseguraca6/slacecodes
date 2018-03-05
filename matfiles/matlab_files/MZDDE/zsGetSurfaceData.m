function zsSurfaceData = zsGetSurfaceData(SurfaceNumber)
% zsGetSurfaceData - Get a structure containing the basic lens surface data.
%
% Usage : zsSurfaceData = zsGetSurfaceData(SurfaceNumber)
% Returns a structure having the following fields.
% type (string), comment (string), curvature (numeric), thickness (numeric), glass (string),
% semidia (numeric), conic (numeric), coating (string), userdll (string),
% beforetdord (numeric indicating order of tilt and decentre before the
% surface), bdx, bdy, btx, bty, btz, (numerics gving decentres and tilts
% before the surface), afterstat (numeric for pickup status of tilts and
% decentres after the surface), aftertdord (numeric giving order of tilts
% and decentres after the surface), adx, ady, atx, aty, atz (numerics
% giving decentres and tilts after the surface).
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
zsSurfaceData = struct('type',       zGetSurfaceData(SurfaceNumber, 0 ), 'comment',     zGetSurfaceData(SurfaceNumber, 1 ), ... 
                       'curvature',  zGetSurfaceData(SurfaceNumber, 2 ), 'thickness',   zGetSurfaceData(SurfaceNumber, 3 ), ...
                       'glass',      zGetSurfaceData(SurfaceNumber, 4 ), 'semidia',     zGetSurfaceData(SurfaceNumber, 5 ), ...
                       'conic',      zGetSurfaceData(SurfaceNumber, 6 ), 'coating',     zGetSurfaceData(SurfaceNumber, 7 ), ...
                       'userdll',    zGetSurfaceData(SurfaceNumber, 9 ), 'beforetdord', zGetSurfaceData(SurfaceNumber, 51), ...
                       'bdx',        zGetSurfaceData(SurfaceNumber, 52), 'bdy',         zGetSurfaceData(SurfaceNumber, 53), ...
                       'btx',        zGetSurfaceData(SurfaceNumber, 54), 'bty',         zGetSurfaceData(SurfaceNumber, 55), ...
                       'btz',        zGetSurfaceData(SurfaceNumber, 56), 'afterstat',   zGetSurfaceData(SurfaceNumber, 60), ...
                       'aftertdord', zGetSurfaceData(SurfaceNumber, 61), 'adx',         zGetSurfaceData(SurfaceNumber, 62), ...
                       'ady',        zGetSurfaceData(SurfaceNumber, 63), 'atx',         zGetSurfaceData(SurfaceNumber, 64), ...
                       'aty',        zGetSurfaceData(SurfaceNumber, 65), 'atz',         zGetSurfaceData(SurfaceNumber, 66));
% deblank the coating name and the comment
zsSurfaceData.comment = deblank(zsSurfaceData.comment);
zsSurfaceData.coating = deblank(zsSurfaceData.coating);
                
