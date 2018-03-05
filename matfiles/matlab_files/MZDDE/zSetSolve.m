function SolveData = zSetSolve(Surface, Code, SolveType, varargin)
% zSetSolve - Sets data for solves and/or pickups on lens surfaces.
%
% Usage : SolveData = zSetSolve(Surface, Code, SolveType, Parameter1, ...)
%
% where Surface is the surface number at which the solve is to be set and Code is
% an integer code indicating which parameter the solve data is for. The solve data is specified in the following
% formats, depending upon the code value according to the following table. The solve takes up to
% four parameters, also depending on the type of solve.
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
% Note that code 5 corresponds to parameter 1, not 0. It is not possible to set a solve on parameter
% number 0.
%
% See also zGetSolve.
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
% Decide how many parameters there should be in the input arguments.

switch Code
  case {0},       
      SolveCodeType = 'curvature';
      switch SolveType
          case {0} , NumParams = 0; SolveTypeText = 'Fixed';
          case {1} , NumParams = 0; SolveTypeText = 'Variable';
          case {2} , NumParams = 1; SolveTypeText = 'Marginal ray angle';
          case {3} , NumParams = 1; SolveTypeText = 'Chief Ray angle';
          case {4} , NumParams = 4; SolveTypeText = 'Pickup';
          case {5} , NumParams = 0; SolveTypeText = 'Marginal ray normal';
          case {6} , NumParams = 0; SolveTypeText = 'Chief ray normal';             
          case {7} , NumParams = 0; SolveTypeText = 'Aplanatic';             
          case {8} , NumParams = 1; SolveTypeText = 'Element power';             
          case {9} , NumParams = 1; SolveTypeText = 'Concentric with surface';             
          case {10}, NumParams = 1; SolveTypeText = 'Concentric with radius';             
          case {11}, NumParams = 1; SolveTypeText = 'Paraxial F/#';             
          case {12}, NumParams = 1; SolveTypeText = 'ZPL macro'; % This does not seem to be available from DDE             
          otherwise  NumParams = 0; SolveTypeText = 'Unknown';
      end
  case {1},       
      SolveCodeType = 'thickness';
      switch SolveType
          case {0} , NumParams = 0; SolveTypeText = 'Fixed';
          case {1} , NumParams = 0; SolveTypeText = 'Variable';
          case {2} , NumParams = 2; SolveTypeText = 'Marginal ray height';
          case {3} , NumParams = 1; SolveTypeText = 'Chief ray height';
          case {4} , NumParams = 2; SolveTypeText = 'Edge thickness';
          case {5} , NumParams = 4; SolveTypeText = 'Pickup';             
          case {6} , NumParams = 2; SolveTypeText = 'Optical path difference';             
          case {7} , NumParams = 2; SolveTypeText = 'Position';             
          case {8} , NumParams = 2; SolveTypeText = 'Compensator';             
          case {9} , NumParams = 1; SolveTypeText = 'Centre of curvature';             
          case {10}, NumParams = 0; SolveTypeText = 'Pupil position';             
          case {11}, NumParams = 1; SolveTypeText = 'ZPL macro'; % This does not seem to be available from DDE            

          otherwise  NumParams = 0; SolveTypeText = 'Unknown';
      end

  case {2},       
      SolveCodeType = 'glass';
      switch SolveType          
          case {0} , NumParams = 0; SolveTypeText = 'Fixed';
          case {1} , NumParams = 3; SolveTypeText = 'Model glass';
          case {2} , NumParams = 1; SolveTypeText = 'Pickup';
          case {3} , NumParams = 1; SolveTypeText = 'Subsitute'; 
          case {4} , NumParams = 2; SolveTypeText = 'Offset';
          otherwise  NumParams = 0; SolveTypeText = 'Unknown';
      end
  case {3},       
      SolveCodeType = 'semi-diameter';
      switch SolveType
          case {0} , NumParams = 0; SolveTypeText = 'Automatic';
          case {1} , NumParams = 0; SolveTypeText = 'Fixed';
          case {2} , NumParams = 4; SolveTypeText = 'Pickup';
          case {3} , NumParams = 0; SolveTypeText = 'Maximum';
          case {4} , NumParams = 1; SolveTypeText = 'ZPL macro';
          otherwise  NumParams = 0; SolveTypeText = 'Unknown';
      end
      
  case {4},       
      SolveCodeType = 'conic';
      switch SolveType
          case {0} , NumParams = 0; SolveTypeText = 'Fixed';
          case {1} , NumParams = 0; SolveTypeText = 'Variable';
          case {2} , NumParams = 4; SolveTypeText = 'Pickup';
          case {3} , NumParams = 1; SolveTypeText = 'ZPL macro';
          otherwise  NumParams = 0; SolveTypeText = 'Unknown';
      end
      
  case num2cell(5:16),    
      SolveCodeType = ['parameter' num2str(Code-4)];
      switch SolveType
          case {0} , NumParams = 0; SolveTypeText = 'Fixed';
          case {1} , NumParams = 0; SolveTypeText = 'Variable';
          case {2} , NumParams = 4; SolveTypeText = 'Pickup';
          case {3} , NumParams = 2; SolveTypeText = 'Chief ray';
          case {4} , NumParams = 1; SolveTypeText = 'ZPL macro';
          otherwise  NumParams = 0; SolveTypeText = 'Unknown';
      end      
  otherwise,      
      SolveCodeType = 'extradata'; % May not be a good assumption
      switch SolveType
          case {0} , NumParams = 0; SolveTypeText = 'Fixed';
          case {1} , NumParams = 0; SolveTypeText = 'Variable';
          case {2} , NumParams = 4; SolveTypeText = 'Pickup';
          case {3} , NumParams = 1; SolveTypeText = 'ZPL macro';
          otherwise  NumParams = 0; SolveTypeText = 'Unknown';
      end
end
DDECommand = sprintf('SetSolve,%i,%i,%i', Surface, Code, SolveType);

if NumParams ~= nargin-3; % Check that user has sent correct number of numeric parameters
    error(['zSetSolve:Incorrect number of numeric parameters given for ' SolveCodeType ' : ' SolveTypeText ' solve. There should be ' num2str(NumParams) ' parameters.'])
end
switch NumParams
    case {1}, DDECommand = [DDECommand sprintf(',%1.20g', varargin{1})];
    case {2}, DDECommand = [DDECommand sprintf(',%1.20g,%1.20g', varargin{1}, varargin{2})];
    case {3}, DDECommand = [DDECommand sprintf(',%1.20g,%1.20g,%1.20g', varargin{1}, varargin{2}, varargin{3})];
    case {4}, DDECommand = [DDECommand sprintf(',%1.20g,%1.20g,%1.20g,%1.20g', varargin{1}, varargin{2}, varargin{3}, varargin{4})];
end
Reply = ddereq(ZemaxDDEChannel, DDECommand, [1 1], ZemaxDDETimeout);

[col, count, errmsg] = sscanf(Reply, '%f,%f,%f,%f,%f', NumParams+1);
SolveData = col';
