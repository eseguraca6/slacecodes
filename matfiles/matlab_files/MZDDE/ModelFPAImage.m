function Results = ModelFPAImage(Waves, Obj, Atm, Lens, FPA)
% ModelFPAImage : Models image sampling in narrow field camera systems.
%
% The chief application of this function is to model sampling of images 
% produced by narrow field cameras, including atmospheric effects, 
% lens effects and the properties of the focal plane array (FPA),
% Various noise mechanisms are modeled.  
%
% Spatial filtering is performed using Fourier techniques.
%
% The signal transfer model is taken from Holst, G.C., "CCD Arrays, 
% Cameras and Displays", SPIE Press and JCD Publishing, Chap. 4, 
% 2nd Edition, pg 104, 1998. The noise model is taken from pg 123.
%
% A good overview of the intention of this model is provided in the
% online report by Thomas Winzell, "Basic Optical Sensor Model",
% Report number FOI--2135--SE, Swedish Defence Research Agency,
% November 2006.
%
% One of the major limitations of the approach taken in this model is the
% assumption of isoplanatism, i.e. that the optical transfer function is
% invariant over the field of view. In general, both atmospheric turbulence
% as well as lens optical transfer functions vary over the field.
%
% Further limitations and assumptions.
% 1) The FPA response is assumed linear with input irradiance.
% 2) The MTF due to the pixel aperture is assumed to be a sinc function.
%    In fact, the MTF of an FPA can vary with wavelength due to photon
%    penetration and charge diffusion. See "CCD Arrays, Cameras and
%    Displays", Section 10.3.1 on pg. 276.
% 3) Interlaced devices are not modeled in that the effect of
%    "serration" is not included. This effect is very annoying in the
%    presence of atmospheric turbulence or other small image motions.
%    It is one of the many reasons that progressive-scan digital
%    cameras are preferable for long range surveillance. In principle
%    serration could be modeled by calling this routine twice with
%    suitable inputs. An example of modeling serration will hopefully
%    become available.
% 4) MTF degradation due to charge transfer efficiency (CTE) effects
%    in the FPA is not included.
% 5) TDI (time delay and integration) devices are not dealt with.
% 6) A practical atmospheric aerosol MTF has not yet been implemented.
%    The work by Kopeika on this topic should serve as the basis for
%    future implementation. See "A System Engineering Approach to
%    Imaging", Chapter 17, SPIE Press, 1998.
%
% Usage : 
%    Results = ModelFPAImage(Wavelengths, Obj, Atm, Lens, FPA)
%
% Where input parameters are ...
% Wavelengths is a vector of wavelengths at which the computation will
%         be performed. Wavelengths must be given in microns.
% 
%   Input Obj is a structure containing information about the object,
%      having the following fields
%         Samples - an array of samples of the object, the first two dimensions being spatial
%                   and the third dimension being spectral. The third dimension must
%                   have the same number of samples as the number of Wavelengths.
%                   Samples can be any numeric class, but are converted to double
%                   for processing. Samples can be spectral radiance or band radiance
%                   if absolute FPA signal levels are required. Spectral radiance must
%                   be given in units of W/m^2/sr/micron. Band radiance is in W/m^2/sr.
%                   Object samples may also be called "scenels". The samples are typically
%                   a synthetic scene or a close range calibrated digital photograph.
%                   Tips for use of digital photography as input objects to this routine.
%                   1) Bear in mind that the digital photograph will contain noise of very
%                   much the same nature as that modeled by this routine. The pictures
%                   should be taken with a high quality, preferably linear CCD camera.
%                   2) Shoot using a tripod at the lowest gain or ISO setting available.
%                   This will help to reduce noise. Shoot in the RAW mode if your camera
%                   has one, and convert to a Matlab-readable image format using dcraw.
%                   3) The camera should have the same or  better bit-depth as the one 
%                   you want to model. It is possible to compensate for noise and lower
%                   bit depth by ensuring that many object pixels (scenels) map onto a 
%                   single image plane FPA pixel. For example ...
%                   if you have 8-bit depth in the object samples and you want to model
%                   a camera with 12 bit depth, then at least 16 object pixels (4 by 4)
%                   must map to one FPA pixel. This oversampling also has the effect of
%                   averaging out the noise in the object samples (scenels).
%         
%         Pitch  - Pitch (spacing) of the object samples in mm. The object must be 
%                  oversampled with reference to the projection onto the FPA pixels. 
%                  Compulsory scalar numeric. The function MeasureImageScale is
%                  one possible method of determining the object sample pitch. If the
%                  object samples are a high resolution digital image, then oversampling
%                  of at least 4 times is advisable. A warning is issued if oversampling
%                  is less than a factor of 4.
%
%         Range  - Distance of the object from the lens. Range must be given in metres.
%                  Compulsory scalar numeric field.
%
%   Input Atm is a structure containing information about the atmosphere,
%      having the following fields, none of which are compulsory. The default is
%      a perfectly clear and still atmosphere.
%         Extinct  - Extinction coefficient of the atmosphere for each of the
%                    wavelengths or wavelength bands. The atmospheric transmission
%                    is computed from the range (distance) of the object and
%                    the extinction coefficient using the expression ...
%                    Atm.Trans = exp(-Atm.Extinct * Obj.Range/1000)
%                    Give either Extinct or Trans but not both. The extinction
%                    coefficient must be given in units of km^-1.
%            Trans - Atmospheric transmission for each of the wavelengths
%                    or spectral bands. This must be the total transmission
%                    between the object and the lens. Atmospheric path
%                    transmittance can be computed using MODTRAN.
%         Radiance - This is the band or spectral radiance of the atmospheric
%                    path between the object and the lens. Must be a vector of
%                    the same length as the Wavelengths input. Units must
%                    be the same as for the Object.Samples input. Atmospheric
%                    path radiance can be computed using MODTRAN.
%              Cn2 - Path averaged atmospheric refractive index structure
%                    function parameter. Scalar numeric. Constant Cn2 is
%                    really only applicable to atmospheric paths that are
%                    at a constant height above ground. Cn2 is used to compute
%                    the turbulence MTF of the atmospheric path. Cn2 of
%                    1e-12 is considered strong turbulence, 1e-13 is moderate
%                    and smaller than 1e-14 is considered weak. The units are
%                    metre to the -2/3 power.
%               r0 - Atmospheric path Fried parameter. Give only one of Cn2,
%                    or r0. The Fried parameter characterises the amount of 
%                    wavefront distortion introduced by a turbulent 
%                    atmospheric path, and can also be used to compute
%                    atmospheric turbulence MTF. Units are metres. If r0
%                    is given then Cn2, h0, h1 and h2 inputs will be ignored.
%               h0 - Reference height for Cn2 above ground in units of metres.
%                    This need only be given if the actual atmospheric path height
%                    above ground (h1) is different from the height for which
%                    the Atm.Cn2 parameter above has been defined. If h0
%                    is given, then h1, the actual height must also be given.
%                    Units are metres. The Tatarski approximation is used
%                    to compute Cn2 at heights different from h0.
%               h1 - The actual starting height (height of the object) above
%                    ground in metres. If h2 is not given, then the path is
%                    assumed to be at constant height of h1 above ground.
%               h2 - The actual finishing height above ground (lens aperture
%                    height) of the atmospheric path in metres. This need
%                    only be given if different from h1 (i.e. a slanted
%                    path is defined). If a slanted path is defined, the
%                    turbulence MTF is computed using a path integral
%                    with Cn2 varying with height according to the Tatarski
%                    approximation. The absolute difference between h1 and 
%                    h2 must be less than or equal to the Obj.Range input.
%      Since the Tatarski model goes to infinity at ground level, none of
%      the height inputs h0, h1 or h2 may be zero (or negative).
%      In all cases, for computation of turbulence MTF, the short exposure
%      MTF is computed. Spherical wave approximations for all turbulence
%      computations are assumed.
%
%   Input Lens is a structure containing information about the lens,
%      having the following fields, of which EFL and one of F and D are
%      compulsory.
%         EFL - Effective focal length in mm. Compulsory scalar numeric.
%         F   - Focal Ratio (dimensionless) OR
%         D   - Aperture diameter in mm (give only one of F or D)
%         Obs - Obscuration ratio (see PMTFobsWFE). Obscuration defaults to zero
%               if not given. Scalar numeric.
%         WFE - RMS wavefront error in fractions of waves at each of the wavelengths.
%               This field is optional, but if present must have the same length as
%               Wavelengths. The Shannon formula is used to model the effect of
%               the wavefront error on the MTF. Only small amounts of WFE 
%               can be modeled using this method. A warning will be issued
%               from the ATF function if WFE is too large.
%     Defocus - The amount of defocus at the image plane in mm. Defocus
%               contributes additional wavefront error that reduces the MTF.
%               The Shannon formula is used to compute the defocus WFE. This
%               method is valid only for small amounts of defocus. A warning
%               will be issued from the ATF function if the defocus is too
%               large.
%       Trans - Lens transmission. If given, this must be a vector of the same
%               length as the Wavelengths input parameter. If omitted, the lens
%               transmission is assumed to be unity for all Wavelengths. The
%               transmission loss due to the obscuration must not be included
%               in this transmission factor. Any transmission loss due to filters
%               must be included.
%   SmearRate - The angular rate of smear due to relative motion of the object
%               and the lens. The SmearRate must be given in radians per second.
%               Defaults to zero smear. To compute smear, the exposure time of
%               the FPA must be given as well (see below).
% SmearOrient - Direction/orientation of the smear in the focal plane. Defaults to
%               zero degrees which is smear in the x-direction. Give 90 degrees
%               for smear in the y-direction.
%   RMSJitter - The root-mean-square jitter displacement in radians. Jitter is high
%               frequency random motion of the sightline. It is assumed that
%               many jitter motions occur during the exposure time of the FPA. It
%               is modeled with a simple gaussian-shaped filter.
%         
%   Input FPA is a structure containing information about the focal plane array,
%      having the following fields. If the FPA structure is completely empty, then 
%      only the Results.FPAIm field is returned.
%         PitchX    - Pixel pitch of the FPA in the x direction in mm. Scalar numeric.
%         PitchY    - Pixel pitch of the FPA in the y direction in mm. If not given,
%                     it is assumed equal to PitchX. Scalar numeric. Compulsory if
%                     the FPA structure is not completely empty.
%         ApertureX - Pixel aperture in the x direction in mm. The pixel aperture may
%                     not exceed the pixel pitch. Scalar numeric.
%         ApertureY - Pixel aperture in the y direction in mm. Scalar numeric. Defaults
%                     to ApertureX if not given. Compulsory input if the FPA structure
%                     is not completely empty.
%         ASR       - Absolute spectral responsivity of the FPA. If omitted, unity is
%                     assumed for all wavelengths. Typical units are amperes per watt
%                     of optical flux, and this unit is assumed here. ASR can be
%                     computed from the spectral quantum efficiency using the
%                     SQEtoASR function.
%         OffsetX  - Sample origin/offset in the X direction. Must be from 0 to 1 pixels.
%                    Scalar numeric. Allows investigation of pixel sample phase shift.
%         OffsetY  - Sample origin/offset in the Y direction. Must be from 0 to 1 pixels.
%                    Scalar numeric.
%         ExpTime  - Exposure time in seconds of the FPA. Compulsory scalar numeric. 
%            PRNU  - RMS photo-response non-uniformity as a standard deviation
%                    of the photo-response in percent. Scalar numeric. 
%                    White, gaussian statistics are used to model PRNU.
%                    If this field is not given, photo-response uniformity is assumed.
%         PRNUSeed - If given, this scalar numeric will be used to seed the random
%                    number generator before computing PRNU. This facility is provided
%                    in order to generate the same PRNU on every call to ModelFPAImage
%                    the reason being that PRNU is fixed at the time the FPA is
%                    manufactured. Shot noise and other noise sources not associated
%                    with FPA manufacture will still be random and different on every
%                    call. This feature is potentially useful for visualising temporal
%                    noise in a sequence of frames from the same FPA, but only if the
%                    subsequent calls results in the same output array size for
%                    the FPASignal output field.
%      DarkCurrent - The mean dark current density of the FPA in amperes per pixel. Dark
%                    current generally has quite strong dependence on temperature.
%                    Scalar numeric. Dark current is assumed zero if this field
%                    is absent. The manufacturer of the FPA may give dark current
%                    of the device in amperes per square centimetre. Multiply
%                    by the pixel area in this case.
%    StdevDarkCurr - The standard deviation of the FPA dark current expressed as 
%                    a percentage of the dark current.
%                    Variance in dark current is a contributer to pattern noise,
%                    called fixed pattern noise. 
%                    Scalar numeric. Dark current is assumed to have a
%                    gaussian distribution and a white power spectrum.
%  DarkCurrentSeed - if given, this field will seed the random number generator
%                    for setting dark current uniformity (also called fixed
%                    pattern noise - FPN). The same comments apply as for 
%                    the PRNUSeed field.
%     ReadoutNoise - On-chip, white amplifier noise in RMS electrons. This noise
%                    source may also be called mux (multiplexer) noise, noise-
%                    equivalent electrons or the "noise floor" by the device
%                    manufacturer.
%    SpecIntegrate - This is a logical flag. If set true, the FPA signal is integrated
%                    over all spectral bands. For spectral integration to be valid
%                    the objects samples must be absolute spectral radiance.
%  DigitalResponse - This is the numer of signal electrons required to elevate
%                    the digital number (DN) output of the camera by 1. If the
%                    DigitalResponse field is given, another output field called
%                    Datels will be given, being the digital number output.
%                    Scalar numeric. Assumed the same for all bands.
%     WellCapacity - This is the maximum number of electrons that can be 
%                    contained in a pixel well. If this number is exceeded,
%                    the pixel saturates. If this scalar numeric field is
%                    given, the Datels output field will be limited to a DN
%                    equal to WellCapacity/DigitalResponse. The FPASignal
%                    output will be limited to the value of WellCapacity.
%                    The FPAPureSignal output will not be affected.
%
% Output Results is a structure with one or more of the following fields ...
%   FPAIm is the spectral or band irradiance at the image plane. Units are consistent
%         with the input scene spectral or band radiance i.e. if object radiance is in
%         W/m^2/sr/nm, then this output will be in W/m^2/nm at the image.
%         This image has the same sample density as the Object.Samples field,
%         i.e. it consists of all object samples (scenels) projected to the image plane
%         after spatial filtering by atmosphere and lens. The effects
%         of smear and jitter are not included, but all transmission effects
%         are. Atmospheric path radiance is also included.
%   FPASignal are the pixel values sampled by the FPA. The samples are signal values per
%         pixel in units of electrons (provided that the FPA.ASR input is in amperes/watt).
%         FPASignal will have the same number of spectral channels as the object unless
%         the spectral integration flag (FPA.SpecIntegrate) is set. 
%         The FPASignal field includes all noise mechanisms requested.
%   FPAPureSignal is the FPA signal uncorrupted by any noise (also not shot noise). The
%         noise per pixel can be computed by taking the difference 
%         FPASignal - FPAPureSignal. The FPAPureSignal is also in electrons if the
%         appropriate input units have been used. The RMS noise for the entire image
%         can be computed by taking the square root of the mean square of the
%         difference i.e. RMSNoise = sqrt(mean(mean((FPASignal-FPAPureSignal).^2)))
%         The mean signal to noise ratio for the entire image is then the mean
%         signal divided by the RMS noise.
%           i.e. SNR = mean(mean(FPAPureSignal))/RMSNoise
%   Datels is the digital output of the camera if the digital responsivity has been
%         given (FPA.DigitalResponse). These numbers are returned as class double,
%         but are rounded to the nearest integer and therefore include the effect
%         of "digitization noise". If the band model has been used to compute a
%         colour image for a camera having a Bayer (or similar) filter, some of
%         these pixels have to be discarded and/or replaced by interpolated values
%         from adjacent pixels. This type of Bayer sampling is not performed by 
%         this function, and will be implemented in a separate function.
%
% A note about image reconstruction :
% The image pixels (or Datels) returned by this function represent the image data obtained
% by a camera. Reconstruction of the image is an important matter, determining how the image
% is ultimately presented to the human observer. The reconstruction filter constitutes
% the display hardware (perhaps amongst other components). If the datels are displayed at
% a true scale of one datel to one display pixel on a computer, then the reconstruction
% filter is the computer display card and monitor on which the image is displayed. The
% bit-depth and MTF of the display must be taken into consideration. One display system
% can be simulated on another display system by reconstructing one disel (display element)
% on the display to be simulated by multiple disels on the simulation display system. The
% viewing distance must then be increased in proportion. e.g. if 8 by 8 disels are used
% on the simulation display to represent 1 by 1 disel on the display to be simulated, then
% the viewing distance must be increased by a factor of 8. The effects of raster, phosphor
% dots and other display artifacts can be simulated in this way. Also, a higher bit-depth
% display can be simulated on a lower bit-depth display using this approach. A seperate
% function will implement reconstruction.
%
% The image processing toolbox command truesize can be used to force Matlab to display
% the datels in one to one correspondence with disels (one data pixel to one display pixel).
%
% For precise control over simulation of reconstruction, the reader is referred to the
% PsychToolbox for Matlab (http://psychtoolbox.org).
%
% In order to simulate a display, the minimal information required is the pre-mask
% line spread functions in the vertical and horizontal directions, the resolution-to-
% addressability ratio (RAR) in the vertical and horizontal directions, and the shadow
% mask aperture functions for red, green and blue (if simulating color imagery). Of
% course, the simulation will not be good if the colors on the simulating display are
% very different from those on the display to be simulated.
%
% Examples of the use of ModelFPAImage are given in the scripts named
%  ModelFPAImageExample1.m etc.
%
% See also : PMTFobsWFE, truesize (image processing toolbox), MeasureImageScale, dcraw

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

CodeRevision = '$Revision: 221 $';
Results.CodeRevision = str2num(CodeRevision(11:end-1));
if nargin == 0
    help ModelFPAImage
    return;
end
%++++++++++++++++++ Check input parameters
% Check Wavelengths
if ~isnumeric(Waves) || ~isvector(Waves)
    error('Wavelengths must be numeric vector.')
end

nWaves = length(Waves);

% Check object info
if ~isfield(Obj, 'Samples') || ~isnumeric(Obj.Samples) || size(Obj.Samples,3) ~= nWaves
    error('Object samples must be numeric array and same depth as number of wavelengths. See help.');
else
    % Make sure samples are class double
    Obj.Samples = double(Obj.Samples);
end

if ~isScalarNumericField(Obj, 'Pitch')
    error('Object input structure must have scalar numeric field Pitch.')
end

if ~isScalarNumericField(Obj, 'Range')
    error('Object input structure must have scalar numeric field Range.')
end    
% Done checking Wavelengths
% -------------- Check Atmospheric fields
% Deal with transmission

if isfield(Atm, 'Trans')
    if isfield(Atm, 'Extinct')
        warning('Atmospheric transmittance and extinction should not both be given. Extinction takes precedence.');
    end
    if isa(Atm.Trans, 'double') && isvector(Atm.Trans) && length(Atm.Trans) == nWaves
        % all is well
    else
        error('Input Atm.Trans must be double precision vector of same length as Wavelengths input');
    end
else
    Atm.Trans = ones(size(Waves)); % Atmosphere assumed to have perfect transmission  
end

if isfield(Atm, 'Extinct')
    if isa(Atm.Extinct, 'double') && isvector(Atm.Extinct) && length(Atm.Extinct) == nWaves
        Atm.Trans = exp(-Atm.Extinct * Obj.Range/1000);
    else
        error('Input Atm.Extinct must be double precision vector of same length as Wavelengths input');
    end
end
% Deal with path radiance, by simply adding to the object radiance
if isfield(Atm, 'Radiance')
    if isa(Atm.Radiance, 'double') && isvector(Atm.Radiance) && length(Atm.Radiance) == nWaves
        Obj.Samples = Obj.Samples + repmat(reshape(Atm.Radiance,1,1,nWaves),size(Obj.Samples,1),size(Obj.Samples,2));
    else
        error('Input Atm.Radiance must be double precision vector of same length as Wavelengths input');
    end
end
% Deal with computation of turbulence MTF
if isScalarNumericField(Atm, 'Cn2')
    % Compute 
end
if isScalarNumericField(Atm, 'r0')
    % Compute turbulence MTF on the basis of r0, which will overwrite any computation of
    % r0 on the basis of Cn2
end

% Done checking atmospheric fields
% -------------- Check the Lens fields
if ~isScalarNumericField(Lens,'EFL')
    error('Lens input structure must have scalar numeric field EFL (effective focal length).')    
end
% Compute system magnification (object to image). Approximate calculation.
Mag = (Lens.EFL/1000)/(Obj.Range - (Lens.EFL/1000)); % Size of image over size of object

if isScalarNumericField(Lens, 'D') % Given lens diameter
    Lens.F = Lens.EFL/Lens.D; % Calculate focal ratio
elseif isScalarNumericField(Lens, 'F')
    Lens.D = Lens.EFL/Lens.F; % Calculate lens diameter
else
    error('One of Lens.D (diameter) or Lens.F (focal ratio) must be given.');
end
if ~isScalarNumericField(Lens, 'Obs')
    Lens.Obs = 0;
end

% Deal with Lens wavefront error
if isfield(Lens, 'WFE') && isa(Lens.WFE, 'double') && isvector(Lens.WFE) 
else
    Lens.WFE = [];
end
% Deal with lens defocus
if isScalarNumericField(Lens, 'Defocus')
    W_defocus = Lens.Defocus ./ (8 * Waves/1000 * Lens.F^2);
    if isempty(Lens.WFE)
        Lens.WFE = W_defocus;
    else
        Lens.WFE = sqrt(W_defocus.^2 + Lens.WFE.^2);
    end
end

% Deal with Lens transmission
if isfield(Lens, 'Trans')
    if isa(Lens.Trans, 'double') && isvector(Lens.Trans) && length(Lens.Trans) == nWaves
        Lens.Trans = Lens.Trans * (1 - Lens.Obs^2);
    else
        error('Input Lens.Trans must be double precision vector of same length as Wavelengths input');
    end
else
    Lens.Trans = ones(size(Waves)) * (1 - Lens.Obs^2);  
end
% Done checking Lens fields
% --------------- Check FPA fields
if ~isempty(FPA)
    if ~isScalarNumericField(FPA, 'PitchX')
        error('FPA input structure must have scalar numeric field PitchX.')
    end

    if ~isScalarNumericField(FPA, 'PitchY')
        FPA.PitchY = FPA.PitchX;
    end

    if ~isScalarNumericField(FPA, 'ApertureX')
        error('FPA input structure must have scalar numeric field ApertureX.')
    end

    if ~isScalarNumericField(FPA, 'ApertureY')
        FPA.ApertureY = FPA.ApertureX;
    end

    if isScalarNumericField(FPA, 'OffsetX') && FPA.OffsetX >= 0 && FPA.OffsetX <= 1.0
        if ~isScalarNumericField(FPA, 'OffsetY')
            FPA.OffsetY = OffsetX;
        end
    else
        FPA.OffsetX = 0;
        FPA.OffsetY = 0;
    end

    if isfield(FPA, 'ASR') & isnumeric(FPA.ASR) & all(size(FPA.ASR) == size(Waves))
        % Put the ASR into the third dimension
        FPA.ASR = reshape(FPA.ASR, 1, 1, length(FPA.ASR));
    else
        disp('FPA.ASR set to unity for all wavelengths.');
        FPA.ASR = ones(1,1,nWaves); % Put into third dimension
    end
end
% Done checking FPA fields
%--------------------------------------------------------
% Start frequency domain computations.
% Spatial filtering will be performed in the image plane.

% Compute spatial frequencies at the object
% Number of samples will be the maximum dimension of the object
N = max(size(Obj.Samples));
if mod(N,2), N=N+1; end; % Make N even
ObjNyq = 1/(2*Obj.Pitch); % Nyquist for object sampling
Objdf = 1/(N*Obj.Pitch); % Spatial frequency increment at object
ObjSpatFreq = 0:Objdf:(N/2)*Objdf;

% Project spatial frequencies to the image plane.
ImSpatFreq = ObjSpatFreq/Mag;
ImNyq = ObjNyq/Mag;
ImSamplePitch = Obj.Pitch * Mag;
% Compute size of object as projected at the image plane
ObjImXSize = (size(Obj.Samples,2)-1)*ImSamplePitch;
ObjImYSize = (size(Obj.Samples,1)-1)*ImSamplePitch;
% Compute centre coordinates of object samples at image plane
ObjImX = 0:ImSamplePitch:(N-1)*ImSamplePitch;
ObjImY = 0:ImSamplePitch:(N-1)*ImSamplePitch;
if ~isempty(FPA)
    % Compute FPA pixel centres at the image
    FPAX = FPA.OffsetX*FPA.PitchX:FPA.PitchX:ObjImXSize;
    FPAY = FPA.OffsetY*FPA.PitchY:FPA.PitchY:ObjImYSize;
    % The image sample pitch should be significantly smaller than the FPA pixel pitch
    if FPA.PitchX > 0
        minFPAPitch = min(FPA.PitchX, FPA.PitchY);
    end
end
%+++++++++++++++++++ Compute Lens MTF at the object spatial frequencies projected
% at the image.
% Compute the cutoff frequencies of the lens
cutoff = 1./(Lens.F * Waves/1000); % Waves here are in microns
highcutoff = max(cutoff);
max(ImSpatFreq);
% The highest frequency that can be passed by the lens should perhaps be less than
% the highest frequency represented in the object.
if highcutoff > max(ImSpatFreq)
    warning('Lens can pass higher spatial frequencies than represented in the object.');
end

% If the FPA definition input structure was given, compute the spatial
% filter due to the pixel aperture as a product of sinc functions.
% Set up double-sided spatial frequencies to compute the sinc functions.
if ~isempty(FPA)
  SincSpatFreq = [-fliplr(ImSpatFreq(2:end)) 1e-10 ImSpatFreq(2:(end-1))]; % Don't use zero to avoid NaN
  [fx, fy] = meshgrid(SincSpatFreq, SincSpatFreq);
  SincSinc = (sin(pi * fx * FPA.ApertureX)./ (pi * fx * FPA.ApertureX)) .* (sin(pi * fy * FPA.ApertureY) ./ (pi * fy * FPA.ApertureY));
  SincSinc = ifftshift(SincSinc); % Swap quadrants, ready for filtering
  % Also set up filters for smear and jitter
  if isScalarNumericField(Lens, 'SmearRate')
      if ~isScalarNumericField(Lens, 'SmearOrient')
          Lens.SmearOrient = 0;
      end
      % Compute the total smear in x and y directions in units of radians per second
      SmearX = FPA.ExpTime * Lens.EFL * Lens.SmearRate * cos(pi * Lens.SmearOrient / 180); % mm
      SmearY = FPA.ExpTime * Lens.EFL * Lens.SmearRate * sin(pi * Lens.SmearOrient / 180); % mm
      SincSmear = (sin(pi * fx * SmearX + pi * fy * SmearY))./(pi * fx * SmearX + pi * fy * SmearY);
      SincSmear(isnan(SincSmear)) = 1; % clobber any NaNs
      SincSmear = ifftshift(SincSmear); % Get ready for filtering
  end
  if isScalarNumericField(Lens, 'RMSJitter')
      % Set up the gaussian jitter filter
      GaussJitter = exp(-2 * pi^2 * (Lens.EFL * Lens.RMSJitter)^2 * (fx.^2 + fy.^2));
      GaussJitter = ifftshift(GaussJitter); % Get ready for filtering
  end
end

for iWave = 1:nWaves % Run through the wavelengths
    % Compute the MTF of the lens
    % First compute the spatial frequencies
    [fx, fy] = meshgrid(ImSpatFreq, ImSpatFreq);
    LensSpatFreq = sqrt(fx.^2 + fy.^2);
    if ~isempty(Lens.WFE)
        % PMTFobsWFE(Wavelengths, Wavelength_Weights, Focal_Ratio, Obscuration_Ratio, Spatial_Frequencies, RMSWavefront_Errors)        
        Lens.MTF = PMTFobsWFE(Waves(iWave)/1000, 1, Lens.F, Lens.Obs, LensSpatFreq(:), Lens.WFE(iWave));
    else
        % PMTFobs(Wavelengths, Wavelength_Weights, Focal_Ratio, Obscuration_Ratio, Spatial_Frequencies)    
        Lens.MTF = PMTFobs(Waves(iWave)/1000, 1, Lens.F, Lens.Obs, LensSpatFreq(:));
    end
    % Revolve the MTF into 2D - old method
    % Lens.MTF = RevolveMTF(Lens.MTF, [],[]); % No padding - old method
    % Lens.MTF = Lens.MTF(1:(end-1),1:(end-1)); % Trim down to size N by N - old method
    Lens.MTF = reshape(Lens.MTF, size(LensSpatFreq));
    % Extend this to full four quadrant MTF
    % Lens.MTF is currently one quarter the size it should be
    TheLensMTF = zeros(N,N); % Full size MTF
    % Fill in from Lens.MTF
    N; % debug
    size(Lens.MTF); % debug
    TheLensMTF(1:N/2, 1:N/2) = Lens.MTF(1:N/2, 1:N/2);
    TheLensMTF(N/2+1:end, 1:N/2) = flipud(Lens.MTF(2:N/2+1, 2:N/2+1));
    TheLensMTF(1:N/2, N/2+1:end) = fliplr(Lens.MTF(2:N/2+1, 2:N/2+1));
    TheLensMTF(N/2+1:end, N/2+1:end) = fliplr(flipud(Lens.MTF(2:N/2+1, 2:N/2+1)));
    
    Lens.MTF = TheLensMTF; clear TheLensMTF; 
    % figure; % debug LensMTF
    % imagesc(Lens.MTF); % debug LensMTF
   
    %Lens.MTF = ifftshift(Lens.MTF); % Prepare for filtering job
    % Filter each of the channels
    % Compute FFT of each of the channels
    ObjFFT = fft2(Obj.Samples(:,:,iWave),size(Lens.MTF,1),size(Lens.MTF,2));
    % Compute image channel spectral/band irradiance as ifft of product of 
    % lens and object FFT including transmission losses using the "camera" equation.
    % Factors here include the atmospheric transmission, the
    % lens transmission and the lens obscuration.    
    FPAIm(:,:,iWave) = pi * abs(ifft2(ObjFFT .* Lens.MTF)) * Atm.Trans(iWave) * Lens.Trans(iWave) / (4 * Lens.F^2);
    % The image as sampled by the FPA must be filtered by the transfer
    % function of the pixel aperture.
    % The transfer function of the pixel aperture is assumed to be the product of the sinc
    % function in both dimensions.
    if ~isempty(FPA)
        SampleSpace = ObjFFT .* Lens.MTF .* SincSinc;
        if isScalarNumericField(Lens, 'SmearRate') % smear the sample space as well
            SampleSpace = SampleSpace .* SincSmear;
        end
        if isScalarNumericField(Lens, 'RMSJitter') % jitter the sample space as well
            SampleSpace = SampleSpace .* GaussJitter;
        end
        % The following is the "camera" equation relating object radiance to image irradiance
        SampleSpace = pi * abs(ifft2(SampleSpace)) * Atm.Trans(iWave) * Lens.Trans(iWave) / (4 * Lens.F^2);
        % Resample at the pitch of the Focal Plane array
        FPASignal(:,:,iWave) = interp2(ObjImX, ObjImY, SampleSpace, FPAX, FPAY');
    end
end
% Crop image back down to original size
Results.FPAIm = FPAIm(1:size(Obj.Samples,1), 1:size(Obj.Samples,2), :);

if isempty(FPA), return; end; % Nothing more to do

% At this point need to do the computation of FPA signal
% The FPASignal are currently in band or spectral irradiance values.
% i.e W/m^2 or W/m^2/micron


% Now multiply by the absolute spectral response (ASR) of the FPA to get the band
% signal in amperes/m^2 or spectral signal in amperes/m^2/micron.
% First generate a set of absolute spectral response weights of the 
% same size as FPASignal. If there is photo-response non-uniformity
% then deal with that by introducing the non-uniformity into ASR.

if isScalarNumericField(FPA, 'PRNU') % Photo-response non-uniformity
    disp('Applying PRNU.');   
    for iWave = 1:nWaves
        % To generate the ASR multiply an array of gaussian-distributed random numbers by
        % the standard deviation (FPA.PRNU) and add the mean response (FPA.ASR)
        if isScalarNumericField(FPA, 'PRNUSeed') % Seed randn if a seed was given
          randn('state', FPA.PRNUSeed);
        end    
        ASR(:,:,iWave) = FPA.ASR(iWave) * FPA.PRNU/100 * randn([size(FPASignal,1) size(FPASignal,2)]) ...
                             + FPA.ASR(iWave);
        randn('state',sum(100*clock)); % Randomize the number generator again
    end
else
   disp('Photo-response is uniform.')
   ASR = repmat(FPA.ASR, [size(FPASignal,1) size(FPASignal,2) 1]); % PRNU is uniform 
end
ASRUniform = repmat(FPA.ASR, [size(FPASignal,1) size(FPASignal,2) 1]);
FPAPureSignal = FPASignal .* ASRUniform; % This is the signal uncorrupted by any noise
FPASignal = FPASignal .* ASR; % This will be the noisy signal

% At this point, FPASignal is in units of amperes/m^2 or amperes/m^2/micron
% Now multiply by the pixel aperture to get amperes/pix or amperes/pix/micron
FPAPureSignal = FPAPureSignal * FPA.ApertureX/1000 * FPA.ApertureY/1000; % Convert pixel mm to metres
FPASignal = FPASignal * FPA.ApertureX/1000 * FPA.ApertureY/1000; % Convert pixel mm to metres

if isScalarNumericField(FPA, 'SpecIntegrate') & FPA.SpecIntegrate
    % Integrate over wavelength
    FPAPureSignal = trapz(Waves, FPAPureSignal, 3); % Integrate over the wavelength dimension    
    FPASignal = trapz(Waves, FPASignal, 3); % Integrate over the wavelength dimension
end

eCharge = 1.60217646e-19; % coulombs, Charge on the electron
% Now, FPASignal is (presumably) in amperes/pixel, so multiply by the exposure time
% and divide by the charge on the electron to get electrons/pixel
FPAPureSignal = FPAPureSignal * FPA.ExpTime / eCharge;
FPASignal = FPASignal * FPA.ExpTime / eCharge;

% Implement the shot noise. The shot noise is computed by taking
% the signal value in electrons (including PRNU if present) as the
% mean and the square root of the signal value as the standard deviation.
% From here, FPAPureSignal remains unchanged, while additional noise
% mechanisms are applied to FPASignal.
FPASignal = sqrt(FPASignal) .* randn(size(FPASignal)) + FPASignal;

% Next add dark current signal
% Calculate the mean dark signal as the product of the mean dark current and the exposure time.
if isScalarNumericField(FPA, 'DarkCurrent')
  MeanDarkSignal = FPA.DarkCurrent * FPA.ExpTime;
  if isScalarNumericField(FPA, 'StdevDarkCurr')
    StdevDarkSignal = FPA.StdevDarkCurr/100 * MeanDarkSignal;
  else
    StdevDarkSignal = 0;
  end
  if isScalarNumericField(FPA, 'DarkCurrentSeed')
      % Seed the random number generator for dark current FPN
      randn('state', FPA.DarkCurrentSeed);
  end
  % Compute the actual dark signal with gaussian statistics
  DarkSignal = StdevDarkSignal * randn(size(FPASignal)) + MeanDarkSignal;
  randn('state', sum(100*clock)); % Randomize the number generator again
  % Apply shot noise to the dark signal
  DarkSignal = sqrt(DarkSignal) .* randn(size(DarkSignal)) + DarkSignal;
  % and finally add the dark signal to the total signal
  FPASignal = FPASignal + DarkSignal;
end

% The signal is now in electrons with the pixel charge noise sources added in.
% The pixel charge is now generally dumped into a sense node capacitor.
% The sense node reset can introduce reset (kTC) noise, that can be much
% reduced with correlated double sampling (CDS).  

% Add in the readout noise if given.
% Readout noise is generally introduced after the sense node capacitor
if isScalarNumericField(FPA, 'ReadoutNoise')  
  FPASignal = FPA.ReadoutNoise * randn(size(FPASignal)) + FPASignal;
end

% Apply well capacity to FPASignal if FPA.WellCapacity was given and exceeded
if isScalarNumericField(FPA, 'WellCapacity')
    FPASignal(FPASignal > FPA.WellCapacity) = FPA.WellCapacity; % These pixels saturated
end

Results.FPAPureSignal = FPAPureSignal; % Signal uncorrupted by noise
Results.FPASignal = FPASignal; % This is the final image result, including all noise

% Now compute the digital response if given
if isScalarNumericField(FPA, 'DigitalResponse')
  Results.Datels = round((1/FPA.DigitalResponse) * FPASignal);
end

% The following noise sources are not included (yet).
% 1) On-chip amplifier 1/f noise
% 2) Off-chip amplifier AWGN and 1/f noise. These noise sources can be
%    reduced by CDS (correlated double sampling) to low levels.
% 3) CTE (charge transfer efficiency) noise. This can apply to very large FP arrays.
%    It is problematic because it can influence the MTF of the device that becomes
%    position dependent. i.e. it is "anisoplanatic" in a way.
% 4) Reset noise is not included. CDS can also reduce this.

% To do ...
% Review all units and make sure they propagate correctly.
% Implement practical aerosol MTF - implement mainly in new functions.

% Future enhancements
% Reconstruction (actually, write another function for reconstruction)
% Multiple field points with hexagonal image partitions - tough problem, not
% sure how to do spatial filtering. Clearly the complex OTF must be used and
% amplitudes summed in the image plane. General process is to isolate an
% object patch, multiply by the object apodization function (hexagonal
% pyramid), perform spatial filtering with the complex OTF and repeat for 
% all image patches. Sum complex contributions from all image patches and
% take the square modulus to get the intensity. The best is probably to get
% OTF calculations from Zemax. Atmospheric OTFs are more difficult still. The
% size of the isoplanatic patch is undoubtedly dependent on spatial frequency
% and also on the lens aperture. Might be able to use Skylight.

return;

function result = isScalarNumericField(Structure, Field)
result = isfield(Structure, Field) && isscalar(getfield(Structure, Field)) && isnumeric(getfield(Structure,Field));
