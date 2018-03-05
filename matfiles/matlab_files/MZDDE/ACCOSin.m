function Status = ACCOSin(varargin)
% ACCOSin - Read an ACCOS .len file into ZEMAX.
%
% Usage : Status = ACCOSin
%
% The following return values are possible
%
%  0 : Success
% -1 : User Canceled operation or file not found
%
% If there are multiple .len files seperated with 'LIB PUT' commands as for a library dump, then
% each lens is saved as a .zmx file, and given the name in the lens idendification line of the input.
% In this case, ACCOSin will ask for the directory in which to store the library dump.

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

% Still to implement and fix
% --------------------------
% Plain SCY (not FANG) in multi-config.
% CVX, RDX etc - all cylindrical components.
% COCY and other solves.
% Investigate why so many YD pikups are being ignored. Seems to be for good reason ie. target of
% pikup has no tilts or decenters, therefore safe to ignore.
% Create log file with copy of narrative. Include surface numbers for both ACCOS and ZEMAX files.
% Look at FNBY, FNBX

Revision = '$Revision: 221 $';
RevDate = '$Date: 2009-10-30 09:07:07 +0200 (Fri, 30 Oct 2009) $';
Revision = Revision(11:(size(Revision,2)-1));
RevDate = RevDate(7:(size(RevDate,2)-1));
disp(['ACCOS Leno Importer for ZEMAX. Version' Revision]);
disp(['Derek Griffith,' RevDate]);

Status = zDDEInit;
if (Status)
    uiwait(msgbox('ZEMAX is not Running.', 'ZEMAX Error', 'error', 'modal'));
    return;
end;

oldPWD = PWD;
DefaultDir = 'c:\popdist';
if (~exist(DefaultDir, 'dir')), DefaultDir = 'c:\'; end;


ACCDir = getenv('ACCOS');
if (strcmp(ACCDir, '')), ACCDir = DefaultDir; end;
cd(ACCDir);

zWindowMinimize(0);
FilterSpec = {'cpfile', 'ACCOS CPFILE'; '*.len;*.leno', 'ACCOS Leno Files'; '*.*', 'All Files' }; 
[iFile, iPath] = uigetfile(FilterSpec, 'Open ACCOS File');
if (iFile) % Seem to have a file to read ACCOS input from
    Status = ReadACCOSFile(fullfile(iPath, iFile));    
else
    Status = -1; zddeclose; cd(oldPWD); return;
end

cd(oldPWD);


function Status = ReadACCOSFile(Filename)
% Read in the ACCOS LEN File
global ACCOSMaterials ZEMAXMaterials
LibDumpPath = '';
% Here are the known ACCOS materials
ACCOSMaterials = {...
'GERM','ARTRI','SILICN','SAPHIR','BAF','SILICA','IRT2','IRT4',...
'CAFL','NAF','LIF','NACL','KI','KCL','KBR','AMTIR1',...
'RZNSE','RZNS','WAT20C','IRT1','PBF2','CDF2','GAAS','ZNS',...
'ZNSE','CDTE','SCGERM','MGF2','KRS-5','LIFX','KBRX','KCLX',...
'KIX','NACLX','CALX-O','CALX-E','CSBRX','CSIX','IRGN6X','IRG11X',...
'MGFX-O','MGFX-E','KDPX-O','KDPX-E','AGCLX','STRTIX','KRS5X','IRGN6X',...
'IRG11X','QRZX-O','QRZX-E','MGALO'...
'SF56', 'LAF21', 'LASF30', 'KZFSN7', 'SF56', 'KZSF4', 'LAF11', 'F11'...
}';

% and the best known equivalent ZEMAX materials
% There may still be errors in this list
ZEMAXMaterials = {...
'GERMANIUM','ARTRI','SILICON','SAPPHIRE','BAF','F_SILICA','IRT2','IRT4',...
'CAF2','NAF','LIF','NACL','KI','KCL','KBR','AMTIR1',...
'ZNSE','CLEARTRAN','WATER','IRT1','PBF2','CDF2','GAAS','ZNS_BROAD',...
'ZNSE','CDTE','SCGERM','MGF2','KRS5','LIF','KBR','KCL',...
'KI','NACL','CALCITE','CALCITE-E','CSBR','CSI','IRGN6','IRG11',...
'MGF2','MGF2-E','KDP','KDP-E','AGCL','STRTI','KRS5','IRGN6',...
'IRG11','QUARTZ','QUARTZ-E','MGALO'...
'N-SF56', 'LAFN21', 'LASFN30', 'KZFS7A', 'SF56A', 'KZFSN4', 'LAFN11', 'FN11'...
}';

UnknownDirectives = {};
UnknownPikups = {};
Status = 0;
UseCoordBreaks = 1;  % Will use ZEMAX Coordinate break surfaces for tilts and decentres if this is set, otherwise surface tilts and decenters are used
                     % Note that pikups of surface tilts and decenters are only honoured if this
                     % flag is set.

fID = fopen(Filename, 'rt');
% Now process the entire contents of the file
while 1
    LenLine = fgetl(fID);
    if ~ischar(LenLine), break, end; % End of file
    LenLine = upper(LenLine); % Convert to upper case
    [Directive, Rest] = strtok(LenLine, ' ,'); % Take the directive from the start of the line
    if (Directive)
    switch Directive
      case 'LENS', zNewLens; Title = Rest(2:size(Rest,2)); % Great, but currently no way to change the lens title in the DDE server !
                   ZEMAXSurface = 0; ACCOSSurface = 0;     % Maintain two pointers, because coordinate breaks will cause a mismatch
                   XObjectAngle = 0; YObjectAngle = 0; XObjectHeight = 0; YObjectHeight = 0;
                   Wavelengths = [0.5876; 0.48613; 0.65627; 0.43584; 0.70653]; NumWaves = 5;
                   WaveWeights = [1.0   ; 1.0    ; 1.0    ; 1.0    ; 1.0    ]; FieldType = 0;
                   zSetWaveMatrix([Wavelengths WaveWeights]); LensComments = {}; NumberComments = 0; LITitle = '';
                   StopSurface = 0; Fixups.Comments = {}; Fixups.ModelGlasses = {}; Fixups.NumberConfigs = 1;
                   Fixups.ConfigData = {}; Fixups.ConfigOperands = 0; TiltDec = zeros(1,7); Fixups.TiltDecBefore = {}; Fixups.TiltDecAfter = {};
                   zSetLabel(1,9999); zSetLabel(2,10000);   % Label these surfaces high for later fixup
      case 'LI',   LITitle = LenLine(4:size(LenLine,2));         % Same dilemma
                   disp(['Reading :' LITitle]); Fixups.Title = deblank(fliplr(deblank(fliplr(LITitle))));
      case 'LIC',  NumberComments = NumberComments + 1; LensComments{NumberComments} = Rest(2:size(Rest,2));
                   Fixups.Comments{NumberComments} = deblank(fliplr(deblank(fliplr(LensComments{NumberComments}))));
      case 'C',    Comment = LenLine(2:size(LenLine,2));
                   [Token, Rest] = strtok(Rest, ' ,');
                   switch Token
                       case 'SURFACE', CheckACCOSSurface = str2num(strtok(Rest, ' ,'));
                       otherwise,
                   end;
      case 'SAY', Token = strtok(Rest, ' ,'); PupilRadius = str2double(Token); zSetSystemAper(0, 1, 2*PupilRadius);
      case 'SCY', [Token, Rest] = strtok(Rest, ' ,'); 
                  if (strcmp(Token, 'FANG'))
                      [Token, Rest] = strtok(Rest, ' ,'); YObjectAngle = str2double(Token); YObjectHeight = 0.0; FieldType = 0;
                  else
                      YObjectHeight = str2double(Token); YObjectAngle = 0.0; FieldType = 1;
                  end;
      case 'SCX', [Token, Rest] = strtok(Rest, ' ,'); 
                  if (strcmp(Token, 'FANG'))
                      [Token, Rest] = strtok(Rest, ' ,'); XObjectAngle = str2double(Token); XObjectHeight = 0.0; FieldType = 0;
                  else
                      XObjectHeight = str2double(Token); XObjectAngle = 0.0; FieldType = 1;
                  end;
      case 'RD', Token = strtok(Rest, ' ,'); Radius = str2double(Token); if (Radius ~= 0), zSetSurfaceData(ZEMAXSurface, 2, 1/Radius); end;
      case 'CV', Token = strtok(Rest, ' ,'); if (Token), Curv = str2double(Token); else Curv = 0.0; end; zSetSurfaceData(ZEMAXSurface, 2, Curv);
      case 'APY',zSetSolve(ZEMAXSurface, 0, 7); % Aplanatic Solve
      case 'COCY',Token = strtok(Rest, ' ,');   % Concentric with surface solve - will only work with prior target surfaces.
                  if (Token), ConSurf =  str2num(Token); ConSurf = zFindLabel(ConSurf); 
                      if (ConSurf ~= -1), zSetSolve(ZEMAXSurface, 0, 9);
                      else disp(['COCY Solve Ignored at Surface ' num2str(ACCOSSurface)]);
                      end;
                  end;
      case 'CC', Token = strtok(Rest, ' ,'); if (Token), Conic = str2double(Token); else Conic = 0.0; end; zSetSurfaceData(ZEMAXSurface, 6, Conic);
      case 'ASPH', [Token, Rest] = strtok(Rest, ' ,'); 
                   if (Token)
                     switch (Token) 
                       case 'RSIRS', disp(['Rotationally Symmetric Spline Surface Definition Ignored at Surface ' num2str(ACCOSSurface)]);
                       case 'IRS'  , disp(['Asymmetric Spline Surface Definition Ignored at Surface ' num2str(ACCOSSurface)]);
                       otherwise   , if (Token), Ad = str2double(Token); else Ad = 0.0; end;
                                     [Token, Rest] = strtok(Rest, ' ,'); if (Token), Ae = str2double(Token); else Ae = 0.0; end;
                                     [Token, Rest] = strtok(Rest, ' ,'); if (Token), Af = str2double(Token); else Af = 0.0; end;
                                     [Token, Rest] = strtok(Rest, ' ,'); if (Token), Ag = str2double(Token); else Ag = 0.0; end;
                                     zSetSurfaceData(ZEMAXSurface, 0, 'EVENASPH'); zSetSurfaceParamVector(ZEMAXSurface, [0, 0, Ad, Ae, Af, Ag]);
                     end;
                   end;
      case 'AD', Token = strtok(Rest, ' ,'); if (Token), Ad = str2Double(Token); else Ad = 0.0; end; 
                 zSetSurfaceData(ZEMAXSurface, 0, 'EVENASPH'); zSetSurfaceParameter(ZEMAXSurface, 2, Ad);
      case 'AE', Token = strtok(Rest, ' ,'); if (Token), Ae = str2Double(Token); else Ae = 0.0; end; 
                 zSetSurfaceData(ZEMAXSurface, 0, 'EVENASPH'); zSetSurfaceParameter(ZEMAXSurface, 3, Ae);
      case 'AF', Token = strtok(Rest, ' ,'); if (Token), Af = str2Double(Token); else Af = 0.0; end; 
                 zSetSurfaceData(ZEMAXSurface, 0, 'EVENASPH'); zSetSurfaceParameter(ZEMAXSurface, 4, Af);
      case 'AG', Token = strtok(Rest, ' ,'); if (Token), Ag = str2Double(Token); else Ag = 0.0; end; 
                 zSetSurfaceData(ZEMAXSurface, 0, 'EVENASPH'); zSetSurfaceParameter(ZEMAXSurface, 5, Ag);
      case 'TH', Token = strtok(Rest, ' ,'); if (Token), Thick = str2Double(Token); else Thick = 0.0; end; zSetSurfaceData(ZEMAXSurface, 3, Thick);
                 if (ZEMAXSurface == 0) % Set the field angles depending on whether object distance is 'infinity'
                     if (Thick >= 1e10)
                       if (FieldType == 1), YObjectAngle = 360.0 * atan(YObjectHeight / Thick) / 6.283185308; FieldType = 0;
                                            XObjectAngle = 360.0 * atan(XObjectHeight / Thick) / 6.283185308; end;    
                     end;
                     switch (FieldType)
                         case 0, FieldPoints = [0, 0, 1; XObjectAngle, YObjectAngle, 1]; zSetFieldMatrix(0, FieldPoints);
                         case 1, FieldPoints = [0, 0, 1; XObjectHeight, YObjectHeight, 1]; zSetFieldMatrix(1, FieldPoints);
                     end;
                 end;
      case 'CLAP',   [Type, Rest] = strtok(Rest, ' ,'); [Token, Rest] = strtok(Rest, ' ,');  % Get all the numerical parameters of the command
                     Parms = [0 0 0 0 0];
                     ParmCount = 0; while (Token), ParmCount = ParmCount + 1; Parms(ParmCount) = str2double(Token); [Token, Rest] = strtok(Rest, ' ,'); end;
                     switch Type
                         case 'RECT', zSetAperture(ZEMAXSurface, 4, Parms(2), Parms(1), Parms(4), Parms(3), '');
                         case 'ELIP', zSetAperture(ZEMAXSurface, 6, Parms(2), Parms(1), Parms(4), Parms(3), '');
                         otherwise  , Aper = zGetAperture(ZEMAXSurface); if (Aper(1)==1), COBSRadius = Aper(2); else COBSRadius = 0; end;
                                      CLAPRadius = str2double(Type); zSetAperture(ZEMAXSurface, 1, COBSRadius, CLAPRadius, Parms(3), Parms(2), '');
                     end;
      case 'COBS',   [Type, Rest] = strtok(Rest, ' ,'); [Token, Rest] = strtok(Rest, ' ,');  % Get all the numerical parameters of the command
                     Parms = [0 0 0 0 0];
                     ParmCount = 0; while (Token), ParmCount = ParmCount + 1; Parms(ParmCount) = str2double(Token); [Token, Rest] = strtok(Rest, ' ,'); end;
                     switch Type
                         case 'RECT', zSetAperture(ZEMAXSurface, 5, Parms(2), Parms(1), Parms(4), Parms(3), '');
                         case 'ELIP', zSetAperture(ZEMAXSurface, 7, Parms(2), Parms(1), Parms(4), Parms(3), '');
                         otherwise  , Aper = zGetAperture(ZEMAXSurface); if (Aper(1)==1), CLAPRadius = Aper(3); else CLAPRadius = 10000; end;
                                      COBSRadius = str2double(Type); zSetAperture(ZEMAXSurface, 1, COBSRadius, CLAPRadius, Parms(3), Parms(2), '');
                     end;
      case 'AIR',    [ZEMAXSurface, ACCOSSurface] = NewSurface(ZEMAXSurface, ACCOSSurface); TiltDec = zeros(1,7);
      case 'SCHOTT', Token = strtok(Rest, ' ,'); 
                     Found = find(strcmp(ACCOSMaterials, Token)); % Look for ZEMAX equivalent
                     if (Found) Glass = ZEMAXMaterials{Found(1)}; else Glass = Token; end; % Take a flyer if not found
                     zSetSurfaceData(ZEMAXSurface, 4, Glass); [ZEMAXSurface, ACCOSSurface] = NewSurface(ZEMAXSurface, ACCOSSurface); TiltDec = zeros(1,7);
      case 'HOYA',   Token = strtok(Rest, ' ,'); 
                     Found = find(strcmp(ACCOSMaterials, Token)); % Look for ZEMAX equivalent
                     if (Found) Glass = ZEMAXMaterials{Found(1)}; else Glass = Token; end; % Take a flyer if not found
                     zSetSurfaceData(ZEMAXSurface, 4, Glass); [ZEMAXSurface, ACCOSSurface] = NewSurface(ZEMAXSurface, ACCOSSurface); TiltDec = zeros(1,7);
      case 'OHARA',  Token = strtok(Rest, ' ,'); 
                     Found = find(strcmp(ACCOSMaterials, Token)); % Look for ZEMAX equivalent
                     if (Found) Glass = ZEMAXMaterials{Found(1)}; else Glass = Token; end; % Take a flyer if not found
                     zSetSurfaceData(ZEMAXSurface, 4, Glass); [ZEMAXSurface, ACCOSSurface] = NewSurface(ZEMAXSurface, ACCOSSurface); TiltDec = zeros(1,7);
      case 'REFL',   Glass = 'MIRROR'; zSetSurfaceData(ZEMAXSurface, 4, Glass); [ZEMAXSurface, ACCOSSurface] = NewSurface(ZEMAXSurface, ACCOSSurface); TiltDec = zeros(1,7);
      case 'GLASS',  [Token, Rest] = strtok(Rest, ' ,'); 
                     if (strcmp(Token, 'MODEL'))
                       [Token, Rest] = strtok(Rest, ' ,'); nd = str2double(Token);
                       [Token, Rest] = strtok(Rest, ' ,'); df = str2double(Token); vd = 50.0; % Need something better here
                       pd = 0.0; % Relative partial dispersion ?
                       zSetSolve(ZEMAXSurface, 2, 1, nd); % This does not work - there is a bug in ZEMAX, therefore we have to arrange a fixup
                       Fixups.ModelGlasses{ZEMAXSurface} = sprintf('GLAS ___BLANK 1 0 %1.20g %1.20g %1.20g 0 0 0 0.0 0.0', nd, vd, pd);
                     else
                        Found = find(strcmp(ACCOSMaterials, Token)); % Look for ZEMAX equivalent
                        if (Found) Glass = ZEMAXMaterials{Found(1)}; else Glass = Token; end;
                        zSetSurfaceData(ZEMAXSurface, 4, Glass);
                     end;
                     [ZEMAXSurface, ACCOSSurface] = NewSurface(ZEMAXSurface, ACCOSSurface); TiltDec = zeros(1,7);
      case 'MATL', Token = strtok(Rest, ' ,'); 
                   Found = find(strcmp(ACCOSMaterials, Token)); % Look for ZEMAX equivalent
                   if (Found) Glass = ZEMAXMaterials{Found(1)}; else Glass = Token; end; % Take a flyer if not found
                   zSetSurfaceData(ZEMAXSurface, 4, Glass);
                   [ZEMAXSurface, ACCOSSurface] = NewSurface(ZEMAXSurface, ACCOSSurface); TiltDec = zeros(1,7);
      case 'ASTOP', Token = strtok(Rest, ' ,'); StopSurface = ZEMAXSurface; LenSys = zsGetSystem; LenSys.stopsurf = StopSurface; zsSetSystem(LenSys);  
      case 'UNITS', Token = strtok(Rest, ' ,'); LenSys = zsGetSystem; 
                    switch Token
                        case 'MM',     LenSys.unitcode = 0;
                        case 'CM',     LenSys.unitcode = 1;
                        case 'INCHES', LenSys.unitcode = 2;
                    end
                    zsSetSystem(LenSys);
      case 'PIKUP', [Type, Rest] = strtok(Rest, ' ,'); [PikupSurf, Rest] = strtok(Rest, ' ,'); ACCOSPikupSurface = str2num(PikupSurf);
                    if (ACCOSPikupSurface < 0), ACCOSPikupSurface = ACCOSSurface + ACCOSPikupSurface; end;
                    ZEMAXPikupSurface = zFindLabel(ACCOSPikupSurface);
                    [ScaleFac, Rest] = strtok(Rest, ' ,'); if (ScaleFac), ScaleFactor = str2num(ScaleFac); else ScaleFactor = 0; end;
                    [Ofset, Rest] = strtok(Rest, ' ,');    if (Ofset),    Offset = str2num(Ofset); else Offset = 0; end;
                    % Debug disp('PIKUP '); disp(Type); disp(PikupSurface); disp(ScaleFactor); disp(Offset);
                    switch Type
                        case 'RD', zSetSolve(ZEMAXSurface, 0, 4, ZEMAXPikupSurface, ScaleFactor);
                        case 'CV', zSetSolve(ZEMAXSurface, 0, 4, ZEMAXPikupSurface, ScaleFactor);
                        case 'CC', zSetSolve(ZEMAXSurface, 4, 2, ZEMAXPikupSurface);
                        case 'AD', zSetSolve(ZEMAXSurface, 6, 2, ZEMAXPikupSurface, Offset, ScaleFactor);
                        case 'AE', zSetSolve(ZEMAXSurface, 7, 2, ZEMAXPikupSurface, Offset, ScaleFactor);
                        case 'AF', zSetSolve(ZEMAXSurface, 8, 2, ZEMAXPikupSurface, Offset, ScaleFactor);
                        case 'AG', zSetSolve(ZEMAXSurface, 9, 2, ZEMAXPikupSurface, Offset, ScaleFactor);                            
                        case 'TH', zSetSolve(ZEMAXSurface, 1, 5, ZEMAXPikupSurface, ScaleFactor, Offset);
                        case 'CLAP', zSetSolve(ZEMAXSurface, 3, 2, ZEMAXPikupSurface);
                        case 'GLASS', zSetSolve(ZEMAXSurface, 2, 2, ZEMAXPikupSurface); [ZEMAXSurface, ACCOSSurface] = NewSurface(ZEMAXSurface, ACCOSSurface); TiltDec = zeros(1,7);
                        case 'XD', if (UseCoordBreaks),
                                     SurfLabel = zGetLabel(ZEMAXSurface - 1); % First get tha label at the previous surface
                                     if (SurfLabel ~= (1000 + ACCOSSurface)), % Then the coordinate break has not yet been inserted
                                       zInsertSurface(ZEMAXSurface); % Put in the coordinate break surface
                                       zSetSurfaceData(ZEMAXSurface, 0, 'COORDBRK'); 
                                       zSetLabel(ZEMAXSurface, 1000+ACCOSSurface);
                                     else
                                         ZEMAXSurface = ZEMAXSurface - 1; % Point to coordinate break for setting of parameters.
                                     end;
                                     ZEMAXPikupSurface = zFindLabel(ACCOSPikupSurface+1000);
                                     if (ZEMAXPikupSurface ~= -1)
                                       zSetSolve(ZEMAXSurface, 5, 2, ZEMAXPikupSurface, Offset, ScaleFactor); else disp(['XD Pikup Ignored at Surface ' num2str(ACCOSSurface)]);
                                     end;
                                     ZEMAXSurface = ZEMAXSurface + 1;                                     
                                   else
                                     disp('XD Pikup Ignored.');
                                   end;
                          case 'YD', if (UseCoordBreaks),
                                     SurfLabel = zGetLabel(ZEMAXSurface - 1); % First get tha label at the previous surface
                                     if (SurfLabel ~= (1000 + ACCOSSurface)), % Then the coordinate break has not yet been inserted
                                       zInsertSurface(ZEMAXSurface); % Put in the coordinate break surface
                                       zSetSurfaceData(ZEMAXSurface, 0, 'COORDBRK'); 
                                       zSetLabel(ZEMAXSurface, 1000+ACCOSSurface);
                                     else
                                         ZEMAXSurface = ZEMAXSurface - 1; % Point to coordinate break for setting of parameters.
                                     end;
                                     ZEMAXPikupSurface = zFindLabel(ACCOSPikupSurface+1000);
                                     if (ZEMAXPikupSurface ~= -1)
                                       zSetSolve(ZEMAXSurface, 6, 2, ZEMAXPikupSurface, Offset, ScaleFactor); else disp(['YD Pikup Ignored at Surface ' num2str(ACCOSSurface)]);
                                     end;
                                     ZEMAXSurface = ZEMAXSurface + 1;                                     
                                   else
                                     disp('YD Pikup Ignored.');
                                   end;
                        case 'ALPHA', if (UseCoordBreaks),
                                     SurfLabel = zGetLabel(ZEMAXSurface - 1); % First get tha label at the previous surface
                                     if (SurfLabel ~= (1000 + ACCOSSurface)), % Then the coordinate break has not yet been inserted
                                       zInsertSurface(ZEMAXSurface); % Put in the coordinate break surface
                                       zSetSurfaceData(ZEMAXSurface, 0, 'COORDBRK'); 
                                       zSetLabel(ZEMAXSurface, 1000+ACCOSSurface);
                                     else
                                         ZEMAXSurface = ZEMAXSurface - 1; % Point to coordinate break for setting of parameters.
                                     end;
                                     ZEMAXPikupSurface = zFindLabel(ACCOSPikupSurface+1000);
                                     if (ZEMAXPikupSurface ~= -1)
                                       zSetSolve(ZEMAXSurface, 7, 2, ZEMAXPikupSurface, Offset, ScaleFactor); else disp(['ALPHA Pikup Ignored at Surface ' num2str(ACCOSSurface)]);
                                     end;
                                     ZEMAXSurface = ZEMAXSurface + 1;                                     
                                   else
                                     disp('ALPHA Pikup Ignored.');
                                   end;
                        case 'BETA', if (UseCoordBreaks),
                                     SurfLabel = zGetLabel(ZEMAXSurface - 1); % First get tha label at the previous surface
                                     if (SurfLabel ~= (1000 + ACCOSSurface)), % Then the coordinate break has not yet been inserted
                                       zInsertSurface(ZEMAXSurface); % Put in the coordinate break surface
                                       zSetSurfaceData(ZEMAXSurface, 0, 'COORDBRK'); 
                                       zSetLabel(ZEMAXSurface, 1000+ACCOSSurface);
                                     else
                                         ZEMAXSurface = ZEMAXSurface - 1; % Point to coordinate break for setting of parameters.
                                     end;
                                     ZEMAXPikupSurface = zFindLabel(ACCOSPikupSurface+1000);
                                     if (ZEMAXPikupSurface ~= -1)
                                       zSetSolve(ZEMAXSurface, 8, 2, ZEMAXPikupSurface, Offset, ScaleFactor); else  disp(['BETA Pikup Ignored at Surface ' num2str(ACCOSSurface)]);
                                     end;
                                     ZEMAXSurface = ZEMAXSurface + 1;                                     
                                   else
                                     disp('BETA Pikup Ignored.');
                                   end;
                         case 'GAMMA', if (UseCoordBreaks),
                                     SurfLabel = zGetLabel(ZEMAXSurface - 1); % First get tha label at the previous surface
                                     if (SurfLabel ~= (1000 + ACCOSSurface)), % Then the coordinate break has not yet been inserted
                                       zInsertSurface(ZEMAXSurface); % Put in the coordinate break surface
                                       zSetSurfaceData(ZEMAXSurface, 0, 'COORDBRK'); 
                                       zSetLabel(ZEMAXSurface, 1000+ACCOSSurface);
                                     else
                                         ZEMAXSurface = ZEMAXSurface - 1; % Point to coordinate break for setting of parameters.
                                     end;
                                     ZEMAXPikupSurface = zFindLabel(ACCOSPikupSurface+1000);
                                     if (ZEMAXPikupSurface ~= -1)
                                       zSetSolve(ZEMAXSurface, 9, 2, ZEMAXPikupSurface, Offset, ScaleFactor); else disp(['GAMMA Pikup Ignored at Surface ' num2str(ACCOSSurface)]);
                                     end;
                                     ZEMAXSurface = ZEMAXSurface + 1;                                     
                                   else
                                     disp('GAMMA Pikup Ignored.');
                                   end;
                                  
                        otherwise, Found = find(strcmp(UnknownPikups, Type));
                                   if (Found)
                                   else
                                     disp(['Unknown PIKUPs of type "' Type '" will be Ignored.']);
                                     UnknownPikups = cat(1, UnknownPikups, {Type});
                                   end;
                    end;
      case 'PY', Token = strtok(Rest, ' ,'); if (Token), RayHeight = str2double(Token); else RayHeight = 0.0; end;
                 zSetSolve(ZEMAXSurface, 1, 2, RayHeight, 0.1, 0);
      case 'WV', NumWaves = 0; Wavelengths = []; [Wv, Rest] = strtok(Rest, ' ,'); 
                 while (Wv), NumWaves = NumWaves + 1; Wavelengths(NumWaves,1) = str2double(Wv); [Wv, Rest] = strtok(Rest, ' ,'); end;
                 Wavelengths = Wavelengths(Wavelengths > 0);
                 zSetWaveMatrix([Wavelengths WaveWeights(1:size(Wavelengths,1),1)]);
      case 'SPTWT', NumWeights = 0; [Weight, Rest] = strtok(Rest, ' ,'); while (Weight), NumWeights = NumWeights + 1; WaveWeights(NumWeights,1) = str2double(Weight); [Weight, Rest] = strtok(Rest, ' ,'); end;
                 zSetWaveMatrix([Wavelengths WaveWeights(1:size(Wavelengths,1),1)]);
      case 'CW', PrimaryWave = str2num(strtok(Rest, ' ,')); zSetPrimaryWave(PrimaryWave);
      case 'CONFIGS', Fixups = ReadOldConfigData(fID, Fixups);
      case 'CONFIG', [Token, Rest] = strtok(Rest, ' ,');
                     if (strcmp(Token, 'OLD')), Fixups = ReadOldConfigData(fID, Fixups);
                     else if (Token), 
                             Config = str2num(Token); Token = strtok(Rest, ' ,'); 
                             if (Token) Surface = str2num(Token); end;
                             Fixups = ReadNewConfigData(fID, Config, Surface, Fixups); 
                          end;
                     end;
      case 'TILT', 
                   [Token, Rest] = strtok(Rest, ' ,'); if (Token), TiltDec(5) = str2double(Token); end; % Alpha
                   [Token, Rest] = strtok(Rest, ' ,'); if (Token), TiltDec(6) = str2double(Token); end; % Beta       
                   [Token, Rest] = strtok(Rest, ' ,'); if (Token), TiltDec(7) = str2double(Token); end; % Gamma 
                   if (UseCoordBreaks),
                     SurfLabel = zGetLabel(ZEMAXSurface - 1); % First get tha label at the previous surface
                     if (SurfLabel ~= (1000 + ACCOSSurface)), % Then the coordinate break has not yet been inserted
                       zInsertSurface(ZEMAXSurface); % Put in the coordinate break surface
                       zSetSurfaceData(ZEMAXSurface, 0, 'COORDBRK'); 
                       zSetLabel(ZEMAXSurface, 1000+ACCOSSurface);
                     else
                         ZEMAXSurface = ZEMAXSurface - 1; % Point to coordinate break for setting of parameters.
                     end;
                     zSetSurfaceParamVector(ZEMAXSurface, [0, TiltDec(3:7), TiltDec(1)]);
                     ZEMAXSurface = ZEMAXSurface + 1;
                   else
                   Fixups.TiltDecBefore{ZEMAXSurface} = sprintf('SCBD 1 %i %i %1.20g %1.20g %1.20g %1.20g %1.20g', TiltDec(1), TiltDec(2), TiltDec(3), TiltDec(4), TiltDec(5), TiltDec(6), TiltDec(7));
                   %Fixups.TiltDecAfter{ZEMAXSurface}  = sprintf('SCBD 2 1 2 %1.20g %1.20g %1.20g %1.20g %1.20g', TiltDec(3), TiltDec(4), TiltDec(5), TiltDec(6), TiltDec(7));
                   end;
      case 'RTILT',
                   TiltDec(1) = 1; % Switch order to Tilts first, then decenters - not sure if this is right 
                   [Token, Rest] = strtok(Rest, ' ,'); if (Token), TiltDec(5) = -str2double(Token); end; % Alpha
                   [Token, Rest] = strtok(Rest, ' ,'); if (Token), TiltDec(6) = -str2double(Token); end; % Beta       
                   [Token, Rest] = strtok(Rest, ' ,'); if (Token), TiltDec(7) = -str2double(Token); end; % Gamma
                   if (UseCoordBreaks),
                     SurfLabel = zGetLabel(ZEMAXSurface - 1); % First get tha label at the previous surface
                     if (SurfLabel ~= (1000 + ACCOSSurface)), % Then the coordinate break has not yet been inserted
                       zInsertSurface(ZEMAXSurface); % Put in the coordinate break surface
                       zSetSurfaceData(ZEMAXSurface, 0, 'COORDBRK'); 
                       zSetLabel(ZEMAXSurface, 1000+ACCOSSurface);
                     else
                         ZEMAXSurface = ZEMAXSurface - 1; % Point to coordinate break for setting of parameters.
                     end;
                     zSetSurfaceParamVector(ZEMAXSurface, [0, TiltDec(3:7), TiltDec(1)]);
                     ZEMAXSurface = ZEMAXSurface + 1;
                   else
                   Fixups.TiltDecBefore{ZEMAXSurface} = sprintf('SCBD 1 %i %i %1.20g %1.20g %1.20g %1.20g %1.20g', TiltDec(1), TiltDec(2), TiltDec(3), TiltDec(4), TiltDec(5), TiltDec(6), TiltDec(7));
                   %Fixups.TiltDecAfter{ZEMAXSurface}  = sprintf('SCBD 2 1 2 %1.20g %1.20g %1.20g %1.20g %1.20g', TiltDec(3), TiltDec(4), TiltDec(5), TiltDec(6), TiltDec(7));
                   end;
%       case 'ALPHA',
%                    [Token, Rest] = strtok(Rest, ' ,'); if (Token), TiltDec(5) = str2double(Token); end; % Alpha
%                    if (UseCoordBreaks),
%                    else
%                    Fixups.TiltDecBefore{ZEMAXSurface} = sprintf('SCBD 1 %i %i %1.20g %1.20g %1.20g %1.20g %1.20g', TiltDec(1), TiltDec(2), TiltDec(3), TiltDec(4), TiltDec(5), TiltDec(6), TiltDec(7));
%                    %Fixups.TiltDecAfter{ZEMAXSurface}  = sprintf('SCBD 2 1 2 %1.20g %1.20g %1.20g %1.20g %1.20g', TiltDec(3), TiltDec(4), TiltDec(5), TiltDec(6), TiltDec(7));
%                    end;
%       case 'BETA', 
%                    [Token, Rest] = strtok(Rest, ' ,'); if (Token), TiltDec(6) = str2double(Token); end; % Beta
%                    if (UseCoordBreaks),
%                    else
%                    Fixups.TiltDecBefore{ZEMAXSurface} = sprintf('SCBD 1 %i %i %1.20g %1.20g %1.20g %1.20g %1.20g', TiltDec(1), TiltDec(2), TiltDec(3), TiltDec(4), TiltDec(5), TiltDec(6), TiltDec(7));
%                    %Fixups.TiltDecAfter{ZEMAXSurface}  = sprintf('SCBD 2 1 2 %1.20g %1.20g %1.20g %1.20g %1.20g', TiltDec(3), TiltDec(4), TiltDec(5), TiltDec(6), TiltDec(7));          
%                    end;
%       case 'GAMMA',
%                    [Token, Rest] = strtok(Rest, ' ,'); if (Token), TiltDec(7) = str2double(Token); end; % Gamma 
%                    if (UseCoordBreaks),
%                    else
%                    Fixups.TiltDecBefore{ZEMAXSurface} = sprintf('SCBD 1 %i %i %1.20g %1.20g %1.20g %1.20g %1.20g', TiltDec(1), TiltDec(2), TiltDec(3), TiltDec(4), TiltDec(5), TiltDec(6), TiltDec(7));
%                    %Fixups.TiltDecAfter{ZEMAXSurface}  = sprintf('SCBD 2 1 2 %1.20g %1.20g %1.20g %1.20g %1.20g', TiltDec(3), TiltDec(4), TiltDec(5), TiltDec(6), TiltDec(7));          
%                    end;
      case 'DEC',  
                   [Token, Rest] = strtok(Rest, ' ,'); if (Token), TiltDec(4) = str2double(Token); end; % y decentre       
                   [Token, Rest] = strtok(Rest, ' ,'); if (Token), TiltDec(3) = str2double(Token); end; % x decentre  
                   if (UseCoordBreaks),
                     SurfLabel = zGetLabel(ZEMAXSurface - 1); % First get tha label at the previous surface
                     if (SurfLabel ~= (1000 + ACCOSSurface)), % Then the coordinate break has not yet been inserted
                       zInsertSurface(ZEMAXSurface); % Put in the coordinate break surface
                       zSetSurfaceData(ZEMAXSurface, 0, 'COORDBRK'); 
                       zSetLabel(ZEMAXSurface, 1000+ACCOSSurface);
                     else
                         ZEMAXSurface = ZEMAXSurface - 1; % Point to coordinate break for setting of parameters.
                     end;
                     zSetSurfaceParamVector(ZEMAXSurface, [0, TiltDec(3:7), TiltDec(1)]);
                     ZEMAXSurface = ZEMAXSurface + 1;
                   else
                   Fixups.TiltDecBefore{ZEMAXSurface} = sprintf('SCBD 1 %i %i %1.20g %1.20g %1.20g %1.20g %1.20g', TiltDec(1), TiltDec(2), TiltDec(3), TiltDec(4), TiltDec(5), TiltDec(6), TiltDec(7));
                   %Fixups.TiltDecAfter{ZEMAXSurface}  = sprintf('SCBD 2 1 2 %1.20g %1.20g %1.20g %1.20g %1.20g', TiltDec(3), TiltDec(4), TiltDec(5), TiltDec(6), TiltDec(7));          
                   end;
%       case 'XD',   
%                    [Token, Rest] = strtok(Rest, ' ,'); if (Token), TiltDec(3) = str2double(Token); end; % x decentre 
%                    if (UseCoordBreaks),
%                    else
%                    Fixups.TiltDecBefore{ZEMAXSurface} = sprintf('SCBD 1 %i %i %1.20g %1.20g %1.20g %1.20g %1.20g', TiltDec(1), TiltDec(2), TiltDec(3), TiltDec(4), TiltDec(5), TiltDec(6), TiltDec(7));
%                    %Fixups.TiltDecAfter{ZEMAXSurface}  = sprintf('SCBD 2 1 2 %1.20g %1.20g %1.20g %1.20g %1.20g', TiltDec(3), TiltDec(4), TiltDec(5), TiltDec(6), TiltDec(7));                    
%                    end;
%       case 'YD',   
%                    [Token, Rest] = strtok(Rest, ' ,'); if (Token), TiltDec(4) = str2double(Token); end; % y decentre 
%                    if (UseCoordBreaks),
%                    else
%                    Fixups.TiltDecBefore{ZEMAXSurface} = sprintf('SCBD 1 %i %i %1.20g %1.20g %1.20g %1.20g %1.20g', TiltDec(1), TiltDec(2), TiltDec(3), TiltDec(4), TiltDec(5), TiltDec(6), TiltDec(7));
%                    %Fixups.TiltDecAfter{ZEMAXSurface}  = sprintf('SCBD 2 1 2 %1.20g %1.20g %1.20g %1.20g %1.20g', TiltDec(3), TiltDec(4), TiltDec(5), TiltDec(6), TiltDec(7));                    
%                    end;
      case 'EOS', DummySurface = zFindLabel(9999); zDeleteSurface(DummySurface);
                  LenSys = zsGetSystem;
                  if (StopSurface == 0), StopSurface = 1; LenSys.stopsurf = StopSurface; zsSetSystem(LenSys); end;
                  % Copy penultimate surface shape to image surface
                  zsSetSurfaceData(LenSys.numsurfs, zsGetSurfaceData(LenSys.numsurfs - 1));
                  % and delete penultimate surface
                  zDeleteSurface(LenSys.numsurfs-1);
      case 'LIB', [Token, Rest] = strtok(Rest, ' ,');
                  if (strcmp(Token, 'PUT'))
                    if (strcmp(LibDumpPath, ''))
                      disp('LIB PUT Requested. Please Select a Suitable Place for the Library Dump.');
                      % LibDumpPath = uigetdir('c:\', 'Select Directory for Library Dump.');      % Won't compile for standalone mode
                      % LibDumpPath = uigetfolder('Select Directory for Library Dump.', 'c:\');   % Compiles, but won't run in standalone mode
                      [DummyFile, LibDumpPath] = uiputfile('Dummy.zmx', 'Navigate to Directory for Lib Dump'); % Use this workaround for the standalone version
                    end;
                    Reply = zPushLens(8);
                    while (Reply == -998) % Timeout on zPushLens
                        Answer = questdlg('ZEMAX is not responding to the Conversion Utility. ZEMAX may be waiting for your input. What would you like to do ?',...
                                          'ZEMAX Unresponsive. What Now ?', 'Continue', 'Abandon', 'Continue');
                        switch Answer
                            case 'Continue', Reply = zPushLens(5);
                            case 'Abandon', Status = -1; return;
                        end;
                    end;
                    Block = strtok(Rest, ' ,');
                    if (LITitle), 
                        CleanTitle = CleanFileName(LITitle);
                        LensFileName = [LibDumpPath '\' CleanTitle ' (Block ' Block ').zmx']; 
                    else LensFileName = ['Block ' Block '.zmx']; 
                    end;
                    zSaveFile([LensFileName '.tmp']);
                    DoFixups(LensFileName, Fixups);
                  end;
                  
      otherwise, Found = find(strcmp(UnknownDirectives, Directive));
                 if (Found)
                 else
                   disp(['Unknown Directives "' Directive '" will be Ignored.']);
                   UnknownDirectives = cat(1, UnknownDirectives, {Directive});
                 end;
    end;
    end;
end;
fclose(fID);

if (LITitle), 
  CleanTitle = CleanFileName(LITitle);
  LensFileName = [LibDumpPath '\' CleanTitle '.zmx']; 
else LensFileName = [LibDumpPath '\Lens.zmx']; 
end;
[FileName, LibDumpPath] = uiputfile(LensFileName, 'Save New ZEMAX Lens'); % Use this workaround for the standalone version
if (FileName)
    LensFileName = fullfile(LibDumpPath, FileName);
end;
Reply = zPushLens(8);
while (Reply == -998) % Timeout on zPushLens
  Answer = questdlg('ZEMAX is not responding to the Conversion Utility. ZEMAX may be waiting for your input. What would you like to do ?',...
                    'ZEMAX Unresponsive. What Now ?', 'Continue', 'Abandon', 'Continue');
  switch Answer
    case 'Continue', Reply = zPushLens(5);
    case 'Abandon', Status = -1; return;
  end;
end;
zSaveFile([LensFileName '.tmp']);
DoFixups(LensFileName, Fixups);
zLoadFile(LensFileName);
zWindowRestore(0);
zPushLens(10);
uiwait(msgbox('Leno File Processing Has Completed.', 'File Processing Completed', 'help', 'non-modal'));
% END OF function ReadACCOSFile
% -----------------------------------------------------------------------------------

function [ZEMAXout,ACCOSout] = NewSurface(ZEMAXin, ACCOSin)
zSetLabel(ZEMAXin, ACCOSin);
ZEMAXout = ZEMAXin + 1; ACCOSout = ACCOSin + 1;
zInsertSurface(ZEMAXout);


function CleanName = CleanFileName(DirtyName)
% Replace Bad characters with alternatives, remove leading and trailing blanks and trailing
% fullstops

BadChars = '/\:*?<>|,"';
AltChars = '#%;+&{}!-`';
DirtyName = deblank(fliplr(deblank(fliplr(DirtyName))));

for i = 1:size(BadChars,2)
    DirtyName(find(DirtyName==BadChars(i))) = AltChars(i);
end;

Len = size(DirtyName,2);
if (DirtyName(Len) == '.'), DirtyName = DirtyName(1:(Len-1)); end;
CleanName = DirtyName;


function Fixups = ReadOldConfigData(fID, InputFixups)
Fixups = InputFixups;
Config = 1;
disp('Processing Old Config Data.')
while 1
  CfgLine = fgetl(fID);
  if ~ischar(CfgLine), return; end; % (Unexpected) End of file
  CfgLine = upper(CfgLine); % Convert to upper case
  [Directive, Rest] = strtok(CfgLine, ' ,'); % Take the directive from the start of the line
  switch Directive
      case 'CFG', [Token, Rest] = strtok(Rest, ' ,'); Config = str2num(Token);
                  Fixups.NumberConfigs = max([Fixups.NumberConfigs, Config]);
      case 'SAY', ApertureData = zGetSystemAper; EPD = ApertureData(3);
                  Fixups.ConfigOperands = Fixups.ConfigOperands + 1;
                  Fixups.ConfigData{Fixups.ConfigOperands} = sprintf('APER 0 1 %1.20g 0', EPD); 
                  [Token, Rest] = strtok(Rest, ' ,'); EPD = 2 * str2double(Token);
                  Fixups.ConfigOperands = Fixups.ConfigOperands + 1;
                  Fixups.ConfigData{Fixups.ConfigOperands} = sprintf('APER 0 %i %1.20g 0',Config, EPD); 
      case 'SCY', [Token, Rest] = strtok(Rest, ' ,');
                  if (strcmp(Token, 'FANG'))
                      Angle = zGetField(2); Angle = Angle(2);
                      Fixups.ConfigOperands = Fixups.ConfigOperands + 1;
                      Fixups.ConfigData{Fixups.ConfigOperands} = sprintf('YFIE 2 1 %1.20g 0', Angle); 
                      [Token, Rest] = strtok(Rest, ' ,');
                      Angle = str2double(Token);
                      Fixups.ConfigOperands = Fixups.ConfigOperands + 1;
                      Fixups.ConfigData{Fixups.ConfigOperands} = sprintf('YFIE 2 %i %1.20g 0', Config, Angle); 
                  end;
      case 'CV', [Token, Rest] = strtok(Rest, ' ,'); ACCOSSurface = str2num(Token); ZEMAXSurface = zFindLabel(ACCOSSurface);
                 Curvature = zGetSurfaceData(ZEMAXSurface, 2);
                 Fixups.ConfigOperands = Fixups.ConfigOperands + 1;
                 Fixups.ConfigData{Fixups.ConfigOperands} = sprintf('CRVT %i 1 %1.20g 0', ZEMAXSurface, Curvature);
                 [Token, Rest] = strtok(Rest, ' ,'); Curvature = str2double(Token);
                 Fixups.ConfigOperands = Fixups.ConfigOperands + 1;
                 Fixups.ConfigData{Fixups.ConfigOperands} = sprintf('CRVT %i %i %1.20g 0', ZEMAXSurface, Config, Curvature);
      case 'CC', [Token, Rest] = strtok(Rest, ' ,'); ACCOSSurface = str2num(Token); ZEMAXSurface = zFindLabel(ACCOSSurface);
                 Conic = zGetSurfaceData(ZEMAXSurface, 6);
                 Fixups.ConfigOperands = Fixups.ConfigOperands + 1;
                 Fixups.ConfigData{Fixups.ConfigOperands} = sprintf('CONN %i 1 %1.20g 0', ZEMAXSurface, Conic);
                 [Token, Rest] = strtok(Rest, ' ,'); Conic = str2double(Token);
                 Fixups.ConfigOperands = Fixups.ConfigOperands + 1;
                 Fixups.ConfigData{Fixups.ConfigOperands} = sprintf('CONN %i %i %1.20g 0', ZEMAXSurface, Config, Conic);
      case 'AD', [Token, Rest] = strtok(Rest, ' ,'); ACCOSSurface = str2num(Token); ZEMAXSurface = zFindLabel(ACCOSSurface);
                 AD = zGetSurfaceParameter(ZEMAXSurface, 2);
                 Fixups.ConfigOperands = Fixups.ConfigOperands + 1;
                 Fixups.ConfigData{Fixups.ConfigOperands} = sprintf('PAR2 %i 1 %1.20g 0', ZEMAXSurface, AD);
                 [Token, Rest] = strtok(Rest, ' ,'); AD = str2double(Token);
                 Fixups.ConfigOperands = Fixups.ConfigOperands + 1;
                 Fixups.ConfigData{Fixups.ConfigOperands} = sprintf('PAR2 %i %i %1.20g 0', ZEMAXSurface, Config, AD);
      case 'AE', [Token, Rest] = strtok(Rest, ' ,'); ACCOSSurface = str2num(Token); ZEMAXSurface = zFindLabel(ACCOSSurface);
                 AE = zGetSurfaceParameter(ZEMAXSurface, 3);
                 Fixups.ConfigOperands = Fixups.ConfigOperands + 1;
                 Fixups.ConfigData{Fixups.ConfigOperands} = sprintf('PAR3 %i 1 %1.20g 0', ZEMAXSurface, AE);
                 [Token, Rest] = strtok(Rest, ' ,'); AE = str2double(Token);
                 Fixups.ConfigOperands = Fixups.ConfigOperands + 1;
                 Fixups.ConfigData{Fixups.ConfigOperands} = sprintf('PAR3 %i %i %1.20g 0', ZEMAXSurface, Config, AE);
      case 'AF', [Token, Rest] = strtok(Rest, ' ,'); ACCOSSurface = str2num(Token); ZEMAXSurface = zFindLabel(ACCOSSurface);
                 AF = zGetSurfaceParameter(ZEMAXSurface, 4);
                 Fixups.ConfigOperands = Fixups.ConfigOperands + 1;
                 Fixups.ConfigData{Fixups.ConfigOperands} = sprintf('PAR4 %i 1 %1.20g 0', ZEMAXSurface, AF);
                 [Token, Rest] = strtok(Rest, ' ,'); AF = str2double(Token);
                 Fixups.ConfigOperands = Fixups.ConfigOperands + 1;
                 Fixups.ConfigData{Fixups.ConfigOperands} = sprintf('PAR4 %i %i %1.20g 0', ZEMAXSurface, Config, AF);
      case 'AG', [Token, Rest] = strtok(Rest, ' ,'); ACCOSSurface = str2num(Token); ZEMAXSurface = zFindLabel(ACCOSSurface);
                 AG = zGetSurfaceParameter(ZEMAXSurface, 2);
                 Fixups.ConfigOperands = Fixups.ConfigOperands + 1;
                 Fixups.ConfigData{Fixups.ConfigOperands} = sprintf('PAR5 %i 1 %1.20g 0', ZEMAXSurface, AG);
                 [Token, Rest] = strtok(Rest, ' ,'); AG = str2double(Token);
                 Fixups.ConfigOperands = Fixups.ConfigOperands + 1;
                 Fixups.ConfigData{Fixups.ConfigOperands} = sprintf('PAR5 %i %i %1.20g 0', ZEMAXSurface, Config, AG);
      case 'TH', [Token, Rest] = strtok(Rest, ' ,'); ACCOSSurface = str2num(Token); ZEMAXSurface = zFindLabel(ACCOSSurface);
                 Thickness = zGetSurfaceData(ZEMAXSurface, 3);
                 Fixups.ConfigOperands = Fixups.ConfigOperands + 1;
                 Fixups.ConfigData{Fixups.ConfigOperands} = sprintf('THIC %i 1 %1.20g 0', ZEMAXSurface, Thickness);
                 [Token, Rest] = strtok(Rest, ' ,'); Thickness = str2double(Token);
                 Fixups.ConfigOperands = Fixups.ConfigOperands + 1;
                 Fixups.ConfigData{Fixups.ConfigOperands} = sprintf('THIC %i %i %1.20g 0', ZEMAXSurface, Config, Thickness);
      case 'EOS', return;
      otherwise, disp(['Config Directive "' Directive '" Ignored.']);
  end;
end;



function Fixups = ReadNewConfigData(fID, Config, ACCOSSurface, InputFixups)
global ACCOSMaterials ZEMAXMaterials
ZEMAXSurface = zFindLabel(ACCOSSurface);
Fixups = InputFixups;
disp('Processing New Config Data.');
while 1
  CfgLine = fgetl(fID);
  if ~ischar(CfgLine), return; end; % (Unexpected) End of file
  CfgLine = upper(CfgLine); % Convert to upper case
  [Directive, Rest] = strtok(CfgLine, ' ,'); % Take the directive from the start of the line
  switch Directive
      case 'CFG', [Token, Rest] = strtok(Rest, ' ,'); Config = str2num(Token);
                  Fixups.NumberConfigs = max([Fixups.NumberConfigs, Config]);
                  [Token, Rest] = strtok(Rest, ' ,'); if (Token), ACCOSSurface = str2num(Token); ZEMAXSurface = zFindLabel(ACCOSSurface); end;
      case 'SAY', ApertureData = zGetSystemAper; EPD = ApertureData(3);
                  Fixups.ConfigOperands = Fixups.ConfigOperands + 1;
                  Fixups.ConfigData{Fixups.ConfigOperands} = sprintf('APER 0 1 %1.20g 0', EPD); 
                  [Token, Rest] = strtok(Rest, ' ,'); EPD = 2 * str2double(Token);
                  Fixups.ConfigOperands = Fixups.ConfigOperands + 1;
                  Fixups.ConfigData{Fixups.ConfigOperands} = sprintf('APER 0 %i %1.20g 0',Config, EPD);                   
      case 'SURF',[Token, Rest] = strtok(Rest, ' ,'); ACCOSSurface = str2num(Token); ZEMAXSurface = zFindLabel(ACCOSSurface);
      case 'SCY', [Token, Rest] = strtok(Rest, ' ,');
                  if (strcmp(Token, 'FANG'))
                      Angle = zGetField(2); Angle = Angle(2);
                      Fixups.ConfigOperands = Fixups.ConfigOperands + 1;
                      Fixups.ConfigData{Fixups.ConfigOperands} = sprintf('YFIE 2 1 %1.20g 0', Angle); 
                      [Token, Rest] = strtok(Rest, ' ,');
                      Angle = str2double(Token);
                      Fixups.ConfigOperands = Fixups.ConfigOperands + 1;
                      Fixups.ConfigData{Fixups.ConfigOperands} = sprintf('YFIE 2 %i %1.20g 0', Config, Angle); 
                  end;  
      case 'WV', [Token, Rest] = strtok(Rest, ' ,'); WaveNumber = 0;
                 while (Token)
                     WaveNumber = WaveNumber + 1;
                     WV = zGetWave(WaveNumber); WV = WV(1);
                     Fixups.ConfigOperands = Fixups.ConfigOperands + 1;
                     Fixups.ConfigData{Fixups.ConfigOperands} = sprintf('WAVE %i 1 %1.20g 0', WaveNumber, WV);
                     WV = str2double(Token);
                     Fixups.ConfigOperands = Fixups.ConfigOperands + 1;
                     Fixups.ConfigData{Fixups.ConfigOperands} = sprintf('WAVE %i %i %1.20g 0', WaveNumber, Config, WV);
                     [Token, Rest] = strtok(Rest, ' ,');
                 end;
     case 'SPTWT',[Token, Rest] = strtok(Rest, ' ,'); WaveNumber = 0;
                 while (Token)
                     WaveNumber = WaveNumber + 1;
                     Weight = zGetWave(WaveNumber); Weight = Weight(2);
                     Fixups.ConfigOperands = Fixups.ConfigOperands + 1;
                     Fixups.ConfigData{Fixups.ConfigOperands} = sprintf('WLWT %i 1 %1.20g 0', WaveNumber, Weight);
                     Weight = str2double(Token);
                     Fixups.ConfigOperands = Fixups.ConfigOperands + 1;
                     Fixups.ConfigData{Fixups.ConfigOperands} = sprintf('WLWT %i %i %1.20g 0', WaveNumber, Config, Weight);
                     [Token, Rest] = strtok(Rest, ' ,');
                 end;
      case 'ASTOP',[Token, Rest] = strtok(Rest, ' ,');
                 ApertureData = zGetSystemAper; StopSurf = ApertureData(2);
                 Fixups.ConfigOperands = Fixups.ConfigOperands + 1;
                 Fixups.ConfigData{Fixups.ConfigOperands} = sprintf('STPS 0 1 %i 0', StopSurf);
                 Fixups.ConfigOperands = Fixups.ConfigOperands + 1;
                 Fixups.ConfigData{Fixups.ConfigOperands} = sprintf('STPS 0 %i %i 0', Config, ZEMAXSurface); 
      case 'CLAP',[Token, Rest] = strtok(Rest, ' ,');
                 Apmx = zGetAperture(ZEMAXSurface); Apmx = Apmx(3);
                 Fixups.ConfigOperands = Fixups.ConfigOperands + 1;
                 Fixups.ConfigData{Fixups.ConfigOperands} = sprintf('APMX %i 1 %1.20g 0', ZEMAXSurface, Apmx);
                 Apmx = str2double(Token);
                 Fixups.ConfigOperands = Fixups.ConfigOperands + 1;
                 Fixups.ConfigData{Fixups.ConfigOperands} = sprintf('APMX %i %i %1.20g 0', ZEMAXSurface, Config, Apmx);
      case 'CLAPD', % Handle CLAPD by setting aperture large 
                 Apmx = zGetAperture(ZEMAXSurface); Apmx = Apmx(3);
                 Fixups.ConfigOperands = Fixups.ConfigOperands + 1;
                 Fixups.ConfigData{Fixups.ConfigOperands} = sprintf('APMX %i 1 %1.20g 0', ZEMAXSurface, Apmx);
                 Apmx = 10000.0;
                 Fixups.ConfigOperands = Fixups.ConfigOperands + 1;
                 Fixups.ConfigData{Fixups.ConfigOperands} = sprintf('APMX %i %i %1.20g 0', ZEMAXSurface, Config, Apmx);
      case 'CV', Curvature = zGetSurfaceData(ZEMAXSurface, 2);
                 Fixups.ConfigOperands = Fixups.ConfigOperands + 1;
                 Fixups.ConfigData{Fixups.ConfigOperands} = sprintf('CRVT %i 1 %1.20g 0', ZEMAXSurface, Curvature);
                 [Token, Rest] = strtok(Rest, ' ,'); Curvature = str2double(Token);
                 Fixups.ConfigOperands = Fixups.ConfigOperands + 1;
                 Fixups.ConfigData{Fixups.ConfigOperands} = sprintf('CRVT %i %i %1.20g 0', ZEMAXSurface, Config, Curvature);
      case 'CC', Conic = zGetSurfaceData(ZEMAXSurface, 6);
                 Fixups.ConfigOperands = Fixups.ConfigOperands + 1;
                 Fixups.ConfigData{Fixups.ConfigOperands} = sprintf('CONN %i 1 %1.20g 0', ZEMAXSurface, Conic);          
                 [Token, Rest] = strtok(Rest, ' ,'); Conic = str2double(Token);
                 Fixups.ConfigOperands = Fixups.ConfigOperands + 1;
                 Fixups.ConfigData{Fixups.ConfigOperands} = sprintf('CONN %i %i %1.20g 0', ZEMAXSurface, Config, Conic);
      case 'AD', AD = zGetSurfaceParameter(ZEMAXSurface, 2);
                 Fixups.ConfigOperands = Fixups.ConfigOperands + 1;
                 Fixups.ConfigData{Fixups.ConfigOperands} = sprintf('PAR2 %i 1 %1.20g 0', ZEMAXSurface, AD);                 
                 [Token, Rest] = strtok(Rest, ' ,'); AD = str2double(Token);
                 Fixups.ConfigOperands = Fixups.ConfigOperands + 1;
                 Fixups.ConfigData{Fixups.ConfigOperands} = sprintf('PAR2 %i %i %1.20g 0', ZEMAXSurface, Config, AD);
      case 'AE', AE = zGetSurfaceParameter(ZEMAXSurface, 3);
                 Fixups.ConfigOperands = Fixups.ConfigOperands + 1;
                 Fixups.ConfigData{Fixups.ConfigOperands} = sprintf('PAR3 %i 1 %1.20g 0', ZEMAXSurface, AE);          
                 [Token, Rest] = strtok(Rest, ' ,'); AE = str2double(Token);
                 Fixups.ConfigOperands = Fixups.ConfigOperands + 1;
                 Fixups.ConfigData{Fixups.ConfigOperands} = sprintf('PAR3 %i %i %1.20g 0', ZEMAXSurface, Config, AE);
      case 'AF', AF = zGetSurfaceParameter(ZEMAXSurface, 4);
                 Fixups.ConfigOperands = Fixups.ConfigOperands + 1;
                 Fixups.ConfigData{Fixups.ConfigOperands} = sprintf('PAR4 %i 1 %1.20g 0', ZEMAXSurface, AF);          
                 [Token, Rest] = strtok(Rest, ' ,'); AF = str2double(Token);
                 Fixups.ConfigOperands = Fixups.ConfigOperands + 1;
                 Fixups.ConfigData{Fixups.ConfigOperands} = sprintf('PAR4 %i %i %1.20g 0', ZEMAXSurface, Config, AF);
      case 'AG', AG = zGetSurfaceParameter(ZEMAXSurface, 2);
                 Fixups.ConfigOperands = Fixups.ConfigOperands + 1;
                 Fixups.ConfigData{Fixups.ConfigOperands} = sprintf('PAR5 %i 1 %1.20g 0', ZEMAXSurface, AG);          
                 [Token, Rest] = strtok(Rest, ' ,'); AG = str2double(Token);
                 Fixups.ConfigOperands = Fixups.ConfigOperands + 1;
                 Fixups.ConfigData{Fixups.ConfigOperands} = sprintf('PAR5 %i %i %1.20g 0', ZEMAXSurface, Config, AG);
      case 'TH', Thickness = zGetSurfaceData(ZEMAXSurface, 3);
                 Fixups.ConfigOperands = Fixups.ConfigOperands + 1;
                 Fixups.ConfigData{Fixups.ConfigOperands} = sprintf('THIC %i 1 %1.20g 0', ZEMAXSurface, Thickness);          
                 [Token, Rest] = strtok(Rest, ' ,'); Thickness = str2double(Token);
                 Fixups.ConfigOperands = Fixups.ConfigOperands + 1;
                 Fixups.ConfigData{Fixups.ConfigOperands} = sprintf('THIC %i %i %1.20g 0', ZEMAXSurface, Config, Thickness); 
      case 'RD', Curvature = zGetSurfaceData(ZEMAXSurface, 2);
                 Fixups.ConfigOperands = Fixups.ConfigOperands + 1;
                 Fixups.ConfigData{Fixups.ConfigOperands} = sprintf('CRVT %i 1 %1.20g 0', ZEMAXSurface, Curvature);          
                 [Token, Rest] = strtok(Rest, ' ,'); Radius = str2double(Token);
                 Fixups.ConfigOperands = Fixups.ConfigOperands + 1;
                 if (Radius ~= 0)
                   Fixups.ConfigData{Fixups.ConfigOperands} = sprintf('CRVT %i %i %1.20g 0', ZEMAXSurface, Config, 1/Radius); 
                 else
                   Fixups.ConfigData{Fixups.ConfigOperands} = sprintf('CRVT %i %i 0.0 0', ZEMAXSurface, Config); 
                 end;
      case {'SCHOTT', 'HOYA', 'OHARA', 'MATL', 'GLASS'},
                 Glass = zGetSurfaceData(ZEMAXSurface, 4);
                 Fixups.ConfigOperands = Fixups.ConfigOperands + 1;
                 Fixups.ConfigData{Fixups.ConfigOperands} = sprintf('GLSS %i 1 %s', ZEMAXSurface, Glass);                
                 Token = strtok(Rest, ' ,'); 
                 Found = find(strcmp(ACCOSMaterials, Token)); % Look for ZEMAX equivalent
                 if (Found) Glass = ZEMAXMaterials{Found(1)}; else Glass = Token; end; % Take a flyer if not found
                 Fixups.ConfigOperands = Fixups.ConfigOperands + 1;
                 Fixups.ConfigData{Fixups.ConfigOperands} = sprintf('GLSS %i %i %s', ZEMAXSurface, Config, Glass); 
      case 'REFL',
                 Glass = zGetSurfaceData(ZEMAXSurface, 4);
                 Fixups.ConfigOperands = Fixups.ConfigOperands + 1;
                 Fixups.ConfigData{Fixups.ConfigOperands} = sprintf('GLSS %i 1 %s', ZEMAXSurface, Glass); 
                 Fixups.ConfigOperands = Fixups.ConfigOperands + 1;
                 Fixups.ConfigData{Fixups.ConfigOperands} = sprintf('GLSS %i %i MIRROR', ZEMAXSurface, Config); 
      case 'AIR', 
                 Glass = zGetSurfaceData(ZEMAXSurface, 4);
                 Fixups.ConfigOperands = Fixups.ConfigOperands + 1;
                 Fixups.ConfigData{Fixups.ConfigOperands} = sprintf('GLSS %i 1 %s', ZEMAXSurface, Glass); 
                 Fixups.ConfigOperands = Fixups.ConfigOperands + 1;
                 Fixups.ConfigData{Fixups.ConfigOperands} = sprintf('GLSS %i %i', ZEMAXSurface, Config); 
      case 'EOS', return;
      otherwise, disp(['Config Directive "' Directive '" Ignored.']);
  end;
end;


function DoFixups(LensFileName, Fixups)
% In this function a number of touchups are performed directly on the .zmx file created with
% zSaveFile above. This is mandatory because certain things cannot currently be done through the
% ZEMAX DDE server. There are also some bugs requiring workarounds eg. model glasses.
% disp(['Doing fixups on ' LensFileName]);
fin = fopen([LensFileName '.tmp'], 'rt'); % This is the file needing fixups
fout = fopen(LensFileName, 'wt'); % This is name of the touched up file.
while 1
    LenLine = fgetl(fin);
    if ~ischar(LenLine), break, end; % End of file
    LenLine = upper(LenLine); % Convert to upper case
    [Directive, Rest] = strtok(LenLine, ' ,'); % Take the directive from the start of the line
    if (Directive)
      switch Directive
        case 'NAME', fprintf(fout, 'NAME %s\n', Fixups.Title);    % Put in the real title
        case 'NOTE', NoteNumber = str2num(strtok(Rest, ' '));
                     if (NoteNumber <= size(Fixups.Comments,2))
                         fprintf(fout, 'NOTE %1i %s\n', NoteNumber, Fixups.Comments{NoteNumber});
                     else
                         fprintf(fout, '%s\n', LenLine);
                     end;
        case 'SURF', SurfNumber = str2num(strtok(Rest, ' ')); fprintf(fout, '%s\n', LenLine);
                     if (SurfNumber > 0)&(SurfNumber <= size(Fixups.TiltDecBefore,2)),
                       if (Fixups.TiltDecBefore{SurfNumber}),
                         fprintf(fout, '  %s\n', Fixups.TiltDecBefore{SurfNumber});
                         %fprintf(fout, '  %s\n', Fixups.TiltDecAfter{SurfNumber});                         
                       end;
                     end;
        case 'GLAS', if (SurfNumber > 0)&(SurfNumber <= size(Fixups.ModelGlasses,2)),  % Here we patch the model glasses just a little
                       if (Fixups.ModelGlasses{SurfNumber}),
                           fprintf(fout, '  %s\n', Fixups.ModelGlasses{SurfNumber});
                       else
                           fprintf(fout, '%s\n', LenLine);
                       end;
                     else
                       fprintf(fout, '%s\n', LenLine);
                     end;
        case 'MNUM', if (Fixups.NumberConfigs > 1),
                       fprintf(fout, 'MNUM %i\n', Fixups.NumberConfigs);
                       if (Fixups.ConfigOperands > 0)
                         Fixups.ConfigData = sort(Fixups.ConfigData); % Sort the data before writing into the ZEMAX file
                         fprintf(fout, '%s\n', Fixups.ConfigData{1});
                         if (Fixups.ConfigOperands > 1),
                           for i = 2:Fixups.ConfigOperands,
                             if (~strcmp(Fixups.ConfigData{i}, Fixups.ConfigData{i-1})), % Avoid writing duplicate lines
                               fprintf(fout, '%s\n', Fixups.ConfigData{i});
                             end;
                           end;
                         end;
                       end;
                     end;
        case 'MOFF', % Write nothing
        otherwise,   fprintf(fout, '%s\n', LenLine);
      end;
    end;
end;
fclose(fin);
fclose(fout);
delete([LensFileName '.tmp']);

