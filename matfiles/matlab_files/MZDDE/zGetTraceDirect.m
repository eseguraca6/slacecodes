function RayTraceData = zGetTraceDirect(wave, mode, startsurf, stopsurf, x, y, z, l, m, n)
% zGetTraceDirect - Direct access raytrace through the current lens in the ZEMAX DDE server. 
%
% Usage : RayTraceData = zGetTraceDirect(wave, mode, startsurf, stopsurf, x, y, z, l, m, n)
%
% zGetTraceDirect provides a more direct access to the ZEMAX ray tracing engine. Normally, rays are defined
% by the normalized field and pupil coordinates hx, hy, px, and py. ZEMAX takes these normalized coordinates and
% computes the object coordinates (x, y, and z) and the direction cosines to the entrance pupil aim point (l, m, and
% n; for the x-, y-, and z-direction cosines, respectively).
% However, there are times when it is more appropriate to trace rays by direct specification of x, y, z, l, m, and
% n. The direct specification has the added flexibility of defining the starting surface for the ray anywhere in the
% optical system. This flexibility comes at the price of requiring the client program to carefully ensure that the starting
% ray coordinates are meaningful.
% Like zGetTrace, this item requires that the client provide additional data. In order to trace a ray, ZEMAX needs
% to know x, y, z, l, m, n, the wavelength, the mode (either real, mode = 0 or paraxial, mode = 1) as well as the
% starting and stopping surfaces to trace the ray from and to. 
% The data vector comes back in the following format:
% error, vigcode, x, y, z, l, m, n, l2, m2, n2, intensity
% where the parameters are exactly the same as for zGetTrace, except for intensity. The intensity is the relative
% transmitted intensity of the ray, excluding any pupil apodization defined. Note zGetTrace includes pupil apodization,
% zGetTraceDirect does not. Both include surface apodizations.
%
% See also zGetTrace, zGetPolTrace, zGetPolTraceDirect
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
DDECommand = sprintf('GetTraceDirect,%i,%i,%i,%i,%1.20g,%1.20g,%1.20g,%1.20g,%1.20g,%1.20g', wave, mode, startsurf, stopsurf, x, y, z, l, m, n);
Reply = ddereq(ZemaxDDEChannel, DDECommand, [1 1], ZemaxDDETimeout);
[col, count, errmsg] = sscanf(Reply, '%i,%i,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f');
RayTraceData = col';

