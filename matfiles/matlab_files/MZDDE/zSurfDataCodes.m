function SurfDataCodes = zSurfDataCodes()
% zSurfDataCodes - Returns structure with surface data codes for use with zGetSurfaceData
%
% Usage : SurfDataCodes = zSurfDataCodes
%
% Returns a struct with the following fields and values, coresponding to the codes required by the
% zGetSurfaceData call.
%
% type = 0       - Surface type name. ( 8 character string)
% comment = 1    - Surface Comment. (string)
% curvature = 2  - Surface Curvature (numeric).
% thickness = 3  - Thickness. (numeric)
% glass = 4      - Glass. (string)
% semidia = 5    - Semi-Diameter. (numeric)
% conic = 6      - Conic. (numeric)
% coating = 7    - Coating. (string)
%
% See also zGetSurfaceData, zSetSurfaceData
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

SurfDataCodes = struct('type', 0, 'comment', 1, 'curvature', 2, 'thickness', 3, 'glass', 4, 'semidia', 5, 'conic', 6, 'coating', 7);
