function [RotationMatrix,ColVector] = zGetGlobalMatrix(SurfaceNumber)
% zGetGlobalMatrix - Requests global matrix transform for a lens surface.
%
% Usage : [RotationMatrix,ColVector] = zGetGlobalMatrix(SurfaceNumber)
%
% Returns the matrix required to convert any local coordinates (such as from a ray trace) into global
% coordinates. For details on the global coordinate matrix, see the section “Global Coordinate Reference Surface“
% in the System Menu chapter of the ZEMAX manual. Also returns the column vector which must be added
% to the rotated vector to yield the global coordinates.
%
% That is GlobalColVector = ColVector + RotationMatrix * LocalColVector
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
DDECommand = sprintf('GetGlobalMatrix,%i',SurfaceNumber);
Reply = ddereq(ZemaxDDEChannel, DDECommand, [1 1], ZemaxDDETimeout);
[col, count, errmsg] = sscanf(Reply, '%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f');
RotationMatrix(1,1) = col(1);
RotationMatrix(1,2) = col(2);
RotationMatrix(1,3) = col(3);
RotationMatrix(2,1) = col(4);
RotationMatrix(2,2) = col(5);
RotationMatrix(2,3) = col(6);
RotationMatrix(3,1) = col(7);
RotationMatrix(3,2) = col(8);
RotationMatrix(3,3) = col(9);
ColVector(1,1) = col(10);
ColVector(2,1) = col(11);
ColVector(3,1) = col(12);



