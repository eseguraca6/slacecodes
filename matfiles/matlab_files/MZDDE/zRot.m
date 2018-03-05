function zRotationMatrix = zRot(Angle)
% zRot - Compute a rotation matrix for rotation about the z-axis.
%
% Usage : zRotationMatrix = zRot(Angle)
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

zRotationMatrix = [cos(Angle) -sin(Angle) 0; sin(Angle) cos(Angle) 0; 0 0 1];

