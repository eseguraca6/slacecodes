function OperandDatum = zGetOperand(Row, Column)
% zGetOperand - Requests data from the Merit Function Editor in ZEMAX.
%
% Usage : OperandDatum = zGetOperand(Row, Column)
% Row is the operand row number in the Merit Function Editor. Column is 1 for type (char), 2 for int1, 3 for int2, 4-7 for
% hx-py, 8 for target, 9 for weight, 10 for value, and 11 for percent contribution. The returned datum is the numeric
% value of the requested parameter. If the command times out, NaN (Not-a-Number) is returned.
%
% The type (column 1) is a 4 letter alphabetic code. This will return as numeric 0 if the row given exceeds the
% maximum number of rows in the merit function.
%
% Example :
% >> OpType = zGetOperand(1,1); % Gets 4-letter operand code of operand 1
%
% For a list of type codes, type "help ZemaxOperands" at the Matlab prompt.
%
% See also zSetOperand, ZemaxOperands.
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
DDECommand = sprintf('GetOperand,%i,%i',Row, Column);
Reply = ddereq(ZemaxDDEChannel, DDECommand, [1 1], ZemaxDDETimeout);
if ~isempty(Reply)
   OperandDatum = str2num(Reply);
   if isempty(OperandDatum )
       OperandDatum = strtrim(Reply);
   end
else OperandDatum = NaN; 
end


