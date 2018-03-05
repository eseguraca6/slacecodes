function FieldData = zGetField(FieldNumber)
% zGetField - Requests data on lens field points from the Zemax DDE server.
%
% Usage : 
% >> FieldData = zGetField(FieldNumber)
%
% Returns a row vector for field point number FieldNumber. The vector contains xfield, yfield, weight, vdx, vdy, vcx, vcy, van.
% If the FieldNumber is given as 0, the data returned is a 2-element row vector containing type, number.
% The parameter type is an integer; either 0, 1, or 2, for angles in degrees, object height, or paraxial image height,
% respectively and 3 for real image height. The parameter number is the number of fields currently defined.
%
% or
%
% >> FieldInfo = zGetField(0)
% In this usage, field point information is returned in a vector as follows
% [type, number, max_x_field, max_y_field] where type is the field type, being
%                   0 for field angle in degrees,
%                   1 for object height in lens units,
%                   2 paraxial image height in lens units,
%                   3 real image height in lens units.
% number is the number of field points and max_x_field and max_y_field are the maximum field points in the x and y directions.
% 
%
% See also zSetField, GetField.
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
DDECommand = sprintf('GetField,%i',FieldNumber);
Reply = ddereq(ZemaxDDEChannel, DDECommand, [1 1], ZemaxDDETimeout);
if FieldNumber == 0
   [col, count, errmsg] = sscanf(Reply, '%i,%i,%f,%f');
else
   [col, count, errmsg] = sscanf(Reply, '%f,%f,%f,%f,%f,%f,%f,%f');
end
FieldData = col';



