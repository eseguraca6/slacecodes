function RayData = genRayDataMode2(hx, hy, px, py, radius, raytracingmode, finalsurface, intensity, wavenumber, Ex, Ey, Phax, Phay)
% genRayDataMode0 - generates a raydata structure suitable for passing to zArrayTrace mode 2 (polarization trace).
%
% Usage : RayData = genRayDataMode2(hx, hy, px, py, radius, raytracingmode, ...
%                                   finalsurface, intensity, wavenumber, Ex, Ey, Phax, Phay)
%
% hx and hy are scalars giving fractional field coordinates.
% px and py are vectors of fractional pupil coordinates. radius is the maximum radius for which points should
% be generated in the pupil.
% raytracingmode is set to 0 for real rays and 1 for paraxial rays.
% finalsurface is the surface at which to stop raytracing. Use -1 for the image surface.
% intensity is the initial intensity to assign to each ray.
% wavenumber is the wavelength number for the raytrace.
% Ex, Ey, Phax, Phay is the starting polarization state for all rays. Set all to zero for unpolarized raytrace.
% This routine cannot be used if you want polarization states to be different for different rays.
%
% The structure RayData which is returned is suitable for passing directly to zArrayTrace.
% Example :
% >> RayDataIn = genRayDataMode2(0, 0, 0:0.1:1, 0:0.1:1, 1, 0, -1, 1, 1, 0, 0, 0, 0);
% >> RayDataOut = zArrayTrace(RayDataIn)
% The above will generate rays starting on axis (hx, hy = 0), and will trace to a square grid of points in the pupil having a 
% spacing of 0.1 in the positive quadrant for x and y. Real rays at wavelength 1 with a starting intensity of 1 will be traced
% right through to the imaging surface. The ray will start unpolarized.
%
% See also zArrayTrace, gridXYRayData

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

% First grid the px and py data using the radius limiter.

% Get the pupil coordinates
GridData = gridXYRayData(px, py, 'z', 'l', radius);
RayData = repmat(struct('x', hx, 'y', hy,  'z', 0, 'l', 0, 'opd', 0, 'intensity', intensity,  'Exr', 0, 'Exi', 0, 'Eyr', 0,'Eyi',0, 'Ezr', 0, 'Ezi', 0, 'wave', wavenumber,...
                        'error', 0, 'vigcode', 0', 'want_opd', 0), ...
                 1, length(GridData));
% Put in the pupil coordinates             
[RayData.z] = deal(GridData.z);
[RayData.l] = deal(GridData.l);

% Lastly, add the header element at the start of the array.
RayData = cat(2,RayData(1),RayData);  % Simply duplicate the first element

% Set the polarization state
RayData(1).x = Ex;
RayData(1).y = Ey;
RayData(1).z = Phax;
RayData(1).l = Phay;
RayData(1).intensity = 0;
RayData(1).wave = 0;

% Insert the non-zero elements, especially the "error" field which carries the number of rays
RayData(1).opd = 2; % Mode 2 raytracing
RayData(1).wave = raytracingmode; % Selects real or paraxial mode.
RayData(1).error = numel(RayData)-1; % This is the number of rays.
RayData(1).want_opd = finalsurface;  % Surface to raytrace to. -1 signifies image surface.

% This structure should be all good for zArrayTrace mode 2 ...


