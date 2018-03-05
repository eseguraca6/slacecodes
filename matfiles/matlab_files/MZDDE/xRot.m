function xRotationMatrix = xRot(Angle)
% xRot - Compute a rotation matrix for rotation about the x-axis.
%
% Usage : xRotationMatrix = xRot(Angle)
%
% The angle must be in radians.


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

xRotationMatrix = [1 0 0; 0 cos(Angle) -sin(Angle); 0 sin(Angle) cos(Angle)];

