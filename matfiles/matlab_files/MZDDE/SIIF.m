function siif = SIIF(Lambda, F, e, L_s, L_b, tau, a_s, x)
% SIIF - The Slit Image Irradiance Function
%
% Usage : E_SIIF = SIIF(Wavelengths, Focal_ratio, Obscuration_Ratio, Slit_Radiance, Background_Radiance, Path_Transmission, Projected_Slit_Width,
%                       Spatial_Sample_Positions);
%
% Returns the diffraction-limited slit image irradiance function for a lens with an annular aperture 
% for each of the wavelengths given (rows) and for each of the spatial positions (columns).
% 
% The other parameters are the slit radiance, background radiance and path transmission from the slit to the focal plane, including the 
% loss due to the central obscuration. These parameters must all be given at the Wavelengths passed in the first parameter.
% The routine also requires the width of the slit as projected at the image plane (i.e. taking the total magnification from slit object to
% image into account).
%
% It is important to note that all length parameters (Wavelength, Projected_Slit_Width and Spatial_Sample_Positions) MUST be given in the same units.
% 
% This routine is provided chiefly for use in a laboratory setting where the lens is presented with a slit projected to infinity by a
% collimator, and the slit radiance is measured in parallel light. However, if the focal ratio is taken to mean the "working" focal ratio,
% then other geometries could be included. The peak image irradiance is computed using the simple relation E = pi L / (4 F^2), where L is
% the slit (or background) radiance and F is the working focal ratio. We assume object and image in air.
%
% The only parameters that may be vector quantities are Wavelengths, Slit_Radiance, Background_Radiance and Path_Transmission, and these must have 
% the same lengths. The Spatial_Sample_Positions is also a vector, but of any length. The sample positions can be anywhere (positive or
% negative), but values that are too large will cause an error. The overall spatial window of this computation is limited by the number of
% samples that are taken for the FFT - see below.
% 
% The SIIF is returned at the wavelengths requested (rows) and at the spatial positions requested (columns), and will carry the same length
% units as the radiance input parameters. That is, if the radiance is passed in W/sr/m^2/micron, then the irradiance (SIIF) will emerge in
% W/m^2/micron.
% 
% This routine calculates the MTF at 128 points from 0 to the cutoff frequency, and pads with zeros out to a total of 2048 points before
% taking the FFT to find the SSF. This should provide adequate accuracy for most purposes, but can be increased if better accuracy is
% required, or decreased if more speed is required. Adjust the parameters 'density' and 'padout' in the code. Keep them powers of 2 to
% increase the speed of the FFT. Pad out typically to 8 times the density value.
%
% If the slit is very narrow, the radiance of the slit may not be equal to the radiance of the source behind the slit, due to diffraction.
% This effect is not taken into account in this computation. Also, the slit must be incoherently illuminated for this computation to be
% valid. Coherent illumination causes a single slit diffraction pattern to apodize the irradiance of the collimator pupil. For incoherent
% illumination of the slit, there is still some apodization of the pupil, namely a single cosine factor. This can be eliminated by using a
% hot wire instead of a back-illuminated slit, but for an F/6 collimator the effect is very small (~0.3% apodization). 
%


% In cases where many wavelengths must be dealt with, it will save time to halve the density and padout numbers.
density = 128; % Use this number of samples in the MTF out to the cutoff frequency
padout = 2048; % Pad the MTF to this number of samples using zeros; 

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

% Verify all the input parameters.

% First ensure wavelengths are a column vector - reshape radiance and tau to column vectors as well
Lambda = reshape(Lambda, size(Lambda,1)*size(Lambda,2),1);
L_s = reshape(L_s, size(L_s,1)*size(L_s,2),1);
L_b = reshape(L_b, size(L_b,1)*size(L_b,2),1);
tau = reshape(tau, size(tau,1)*size(tau,2),1);
% Next ensure radiance and transmission are the same lengths as Lambda
if length(L_s) ~= length(Lambda)
    error('Slit Radiance data must be given at input Wavelengths.');
end
if length(L_b) ~= length(Lambda)
    error('Background Radiance data must be given at input Wavelengths.');
end
if length(tau) ~= length(Lambda)
    error('Transmission data must be given at input Wavelengths.');
end

% Make sure that x is a row vector
x = reshape(x, 1, size(x,1)*size(x,2));

% Ensure F,e, a_s positive
F = abs(F(1));
e = abs(e(1));
a_s= abs(a_s(1));

% Next thing is to calculate the SSF (slit spread function)

% Start by computing the obscured MTF at all the mavelengths
% First establish the cutoff frequency
cutoff = 1/(min(Lambda)*F);
df = cutoff/(density - 1); % These are the frequency steps we will be using
deltax = 1/(padout*df); % These are the spatial steps we will be using
% Compute the positions at which we will evaluate the SSF and SIIF
nx = -(padout/2):1:(padout/2 - 1);
xx = nx * deltax;
xxmax = max(xx);
xxmin = min(xx);

% Winge if the user has requested samples outside this window
if (min(x) < xxmin) || (max(x) > xxmax)
    disp('There are x positions that are outside the range of the computation window.');
    disp('If you really need results at these positions, consider altering the density');
    disp('and/or padout parameters in the code of this routine.');
    error('Aborted');
end

% Winge if the slit width is wider than 75% of the spatial window
if a_s > (0.75 *(xxmax-xxmin))
    disp('The slit width is more than 75% of the spatial window. Consider adjusting the algorithm for this computation.');
    disp('The spatial window can be increased by increasing the padout parameter in the code of this routine.');
    error('Aborted');
end

% Use spatial frequencies up to cutoff
sf = 0:df:cutoff;

% Compute the obscured MTF for all wavelengths and spatial frequencies
% Result comes back frequencies along rows, wavelengths down columns
if e==0
  MTFe = MTF(Lambda, F, sf);  % Use unobscured calc if no central obscuration
else
  MTFe = MTFobs(Lambda, F, e, sf);
end
% Now multiply by the transfer function of the slit, the sinc function may only be implemented in the signals toolbox.
% See if toolbox sinc is available, otherwise improvise
if isempty(which('sinc')) % sinc function not available
  sfZeros = find(sf == 0); % find zeros in spatial frequencies
  sf(sfZeros) = 1; % replace with arbitrary non-zero value
  MTFs = sin(pi * a_s * sf) ./ (pi * a_s * sf);
  MTFs(sfZeros) = 1; % put in ones where the sf was zero.
else
  MTFs = sinc(a_s * sf);
end
% Duplicate down rows for each wavelength
MTFs = repmat(MTFs, length(Lambda), 1);

totalmtf = MTFe .* MTFs;

% Reflect and pad with zeros on either side so that total length is padout
padding = padout/2 - density;
totalmtf = [zeros(length(Lambda),padding + 1), fliplr(totalmtf(:,2:end)), totalmtf, zeros(length(Lambda),padding)];

% Now take the FFT of each row - this gives the slit spread function
ssf = fftshift(abs(fft(totalmtf,[],2)),2);

% What remains is to normalise correctly
% Next integrate energy ssf
ssfarea = deltax * trapz(ssf,2);

% Compute flux per unit length of slit getting through to the image plane
% First compute irradiance in perfect slit image
E_s = pi * L_s .* tau / (4 * F^2);
% And compute background irradiance
E_b = pi * L_b .* tau / (4 * F^2);

Phi_s = E_s * a_s;

% Now scale the ssf so that the area is the same as Phi_s
siif = ssf .* repmat((Phi_s ./ ssfarea),1,padout);

% Next deal with the background contribution
% We assume that the spread function for the background is just the arithmetic inverse of the ssf
ssfb = - ssf;
% The area under this curve will be negative
ssfbarea = -ssfarea;

% Compute the total background flux per unit length as a negative contribution
Phi_b = -E_b * a_s;
% and normalise the background to have the same flux
siifb = ssfb .* repmat((Phi_b ./ ssfbarea),1,padout);

% Add in the background flux and raise up onto a pedestal of E_b
siif = siif + siifb + repmat(E_b, 1, padout);

% Finally, interpolate the result to the positions the user requested
siif = interp1(xx, siif', x, 'spline')';

