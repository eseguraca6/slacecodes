function [RotationMatrix, Position] = zGetNSCMatrix(SurfaceNumber, ObjectNumber)
% zGetNSCMatrix : Get global rotation matrix and global position of an NSC object
%
% Usage :
%  >> [RotationMatrix, Position] = zGetNSCMatrix(SurfaceNumber, ObjectNumber)
%
% Where :
%   SurfaceNumber and ObjectNumer are the surface and object numbers of
%   the NSC object for which the rotation matrix and position are required.
%
%   RotationMatrix is the global rotation (3 by 3) matrix of the object.
%   Position is the global x,y,z position of the object as a column vector.
%
% If the global tilts about the z, y and x axes in that order are zd, yd and xd
% in degrees, then the RotationMatrix returned should be the same as
% xdRot(xd) * ydRot(yd) * zdRot(zd).
%
% See also : xdRot, ydRot, zdRot

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
% $Author: DGriffith $

global ZemaxDDEChannel ZemaxDDETimeout
DDECommand = sprintf('GetNSCMatrix,%i,%i',SurfaceNumber, ObjectNumber);
Reply = ddereq(ZemaxDDEChannel, DDECommand, [1 1], ZemaxDDETimeout);
[col, count, errmsg] = sscanf(Reply, '%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f');
Position = col(10:12);
RotationMatrix = reshape(col(1:9),3,3)';
