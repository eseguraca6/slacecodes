function yRotationMatrix = xRot(Angle)
% yRot - Compute a rotation matrix for rotation about the y-axis.
%
% Usage : yRotationMatrix = yRot(Angle)
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

yRotationMatrix = [cos(Angle) 0 sin(Angle); 0 1 0; -sin(Angle) 0 cos(Angle)];
