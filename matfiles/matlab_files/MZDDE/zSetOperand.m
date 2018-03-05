function OperandDatum = zSetOperand(Row, Column, Value)
% zSetOperand - Inserts data into the Merit Function Editor in ZEMAX.
%
% Usage : OperandDatum = zSetOperand(Row, Column, Value)
% Row is the operand row number in the Merit Function Editor. Column is 1 for type, 2 for int1, 3 for int2, 4-7 for
% hx-py, 8 for target, and 9 for weight. The returned value is the same as for zGetOperand. 
%
% For a list of type codes, type "help zemaxoperands" at the Matlab prompt.
% Returns the Value or NaN (not-a-number) if the command times out.
%
% See also zSetOperandMatrix, zGetOperand, zGetOperandMatrix
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
DDECommand = sprintf('SetOperand,%i,%i,%1.20g',Row, Column, Value);
Reply = ddereq(ZemaxDDEChannel, DDECommand, [1 1], ZemaxDDETimeout);
if (Reply), OperandDatum = str2double(Reply); else OperandDatum = NaN; end;


