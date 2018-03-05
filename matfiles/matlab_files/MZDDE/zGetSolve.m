function SolveData = zGetSolve(Surface, Code)
% zGetSolve - Requests data for solves and/or pickups on lens surfaces.
%
% Usage : SolveData = zGetSolve(Surface, Code)
%
% where Code is
% an integer code indicating which surface parameter the solve data is for. The solve data is returned in the following
% vector formats, depending upon the code value according to the following table.
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
% The solvetype is an integer code, and the parameters have meanings that depend upon the solve type; see
% the chapter "Solves" for details. The Introduction gives a summary for the various solve types.
%
% See also zSetSolve.
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
DDECommand = sprintf('GetSolve,%i,%i', Surface, Code);
Reply = ddereq(ZemaxDDEChannel, DDECommand, [1 1], ZemaxDDETimeout);
% Replace commas with spaces
Reply = strrep(Reply, ',', ' ');
% Scan for the parameters
[col, count, errmsg] = sscanf(Reply, '%f');
SolveData = col';
