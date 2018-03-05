function Results = NarcWiz
% NarcWiz - Narcissus analysis wizard
%
% Usage : NarcOut = NarcWiz      % NarcOut is case sensitive
%         report narcissus
%
% This wizard has been superceded by the function IRNarcissus which is more rigorous. IRNarcissus takes
% wavelength dependence of coatings into account. IRNarcissus requires no user intervention during the 
% calculation. NarcWiz remains in the toolbox for reference purposes.
%
% NarcWiz Takes the user through a narcissus analysis of the lens in the ZEMAX DDE server. NarcOut is a
% structure containing various items required for the report generator, so the function must be
% called exactly as shown above. The report will be generated in rich text format (.rtf) and
% displayed in MS Word.
%
% The general restrictions and assumptions are as follows :
% 1) The lens model to be analysed is for a 3rd generation thermal imager using a cooled detector
%    which has a cold stop. The cold stop is assumed to be at the surface before the image surface
%    and the detector window is assumed to come before the cold stop. Clear apertures of these
%    objects must be set correctly.
% 2) The inside of the dewar has emissivity of 1 all over and across the spectral band.
% 3) The side of the cold stop facing outward has a user-defined emissivity and the same temperature
%    as the inside of the dewar right out to the clear aperture of the dewar window.
% 4) Emissions and reflections of thermal radiation by non-optical surfaces are lambertian.
% 5) Lens must be single configuration. Save and analyse each configuration seperately, taking
%    special care to ensure that the apertures are as they would be for the system as-built. It is
%    particularly important that the clear aperture of the dewar window is correctly set from
%    mechanical drawings of the dewar.
% 6) Only rotationally symmetrical lenses are currently handled - mainly a
%    retriction of the ZEMAX functions used for the computation. The whole
%    approach to the problem would have to change significantly to cater
%    for non-symmetrical systems.
%
% The general functions performed are as follows :
% 1) Create a directory named after the lens to be analysed in which all results will be saved. The
%    directory name will have the .Narcissus extension.
% 2) Ensure that the system is correctly set up, has clear apertures and coatings defined. Currently this is
%    done by appealing to the users's sense of thoroughness.
% 3) Compute system transmission, YNI contributions and uniformity of image illumination.
% 4) Reverse the lens and create single bounce ghost reflection models for each optical surface.
% 5) Compute the Narcissus-Induced Delta T contributions for each surface.
% 6) Plot total NITD, NITD per surface and overall image irradiance uniformity per configuration.
% 7) Generate subjective images of image non-uniformity.
% 8) Rank surfaces in order of contribution to NITD and tabulate with YNI contributions.
% 9) Compute maximum slope of total NITD and overall image non-uniformity. This gives an indication
%    of the local visibility of the image non-uniformities.
% 10) If the user gives the command 'report narcissus', a report will be generated in MS Word,
%     containing all of the outputs.
%
% Possible return values for NarcWiz are
%  0 - Everything seems to be OK
% -1 - ZEMAX not running and could not start ZEMAX.
% -2 - The lens you wanted to analyse cannot be raytraced.
% -3 - Lens has fewer than 6 surfaces. Detector + cold stop + window + 2 additional lens surfaces is
%      six at least.
% -4 - Lens does not operate primarily in a thermal band.
% -5 - Lens is multi-config. Currently we only do single config. Save and analyse each config
%      seperately.
% -6 - User cancelled wizard.
% -7 - Double bounce ghost lenses were encountered - restart analysis.
% -8 - Lens has wrong field type. Change to "real image height".

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

Revision = '$Revision: 221 $';
Revision = Revision(11:(size(Revision,2)-1));
disp(['Narcissus Analysis Wizard. Version' Revision]);
RevDate = '$Date: 2009-10-30 09:07:07 +0200 (Fri, 30 Oct 2009) $';
RevDate = RevDate(7:(size(RevDate,2)-1));
disp(['Copyright Defencetek, CSIR,' RevDate]);

NarcIcon=1:64; NarcIcon=(NarcIcon'*NarcIcon)/64; % Make an icon for use with dialogs

Results.Status = zDDEInit; % Attempt to contact ZEMAX through DDE.
if (Results.Status == -1)        % Failed, try to start ZEMAX and ask user to select the file
    Results.Status = zDDEStart;
    if (Results.Status == 0)     % Success, now do the open file dialog
        uiwait(msgbox('ZEMAX is Starting. Please accept DDE commands from Matlab and open the lens file for Narcissus Analysis.', 'ZEMAX Startup', 'custom', NarcIcon, hot(64),'modal'))
        zOpenWindow('Ope'); zWindowMaximize(0);
    end
end
if (Results.Status == -1) return; end; % Give up

while (zGetRefresh == -2); end;       % Wait for user to accept DDE messaging and open the lens file

if (zGetRefresh ~= 0) 
    uiwait(msgbox('The lens you are attempting to analyse cannot be raytraced.', 'Fatal Lens Error', 'error', 'modal'));
    Results.Status = -2;
    return; % Give up
end
zPushLens(10);
while (zGetRefresh == -2); end;       % Wait for user to accept DDE messaging and open the lens file

% Get some lens data, including the wavelengths and the number of lens surfaces.
LenSys = zsGetSystem;
if (LenSys.numsurfs < 6)
    uiwait(msgbox('The lens you are attempting to analyse has less than 6 Surfaces.', 'Fatal Lens Error', 'error', 'modal'));
    Results.Status = -3;
    return;
end

% Check that the field type is set to "real image height"
FieldData = zGetField(0); FieldType = FieldData(1);
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

% By now we think there is a useable lens in the ZEMAX DDE server, and we start with analysis.

% Firstly find the location of the lens and create a directory for Narcissus analysis output
% The directory has the same name as the lens file, but has the extension .Narcissus
LensFilePath = zGetFile; 
[LensDir, LensFile] = fileparts(LensFilePath);
[Success, Message, MessageID] = mkdir(LensDir, [LensFile '.Narcissus']);
NarcDir = [LensDir '\' LensFile '.Narcissus\'];

% If directory already exists
if (strcmp(MessageID, 'MATLAB:MKDIR:DirectoryExists'))
     % uiwait(msgbox('The .Narcissus directory for this lens already exists. Old Data will be overwritten.', 'Directory Warning', 'custom', NarcIcon, hot(64), 'modal'));
    if (exist([NarcDir 'rho.txt'], 'file'))
      Answer = questdlg('Relative Illumination Data for this lens already exists. Recompute Relative Illumination ?', 'Recalculate Relative Illumination');
      if (strcmp(Answer,'Yes')), delete([NarcDir 'rho.txt']); end; if (strcmp(Answer, 'Cancel')), Results.Status = -6; return; end;
    end;
    if (exist([NarcDir 'nu.txt'], 'file'))
      Answer = questdlg('Vignetting Data for this lens already exists. Recompute Vignetting Data ?', 'Recalculate Veignetting Data');
      if (strcmp(Answer,'Yes')), delete([NarcDir 'nu*.txt']); delete([NarcDir 'cnu*.txt']); end;  if (strcmp(Answer, 'Cancel')), Results.Status = -6; return; end;  
    end;
    delete([NarcDir 'GH*.ZMX']);          % Delete all ghost lenses in this directory
end

% Here we will deal with multiconfiguration lenses. For now just dump the user if the lens is
% multi-config.

ConfigData = zGetConfig;
if (ConfigData(2) > 1)
    uiwait(msgbox('This wizard currently only handles single configuration systems.', 'Fatal Lens Error', 'error', 'modal'));
    Results.Status = -5;
    return;
end

uiwait(msgbox('Please ensure that all lens surfaces have correct clear apertures and coatings. Only then click OK in this message box.', 'Apertures/Coatings', 'custom', NarcIcon, hot(64), 'modal'));

% Get the latest lens
zGetRefresh;
% and save it as 'Primary.zmx' in the analysis directory
zSaveFile([NarcDir 'Primary.zmx']);

% Get some global variables, including the ambient scene temperature, the dewar termperature, the
% housing temperature, and the cold stop reflectivity.
Prompt = {'Scene Temperature (K)', 'Dewar Temperature (K)', 'Camera Housing Temperature (K)', 'Cold Stop Reflectivity (%)'};
DefAns = {'300',                   '120',                   '300',                            '1'                         };
Answer = inputdlg(Prompt, 'Narcissus Wizard : Temperature and Emmissivity Inputs', 1, DefAns);
if (~isempty(Answer))
  T_a = str2double(Answer{1});        % T_a = Scene ambient temperature
  T_d = str2double(Answer{2});        % T_d = Internal Dewar temperature in kelvins
  T_h = str2double(Answer{3});        % T_h = optical housing temperature
  r_c = str2double(Answer{4})/100.0;  % r_c = reflectivity of the outer surface of the cold stop
else
    Results.Status = -6;
    return;
end

% Compute the effective F/number from the size of the cold stop and it's distance from the focal
% plane array.
ImSurf = LenSys.numsurfs;
ColdStopSurf = ImSurf - 1;
SurfDataCode = zSurfDataCodes;
ColdStopSemiDia = zGetSurfaceData(ColdStopSurf, SurfDataCode.semidia);
ColdStopDist = zGetSurfaceData(ColdStopSurf, SurfDataCode.thickness);
F = 1 / (2 * sin(atan(ColdStopSemiDia/ColdStopDist)));

% Now compute axial transmission, image illumination uniformity and YNI contributions.
% To compute axial transmission, trace an axial ray.
PolTraceData = zGetPolTrace(PrimaryWave, 0, -1, 0, 0, 0, 0, 0, 1, 0, 0);
tau_S = PolTraceData(2); % This is axial system transmission. An enhanced version could do better.

% Compute YNI contributions and image uniformity using zGetTextFile
% First the settings file must be located
% Settings for the vignetting and relative illumination data are particularly important
mDir = [fileparts(which('NarcWiz')) '\'];
SettingsFile = [LensDir '\' LensFile '.cfg']; % Get the settings from the originating file
zGetTextFile([NarcDir 'YNIf.txt'], 'Yni', SettingsFile, 1); % Compute and save YNI contributions
BusyMessage = ZEMAXBusy; pause(1); % Display a message telling the user that ZEMAX is busy
while (zDDEBusy), end; % Wait for command to complete
if (~exist([NarcDir 'rho.txt']))
  zGetTextFile([NarcDir 'rho.txt'], 'Rel', SettingsFile, 1); % Compute and save relative illumination
end;
while (zDDEBusy), end; % Wait for command to complete
delete(BusyMessage); % Pack away the message

% The next step is to reverse the lens and patch up
zWindowMaximize(0);
zOpenWindow('Rev'); % Reverse elements
uiwait(msgbox('Switch to ZEMAX and select all lens surfaces for reversal. When done click OK.', 'Reverse Warning', 'custom', NarcIcon, hot(64), 'modal'));
zGetRefresh; % Lens should be reversed now
% Fix up surface 0
zSetSurfaceData(0, SurfDataCode.thickness, ColdStopDist);
% Fix up surface 1 (the cold stop)
zDeleteSurface(1);
zSetSurfaceData(1, SurfDataCode.semidia, ColdStopSemiDia);
zSetAperture(1, 1, 0, ColdStopSemiDia, 0, 0, '');
% Set aperture characteristics
zSetSystemAper(0, 1, ColdStopSemiDia*2);
% Set the field type to object height
FieldData = zGetField(0);
zSetFieldType(1, FieldData(2));

% Fixup coatings
Coating = 'I.99';
LenSys = zsGetSystem;
for Surf = 1:(LenSys.numsurfs),
    if (~strcmp(zGetSurfaceData(Surf, SurfDataCode.glass),zGetSurfaceData(Surf-1, SurfDataCode.glass)))
        zSetSurfaceData(Surf, SurfDataCode.coating, Coating);
    else
        zSetSurfaceData(Surf, SurfDataCode.coating, '');
    end
end

% Remove the aperture from the image surface
zSetAperture(LenSys.numsurfs, 0, 0, 0, 0, 0, '');

% Get the radius of the cold stop
R_c = zGetAperture(1); R_c = R_c(3);

% Get the inner and outer window radii
R_wi = zGetAperture(2); R_wi = R_wi(3);
R_wo = zGetAperture(3); R_wo = R_wo(3);

% Get lens units
switch LenSys.unitcode,
    case 0, Units = 'mm';
    case 1, Units = 'cm';
    case 2, Units = 'in';
    case 3, Units = 'm';
end

zPushLens(10);
% Snatch a picture of the lens for the report
zGetMetaFile([NarcDir 'Primary Reversed.emf'], 'Lay', SettingsFile, 1);
zOpenWIndow('Sas');
uiwait(msgbox(['Switch to ZEMAX and save the lens as "Primary Reversed.zmx" in the directory ' NarcDir], 'Save Request', 'custom',NarcIcon, hot(64), 'modal'));
zOpenWindow('Gho');
uiwait(msgbox('Switch to ZEMAX and generate single bounce ghost lenses for all surfaces. Remember to specify Save Files and the correct coating', 'Ghost Lens Generation', 'custom', NarcIcon, hot(64), 'modal'));

% The next job is to perform a vignetting calculation and save text for each ghost lens
% Start by getting a list of all ghost lenses
GhostFiles = dir([NarcDir 'gh*.zmx']);
% Loop and load each ghost lens in turn

BusyMessage = ZEMAXBusy; pause(1);
nuFID = fopen([NarcDir 'nu.txt'], 'wt');
for i=1:size(GhostFiles,1)
    zLoadFile([NarcDir GhostFiles(i).name]);  % Load up the next ghost lens file
    LenSys = zsGetSystem;                     % Get system operating parameters esp. number of surfaces
    zPushLens(3);                             % Push the lens into the foreground
    GhostSurf = GhostFiles(i).name(3:5);      % Extract the ghosting surface from the filename
    NoNoSurf  = GhostFiles(i).name(6:8);      % This must be 000, otherwise user has generated double bounce lenses
    if (~strcmp(NoNoSurf, '000'))             % The user seems to have generated double bounce lenses
        uiwait(msgbox('Encountered double bounce ghost lenses. Restart the analysis.', 'Double Bounce Error', 'error', 'modal'));
        delete([NarcDir 'GH*.ZMX']);          % Delete all ghost lenses in this directory
        delete(BusyMessage);                  % Delete the busy message
        Results.Status = -7;                  % Give up
        return;
    end;
    nuDataFile = ['nu' GhostSurf '.txt'];     % Synthesize filename of vignetting data with cold stop
    nu_cDataFile = ['cnu' GhostSurf '.txt'];  % Filename of vignetting data without cold stop
    % Compute transmission for the axial ray
    PolTraceData = zGetPolTrace(PrimaryWave, 0, -1, 0, 0, 0, 0, 0, 1, 0, 0);
    tau = PolTraceData(2); % This is axial system transmission. An enhanced version could do better.
    fprintf(nuFID, '%s %1.20g\n', nuDataFile, tau);       % Write filename and transmission data into file for later
    nuDataFile = [NarcDir nuDataFile];                    % Synthesize full pathname of vignetting data with cold stop
    nu_cDataFile = [NarcDir nu_cDataFile];                % Synthesize full pathname of vignetting data without cold stop
    if (~exist(nuDataFile, 'file')),                      % Check if the vignetting datafile already exists
      zGetTextFile(nuDataFile, 'Vig', SettingsFile, 1);   % if not, generate vignetting data for this ghost lens
    end;
    zSetAperture(LenSys.numsurfs - 1, 0, 0, 0, 0, 0, ''); % Now remove the cold stop aperture
    zPushLens(3);                                         % Push the lens into the foreground
    if (~exist(nu_cDataFile, 'file')),                    % Check if the vigentting data file exists
      zGetTextFile(nu_cDataFile, 'Vig', SettingsFile, 1); % if not, generate vignetting data for this ghost lens with cold stop removed
    end;
end
fclose(nuFID);
delete(BusyMessage);

% Here are the pixel resolutions at which to plot the qualitative narcissus map
xres = 640;
yres = 480;

% Here are the wavelengths over which we will integrate
deltalambda = 0.02;
lambda1 = 3.0;
lambda2 = 5.0;
lambda = lambda1:deltalambda:lambda2;
lambda = lambda';

% Compute Black body curves for ambient scene, dewar and housing
BB_a = planck(lambda, T_a);
BB_d = planck(lambda, T_d);
BB_h = planck(lambda, T_h);

% Read in the relative illumination (irradiance) rho
% Please check that the number of headerlines is correct

[yrho, rho] = textread([NarcDir 'rho.txt'], '%f %f', 'headerlines', 13);

% Now read in all the filename and transmittance data from nu.txt

[names, tau] = textread([NarcDir, 'nu.txt'], '%9c %f'); % Filenames of vignetting data with cold stop
names_c = cat(2,repmat('c',size(names,1),1),names);     % Filenames of vignetting data wihtout cold stop
% Now read in all of the vignetting curves
for i=1:size(names)
    [y, nu(:,i)] = textread([NarcDir names(i,:)], '%f %f', 'headerlines', 12);     % Read vignetting data with cold stop
    [y, nu_c(:,i)] = textread([NarcDir names_c(i,:)], '%f %f', 'headerlines', 12); % Read vignetting data without cold stop
end

% It is possible that rho has been computed on a less dense y field sampling. We must therefore resample rho.
rho = interp1(yrho, rho, y, 'spline');

% Now compute and sum all the irradiance terms

% First the contribution from the ambient scene, with and without the effect of rho
H_arho = tau_S * trapz(lambda, BB_a) * rho / (4 * F * F);
H_a = tau_S * trapz(lambda, BB_a) * ones(size(rho)) / (4 * F * F);
% Next comes the direct contribution from the cold dewar walls;
H_d = 2 * sqrt(1 - 1 / (4 * F * F)) * trapz(lambda, BB_d) * ones(size(H_a));
% The following contribution is the "cold return", or cold straylight from single bounce reflections
H_id = repmat(tau',size(nu,1),1).*nu*trapz(lambda, BB_d) / (4 * F * F);
sigmaH_id = sum(H_id,2);
% Secondly, we have the mixed return from the outside of the cold stop
H_idh = repmat(tau',size(nu,1),1).*(nu_c - nu)*trapz(lambda, (r_c * BB_h + (1 - r_c) * BB_d)) / (4 * F * F);
sigmaH_idh = sum(H_idh,2);
% Lastly, the warm return, assumed to come from the housing
H_ih = repmat(tau',size(nu,1),1).*(1-nu_c)*trapz(lambda, BB_h) / (4 * F * F);
sigmaH_ih = sum(H_ih,2);

% Here comes the final irradiance sum, with and without the effect of rho

H_rho = H_arho + H_d + sigmaH_id + sigmaH_idh + sigmaH_ih;
H = H_a + H_d + sigmaH_id + sigmaH_idh + sigmaH_ih;

% and here come the contributions per surface

H_i = repmat(H_a, 1, size(H_id,2)) + repmat(H_d, 1, size(H_id,2)) + H_id + H_idh + H_ih;

% And finally we get to NITD

% First compute planck curve for radiation one kelvin above ambient
BB_a1 = planck(lambda, T_a + 1);

% Compute Detector irradiance delta T
TD = (H_rho-H(1))./(tau_S * rho * (trapz(lambda, BB_a1) - trapz(lambda, BB_a))/(4 * F * F));

% Total NITD computed without the effect of rho
%NITD = (H-H(1))./(tau_S * ones(size(rho)) * (trapz(lambda, BB_a1) - trapz(lambda, BB_a))/(4 * F * F));
NITD = (H-H(1))/(tau_S *(trapz(lambda, BB_a1) - trapz(lambda, BB_a))/(4 * F * F));
normNITD = NITD - NITD(1);

% Compute the NITD contributions per surface 
NITD_i = (H_i - repmat(H_i(1,:), size(H_i,1),1))/(tau_S *(trapz(lambda, BB_a1) - trapz(lambda, BB_a))/(4 * F * F));

% Find worst offending surfaces

sigmaNITD_i = sum(NITD_i);
sigmaNITD_i = sigmaNITD_i';
Worst = flipdim(sortrows([str2num(names(:,3:5)) sigmaNITD_i],2),1); % Rank surfaces on worst total integrated NITD

% Compute the maximum gradient of NITD contribution per surface in kelvins
% per image diagonal
for Col = 1:size(NITD_i,2)
  slup = 2 * max(gradient(NITD_i(:,Col),mean(diff(y/max(y)))));    % maximum slope is most upward
  sldn = -2 * min(gradient(NITD_i(:,Col),mean(diff(y/max(y)))));   % minimum slope is most downward
  maxgradNITD_i(1,Col) = max([slup, sldn]);                        % maximum of either upward or downward slope
end;

WorstSlope = flipdim(sortrows([str2num(names(:,3:5)) maxgradNITD_i'],2),1); % Rank surfaces on maximum gradient of NITD contribution

% Read in the YNI contributions
[YNIsurf, YNIf] = textread([NarcDir, 'YNIf.txt'], '%f %f', 'headerlines', 11);
% Reverse order as for ghost analysis lenses
YNIf = flipud(YNIf);
Worst(:,3) = YNIf(Worst(:,1));
WorstSlope(:,3) = YNIf(WorstSlope(:,1));
% Display Worst offenders with rank and YNI contribution
Rank = (1:size(Worst,1))';
Worst = cat(2,Rank,Worst);
Rank = (1:size(WorstSlope,1))';
WorstSlope = cat(2,Rank,WorstSlope);
disp(Worst);         % Worst integrated NITD contributions
disp(WorstSlope);    % Worst NITD slope contributions

h1 = figure;
set(h1, 'Tag', 'NITDps');
plot(y,NITD_i);
grid;
xlabel('Field Position (mm)');
ylabel('NITD per Surface (K)');
legend(names(:,4:5));
title(['NITD per Surface for T_a = ' num2str(T_a) 'K    T_d = ' num2str(T_d) 'K    T_h = ' num2str(T_h) 'K    r_c = ' num2str(r_c*100) '%']);

h2 = figure;
set(h2, 'Tag', 'TNITD');
plot(y,NITD);
grid;
xlabel('Field Position (mm)');
ylabel('Total NITD (K)');
title(['Total NITD for T_a = ' num2str(T_a) 'K    T_d = ' num2str(T_d) 'K    T_h = ' num2str(T_h) 'K    r_c = ' num2str(r_c*100) '%']);

h3 = figure;
set(h3, 'Tag', 'IrrUni');
plot(y,TD);
grid;
xlabel('Field Position (mm)');
ylabel('TD (K)');
title(['Irradiance Uniformity for T_a = ' num2str(T_a) 'K    T_d = ' num2str(T_d) 'K    T_h = ' num2str(T_h) 'K    r_c = ' num2str(r_c*100) '%']);


% Compute the NITD and TD maximum gradients in kelvins per image diagonal
slup = 2 * max(gradient(NITD,mean(diff(y/max(y)))));   % maximum slope is most upward
sldn = -2 * min(gradient(NITD,mean(diff(y/max(y)))));  % minimum slope is most downward
maxgradNITD = max([slup, sldn]);                       % find the steepest slope

slup = 2 * max(gradient(TD  ,mean(diff(y/max(y)))));   % maximum slope is most upward
sldn = -2 * min(gradient(TD  ,mean(diff(y/max(y)))));  % minimum slope is most downward
maxgradTD = max([slup, sldn]);                         % find the steepest slope

% Display the maximum gradient values
disp(['Maximum Gradient of NITD is ' num2str(maxgradNITD) ' K per Image Diagonal']);
disp(['Maximum Gradient of Image Uniformity is ' num2str(maxgradTD) ' K per Image Diagonal']);

% Now also make narcissus image map for "qualitative" impact of this total NITD and uniformity curve
% We find the distance of the pixel centre from the image centre and set the brightness according to
% the fraction of the image semi-diagonal.
% First find the length of the image semidiagonal in pixels.
semidiag = round(sqrt((xres/2)^2 + (yres/2)^2));

% Now compute the radial distance of the centre of each pixel from the centre of the image
r = max(y) * abs(repmat(1:1:xres, yres, 1) - xres/2 + j * (repmat((1:1:yres)',1, xres) - yres/2)) / semidiag;

% Finally, interpolate TD and NITD on this grid of radii
imTD = interp1(y, TD, r);
imNITD = interp1(y, normNITD, r);


% Perform some scaling and shifting - currently this is not correct to yield a good representation
% SiTF must be taken into account.
% imH and imH_rho are probably the better indication at this stage.
minim = min(min(imTD));
imTD = imTD - minim;
imTD = imTD/max(max(imTD));

minim = min(min(imNITD));
imNITD = imNITD - minim;
imNITD = imNITD/max(max(imNITD));

% imH = 0.75 * imH/max(max(imH));
% imH_rho = 0.75 * imH_rho/max(max(imH_rho));

% Display the image non-uniformity representations
figure;
imshow(imTD);
title(['Total Image Uniformity for T_a = ' num2str(T_a) 'K    T_d = ' num2str(T_d) 'K    T_h = ' num2str(T_h) 'K']);

figure;
imshow(imNITD);
title(['NITD Uniformity for T_a = ' num2str(T_a) 'K    T_d = ' num2str(T_d) 'K    T_h = ' num2str(T_h) 'K']);

% figure;
% imshow(imH);
% title(['Image Irradiance for T_a = ' num2str(T_a) 'K    T_d = ' num2str(T_d) 'K    T_h = ' num2str(T_h) 'K']);
% xlabel('Note : \rho is neglected');

% figure;
% imshow(imH_rho);
% title(['Image Irradiance for T_a = ' num2str(T_a) 'K    T_d = ' num2str(T_d) 'K    T_h = ' num2str(T_h) 'K']);
% xlabel('Note : \rho is included');

% Save the images for later reference

imwrite(imTD, [NarcDir 'FieldUniformity.jpg']);
imwrite(imNITD, [NarcDir 'NITDUniformity.jpg']);
% imwrite(imH, [NarcDir 'ImageIrradianceWithoutRho.jpg']);
% imwrite(imH_rho, [NarcDir 'ImageIrradianceWithRho.jpg']);

% Set up results to pass back
Results.Revision = Revision;        % Revision of NarcWiz which produced this output
Results.RevDate = RevDate;          % Date of Revision which produced this output
Results.LensFile = LensFilePath;    
Results.LensDir = LensDir;
Results.NarcDir = NarcDir;
Results.Worst = (cat(1, {'Rank', 'Surface Number', 'Contribution', 'YNI'}, num2cell(Worst)))';
Results.WorstSlope = (cat(1, {'Rank', 'Surface Number', 'Slope', 'YNI'}, num2cell(WorstSlope)))';
Results.T_a = T_a;    % Ambient scene temperature
Results.T_d = T_d;    % Internal dewar temperature
Results.T_h = T_h;    % Camera housing temperature
Results.r_c = r_c*100;% Reflectivity of the cold stop
Results.D_c = R_c*2;  % Diameter of the cold stop
Results.D_wo = R_wo*2;% Outer window clear aperture diameter
Results.D_wi = R_wi*2;% Inner window clear aperture diameter
Results.Units = Units;% Lens dimensional units
Results.maxgradNITD = maxgradNITD;      % Maximum gradient of total NITD
Results.maxgradTD = maxgradTD;          % Maximum gradient of total image non-uniformity
Results.maxgradNITD_i = maxgradNITD_i;  % Maximum gradient of surface contributions to NITD





