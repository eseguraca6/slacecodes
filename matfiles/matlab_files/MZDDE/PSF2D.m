function PSF2D=PSF2D(Lambda, w, F, xres, yres, ds, e)
% PSF2D(Wavelengths, Wavelength_Weights, Focal_Ratio, Number_of_X_Pixels, Number_of_Y_Pixels, Pixel_Pitch, Central_Obscuration_Ratio)
%
% Computes a normalised 2-dimensional image of the polychromatic diffraction-limited point spread function.
% The number of pixels in x and y can be specified, along with the pixel pitch.
% A central obscuration can be specified with the ratio of the obscuration diameter to the total diameter.
% The x and y pixel counts should be even.
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

% First find the length of the image semidiagonal in pixels.
semidiag = sqrt((xres/2)^2 + (yres/2)^2);

% Next compute the radial distances to compute the 1D PSF
r = 0:ds:(ds*(semidiag + 0.01 * semidiag)); % Ensure we get far enough out

% semidiag = round(semidiag);

% Compute the 1D PSF
apPSF = PPSF(Lambda, w, F, r, e);

% Now compute the radial distance of the centre of each pixel from the centre of the image
x = -xres/2:1:xres/2;
y = -yres/2:1:yres/2;
[x,y] = meshgrid(x,y);
rr = ds * sqrt(x.*x + y.*y); % Radial distance of each pixel

% Interpolate the 2D image
PSF2D = interp1(r, apPSF, rr, 'spline');



