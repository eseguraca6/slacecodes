function [TolType, TolData] = zGetTol(TolNumber)
% zGetTol - Extracts lens tolerance data from the ZEMAX tolerance editor.
%
% Usage: [TolType, TolData] = zGetTol(TolNumber)

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


% where TolNumber the tolerance operand number. 
% If TolNumber is not zero, and corresponds to a valid
% tolerance operand number, the returned data contains the following
% TolType is a four letter mnemonic for the tolerance type
% TolData is a row vector containing the int1, int2, min, max
%
% If TolNumber is out of range, TolType returns 'TOFF' and Toldata returns the total number of operands
% as for zGetTolCount.
%
% See also zGetTolCount
%

% $Revision: 221 $

global ZemaxDDEChannel ZemaxDDETimeout
TolCount = zGetTolCount;
if (TolNumber >= 1) & (TolNumber <= TolCount) 
  DDECommand = sprintf('GetTol,%i',TolNumber);
  Reply = ddereq(ZemaxDDEChannel, DDECommand, [1 1], ZemaxDDETimeout);
  [TolType, Reply] = strtok(Reply, ' ,');
  [col, count, errmsg] = sscanf(Reply, ',%f,%f,%f,%f');
  TolData = col';
else
   TolType = 'TOFF';
   TolData = TolCount;
end


