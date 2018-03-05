function Status = zInsertSurface(SurfaceNumber)
% zInsertSurface - Insert a lens surface in the ZEMAX DDE server.
%
% Usage : Status = zInsertSurface(SurfaceNumber)
% The new surface will be placed at the location indicated by the parameter surf. See also zSetSurfaceData to define
% data for the new surface.
%
% See also zDeleteSurface
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
DDECommand = sprintf('InsertSurface,%i',SurfaceNumber);
Status = ddereq(ZemaxDDEChannel, DDECommand, [1 1], ZemaxDDETimeout);

