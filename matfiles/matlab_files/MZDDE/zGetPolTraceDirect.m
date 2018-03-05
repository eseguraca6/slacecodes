function PolTraceData = zGetPolTraceDirect(wave, mode, startsurf, stopsurf, x, y, z, l, m, n, Ex, Ey, Phax, Phay)
% zGetPolTraceDirect - Provides the same direct access to the ZEMAX ray tracing engine that GetTraceDirect
% does, and allows for polarized ray tracing as well.
%
% Usage : PolTraceData = zGetPolTraceDirect(wave, mode, startsurf, stopsurf, x, y, z, l, m, n, Ex, Ey, Phax, Phay)
% The data message comes back in the same format as described in GetPolTrace.
% x, y, z, l, m, n define the starting point and direction of the ray.
% The arguments are identical to zGetTraceDirect, except for the additional Ex, Ey, Phax, and Phay arguments. Ex and
% Ey are the normalized electric field magnitudes in the x and y directions. The quantity Ex*Ex + Ey*Ey should have
% a value of 1.0 (with an important exception described below) although any values are accepted. Phax and Phay
% are the relative phase, in degrees.
% If Ex, Ey, Phax, and Phay are all zero, and only in this case, then ZEMAX assumes an "unpolarized" ray trace
% is required. An unpolarized ray trace actually requires ZEMAX to trace two orthogonal rays and the resulting
% transmitted intensity be averaged. If any of the four values are not zero, then a single polarized ray will be traced.
% For example, to trace the real unpolarized marginal ray to the image surface at wavelength 2, the call
% would be
% zGetPolTrace(2,0,-1,0.0,0.0,0.0,1.0,0,0,0,0)
% For polarized rays, the data comes back in the following row vector :
% error, intensity, Exr, Eyr, Ezr, Exi, Eyi, Ezi
% The integer error will be zero if the ray traced successfully, otherwise it will be a positive or negative number.
% If positive, then the ray missed the surface number indicated by error. If negative, then the ray total internal
% reflected (TIR) at the surface given by the absolute value of the error number. Always check to verify the ray data
% is valid before using the rest of the vector.
%
% The intensity will be the transmitted intensity. It is always normalized to an input electric field intensity of unity.
% The transmitted intensity accounts for surface, thin film, and bulk absorption effects, but does not consider
% whether or not the ray was vignetted. The Ex, Ey, and Ez values are the electric field components, with the r and
% i characters denoting the real and imaginary portions.
% For unpolarized rays, the returned row vector is simply:
% error, intensity
%
% See also zGetTrace, zGetTraceDirect, zGetPolTrace
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
DDECommand = sprintf('GetPolTrace,%i,%i,%i,%i,%1.20g,%1.20g,%1.20g,%1.20g,%1.20g,%1.20g,%1.20g,%1.20g,%1.20g,%1.20g', wave, mode, startsurf, stopsurf, x, y, z, l, m, n, Ex, Ey, Phax, Phay);
Reply = ddereq(ZemaxDDEChannel, DDECommand, [1 1], ZemaxDDETimeout);
if (Ex == 0) & (Ey == 0) & (Phax == 0) & (Phay == 0)
   [col, count, errmsg] = sscanf(Reply, '%f,%f');
else
   [col, count, errmsg] = sscanf(Reply, '%f,%f,%f,%f,%f,%f,%f,%f');
end
PolTraceData = col';


