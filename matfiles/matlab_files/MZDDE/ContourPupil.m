function [x,y,px,py] = ContourPupil(ObHeight, PupRadius, nRays, iWave)
% ContourPupil : Return image coordinates of a ring of rays in the current Zemax lens pupil
%
% Usage :
%   >> [x,y,px,py] = ContourPupil(ObHeight, PupRadius, nRays);
%     or
%   >> [x,y,px,py] = ContourPupil(ObHeight, PupRadius, nRays, iWave);
%
% Where :
%  ObHeight is the fractional object height. Can be scalar or a two component
%    vector giving the fractional x and y object coordinates (hx and hy).
%    If scalar, ObHeight is taken to be the y coordinate (hy).
%  PupRadius is the fractional pupil coordinate of the ring of rays to be traced.
%    This input must be scalar.
%  nRays is the number of rays in the ring to be traced. nRays must 
%  iWave is the Zemax wavelength number to use. If not given, the wavelength is
%    assumed to be wavelength 1.
%  px and py are the computed relative pupil coordinates.
%  x and y are the image plane coodinates of the ray intersections.
%
% Example :
%   >> [x,y] = ContourPupil(1, 1, 100);
%   >> plot([x x(1)],[y y(1)]);
%
% The above example traces 100 rays from full field position in the y direction around
% the edge of the pupil and gives the x and y coordinates of the ray intersections in
% the image plane. The complete ray trajectory contour is then plotted.

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

% $Date: 2009-10-30 09:07:07 +0200 (Fri, 30 Oct 2009) $
% $Revision: 221 $
% $Author: DGriffith $

%% Exercise some input control
switch prod(size(ObHeight))
    case 1
        hx = 0;
        hy = ObHeight;
    case 2
        hx = ObHeight(1);
        hy = ObHeight(2);
    otherwise
        error('ContourPupil:BadObHeight', 'ObHeight input must be scalar or two component vector.')
end

nRays = round(abs(nRays(1)));
if nRays < 3
    error('ContourPupil:BadnRays', 'Input nRays must be positive integer greater than 2.')
end

if ~exist('iWave', 'var')
    iWave = 1;
else
    iWave = round(abs(iWave(1)));
end

PupRadius = abs(PupRadius(1));

%% Calculate the pupil coordinates
% Get the theta angles of the rays in the pupil
dtheta = 2*pi /nRays;

theta = 0:dtheta:(2*pi-dtheta/2);

px = PupRadius * cos(theta);
py = PupRadius * sin(theta);
RealRayTrace = 0; % Perform tracing of real rays - paraxial rays are boring
Surface = -1; % Trace right through to image surface

%% Trace rays at the computed pupil coordinates
for iRay = 1:length(px)
    RayTraceData = zGetTrace(iWave, RealRayTrace, Surface, hx, hy, px(iRay), py(iRay));
    % If there is no error, populate the outputs, otherwise insert NaNs.
    if RayTraceData(1) == 0 % Ray traced successfully (may still have been vignetted)
        x(iRay) = RayTraceData(3);
        y(iRay) = RayTraceData(4);
    else
        x(iRay) = NaN;
        y(iRay) = NaN;
    end
end
