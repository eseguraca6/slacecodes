function yRotationMatrix = xdRot(Angle)
% ydRot - Compute a rotation matrix for rotation about the y-axis in degrees.
%
% Usage : yRotationMatrix = ydRot(Angle)
%
% The angle must be in degrees.
% The coordinate system convention is the same as for ZEMAX.


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
Angle = Angle*pi/180; % Convert to radians
yRotationMatrix = [cos(Angle) 0 sin(Angle); 0 1 0; -sin(Angle) 0 cos(Angle)];
