function zRotationMatrix = zdRot(Angle)
% zdRot - Compute a rotation matrix for rotation about the z-axis in degrees.
%
% Usage : zRotationMatrix = zdRot(Angle)
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
zRotationMatrix = [cos(Angle) -sin(Angle) 0; sin(Angle) cos(Angle) 0; 0 0 1];

