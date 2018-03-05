function [x, y] = SpiralSpot(Hy, Hx, Wave, Spirals, Rays)
% SpiralSpot - Produces a series of x, y values of rays traced in a spiral over the entrance pupil
%
% Usage : [x, y] = SpiralSpot(ObjectHeighty, ObjectHeightx, Wave, Spirals, Rays)
%         plot(x,y)
% Where the x and y data is the ray landing  data at the image surface in lens units.
%       ObjectHeighty is the fractional object height in y from which the rays are traced.
%       ObjectHeightx is the fractional object height in x from which the rays are traced.
%       Wave is the wavelength number to use.
%       Spirals is the number of spirals to execute.
%       Rays is the number of rays to trace, and therefore the number of x,y pairs as well.

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

zGetRefresh;  % Get the latest lens

FinishAngle = Spirals * 2 * pi;
dTheta = FinishAngle / (Rays-1);
Theta = 0:dTheta:FinishAngle;
R = Theta / FinishAngle;
Px = R .* cos(Theta);
Py = R .* sin(Theta);

for i = 1:length(Px)
  RayTraceData = zGetTrace(Wave, 0, -1, Hx, Hy, Px(i), Py(i));
  if RayTraceData(1) == 0
      x(i) = RayTraceData(3);
      y(i) = RayTraceData(4);
  else
      error('Raytrace Error');
  end
end



