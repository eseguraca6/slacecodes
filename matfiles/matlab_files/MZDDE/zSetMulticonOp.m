function [rOpType, Numbers] = zSetMulticonOp(RowNumber, OpType, Number1, Number2, Number3)
% zSetMulticonOp - Set an operand type and associated numerical parameters in the ZEMAX
% multi-configuration editor.
%
% Usage : [rOpType, Numbers] = zSetMulticonOp(RowNumber, OpType, Number1, Number2, Number3)
% where RowNumber is the row number in the multiconfiguration editor, OpType is the four letter
% multi-configuration operand name, and the 3 numbers complete the definition of the operand
% according to the 'Summary of Multi-Configuration Operands' section in the ZEMAX manual.
% The function echos the OpType and Numbers. Numbers is a 3-column row vector.
%
% See also zSetMulticon, zGetMulticon
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
DDECommand = sprintf('SetMulticon,0,%i,%s,%1.20g,%1.20g,%1.20g',RowNumber, OpType, Number1, Number2, Number3);
Reply = ddereq(ZemaxDDEChannel, DDECommand, [1 1], ZemaxDDETimeout);
[rOpType, Reply] = strtok(Reply, ',');
[col, count, errmsg] = sscanf(Reply, ',%f,%f,%f');
Numbers = col';
