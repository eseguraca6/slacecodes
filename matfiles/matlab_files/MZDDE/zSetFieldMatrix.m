function FieldPoints = zSetFieldMatrix(FieldType, FieldDataMatrix)
% zSetFieldMatrix - sets all field points from a matrix
%
% Usage : FieldPoints = zSetFieldMatrix(FieldType, FieldDataMatrix)
%
% Create and pass a matrix having 8 columns of field data xf, yf, wgt, vdx, vdy, vcx, vcy, van
% If the matrix has fewer columns, it will be assumed that columns on the right are zero.
% The matrix can have from 1 to 12 rows.
% The function returns the number of field points set.
% The parameter FieldType is an integer; either 0, 1, or 2, for angles in degrees, object height, or paraxial image height,
% respectively, 3 for real image height.
%
% See also zGetField, zSetField
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

FieldCount = size(FieldDataMatrix,1);
ColCount = size(FieldDataMatrix,2);
if (FieldCount > 12) FieldCount = 12; end;
if (FieldCount <= 0) FieldPoints = 0; return; end;
zSetFieldType(FieldType, FieldCount);
if (ColCount < 8)
   for iii = (ColCount+1):8,
      FieldDataMatrix(:,iii) = 0;
   end
end
for iii = 1:FieldCount,
   zSetField(iii, FieldDataMatrix(iii,1),FieldDataMatrix(iii,2),FieldDataMatrix(iii,3),FieldDataMatrix(iii,4),FieldDataMatrix(iii,5),FieldDataMatrix(iii,6),FieldDataMatrix(iii,7),FieldDataMatrix(iii,8));
end
FieldPoints = FieldCount;



