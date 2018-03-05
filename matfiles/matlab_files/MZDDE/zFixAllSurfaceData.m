function Reply = zFixAllSurfaceData(Surfaces)
% zFixAllSurfaceData - Fixes lens data for listed surfaces.
%
% Usage : Reply = zFixAllSurfaceData(Surfaces)
% 
% Sets curvature, thickness, glass, semi-diameter and all parameters to 'fixed' mode for the surface numbers given in
% the vector Surfaces (i.e. removes all solves and variables).
%
% To fix all lens data (excluding extra data) use zFixAllSurfaceData(0:zNumSurfs)
% or just zFixAllSurfaceData without any parameters.
% See also : zFixSurfaceData, zSetSolve
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
% $Author: DGriffith $

if nargin == 0
  Reply = zFixSurfaceData(0:zNumSurfs,0:12);   
else
  Reply = zFixSurfaceData(Surfaces,0:12);
end
