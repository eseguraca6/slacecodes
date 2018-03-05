function RayData = genRayDataMode0(hx, hy, px, py, radius, raytracingmode, finalsurface, intensity, wavenumber, opdrequest)
% genRayDataMode0 - generates a raydata structure suitable for passing to zArrayTrace mode 0.
%
% Usage : RayData = genRayDataMode0(hx, hy, px, py, radius, ...
%                                   raytracingmode, finalsurface, intensity, wavenumber, opdrequest)
%
% hx and hy are scalars giving fractional field coordinates.
% px and py are vectors of fractional pupil coordinates. radius is the maximum radius for which points should
% be generated in the pupil.
% raytracingmode is set to 0 for real rays and 1 for paraxial rays.
% finalsurface is the surface at which to stop raytracing. Use -1 for the image surface.
% intensity is the initial intensity to assign to each ray.
% wavenumber is the wavelength number for the raytrace.
% opdrequest is set to 0 for no OPD calculation. Set to 1 to request OPD calculation.
%
% The structure RayData which is returned is suitable for passing directly to zArrayTrace.
% Example :
% >> RayDataIn = genRayDataMode0(0, 0, 0:0.1:1, 0:0.1:1, 1, 0, -1, 1, 1, 0);
% >> RayDataOut = zArrayTrace(RayDataIn)
% The above will generate rays starting on axis (hx, hy = 0), and will trace to a square grid of point in the pupil having a 
% spacing of 0.1 in the positive quadrant for x and y. Real rays at wavelength 1 with a starting intensity of 1 will be traced
% right through to the imaging surface. OPD data will not be returned.
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

GridData = gridXYRayData(px, py, 'z', 'l', radius);

RayData = repmat(struct('x', hx, 'y', hy,  'z', 0, 'l', 0, 'opd', 0, 'intensity', intensity,  'wave', wavenumber,...
                        'error', 0, 'vigcode', 0', 'want_opd', 0), ...
                 1, length(GridData));
% Put in the pupil coordinates             
[RayData.z] = deal(GridData.z);
[RayData.l] = deal(GridData.l);

% Lastly, add the header element at the start of the array.
RayData = cat(2,RayData(1),RayData);  % Simply duplicate the first element

% Zero out the unwanted fields in element 1 to avoid confusion
RayData(1).x = 0;
RayData(1).y = 0;
RayData(1).z = 0;
RayData(1).l = 0;
RayData(1).intensity = 0;
RayData(1).wave = 0;

% Insert the non-zero elements, especially the "error" field which carries the number of rays
RayData(1).opd = 0; % Would default to zero, but state the mode selection explicitly for reference.
RayData(1).wave = raytracingmode; % Selects real or paraxial mode.
RayData(1).error = numel(RayData)-1; % This is the number of rays.
RayData(1).want_opd = finalsurface;  % Surface to raytrace to. -1 signifies image surface.

% This structure should be all good for zArrayTrace mode 0 ...


