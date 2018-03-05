function OperandMatrix = zGetOperandMatrix(WantStruct)
% zGetOperandMatrix - Uses a sequence of calls to zGetOperand until the entire Merit Function has been retrieved.
%
% Usage : OperandMatrix = zGetOperandMatrix
%         OperandMatrix = zGetOperandMatrix(WantStruct)
% Returns a cell array of 11 columns and as many rows as there are operands in the merit function.
% Column 1 is the operand type as a string, such as "EFFL", 2 is int1, 3 is int2, 4-7 are data1-data4, 8 is target, 
%  9 is weight, 10 is current value, and 11 for percent contribution.
%
% If the WantStruct parameter is specified as logical 1, then the merit function is returned as a structure with the
% following fields. 
% type, int1, int2, data1, data2, data3, data4, target, weight, value, contribution
%
% Examples :
% >> MFunction = zGetOperandMatrix; % Gets the entire merit function in a cell array
% >> MeritFunction = zGetOperandMatrix(1); % Gets the entire merit function in a structure
% >> Operands = strvcat(MeritFunction.type); % Get all the 4-letter operand codes in a char matrix
% >> Contributions = [MeritFunction.contribution]'; % Get percentage contributions in Contributions
%
% See also zGetOperand, ZemaxOperands
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

iii = 1;
OperandType = zGetOperand(iii, 1);
if isnan(OperandType) % timeout
    OperandMatrix = [];
    return;
end

while (OperandType ~= 0)
   OperandMatrix{iii, 1} = OperandType;
   for jjj = 2:11,
      OperandMatrix{iii, jjj} = zGetOperand(iii, jjj);
   end
   iii = iii + 1;
   OperandType = zGetOperand(iii, 1);
end

if exist('WantStruct','var') && WantStruct
    OperandMatrix = cell2struct(OperandMatrix, {'type','int1','int2','data1','data2','data3','data4','target','weight','value','contribution'},2);
end
