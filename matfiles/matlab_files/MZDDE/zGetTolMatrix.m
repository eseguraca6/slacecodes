function [TolTypes, TolMatrix] = zGetTolMatrix()
% zGetTolMatrix - Extracts a matrix containing all tolerance data from the ZEMAX tolerance editor.
%
% Usage: [TolTypes, TolMatrix] = zGetTolMatrix
%
% Retrieves all tolerance types in a column vector (TolTypes) of 4-letter mnemonics.
% TolMatrix is a matrix of tolerance parameters as defined for zGetTol.
%
% See also zGetTolCount, zGetTol
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
TolCount = zGetTolCount;
for iii = 1:TolCount 
  DDECommand = sprintf('GetTol,%i',iii);
  Reply = ddereq(ZemaxDDEChannel, DDECommand, [1 1], ZemaxDDETimeout);
  [Mnemonic, Reply] = strtok(Reply, ' ,');
  TolTypes(iii,:) = Mnemonic;
  [col, count, errmsg] = sscanf(Reply, ',%f,%f,%f,%f');
  TolMatrix(iii,1) = col(1);
  TolMatrix(iii,2) = col(2);
  TolMatrix(iii,3) = col(3);
  TolMatrix(iii,4) = col(4);
end



