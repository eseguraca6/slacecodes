function Reply = zFixSurfaceData(Surfaces, Codes)
% zFixSurfaceData - Make lens surface data fixed.
%
% Usage : Reply = zFixSurfaceData(Surfaces, Codes)
%
% Surfaces is a vector of numbers of surfaces which should be fixed. Code is the surface parameter which should be made
% fixed. The codes are the same as for the zSetSolve function as follows :
%
%  |-------------------------|----------------------------------------------------------------|
%  | zSetSolve Code         -|- Returned data format                                          |
%  |-------------------------|----------------------------------------------------------------|
%  | 0, curvature           -|- solvetype, parameter1, parameter2                             |
%  | 1, thickness           -|- solvetype, parameter1, parameter2, parameter3                 |
%  | 2, glass               -|- solvetype (solvetype 0)                                       |
%  |                        -|- solvetype, Index, Abbe, Dpfg (for solvetype = 1, model glass) |
%  |                        -|- solvetype, pickupsurf (for solvetype = 2, pickup)             |
%  |                        -|- solvetype (for solvetype = any other value)                   |
%  | 3, semi-diameter       -|- solvetype, pickupsurf                                         |
%  | 4, conic               -|- solvetype, pickupsurf                                         |
%  | 5-12, parameters 1-8   -|- solvetype, pickupsurf, offset, scalefactor, pickupcolumn      |
%  | 1001+, extra data values|- solvetype, pickupsurf, scalefactor                            |
%  |-------------------------|----------------------------------------------------------------|
%
% See the chapter on Solves in the Zemax manual for further details on the
% codes and parameters.
% 
% Example:
% >> zFixSurfaceData(1:4, 0:2); % will set curvatures, thicknesses and glasses for surfaces 1 to 4 to fixed mode.
% 
% See also : zSetSolve, zFixAllSurfaceData
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

for Surf = Surfaces
  for Code = Codes
    switch Code
       case {3},    Reply = zSetSolve(Surf, Code, 1); % For semi-diameters the integer is 1
       otherwise,   Reply = zSetSolve(Surf, Code, 0); % All the rest use 0
    end
  end
end
