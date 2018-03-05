function FieldData = zSetFieldType(FieldType, FieldNumber)
% zSetFieldType - Sets field type and number of field points.
%
% Usage : FieldData = zSetField(FieldType, FieldNumber)
% The parameter FieldType is an integer; either 0, 1, or 2, for angles in degrees, object height, or paraxial image height,
% respectively, 3 for real image height. The parameter FieldNumber is the number of fields to be defined using zSetField.
% The function returns FieldType and FieldNumber in a row vector.
%
% See also zSetField, zGetField.
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
DDECommand = sprintf('SetField,0,%i,%i',FieldType, FieldNumber);
Reply = ddereq(ZemaxDDEChannel, DDECommand, [1 1], ZemaxDDETimeout);
[col, count, errmsg] = sscanf(Reply, '%i,%i');
FieldData = col';



