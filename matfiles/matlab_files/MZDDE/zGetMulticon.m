function [OperandType, OperandValue, OperandData] = zGetMulticon(ConfigNumber, RowNumber)
% zGetMulticon - Extract data from the ZEMAX multi-configuration editor.
%
% Usage : [OperandType, OperandValue, OperandData] = zGetMulticon(ConfigNumber, RowNumber)
%
% If ConfigNumber is greater than 1 and less than or equal to the number of configurations, the returned
% parameters are as follows :
% OperandType is the four letter operand type name as detailed in the 'Optimization/Optimization
% operands' section of the ZEMAX manual.
% OperandValue could be numeric or a string depending on OperandType. If OperandType is 'GLSS',
% 'MOFF', 'MCOM', or 'COTN', then OperandValue is a string. Otherwise it is numeric.
% OperandData will be a row vector comprising NumberConfig and NumberRow which are the total number of 
% configs and rows in the multi-configuration editor.
% If the ConfigNumber is zero, the multicon operand type data is returned as follows:
% OperandType is the type as before
% OperandValue is zero and OperandData is a row vector comprising Number1, Number2, Number3
% These numbers are described in 'Summary of multi-configuration operands' in the ZEMAX manual.
%
% See also zSetMulticon.
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
DDECommand = sprintf('GetMulticon,0,%i', RowNumber);
Reply = ddereq(ZemaxDDEChannel, DDECommand, [1 1], ZemaxDDETimeout);
[OperandType, Reply] = strtok(Reply, ' ,');
if ConfigNumber == 0
   [col, count, errmsg] = sscanf(Reply, ',%f,%f,%f');
   OperandValue = 0;
   OperandData = col';
else
   DDECommand = sprintf('GetMulticon,%i,%i',ConfigNumber, RowNumber);
   Reply = ddereq(ZemaxDDEChannel, DDECommand, [1 1], ZemaxDDETimeout);
   if (OperandType == 'GLSS') | (OperandType == 'MCOM') | (OperandType == 'COTN') | (OperandType == 'MOFF')
      [OperandValue, Reply] = strtok(Reply, ',');
      [col, count, errmsg] = sscanf(Reply, ',%f,%f');
      OperandData = col';
   else
      [col, count, errmsg] = sscanf(Reply, '%f,%f,%f');
      OperandValue = col(1);
      OperandData = col(2:3)';
   end
end


