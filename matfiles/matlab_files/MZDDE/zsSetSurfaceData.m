function zsSurfaceData = zsSetSurfaceData(SurfaceNumber, SurfaceData)
% zsSetSurfaceData - Sets basic lens surface data from a Matlab structure.
%
% Usage : zsSurfaceData = zsSetSurfaceData(SurfaceNumber, SurfaceData)
%
% Must be passed a structure with the following fields.
% type (string), comment (string), curvature (numeric), thickness (numeric), glass (string),
% semidia (numeric), conic (numeric), coating (string), userdll (string),
% beforetdord (numeric indicating order of tilt and decentre before the
% surface), bdx, bdy, btx, bty, btz, (numerics gving decentres and tilts
% before the surface), afterstat (numeric for pickup status of tilts and
% decentres after the surface), aftertdord (numeric giving order of tilts
% and decentres after the surface), adx, ady, atx, aty, atz (numerics
% giving decentres and tilts after the surface).
%
% The surface SurfaceNumber will be set with these fields.
%
% See also zSetSurfaceData, zGetSurfaceData, zsGetSurfaceData

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

zSetSurfaceData(SurfaceNumber, 0 , SurfaceData.type);
zSetSurfaceData(SurfaceNumber, 1 , SurfaceData.comment);
zSetSurfaceData(SurfaceNumber, 2 , SurfaceData.curvature);
zSetSurfaceData(SurfaceNumber, 3 , SurfaceData.thickness);
zSetSurfaceData(SurfaceNumber, 4 , SurfaceData.glass);
zSetSurfaceData(SurfaceNumber, 5 , SurfaceData.semidia);
zSetSurfaceData(SurfaceNumber, 6 , SurfaceData.conic);
zSetSurfaceData(SurfaceNumber, 7 , SurfaceData.coating);
if ~isempty(SurfaceData.userdll)
  zSetSurfaceData(SurfaceNumber, 9 , SurfaceData.userdll);
end
zSetSurfaceData(SurfaceNumber, 51, SurfaceData.beforetdord);
zSetSurfaceData(SurfaceNumber, 52, SurfaceData.bdx);
zSetSurfaceData(SurfaceNumber, 53, SurfaceData.bdy);
zSetSurfaceData(SurfaceNumber, 54, SurfaceData.btx);
zSetSurfaceData(SurfaceNumber, 55, SurfaceData.bty);
zSetSurfaceData(SurfaceNumber, 56, SurfaceData.btz);
zSetSurfaceData(SurfaceNumber, 60, SurfaceData.afterstat);
zSetSurfaceData(SurfaceNumber, 61, SurfaceData.aftertdord);
zSetSurfaceData(SurfaceNumber, 62, SurfaceData.adx);
zSetSurfaceData(SurfaceNumber, 63, SurfaceData.ady);
zSetSurfaceData(SurfaceNumber, 64, SurfaceData.atx);
zSetSurfaceData(SurfaceNumber, 65, SurfaceData.aty);
zSetSurfaceData(SurfaceNumber, 66, SurfaceData.atz);


