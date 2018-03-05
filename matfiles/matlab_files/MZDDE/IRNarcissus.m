function Results = IRNarcissus(Surfaces, T_a, T_h, T_d, eps_csa, AbsSpecSens, FieldSampling, StopSampling, zmxFilename)
% IRNarcissus - Compute narcissus contributions for staring thermal camera.
%
% Computes and reports on narcissus effects in a staring thermal camera. NarcOut is a
% structure containing various items required for the report generator, so the function must be
% called exactly as shown below. The report will be generated in rich text format (.rtf) and
% displayed in MS Word. The function returns the NITD (narcissus-induced temperature difference)
% due to the specified optical surfaces, as well as the peak slope of the NITD.
%
% Usage : 
% >> NarcOut = IRNarcissus(Surfaces, T_a, T_h, T_d, eps_csa, AbsSpecSens, FieldSampling, StopSampling, AspectRatio, zmxFilename);
% >> ShowNarcissus(NarcOut, 4/3, 640, 480); % plot the narcissus results at 640 by 480 pixel resolution and 4/3 aspect ratio
% >> report narcissus % generate a report in .rtf format (requires Matlab Report Generator toolbox)
%
% Where :
%     Surfaces are the surface numbers of the lens to be analysed. If Surfaces is given as the empty matrix [],
%          then all surfaces are analysed. This feature is useful if you want to analyse a specific surface or
%          range of surfaces that have proved troublesome. This is also useful if you want to disregard
%          contributions from surfaces occurring after the position in which the calibration black body is
%          inserted.
%     T_a is the average ambient scene temperature. NITD is computed with reference to the scene temperature. Emissivity of
%          1.0 is assumed. All temperatures must be given in kelvin (K).
%     T_h is the housing temperature. Emissivity of 1.0 is assumed. Angular emissivity effects are assumed negligible.
%     T_d is the internal detector temperature. The inside of the cold shield is assumed to be at this temperature, and
%          emissivity of 1.0 is assumed.
%     eps_csa is the emissivity of the annulus of the cold shield around the cold stop. This annulus is assumed to
%          fill the window of the detector outside the cold stop, and any scout rays intersecting this annulus will contribute
%          at L_BB(T_d) * eps_csa + L_BB(T_h) * (1 - eps_csa) where L_BB(T) is the radiance of a black body at temperature
%          T.
%     AbsSpecSens is the absolute spectral responsivity of the detector, including filter.
%          The absolute spectral sensitivity of the detector is often given in amperes per watt (A/W) of optical
%          power. If you have the spectral quantum efficiency of the detector it must be converted. Use the function
%          SQEtoASR (spectral quantum efficiency to absolute spectral response). If AbsSpecSens is given 
%          as an empty matrix [], then the wavelengths and weights for the analysis are taken from the lens itself.
%          This will limit the analysis to a maximum of 24 wavelengths, while the number of wavelengths is unlimited
%          if you give an explicit list. Wavelengths must be in units of microns. The wavelengths must be listed in
%          the first column and the responsivity in the second column. Wavelengths must be equally spaced and increasing.
%          Careful consideration should be given to the selection of wavelengths as the NITD computation may be 
%          significantly affected. 
%          It is also possible to specify a filename from which to read the wavelengths and weights. This file must 
%          be of the same format as a file written with the WriteZemaxWaveFile function. This is the format that Zemax 
%          uses to save wavelength and weight data.
%          Note that if you give the absolute spectral response of the detector in amperes per watt, then the signal
%          levels returned by IRNarcissus will be in A/mm^2. If you only have a relative spectral response, then this
%          can be given instead. The system signals returned will then also be in relative terms. NITD, however, is
%          always returned in K with reference to the scene temperature.
%          If you specify the AbsSpecSens as 1.0 at all wavelengths, then the computed signal can be interpreted directly
%          as irradiance (units of W/mm^2) at the FPA. The total narcissus signal is returned in S_k and the narcissus
%          signal contributions per surface are returned in S_ik.
%     FieldSampling is the number of field points from the optical axis to the maximum radial field point. The peak
%          slope of the NITD could be sensitive to the density of the field sampling. Computation time is greatly
%          affected, so this must be considered carefully. If the NITD curve appears to have sudden changes of slope,
%          the field sampling should be increased to accurately capture these sections of the curve. FieldSampling must
%          be a minimum of 2.
%     StopSampling is the number of rays to trace in the x and y directions in the cold stop. Sampling of 100 will
%          give about 7850 rays (100 * 100 * pi / 4). Rays are traced in a square grid and each ray is assumed to
%          contribute the same amount. Therefore ray density should be quite high.
%     zmxFilename is the Zemax lens file to analyse. If this parameter is omitted, then the lens
%          in the LDE (lens data editor) will be fetched and analysed. If this parameter is specified as '', then
%          a dialog will be opened to specify the file.
%
% The output (NarcOut) is a structure with the following fields.
%     Results.Status is the status of the computation
%         Possible return values for Results.Status are
%          0 - Everything seems to be OK
%         -1 - ZEMAX not running and could not start ZEMAX.
%         -2 - The lens you wanted to analyse cannot be raytraced.
%         -3 - Lens has fewer than 6 surfaces. Detector + cold stop + window + 2 additional lens surfaces is
%              six at least.
%         -4 - Lens does not operate primarily in a thermal band.
%         -5 - Lens is multi-config. Currently we only do single config. Save and analyse each config
%              seperately.
%         -6 - User cancelled computation.
%         -8 - Lens has wrong field type. Change to "real image height".
%         -9 - Something is wrong with the input parameters. Check last warning.
%     Results.Revision is the Revision of IRNarcissus which produced this output.
%     Results.RevDate is the Date of the Revision which produced this output.
%     Results.LensFile is the Zemax lens file that was analysed.    
%     Results.LensDir is the directory in which the Zemax lens file is stored
%     Results.NarcDir is the directory containing the narcissus analysis results.
%     Results.Worst is the NITD contribution of each of the requested surfaces. ???????????????????
%     Results.WorstSlope is the NITD of the ????????????????
%     Results.T_a is the average ambient scene temperature
%     Results.T_d is the internal dewar temperature (cold shield internal temperature)
%     Results.T_h is the Camera housing temperature
%     Results.eps_csa is the emissivity of the cold shield annulus around the cold stop
%     Results.D_c is the Diameter of the cold stop
%     Results.D_wo is the Outer window clear aperture diameter
%     Results.D_wi is the Inner window clear aperture diameter
%     Results.Units are the Lens dimensional units
%     Results.maxgradNITD is the maximum gradient of total NITD
%     Results.maxgradTD is the maximum gradient of total image non-uniformity
%     Results.maxgradNITD_i are the maximum gradients of surface contributions to NITD
%
% Generation of the report requires the Matlab report generator.
%
% Examples :
% >> NarcOut = IRNarcissus([3 4], 300, 300, 200, 0.8, [], 30, 120);
%
% This command will compute the NITD contributions of surfaces 3 and 4 on the lens currently in the LDE.
% The scene and the camera housing have a temperature of 300 K with an emissivity of 1.
% The outside of the cold shield has a temperature of 200 K and emissivity of 0.8, while the inside of
% the cold shield has temperature of 200 K and emissivity of 1. The spectral responsivity of the detector
% will be taken from the lens wavelengths and weights. The NITD will be computed for 30 points along the
% semi-diagonal of the detector. The cold stop will be sampled with rays on a grid of spacing equal to
% 1/120 of the stop diameter for each field (detector) position. The aspect ratio of the detector will
% default to 4:3.
% 
%
% The general restrictions and assumptions are as follows :
% 1) The lens model to be analysed is for a 3rd generation thermal imager using a cooled detector
%    which has a cold stop. The cold stop is assumed to be at the surface before the image surface
%    and the detector window is assumed to come before the cold stop. Clear apertures of these
%    objects must be set correctly. The cold stop is a circular aperture in the cold shield.
% 2) The inside of the dewar has uniform emissivity across the spectral band. For the purposes
%    of narcissus evaluation, this is likely to be the worst case scenario. 
% 3) The side of the cold shield facing out of the dewar has a user-defined emissivity and the same temperature
%    as the inside of the dewar right out to the clear aperture of the dewar window. The effective
%    radiance of this side of the cold shield is e * BB_coldshield + (1-e)* BB_housing where e is the emissivity 
%    of the cold shield, BB_coldshield is black body radiation at the internal temperature of the dewar and 
%    BB_housing is black body radiation at the temperature of the camera housing.
% 4) Emissions and reflections of thermal radiation by non-optical surfaces are lambertian. Angular emissivity
%    and spectral variations of emissivity cannot be modeled in this version of IRNarcissus.
% 5) Lens must be single configuration. Save and analyse each configuration seperately, taking
%    special care to ensure that the apertures are as they would be for the system as-built. It is
%    particularly important that the clear aperture of the dewar window is correctly set from
%    mechanical drawings of the dewar.
% 6) Only rotationally symmetrical, sequential lenses are currently handled - this is mainly a
%    retriction of the ZEMAX functions used for the computation and the general approach. The whole
%    approach to the problem would have to change significantly to cater
%    for non-symmetrical systems. Catering for a non-circular cold stop (e.g. stadium) or other non-circular
%    apertures should not involve such major changes.
% 7) The coatings must have been defined in a manner that includes the substrate material as the last layer. This
%    must be so in order to correctly model the reflectance of the surface when the material is changed to
%    MIRROR in the lens specification. For examples of this, examine the definitions of coatings for Silicon
%    and Germanium substrates in the file MZDDE\zmx\IR3to5Coating.DAT and see the section on "Defining Coatings
%    in ZEMAX" in the Chapter on POLARIZATION ANALYSIS in the ZEMAX manual. Also the coating layers must be
%    given absolute thicknesses otherwise the coating properties will change during narcissus analysis as the
%    primary wavelength is changed during the wavelength loop.
% 8) Scout ray terminations have negligible dependence on wavelength. A bundle of rays are traced for each surface
%    and each field position, but not for each wavelength. The same set of scout ray terminations are used for
%    all wavelengths. Scout rays are always traced at the primary wavelength of the lens.
% 9) It is preferable to delete the merit function for the lens to be analysed. Updating of the merit function
%    takes time and ray failures are likely to occur.
%
% The general functions performed are as follows :
% 1) Create a directory named after the lens to be analysed in which all results will be saved. The
%    directory name will have the .Narcissus extension.
% 2) Performing some basic checks to see if the lens is a valid candidate for narcissus analysis.
%    These checks include ... 
%             ?????????????????????????????
% 3) Compute system transmission, YNI contributions and uniformity of image illumination.
% 4) Reverse the lens and put into double pass.
% 5) Compute the Narcissus-Induced Delta T contributions for each specified surface at each of the
%    specified wavelengths.
% 6) Plot total NITD, NITD per surface and overall image irradiance uniformity.
% 7) Generate subjective images of image non-uniformity.
% 8) Rank surfaces in order of contribution to NITD and tabulate with YNI contributions.
% 9) Compute maximum slope of total NITD and overall image non-uniformity. This gives an indication
%    of the local visibility of the image non-uniformities. Also, a relative figure of narcissus visibility
%    is computed through the use of the contrast threshold function of the human eye.
% 10) If the user gives the command 'report narcissus', a report will be generated in MS Word,
%     containing all of the outputs. This will require that the Matlab Report Generator be available.
%
% Bugs :
% IRNarcissus can be run only once per Matlab session. Generally, a second run will crash Matlab. The reason 
% for this is currently unknown. To avoid disappointment, restart Matlab after each run of IRNarcissus.
%
% Due to a problem with the way that Zemax models coatings, it seems to be impossible to automate the way
% a coating is handled when changed to a mirror surface in the case where the incident medium is not air.
% The workaround is to use the previous surface for computation of the scout ray transmission. This means that
% (aside from a small additional error) you cannot have different coatings on the two surfaces of a component.
% The coating on the second surface of the component is the one that will be used to compute the narcissus
% contributions from both surfaces. In the returned Results structure, the variable tau_ik is the scout ray
% transmission attributed to surface i at field position k. Examine this variable if in doubt about this.
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
% $Author: DGriffith $

global Cancelled % This global variable will be set by the PleaseCancel callback function if the user presses the cancel button.
tic; % Start timer to see how long this takes
Cancelled = 0;

Revision = '$Revision: 221 $';
Revision = Revision(11:(size(Revision,2)-1));
disp(['IRNarcissus. Version' Revision]);
RevDate = '$Date: 2009-10-30 09:07:07 +0200 (Fri, 30 Oct 2009) $';
RevDate = RevDate(7:(size(RevDate,2)-1));
disp(['Copyright DPSS, CSIR,' RevDate]);

NarcIcon=1:64; NarcIcon=(NarcIcon'*NarcIcon)/64; % Make an icon for use with dialogs

% +++++++++++++++ Setup Zemax communication
Results.Status = zDDEInit; % Attempt to contact ZEMAX through DDE.
if (Results.Status == -1)        % Failed, try to start ZEMAX and ask user to select the file
    Results.Status = zDDEStart;
    if (Results.Status == 0)     % Success, now do the open file dialog
        uiwait(msgbox('ZEMAX is Starting. Please accept DDE commands from Matlab and open the lens file for Narcissus Analysis.', 'ZEMAX Startup', 'custom', NarcIcon, hot(64),'modal'))
        zOpenWindow('Ope'); zWindowMaximize(0);
    end
end
if (Results.Status == -1), return; end; % Give up

while (zGetRefresh == -2); end;       % Wait for user to accept DDE messaging and open the lens file

% Set the DDE timeout high
OldTimeout = zGetTimeout;
zSetTimeout(120); % two minutes

% Open the file if asked for by the user
if exist('zmxFilename', 'var') 
    if exist(zmxFilename, 'file')
        zLoadFile(zmxFilename);
    else
        warning(['IRNarcissus:Specified file ' zmxFilename ' cannot be found. Full path name may be required.']);
        Results.Status = -9;
        return;
    end
end

if (zGetUpdate ~= 0) 
    uiwait(msgbox('The lens you are attempting to analyse cannot be raytraced.', 'Fatal Lens Error', 'error', 'modal'));
    Results.Status = -2;
    return; % Give up
end
zPushLens(10);
while (zGetRefresh == -2); end;       % Wait for user to accept DDE messaging and open the lens file

% ++++++++++++++++ Parameter and Lens Validity Checking
% Next do some parameter checking

if ~isempty(Surfaces)
    if ~isvector(Surfaces) || ~isnumeric(Surfaces)
        warning('IRNarcisus:Surfaces input parameter must be a numeric vector.');
        Results.Status = -9;
    end
end

% Check Temperature inputs
if ~all(isnumeric([T_a T_h T_d])) || any([T_a T_h T_d] < 0) || any([T_a T_h T_d] > 500)
    warning('IRNarcissus:Temperatures must be numeric and from 0 to 500 K.');
    Results.Status = -9;
    return;
end

% Check FieldSampling input
if ~isscalar(FieldSampling) || ~isnumeric(FieldSampling) || (FieldSampling < 2)
    warning('IRNarcissus:FieldSampling input must be scalar, numeric and greater than 2.');
    Results.Status = -9;
    return;
end
FieldSampling = round(FieldSampling);

% First get the wavelengths
if isempty(AbsSpecSens) % Must get wavelengths from zemax
  AbsSpecSens = zGetWaveMatrix;
end

lambda = AbsSpecSens(:,1); % First column is wavelength 
Results.lambda = lambda;

if numel(lambda) > 1
    deltalambda = diff(lambda);
    % Wavelengths must be monotonic and increasing for easy integration and between 1 and 14 microns
    % This restriction should be relaxed by using trapz(lambda, function) instead of deltalambda * trapz(function)
    if ~all(deltalambda > 0) || ~all(abs(deltalambda - deltalambda(1))<=10*eps('double')) || min(lambda) < 1 || max(lambda > 14)
        Results.Status = -9;
        warning('IRNarcissus:Wavelengths must be monotonic and increasing and within the waveband 1 to 14 microns.');
        return;
    end
    deltalambda = deltalambda(1);
else
    deltalambda = 0;
end




% Check number of lens surfaces, there must be a minimum of 6 (one lens at least, window, cold stop and detector)
LenSys = zsGetSystem;
if (LenSys.numsurfs < 6)
    uiwait(msgbox('The lens you are attempting to analyse has less than 6 Surfaces.', 'Fatal Lens Error', 'error', 'modal'));
    Results.Status = -3;
    return;
end

% If the surfaces are not explicitly given, default to all surfaces
if isempty(Surfaces)
    Surfaces = 1:LenSys.numsurfs - 2; % Don't process cold stop or image surface
end
Results.Surfaces = Surfaces;

% Check that the field type is set to "real image height"
FieldData = zGetField(0); FieldType = FieldData(1);
% Take the maximum y field as the semidiagonal of the FPA
FPASemiDiagonal = FieldData(4);
if (FieldType ~= 3)
    uiwait(msgbox('The lens you are attempting to analyse has the wrong field type. Change field type to "Real Image Height"', 'Fatal Lens Error', 'error', 'modal'));
    Results.Status = -8;
    return;
end;

PrimaryWave = zGetWave(0); NumberWaves = PrimaryWave(2); PrimaryWave = PrimaryWave(1);
PrimaryWaveLength = zGetWave(PrimaryWave); % Get the primary wavelength

if (PrimaryWaveLength(1) < 1) | (PrimaryWaveLength(1) > 14)
    uiwait(msgbox('The primary wavelength for this lens seems to be out of the normal thermal bands.', 'Fatal Lens Error', 'error', 'modal'));
    Results.Status = -4;
    return;
end

% Get lens units
switch LenSys.unitcode,
    case 0, Units = 'mm';
    case 1, Units = 'cm';
    case 2, Units = 'in';
    case 3, Units = 'm';
end

Results.Units = Units;

% Lens units must be mm for now. Should be nicer to the user I suppose.
if ~strcmp(Units, 'mm')
    warning('IRNarcissus:Sorry, but lens units must be mm');
    Results.Status = -9;
    return
end

% By now we think there is a useable lens in the ZEMAX DDE server, and we start with analysis.

% +++++++++++++++ Prepare output directory
% Firstly find the location of the lens and create a directory for Narcissus analysis output
% The directory has the same name as the lens file, but has the extension .Narcissus
LensFilePath = zGetFile; 
[LensDir, LensFile] = fileparts(LensFilePath);
[Success, Message, MessageID] = mkdir(LensDir, [LensFile '.Narcissus']);
NarcDir = [LensDir '\' LensFile '.Narcissus\'];

% If directory already exists ask user if overwrite ?
if (strcmp(MessageID, 'MATLAB:MKDIR:DirectoryExists'))
     %uiwait(msgbox('The .Narcissus directory for this lens already exists. Old Data will be overwritten.', 'Directory Warning', 'custom', NarcIcon, hot(64), 'modal'));
    button = questdlg('The .Narcissus directory for this lens already exists. Overwrite existing data ?','Overwrite Old Data', 'Yes');
    if ~strcmp(button, 'Yes')
        Results.Status = -6;
        return;
    end
end



% Clear out all results in the .narcissus directory
delete([NarcDir '\*.*']);

% +++++++++++++++ Deal with multiconfiguration lenses
% For now just dump the user if the lens is multi-config.

ConfigData = zGetConfig;
if (ConfigData(2) > 1)
    uiwait(msgbox('This routine currently only handles single configuration systems.', 'Fatal Lens Error', 'error', 'modal'));
    Results.Status = -5;
    return;
end


% Get the latest lens
zGetRefresh;
% and save it as 'Primary.zmx' in the analysis directory
zSaveFile([NarcDir 'Primary.zmx']);

r_c = 1 - eps_csa; % Reflectivity of the cold stop is computed as 1 - emissivity.

% Compute the effective F/number from the size of the cold stop and it's distance from the focal
% plane array.
ImSurf = LenSys.numsurfs;
n_i = ImSurf - 2; % number of surfaces to analyse will exclude the image surface and the cold stop
ColdStopSurf = ImSurf - 1;
SurfDataCode = zSurfDataCodes;
ColdStopSemiDia = zGetSurfaceData(ColdStopSurf, SurfDataCode.semidia);
ColdStopDist = zGetSurfaceData(ColdStopSurf, SurfDataCode.thickness);
F = 1 / (2 * sin(atan(ColdStopSemiDia/ColdStopDist)));
Results.F = F; % Focal Ratio of the cold stop

% ++++++++++++++++++ Compute ambient scene signal
% First major computation is to get the scene signal as a function of field.
% Compute Black body radiance curves for ambient scene, dewar and housing
% Planck returns radiance in W/cm^2/sr/micron, must convert to W/mm^2/sr/micron
BB_a = Planck(lambda, T_a) / 100;
BB_a1 = Planck(lambda, T_a + 1) / 100; % Scene radiance at T_a + 1, used for computing NITD
BB_d = Planck(lambda, T_d) / 100;
BB_h = Planck(lambda, T_h) / 100;


% Set up the pupil sampling definitions for tracing of large numbers of rays using zArrayTrace
pupildelta = 1/(StopSampling - 1);
% genRayDataMode2(hx, hy, px, py, radius, raytracingmode, finalsurface, intensity, wavenumber, Ex, Ey, Phax, Phay)
% PolRayData = genRayDataMode2(0, 0, 0, 0, 1, 0, -1, 1, 1, 0, 0, 0, 0); % Set up for unpolarised ray
RayData = genRayDataMode0(0, 0, 0:pupildelta:1, -1:pupildelta:1, 1, 0, -1, 1, 1, 0); % Don't need OPDs

px = [RayData.z]'; % Get the pupil y coordinates;
px = px(2:end); % Drop the first element, that is control data for the raytrace
py = [RayData.l]';
py = py(2:end);

% Calculate elemental area in the pupil (cold stop).
x_2 = px * ColdStopSemiDia;
y_2 = py * ColdStopSemiDia;

n_l = numel(lambda);
n_k = FieldSampling; 
dx_2 = pupildelta * ColdStopSemiDia; % dy_2 is the same
dA = dx_2 * dx_2;
Omega = zeros(1, n_k); % Preallocate the array to hold the projected solid angle of the cold stop
z = ColdStopDist;

% Preallocate FPA spectral irradiance from the scene
E_a = zeros(n_k, n_l);
E_a1 = zeros(n_k, n_l);
tau_akl = zeros(n_k, n_l);
r = zeros(n_k, 1);

kfield = 1;
for hy = 0:1/(n_k - 1):1   % Run through field
    r(kfield) = hy * FPASemiDiagonal; % Compute actual field height in mm
    % Next, ompute the projected solid angle for dA_2 at dA_1 for all field positions
    dOmega = dA * z * z ./ (x_2.^2 + (y_2 - r(kfield)).^2 + z * z).^2;
    Omega(kfield) = sum(dOmega);
    for llambda = 1:n_l
       % Set the lens wavelength to the current wavelength
       zSetWave(1, lambda(llambda), 1); % Weight is arbitrarily 1
       zGetUpdate;
       % Compute lens transmission for this field point
       % Trace chief ray to get transmission.
       % Note that the "unpolarized" raytrace for zGetPolTrace does not seem to work.
       % PolTraceData = zGetPolTrace(wave, mode, surf, hx, hy, px, py, Ex, Ey, Phax, Phay)
       PolTraceDataEx = zGetPolTrace(1, 0, -1, 0, hy, 0, 0, 1, 0, 0, 0);
       PolTraceDataEy = zGetPolTrace(1, 0, -1, 0, hy, 0, 0, 0, 1, 0, 0);       
       if PolTraceDataEx(1) == 0 % if ray did not fail
           tau = (PolTraceDataEx(2) + PolTraceDataEy(2)) / 2; % Ray transmission
       else % chief ray failed to trace
           tau = 1;
           warning(['Chief ray failed to trace for hy = ' num2str(hy) '. Transmission set to 1.0']);           
       end
       tau_akl(kfield, llambda) = tau;
       dE_a = BB_a(llambda) * tau .* dOmega;
       dE_a1 = BB_a1(llambda) * tau .* dOmega;
       E_a(kfield, llambda) = sum(dE_a);
       E_a1(kfield, llambda) = sum(dE_a1);
       % disp(['Completed wave ' num2str(llambda) ' at field ' num2str(kfield)]);
    end
    kfield = kfield + 1;
end
Omega = 2 * Omega; % Only computed over positive px, so must double the result
E_a = 2 * E_a; % same here
E_a1 = 2 * E_a1; % and here

% Compute the background signal due to the cold shield emissions (emissivity assumed = 1)
ColdShieldOmega = pi - Omega; % The projected solid angle of the cold shield at the FPA as a function of field
E_cs = repmat(ColdShieldOmega, n_l, 1) .* repmat(BB_d, 1, n_k);
E_cs = E_cs';

% Compute the signal coming from the scene by weighting and integrating over wavelength
% If operating at a single wavelength, assume band-integrated quantities
if deltalambda > 0
  dS_a = E_a .* repmat(AbsSpecSens(:,2)', n_k, 1);
  S_a = deltalambda * trapz(dS_a, 2);
  dS_a1 = E_a1 .* repmat(AbsSpecSens(:,2)', n_k, 1);
  S_a1 = deltalambda * trapz(dS_a1, 2);
  dS_cs = E_cs .* repmat(AbsSpecSens(:,2)', n_k, 1);  
  S_cs = deltalambda * trapz(dS_cs, 2);
else
  S_a = E_a * AbsSpecSens(2);
  S_a1 = E_a1 * AbsSpecSens(2);
  S_cs = E_cs * AbsSpecSens(2);
end

deltaS_a = S_a1 - S_a; % Increment in FPA signal for scene temperature increase of 1 K
TD = S_a ./ deltaS_a; % This is the image irradiance uniformity converted to equivalent scene temperature difference
TD = TD - TD(1); % Normalise to axial value to get delta temperatures

% Build up more results
Results.TD = TD;
Results.Omega = Omega';
Results.E_a = E_a;
Results.E_a1 = E_a1;
Results.E_cs = E_cs;
Results.tau_akl = tau_akl;
Results.BB_a = BB_a; % Ambient average scene spectral radiance (emissivity assumed = 1)
Results.BB_a1 = BB_a1; % Spectral radiance of BB at 1 K above the ambient scene temperature (emissivity assumed = 1)
Results.BB_d = BB_d; % Spectral radiance of the inside of the detector dewar (emissivity assumed = 1)
Results.BB_h = BB_h; % Spectral radiance of the housing (emissivity assumed = 1)
Results.S_a = S_a; % FPA signal or irradiance (A/mm^2 or W/mm^2) due to the scene
Results.S_a1 = S_a1; %  FPA signal or irradiance (A/mm^2 or W/mm^2) due to the scene with increase of 1K
Results.S_cs = S_cs; % FPA signal due to radiation from the cold shield
Results.r = r;
Results.AbsSpecSens = AbsSpecSens(:,2);

zSetWave(1, lambda(1), 1); % Reset wavelength 1
zGetUpdate;



% Compute YNI contributions using zGetTextFile
% First the settings file must be located
% Settings for the vignetting and relative illumination data are particularly important
mDir = [fileparts(which('IRNarcissus')) '\'];
SettingsFile = [LensDir '\' LensFile '.cfg']; % Get the settings from the originating file
zGetTextFile([NarcDir 'YNIf.txt'], 'Yni', SettingsFile, 1); % Compute and save YNI contribution

% The next step is to reverse the lens
ReverseSurfaces;

% Get the radius of the cold stop
R_c = ColdStopSemiDia;

% Get the inner and outer window radii
R_wi = zGetAperture(2); R_wi = R_wi(3);
R_wo = zGetAperture(3); R_wo = R_wo(3);

% Set what was the object distance (usually infinity) to zero
revlensys = zsGetSystem; % Reversed lens system data
zSetSurfaceData(revlensys.numsurfs - 1, 3, 0);
zSetSystemAper(3, 1, R_c); % Set system aperture to float by stop size.
zPushLens(10);


% Snatch a picture of the lens for the report
zGetMetaFile([NarcDir 'Primary Reversed.emf'], 'Lay', SettingsFile, 1);
zSaveFile([NarcDir 'Primary Reversed.zmx']);

% Now for the big one - compute the NITD contributions per lens surface
% First put the lens into doublepass

DoublePass;
zSetFloat; % Ensure all surfaces have som,e kind of aperture. Don't put in unnecessary dummy surfaces.
zSaveFile([NarcDir 'Double Pass.zmx']);

zPushLens(10);

% Loop through the original surface numbers
% Initialise surface reflectivities
tau_il = zeros(n_i, n_l); % Transmission to surface under analysis including surface reflectivity
n_a = zeros(n_i, n_k); % Number of scout rays going back into the dewar (each field point and each surface)
n_b = zeros(n_i, n_k); % Number of scout rays ending on cold stop annulus
n_c = zeros(n_i, n_k); % Number of scout rays terminating on housing
n_tir = zeros(n_i, n_k); % Number of scout rays ending in total internal reflection
E_ikl = zeros(n_i, n_k, n_l); % This is the FPA spectral irradiance per surface, per field position and per wavelength.
S_ik = zeros(n_i, n_k); % This is the narcissus signal level per square mm at each field position per surface
S_k = zeros(n_k); % This is the total narcissus signal for all surfaces

% Create 3D array of absolute spectral sensitivities
AbsSpecSens_ikl = reshape(AbsSpecSens(:,2),[1 1 n_l]); % Get the spectral sensitivies into the 3rd dimension
AbsSpecSens_ikl = repmat(AbsSpecSens_ikl, [n_i n_k 1]); % Replicate in row and column directions


progressbar = waitbar(0,'Raytracing .... ','CreateCancelBtn','PleaseCancel', 'Name', 'IRNarcissus');
worktodo = length(Surfaces) * n_k; % Product of the requested surfaces and number of field position
workdone = 0;
for isurf = 1:n_i
  % Delete the 2 centre surfaces
  opsurf = n_i - isurf + 2; % plus 2 because the image surface and cold stop do not get analysed
  % Remove the pickup on semi-diameter on opsurf + 1
  zSetSolve(opsurf + 2, 3, 1); % set to "fixed"
  zDeleteSurface(opsurf); 
  zDeleteSurface(opsurf);
  % Remove the glass pickup (solve) on the surface to be analysed
  zSetSolve(opsurf, 2, 0);
  % Change the surface under analysis to a mirror
  zSetSurfaceData(opsurf, 4, 'MIRROR');
  zSaveFile([NarcDir 'Surface' num2str(isurf) '.zmx']);
  zPushLens(10);
  % pause;
  
  FPASurf = zNumSurfs;
  ColdStopSurf = FPASurf - 1;
  % Loop through field positions
  % But only do the calculations for this surface if the user requested it
  if any(isurf == Surfaces)
      kfield = 1;
      for hy = 0:1/(n_k - 1):1
        waitbar(workdone/worktodo, progressbar, ['Raytracing Surface ' num2str(isurf) ' of ' num2str(n_i)], 'Name', 'IRNarcissus');
        % Next, compute the projected solid angle for dA_2 at dA_1 for all field positions
        dOmega = (dA * z * z ./ (x_2.^2 + (y_2 - r(kfield)).^2 + z * z).^2)';
        % Change the field data in the input ray data for next field position hy
        [RayData(2:end).y] = deal(hy);
        zSetWave(1, PrimaryWaveLength, 1); % Set the wavelength for raytracing, use the primary wavelength.
        zGetUpdate;        % Update the lens
        zDDEClose; % Close the DDE link so that there is no interference from zArrayTrace
        RayDataOut = zArrayTrace(RayData);
        zDDEInit;  % Reopen the DDE link
        vigcodes = [RayDataOut(2:end).vigcode]; % Get the vignetting codes from the resulting output ray data
        errcodes = [RayDataOut(2:end).error];   % Get the error codes
        % The following piece of code classifies the rays in terms of how they terminate. There are a number of subtleties
        % with regard to interpretation of the ray error and vignetting codes. Vignetting means that the ray is blocked by
        % the clear aperture defined on a surface. The following is an extract from the Zemax manual.

        % The integer error code will be zero if the ray traced successfully, otherwise it will be a positive or negative number.
        % If positive, then the ray missed the surface number indicated by error. If negative, then the ray total internal
        % reflected (TIR) at the surface given by the absolute value of the error number. 
        %
        % The parameter vigcode is the first surface where the ray was vignetted. Unless an error occurs at that surface
        % or subsequent to that surface, the ray will continue to trace to the requested surface.
        
        % Hence, ray failures due to TIR only matter to us if they occur before vignetting.

        rays_tir = (errcodes < 0); % Rays undergoing total internal reflection
        n_tir(isurf, kfield) = sum(rays_tir);
        rays_miss = (errcodes > 0); % Rays that completely miss surfaces
        n_miss(isurf, kfield) = sum(rays_miss);

        rays_a = ((vigcodes == 0 | vigcodes == FPASurf) & errcodes == 0); % Rays terminating in the dewar
        n_a(isurf, kfield) = sum(rays_a);
        rays_b = (vigcodes == ColdStopSurf & errcodes == 0); % Rays terminating on the cold stop/shield annulus
        n_b(isurf, kfield) = sum(rays_b);
        rays_c = (abs(errcodes) > opsurf) | ((vigcodes > opsurf) & (vigcodes < ColdStopSurf)); % Rays failing or vignetting after analysis surface
        % rays_c = rays_c & ~rays_b; % rays_c includes rays_b, so remove rays_b
        n_c(isurf, kfield) = sum(rays_c);
        rays_d = ((errcodes ~=0 & abs(errcodes) <= opsurf) | (vigcodes > 1 & vigcodes <= opsurf)); % Ray fails or is vignetted before 
                                                                         % surface under analysis (but not at cold stop).
        n_d(isurf, kfield) = sum(rays_d);

        % Loop through wavelength to compute surface reflectivity using an axial ray
        for llambda = 1:n_l
            zSetWave(1, lambda(llambda), 1); % Set the wavelength
            zGetUpdate;        % Update the lens
            % Zemax has a problem (bug perhaps) with computing reflectance correctly when going from a material into air
            % The workaround is to temporarily make the previous surface a mirror and compute the transmission to that surface.
            PreviousMaterial = zGetSurfaceData(opsurf - 1, 4); % Get the material of the previous surface
            if ~all(isspace(PreviousMaterial)) % material at previous surface is not air
              zSetSurfaceData(opsurf - 1, 4, 'MIRROR'); % temporarily change previous material to a mirror
              zGetUpdate;
              PolTrace = zGetPolTrace(1, 0, opsurf - 1, 0, 0, 0, 0, 1, 0, 0, 0); % Trace polarized axial ray to the previous surface
              zSetSurfaceData(opsurf - 1, 4, PreviousMaterial); % Change material back again
              zGetUpdate;
            else
              PolTrace = zGetPolTrace(1, 0, opsurf, 0, 0, 0, 0, 1, 0, 0, 0); % Trace polarized axial ray to the surface under analysis
            end
            tau_il(isurf, llambda) = PolTrace(2); % Transmission to surface i along scout ray as a function of wavelength
            % Now integrate over the cold stop to get irradiance levels per surface, per field position and per wavelength
            dE = tau_il(isurf, llambda) * dOmega .* ( ...
                 BB_d(llambda) * rays_a + ...                 % Contribution from inside the detector 
                 BB_d(llambda) * eps_csa * rays_b + ...       % Emissive component of cold stop annulus
                 BB_h(llambda) * (1 - eps_csa) * rays_b + ... % Reflective component of cold stop annulus
                 BB_h(llambda) * rays_c) + ...                % Rays terminating on housing after surface under analysis
                 BB_h(llambda) * dOmega .* rays_d;            % Terminated before (!) the surface under analysis. Something wrong ?
            dE = 2 * dE; % double up since only half of the stop was traced
            E_ikl(isurf, kfield, llambda) = sum(dE);
        end
        kfield = kfield + 1;
        if Cancelled % user wants to stop the computation
            delete(progressbar);
            Results.Status = -6;
            zLoadFile(LensFilePath); % Restore the original lens to the LDE
            zPushLens(10, 1); % Push and update
            zSetTimeout(OldTimeout); % Restore timeut value to what is was to start with  
            return;
        end
        workdone = workdone + 1;      
      end 
  end
end
delete(progressbar);
% Integrate over wavelength, weighted by absolute spectral sensitivity to get narcissus signal per surface and field position
% If operating at a single wavelength, assume band-integrated quantities
if deltalambda > 0
  dS_ikl = E_ikl .* AbsSpecSens_ikl;
  S_ik = deltalambda * trapz(dS_ikl, 3); % Integrate over the third dimension (lambda)
else
  S_ik = E_ikl * AbsSpecSens(2); % Band quantity
end    


% Sum over surfaces to get the total narcissus signal as a function of field (kfield)
S_k = sum(S_ik);

% Now for the NITD per surface
% NITD is defined as the narcissus signal divided by the increase of scene signal when the scene temperature T_a is increased by 1 K.
% NITD per surface uses S_ik and deltaS_a
% deltaS_a is a column vector with field position changing by row. Need to replicate the transpose.
NITD_i = S_ik ./ repmat(deltaS_a', n_i, 1); % replicate the scene signal delta by the number of surfaces
% NITDs are normalised to zero on axis
normNITD_i = NITD_i - repmat(NITD_i(:,1), 1, n_k);
% Total NITD found by taking the ratio of S_k to deltaS_a over field positions
NITD = S_k ./ deltaS_a'; % Need transpose again, because deltaS_k is row vector
normNITD = NITD - NITD(1);

Results.NITD_i = NITD_i;
Results.normNITD_i = normNITD_i;
Results.NITD = NITD;
Results.normNITD = normNITD;
Results.E_ikl = E_ikl; % Narcissus FPA spectral irradiance (function of surface i, field position k and wavelength l.
Results.S_ik = S_ik;   % Narcissus FPA signal per surface (function of surface i and field position k)
Results.S_k = S_k;     % Total narcissus FPA signal (function of field position k only)
Results.tau_il = tau_il; % Transmission to surface under analysis including reflectivity
Results.n_a = n_a;
Results.n_b = n_b;
Results.n_c = n_c;
Results.n_d = n_d;
Results.n_tir = n_tir;
Results.n_miss = n_miss;
Results.N_k = length(vigcodes); % Total number of rays traced per field position
Results.N = Results.N_k * n_k; % Total number of rays traced


% +++++++++++++++++++ Find worst offending surfaces


SurfNumbers = (1:n_i)'; 
Worst = flipud(sortrows([SurfNumbers normNITD_i(:,end)],2)); % Rank surfaces on total NITD viz. normNITD_i(isurf, end)
% Should possibly use max(normNITD_i,[],1) in the previous statement - for review

% Compute the maximum gradient of NITD contribution per surface in kelvins
% per image diagonal
for isurf = 1:n_i
  slup = 2 * max(gradient(NITD_i(isurf, :),mean(diff(r/max(r)))));    % maximum slope is most upward
  sldn = -2 * min(gradient(NITD_i(isurf, :),mean(diff(r/max(r)))));   % minimum slope is most downward
  maxgradNITD_i(isurf, 1) = max([slup, sldn]);                        % maximum of either upward or downward slope
end;

WorstSlope = flipud(sortrows([SurfNumbers maxgradNITD_i],2)); % Rank surfaces on maximum gradient of NITD contribution



% Read in the YNI contributions
[YNIsurf, YNIf] = textread([NarcDir, 'YNIf.txt'], '%f %f', 'headerlines', 11);
Worst(:,3) = YNIf(Worst(:,1));
WorstSlope(:,3) = YNIf(WorstSlope(:,1));
% Display Worst offenders with rank and YNI contribution

Worst = cat(2,SurfNumbers,Worst);
Rank = (1:size(WorstSlope,1))';
WorstSlope = cat(2,SurfNumbers,WorstSlope);
%disp(Worst);         % Worst integrated NITD contributions
%disp(WorstSlope);    % Worst NITD slope contributions

Results.Worst = Worst;
Results.WorstSlope = WorstSlope;

% Compute the NITD and TD maximum gradients in kelvins per image diagonal
slup = 2 * max(gradient(NITD,mean(diff(r/max(r)))));   % maximum slope is most upward
sldn = -2 * min(gradient(NITD,mean(diff(r/max(r)))));  % minimum slope is most downward
maxgradNITD = max([slup, sldn]);                       % find the steepest slope

slup = 2 * max(gradient(TD  ,mean(diff(r/max(r)))));   % maximum slope is most upward
sldn = -2 * min(gradient(TD  ,mean(diff(r/max(r)))));  % minimum slope is most downward
maxgradTD = max([slup, sldn]);                         % find the steepest slope

% Display the maximum gradient values
%disp(['Maximum Gradient of NITD is ' num2str(maxgradNITD) ' K per Image Diagonal']);
%disp(['Maximum Gradient of Image Uniformity is ' num2str(maxgradTD) ' K per Image Diagonal']);


% Set up more results to pass back
Results.Revision = Revision;        % Revision of IRNarcissus which produced this output
Results.RevDate = RevDate;          % Date of Revision which produced this output
Results.LensFile = LensFilePath;    
Results.LensDir = LensDir;
Results.NarcDir = NarcDir;
Results.FPASemiDiagonal = FPASemiDiagonal;
Results.n_i = n_i;
Results.n_k = n_k;
Results.n_l = n_l;
Results.Worst = (cat(1, {'Rank', 'Surface Number', 'Contribution', 'YNI'}, num2cell(Worst)));
Results.WorstSlope = (cat(1, {'Rank', 'Surface Number', 'Slope', 'YNI'}, num2cell(WorstSlope)));
Results.T_a = T_a;    % Ambient scene temperature
Results.T_d = T_d;    % Internal dewar temperature
Results.T_h = T_h;    % Camera housing temperature
Results.eps_csa = eps_csa; % Emissivity of cold stop annulus
Results.r_c = r_c*100;% Reflectivity of the cold stop annulus in percent
Results.D_c = R_c*2;  % Diameter of the cold stop
Results.D_wo = R_wo*2;% Outer window clear aperture diameter
Results.D_wi = R_wi*2;% Inner window clear aperture diameter
Results.Units = Units;% Lens dimensional units
Results.maxgradNITD = maxgradNITD;      % Maximum gradient of total NITD
Results.maxgradTD = maxgradTD;          % Maximum gradient of total image non-uniformity
Results.maxgradNITD_i = maxgradNITD_i;  % Maximum gradient of surface contributions to NITD



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Have you remembered to double quantities where necessary ????????????????????????????????????????????????
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

Results.Runtime = toc; % Return runtime of routine

% Finally, save the results to the .Narcissus directory
save([NarcDir 'Results.mat'], 'Results');
% Reload the original file and push to the user
zLoadFile(Results.LensFile);
zPushLens(10, 1); % Push and update
zSetTimeout(OldTimeout); % Restore timeut value to what is was to start with
return; % ========================================================================================================
