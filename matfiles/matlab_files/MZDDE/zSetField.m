function FieldData = zSetField(n, xf, yf, wgt, vdx, vdy, vcx, vcy, van)
% zSetField - Sets field data for a particular field point.
%
% Usage : There are two usage forms...
% >> FieldInfo = zSetField(0, FieldType, NumberOfFieldPoints);
%
% This will set the type and number of field points.
% FieldType must be 0 for field angle in degrees,
%                   1 for object height in lens units,
%                   2 paraxial image height in lens units,
%                   3 real image height in lens units.
%
% The FieldInfo is returned as for zGetField, namely a vector of 4 quantities
% [type, number, max_x_field, max_y_field] where type is the field type as above,
% number is the number of field points and max_x_field and max_y_field are the maximum field points in the x and y directions.
%
% or
%
% >> FieldData = zSetField(n, xf, yf, wgt, vdx, vdy, vcx, vcy, van);
% 
%
% If n is a valid field number (between 1 and the number of fields, inclusive) then the field x and y values, field weight,
% and vignetting factors are all set.  The returned row vector is the same as for zGetField.
%
% See also zGetField
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

if n == 0
    DDECommand = sprintf('SetField,0,%1.20g,%1.20g',xf, yf); % In this usage, xf = FieldType and yf = NumberOfFieldPoints
    Reply = ddereq(ZemaxDDEChannel, DDECommand, [1 1], ZemaxDDETimeout);
    [col, count, errmsg] = sscanf(Reply, '%f,%f,%f,%f'); % Four parameters are returned as for zGetField 
else
    DDECommand = sprintf('SetField,%i,%1.20g,%1.20g,%1.20g,%1.20g,%1.20g,%1.20g,%1.20g,%1.20g',n, xf, yf, wgt, vdx, vdy, vcx, vcy, van);
    Reply = ddereq(ZemaxDDEChannel, DDECommand, [1 1], ZemaxDDETimeout);
    [col, count, errmsg] = sscanf(Reply, '%f,%f,%f,%f,%f,%f,%f,%f');
end
FieldData = col';


