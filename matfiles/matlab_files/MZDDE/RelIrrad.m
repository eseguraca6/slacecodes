function [x,y,ppx,ppy] = RelIrrad(wave, NumberOfFieldPoints, NumberOfRaysPerFieldPoint)
% RelIrrad - Computes Relative Irradiance (Illuminance perhaps) of the image plane of an axisymmetric lens system.
%
% Usage : RI = RelIrrad(wave, NumberOfFieldPoints, NumberOfRaysPerFieldPoint)
% A number of assumptions are made to get a valid result.
% 1) The object space is filled with radiation of uniform radiance in all directions.
%    i.e. the object space is isotropic in radiance.
%    This condition is similar to putting the system inside an integrating sphere.
% 2) The image irradiance is measured at a planar image surface.
% 3) The lens system is axisymmetric, free of vignetting and other field-dependent transmission modulatiing effects.
% 4) The aberrations of the lens system are negligible except for distortion.
% 5) There are no obscurations in the pupil of the lens, either induced by aberration or mechanically. i.e. the result for a
%    system with a central obscuration will be wrong.
% 6) The method used is to calculate the flux entering the entrance pupil, and then to calculate the flux density arriving at
% the image plane using the distortion function of the lens system. The distortion function is defined as the relationship
% between the angle of the chief ray (central ray at the aperture stop) entering the entrance pupil, and the distance at which
% this ray strikes the image plane from the optical axis.
% 7) This computation should give a similar result to the ZEMAX Relative Illumination (RI) computation, except that the ZEMAX
% result includes vignetting and other field-dependent transmission effects. The result of this computation, however, does
% represent an uppper limit on the image relative irradiance.
% 8) As with the ZEMAX RI computation, the result is normalized to the axial value.
% 9) You must ensure that ZEMAX is accurately finding the edge of the entrance pupil, and ray aiming will most likely have to
% be switched on for systems having internal aperture stops.
% 10) Your field size must be specified in degrees in object space, the object surface must be set to infinity, and your
% maximum field angle must be positive and less than 90 degrees. This routine currently does no checking of these aspects.
%
% wave is the wavelength number at which to perform the analysis.
% The NumberOfFieldPoints parameter determines the number of field points at which to calculate the RI, and the
% NumberOfRaysPerFieldPoint determines the number of rays traced around the edge of the entrance pupil to compute the effective
% collecting area of the pupil.

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

% Start the interface and get the lens in the LDE
zDDEInit; 
zGetRefresh;

% Insert a dummy surface at surface 1.
zInsertSurface(1);
% Set the surface type to Tilted.
%zsetsurfacedata(1, 0, 'TILTSURF')
%zgetsurfacedata(1, 0)

% Set up a loop for all field positions
fieldinc = 1 / NumberOfFieldPoints;
angleinc = pi / NumberOfRaysPerFieldPoint; % we will trace over only a semicircle of rays, since we rely on bilateral symmetry
i = 1;
for relfield = 0:fieldinc:1
    % Run around the edge of the pupil and trace the number of rays requested
    j = 1;
    for angle = 0:angleinc:pi
        % Compute relative pupil coordinates
        px = sin(angle);
        py = cos(angle);
        % Trace a ray and get the ray coordinates at surface 1
        RayTraceData = zGetTrace(wave, 0, 1, 0.0, relfield, px, py);
        if RayTraceData(1)~=0
            error('Raytrace error');
        end
        ppx(i,j) = px;
        ppy(i,j) = py;
        x(i,j) = RayTraceData(3);
        y(i,j) = RayTraceData(4);
        j = j + 1;
    end
    i = i + 1;
end
