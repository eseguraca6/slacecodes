function S = WriteSMARTSInput(S, Filename)
% WriteSMARTSInput : Write the input text file for SMARTS 2.9.5 from a card structure
%
% SMARTS is the Simple Model of the Atmospheric Radiative Transfer of
% Sunshine, available at http://www.nrel.gov/rredc/smarts/
% SMARTS Author : Christian A. Gueymard
%
% Usage :
%   >> WriteSMARTSInput(SMARTStruct, Filename)
%   >> WriteSMARTSInput(SMARTStruct)  % Opens a file dialog
% 
% Where :
%  Filename is the full path and filename of the SMARTS input text file to write.
%  SMARTSruct is a structure containing the input parameters named
%    in a hierarchy as given in the SMARTS 2.9.5 user manual.
% The data for card 1 is in SMARTStruct.C1 and so forth.
% The comment is to be in the field Comment field if desired.
%
% This SMARTS input file writer does some basic parameter checking, and
% will issues warnings where there appear to be problems with the input
% file. This checking is by no means exhaustive. In most cases a simple
% range check is performed.
%
% Examples :
% >> S = WriteSMARTSInput(SMARTStruct, 'C:\SMARTS\smarts295.inp.txt')
%
% >> S = WriteSMARTSInput(SMARTStruct); % Opens a file dialog
%
% See Also : ReadSMARTSInput, DisplaySMARTSInput, CheckSMARTSInput,
%   TweakSMARTSInput, RunSMARTS, ReadSMARTSOutput, PlotSMARTSOutput

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

persistent SMARTSRoot % Root directory of the SMARTS installation

if isempty(SMARTSRoot)
  SMARTSRootFile = [fileparts(which('RunSMARTS')) '\SMARTSRoot.mat'];
  if exist(SMARTSRootFile, 'file')
      load(SMARTSRootFile)
  else
      SMARTSRoot = SetSMARTSRoot;
  end
end

if ~exist('S', 'var') || ~isstruct(S) || ~isscalar(S)
    error('Missing SMARTS input scalar card structure parameter "SMARTStruct".')
end

%% Check existence of output file and open
if ~exist('Filename', 'var') || isempty(Filename)
    % Use dialog
    [Filename, Pathname] = uiputfile({'*.inp.txt';'*.txt';'*.*'},'SMARTS Input File Selector', [SMARTSRoot 'smarts295.inp.txt']);
    if Filename
      Filename = [Pathname Filename];
    else
        S = [];
        return;
    end
end

if exist(Filename, 'file')
% Perhaps ask user for permission to overwite ?
end


S.fid = fopen(Filename, 'wt');
S.Line = 0;
S.Filename = Filename;

%% Card 1 : Comment describing the file
S = pC(S, 'C1', {'COMNT'}, '%s', 1); % Comment


%% Card 2 : Site atmospheric pressure option
S = pC(S, 'C2', {'ISPR'}, '%g ', 1);  % Site Pressure Option
switch S.C2.ISPR
    case 0, S = pC(S, 'C2a', {'SPR'}, '%g ', 1); RangeCheck(S, 'C2a', 'SPR', 0.0004, Inf);
    case 1, S = pC(S, 'C2a', {'SPR', 'ALTIT', 'HEIGHT'}, '%g %g %g ', 1);
        RangeCheck(S, 'C2a', 'SPR', 0.0004, Inf);
        RangeCheck(S, 'C2a', 'ALTIT', 0, 100);
        RangeCheck(S, 'C2a', 'HEIGHT', 0, 100);
        if (S.C2a.ALTIT + S.C2a.HEIGHT) > 100
            warning('WriteSMARTS:HEIGHTuBound', ['ALTIT + HEIGHT should be less than 100 km' atPlace(S, 'C2a')]);
        end
    case 2, S = pC(S, 'C2a', {'LATIT', 'ALTIT', 'HEIGHT'}, '%g %g %g ', 1);
        RangeCheck(S, 'C2a', 'LATIT', -90, 90);
        RangeCheck(S, 'C2a', 'ALTIT', 0, 100);
        RangeCheck(S, 'C2a', 'HEIGHT', 0, 100);
        if (S.C2a.ALTIT + S.C2a.HEIGHT) > 100
            warning('WriteSMARTS:HEIGHTuBound', ['ALTIT + HEIGHT should be less than 100 km' atPlace(S, 'C2a')]);
        end        
    otherwise
        warning('WriteSMARTS:UnknownISPR', ['Unknown site pressure option ISPR = ' num2str(S.C2.ISPR) ...
            atPlace(S, 'C2')]);
end

%% Card 3 : Atmospheric defaults
S = pC(S, 'C3', {'IATMOS'}, '%g ', 1); % Selection of defaults for the atmosphere
switch S.C3.IATMOS
    case 0, S = pC(S, 'C3a', {'TAIR', 'RH', 'SEASON', 'TDAY'}, '%g %g %s %g ', 1);
        RangeCheck(S, 'C3a', 'TAIR', -120, 50); % Air temperature
        RangeCheck(S, 'C3a', 'RH', 0 ,100); % Relative humidity
        if ~any(strcmp(S.C3a.SEASON, {'WINTER', 'SUMMER'}))
            warning('WriteSMARTS:UnknownSEASON', ['Unknown SEASON = ' S.C3a.SEASON ...
                ' given on Card C3a at Line ' num2str(S.C3a.Line)]);
        end
        RangeCheck(S, 'C3a', 'TDAY', -120, 50);
    case 1, S = pC(S, 'C3a', {'ATMOS'}, '%s', 1);
        if ~any(strcmp(S.C3a.ATMOS, {'USSA','MLS','MLW','SAS','SAW','TRL','STS','STW','AS','AW'}))
            warning('WriteSMARTS:UnknownATMOS', ['Unknown atmosphere ATMOS = ' S.C3a.ATMOS ...
                ' on Card C3a at Line ' num2str(S.C3a.Line)]);
        end
    otherwise
      warning('WriteSMARTS:UnknownIATMOS', ['Unknown atmospheric defaults option IATMOS = ' num2str(S.C3.IATMOS) ...
          ' value on Card 3 at Line ' num2str(S.C3.Line)]);
end

%% Card 4 : Water vapour
S = pC(S, 'C4', {'IH2O'}, '%g ', 1);
switch S.C4.IH2O
    case 0, S = pC(S, 'C4a', {'W'}, '%g ', 1);
        RangeCheck(S, 'C4a', 'W', 0, 12); % Precipitable water
    case 1, 
        if S.C3.IATMOS == 0
            warning('WriteSMARTS:UnknownIH2O',['Water vapour option IH2O = ' num2str(S.C4.IH2O) ...
              ' not valid for IATMOS = 0 ' atPlace(S,'C4') ]);
        end
    case 2
    otherwise
        warning('WriteSMARTS:UnknownIH2O', ['Unknown water vapour option IH2O = ' num2str(S.C4.IH2O) atPlace(S, 'C4')]);
end

%% Card 5 : Ozone
S = pC(S, 'C5', {'IO3'}, '%g ', 1);
switch S.C5.IO3
    case 0, S = pC(S, 'C5a', {'IALT', 'AbO3'}, '%g %g ', 1);
    case 1, 
        if S.C3.IATMOS == 0
            warning('WriteSMARTS:UnknownIO3',['Ozone option IO3 = ' num2str(S.C5a.IO3) ...
              ' not valid for IATMOS = 0 ' atPlace(S,'C5a') ]);
        end
        
    otherwise
        warning('WriteSMARTS:UnknownIO3', ['Unknown ozone option IO3 = ' num2str(S.C5.IO3) ' value ' atPlace(S,'C5')]);
end

%% Card 6 : Gaseous absorption and pollution
S = pC(S, 'C6', {'IGAS'}, '%g ', 1);
switch S.C6.IGAS
    case 0, S = pC(S, 'C6a', {'ILOAD'}, '%g ', 1);
            if S.C6a.ILOAD < 0 || S.C6a.ILOAD > 4 || round(S.C6a.ILOAD) ~= S.C6a.ILOAD
                warning('WriteSMARTS:UnknownILOAD', ['Tropospheric pollution option ILOAD = ' S.C6a.ILOAD ...
                         ' out of integer range 0 to 4 on Card 6a at Line ' num2str(S.C6a.Line)]);
            end
            if S.C6a.ILOAD == 0
                S = pC(S, 'C6b', {'ApCH2O','ApCH4','ApCO','ApHNO2','ApHNO3','ApNO','ApNO2','ApNO3','ApO3','ApSO2'}, ...
                                  '%g %g %g %g %g %g %g %g %g %g ', 1);
            end
            % Rangechecks ?
    case 1, 
        if S.C3.IATMOS == 0
            warning('WriteSMARTS:UnknownIGAS',['Tropospheric pollutants option IGAS = ' num2str(S.C6.IGAS) ...
              ' not valid for IATMOS = 0 ' atPlace(S,'C6') ]);
        end
        
    otherwise
        warning('WriteSMARTS:UnknownIGAS',['Unknown gas/pollutants option IGAS = ' S.C6.IGAS ' value ' atPlace(S, 'C6')]);
end

%% Card 7 : Carbon dioxide concentration
S = pC(S, 'C7', {'qCO2'}, '%g ', 1);
RangeCheck(S, 'C7', 'qCO2', 0, Inf);

%% Card 7a : Extraterrestrial solar spectrum
S = pC(S, 'C7a', {'ISPCTR'}, '%g ', 1);
if S.C7a.ISPCTR < -1 || S.C7a.ISPCTR > 8 || round(S.C7a.ISPCTR) ~= S.C7a.ISPCTR 
    warning('WriteSMARTS:UnknownISPCTR',['Unknown extraterrestrial spectrum option ISPCTR = ' S.C7a.ISPCTR  ...
             ' is out of integer range -1 to 8 ' atPlace(S, 'C7a')]);
end


%% Card 8 : Aerosol model
S = pC(S, 'C8', {'AEROS'}, '%s', 1); % Aerosol Type
switch S.C8.AEROS
    case 'USER', S = pC(S, 'C8a', {'ALPHA1','ALPHA2','OMEGL','GG'}, '%g %g %g %g ', 1); 
    case {'S&F_RURAL','S&F_URBAN','S&F_MARIT','S&F_TROPO','SRA_CONTL','SRA_URBAN', ...
          'SRA_MARIT','B&D_C','B&D_C1','DESERT_MIN','DESERT_MAX'}
    otherwise
        warning('WriteSMARTS:UnknownAEROS',['Unknown aerosol type ' S.C8.AEROS atPlace(S,'C8')]);
end

%% Card 9 : Turbidity/aerosol optical depth
S = pC(S, 'C9', {'ITURB'}, '%g ', 1); % Turbidity/Aerosol Optical Depth
switch S.C9.ITURB
    case 0, S = pC(S, 'C9a', {'TAU5'}, '%g ', 1); RangeCheck(S, 'C9a', 'TAU5', 0, Inf);
    case 1, S = pC(S, 'C9a', {'BETA'}, '%g ', 1); RangeCheck(S, 'C9a', 'BETA', 0, Inf);
    case 2, S = pC(S, 'C9a', {'BCHUEP'}, '%g ', 1); RangeCheck(S, 'C9a', 'BCHUEP', 0, Inf);
    case 3, S = pC(S, 'C9a', {'RANGE'}, '%g ', 1); RangeCheck(S, 'C9a', 'RANGE', 0, 999);
    case 4, S = pC(S, 'C9a', {'VISI'}, '%g ', 1); RangeCheck(S, 'C9a', 'VISI', 0.77, 764);
    case 5, S = pC(S, 'C9a', {'TAU550'}, '%g ', 1); RangeCheck(S, 'C9a', 'TAU550', 0, Inf);
    otherwise
        warning('WriteSMARTS:UnknownITURB', ['Unknown turbidity option ITURB = ' num2str(S.C9.ITURB) atPlace(S,'C9')]);
end

%% Card 10 : Zonal ground surface albedo
S = pC(S, 'C10', {'IALBDX'}, '%g ', 1); % Ground surface albedo option
switch S.C10.IALBDX
    case -1, S = pC(S, 'C10a', {'RHOX'}, '%g ', 1); % Fixed broadband albedo
        RangeCheck(S, 'C10a', 'RHOX', 0, 1);
    case 0 % Read user-defined spectral albedo from Albedo.dat (lambertian)
    case 1 % Read user-defined spectral albedo from Albedo.dat (non-lambertian)
    case 2 % Spectral, non-lambertian reflectance for water computed at runtime
    otherwise
        if S.C10.IALBDX < -1 || S.C10.IALBDX > 66
          warning('WriteSMARTS:UnknownIALBDX',['Unknown zonal albedo option IALBDX = ' num2str(S.C10.IALBDX) ...
              atPlace(S,'C10')]);
        else % Use pre-defined material albedo as per list in documentation
        end
end


%% Card 10b : Tilted surface calculation
S = pC(S, 'C10b', {'ITILT'}, '%g ', 1); % Tilted surface calculation option
switch S.C10b.ITILT
    case 0 % Bypass calculation for tilted receiver surface
    case 1, S = pC(S, 'C10c', {'IALBDG','TILT','WAZIM'}, '%g %g %g ', 1); % Get parameters of tilted surface
        switch S.C10c.IALBDG % Check IALBDG flag for foreground local albedo near receiver surface
            case -1, S = pC(S, 'C10d', {'RHOG'}, '%g ', 1); % Fixed broadband albedo
                RangeCheck(S, 'C10d', 'RHOG', 0, 1);
            case 0 % Read user-defined spectral albedo from Albedo.dat (lambertian)
            case 1 % Read user-defined spectral albedo from Albedo.dat (non-lambertian)
            case 2 % Spectral, non-lambertian reflectance for water computed at runtime
            otherwise
                if S.C10c.IALBDG < -1 || S.C10c.IALBDG > 66
                  warning('WriteSMARTS:UnknownIALBDG',['Unknown foreground albedo option IALBDG = ' num2str(S.C10c.IALBDG) ...
                           ' on Card 10d at Line ' num2str(S.C10c.Line)]);
                else % Use pre-defined material albedo as per list in documentation
                end
        end
        if S.C10c.TILT < 0 || S.C10c.TILT > 90
            if S.C10c.TILT ~= -999; % sun tracking option
              warning('WriteSMARTS:TILTbound',['Receiver tilt angle TILT = ' num2str(S.C10c.TILT) ...
                       ' out of range (0 - 90 deg)' atPlace(S,'C10c')]);
            end
        end
        if S.C10c.WAZIM < 0 || S.C10c.WAZIM > 360
            if S.C10c.WAZIM ~= -999; % Sun tracking option
              warning('WriteSMARTS:WAZIMbound',['Receiver azimuth angle WAZIM = ' num2str(S.C10c.WAZIM)  ...
                       ' out of range (0 - 360 deg.)' atPlace(S,'C10c')]);
            end
        end
        
    otherwise
        warning('WriteSMARTS:UnknownITILT',['Unknown receiver tilt option ITILT = ' num2str(S.C10b.ITILT) atPlace(S, 'C10b')])
end

%% Card 11 : Spectral range, sun irradiance correction and solar constant
S = pC(S, 'C11', {'WLMN','WLMX','SUNCOR','SOLARC'}, '%g %g %g %g ', 1);
RangeCheck(S, 'C11', 'WLMN', 280, 4000);
RangeCheck(S, 'C11', 'WLMX', 280, 4000);
if S.C11.WLMX <= S.C11.WLMN
    warning('WriteSMARTS:WLBotch',['Maximum wavelength WLMX = ' num2str(S.C11.WLMX) ' is less than or equal to WLMN  = ' num2str(S.C11.WLMN) ...
             atPlace(S, 'C11')]);    
end

%% Card 12 : Select results to be printed
S = pC(S, 'C12', {'IPRT'}, '%g ', 1);
if S.C12.IPRT < 0 || S.C12.IPRT > 3 || round(S.C12.IPRT) ~= S.C12.IPRT
    warning('WriteSMARTS:UnknownIPRT',['Print output option IPRT = ' num2str(S.C12.IPRT) ...
             ' is out of integer range (0,1,2 or 3)' atPlace(S,'C12')]);
end
% Card 12 a : Print wavelength range
if S.C12.IPRT >= 1
    S = pC(S, 'C12a', {'WPMN','WPMX','INTVL'}, '%g %g %g ', 1); % Range of wavelengths to print
    if S.C12a.WPMN < S.C11.WLMN
        warning('WriteSMARTS:WPBotch',['Wavelength print range lower boundary WPMN = ' num2str(S.C12a.WPMN) ...
            ' must be greater than calculation range WLMN = ' num2str(S.C11.WLMN) atPlace(S,'C12a')]);
    end
    if S.C12a.WPMX > S.C11.WLMX
        warning('WriteSMARTS:WPBotch',['Wavelength print range upper boundary WPMX = ' num2str(S.C12a.WPMX) ...
            ' must be less than calculation range WLMX = ' num2str(S.C11.WLMX) atPlace(S,'C12a')]);

    end
    RangeCheck(S, 'C12a', 'INTVL', 0.5, Inf);
end
% Card 12b : Total number of variables to print
if S.C12.IPRT == 2 || S.C12.IPRT == 3
  S = pC(S, 'C12b', {'IOTOT'}, '%g ', 1);
  if S.C12b.IOTOT < 1 || S.C12b.IOTOT > 43 || round(S.C12b.IOTOT) ~= S.C12b.IOTOT
      warning('WriteSMARTS:IOTOTbound',['Number of output variables IOTOT = ' num2str(S.C12b.IOTOT) ...
          ' out of integer range (1 - 43)' atPlace(S,'C12b')]);
  end
  S = pC(S, 'C12c', {'IOUT'}, '%g ', S.C12b.IOTOT);
  if length(S.C12c.IOUT) ~= S.C12b.IOTOT
      warning('WriteSMARTS:IOTOTbad', ['Number of variable codes given, length(IOUT) = ' num2str(length(S.C12c.IOUT)) ...
          ' does not correspond to IOTOT = ' num2str(S.C12b.IOTOT) atPlace(S, 'C12c')]);
  end
end

%% Card 13 : Calculation of circumsolar radiation for radiometer geometry
S = pC(S, 'C13', {'ICIRC'}, '%g ', 1);
switch S.C13.ICIRC
    case 0 % Bypass circumsolar radiation calculation
    case 1, S = pC(S, 'C13a', {'SLOPE', 'APERT', 'LIMIT'}, '%g %g %g ', 1);
        RangeCheck(S, 'C13a', 'SLOPE', 0, 10);
        RangeCheck(S, 'C13a', 'APERT', 0, 10);
        RangeCheck(S, 'C13a', 'LIMIT', 0, 10);
        % Need to consider other integrity checks here
        
    otherwise
        warning('WriteSMARTS:UnknownICIRC',['Unknown circumsolar calculation option ICIRC = ' num2str(S.C13.ICIRC) ...
            atPlace(S, 'C13')]);
end

%% Card 14 : Output scanning/smoothing function (convolution)
S = pC(S, 'C14', {'ISCAN'}, '%g ', 1);
switch S.C14.ISCAN
    case 0 % Bypass computation of convolved output (smarts295.scn.txt)
    case 1, S = pC(S, 'C14a', {'IFILT','WV1','WV2','STEP','FWHM'}, '%g %g %g %g %g ', 1);
        if S.C14a.IFILT < 0 || S.C14a.IFILT > 1 || round(S.C14a.IFILT) ~= S.C14a.IFILT
          warning('WriteSMARTS:UnknownIFILT',['Unknown filter option IFILT = ' num2str(S.C14a.IFILT) ...
              atPlace(S, 'C14a')]);
        end
        if S.C14a.WV1 <= S.C11.WLMN + S.C14a.FWHM
            warning('WriteSMARTS:WV1bound',['Filtering/convolution start wavelength WV1 = ' num2str(S.C14a.WV1) ...
                ' out of bounds' atPlace(S, 'C14a')]);
        end
        if S.C14a.WV2 >= S.C11.WLMX - S.C14a.FWHM
            warning('WriteSMARTS:WV2bound',['Filtering/convolution end wavelength WV2 = ' num2str(S.C14a.WV1) ...
                ' out of bounds' atPlace(S, 'C14a')]);
        end
        RangeCheck(S, 'C14a', 'STEP', 0, Inf);
        RangeCheck(S, 'C14a', 'FWHM', 0, Inf);
    otherwise
        warning('WriteSMARTS:UnknownISCAN',['Unknown filtered (convolved) option ISCAN = ' num2str(S.C14.ISCAN) atPlace(S, 'C14')]);
end

%% Card 15 : Option for calculation of illuminance and PAR
S = pC(S, 'C15', {'ILLUM'}, '%g ', 1);
switch S.C15.ILLUM
    case -2 % Use CIE 1988 V(Lambda) curve from VMLambda.dat
    case -1 % Use CIE 1924 photopic V(lambda) curve from VLambda.dat, override WVML and WVMX
    case  0 % Bypass photometry and PAR
    case  1 % Use CIE 1924 photopic V(lambda) curve from VLambda.dat, 
    case  2 % Add luminous efficacy calculation, Use CIE 1988 VMLambda.dat
    otherwise
        warning('WriteSMARTS:UnknownILLUM',['Unknown lluminance calculation option ILLUM = ' num2str(S.C15.ILLUM) ...
            atPlace(S, 'C15')]);
end

%% Card 16 : Special UV calculations
S = pC(S, 'C16', {'IUV'}, '%g ', 1);
switch S.C16.IUV
    case 0 % Bypass 
    case 1 % Compute UVA, UVB, UV index
    otherwise
        warning('WriteSMARTS:UnknownIUV',['Unknown special UV calculation option IUV = ' num2str(S.C16.IUV) ...
            atPlace(S, 'C16')]);
end

%% Card 17 : Airmass calculation options
S = pC(S, 'C17', {'IMASS'}, '%g ', 1);
switch S.C17.IMASS
    case 0, S = pC(S, 'C17a', {'ZENIT','AZIM'}, '%g %g ', 0, 'commentStyle', '!');
        RangeCheck(S, 'C17a', 'ZENIT', 0, 90);
        RangeCheck(S, 'C17a', 'AZIM', 0, 360);
    case 1, S = pC(S, 'C17a', {'ELEV','AZIM'}, '%g %g ', 0, 'commentStyle', '!');
        RangeCheck(S, 'C17a', 'ELEV', 0, 90);
        RangeCheck(S, 'C17a', 'AZIM', 0, 360);
    case 2, S = pC(S, 'C17a', {'AMASS'}, '%g ', 0, 'commentStyle', '!');
        RangeCheck(S, 'C17a', 'AMASS', 1, 38.2);
    case 3, S = pC(S, 'C17a', {'YEAR','MONTH','DAY','HOUR','LATIT','LONGIT','ZONE'}, '%g %g %g %g %g %g %g ',0, 'commentStyle', '!');
        iRangeCheck(S,'C17a', 'YEAR', 1000, 3000);
        iRangeCheck(S,'C17a', 'MONTH', 1, 12);
        iRangeCheck(S,'C17a', 'DAY', 1, 31);
        RangeCheck(S, 'C17a', 'HOUR', 0, 24);
        RangeCheck(S, 'C17a', 'LATIT', -90, 90);
        RangeCheck(S, 'C17a', 'LONGIT', -180, 180);
        RangeCheck(S, 'C17a', 'ZONE', -12, 12);
    case 4, S = pC(S, 'C17a', {'MONTH','LATIT','DSTEP'}, '%g %g %g ', 0, 'commentStyle', '!');
        iRangeCheck(S,'C17a', 'MONTH', 1, 12);
        RangeCheck(S, 'C17a', 'LATIT', -90, 90);
        if any(60/S.C17a.DSTEP ~= round(60/S.C17a.DSTEP))
            warning('WriteSMARTS:DSTEPval', ['Integration interval DSTEP = ' num2str(S.C17a.DSTEP) ...
                ' should divide into 60 an integral number of times' atPlace(S, 'C17a')]);
        end
    otherwise
        warning('WriteSMARTS:UnknownIMASS',['Unknown airmass calculation option IMASS = ' num2str(S.C17.IMASS) ...
            atPlace(S, 'C17')]);
end

fclose(S.fid);
S = rmfield(S,'fid');
S = rmfield(S,'Line'); % Line number tracker
return;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Local Function to write a card
function Si = pC(Si, Card, Fields, Format, N, varargin)

% Check that the card exists in the structure
if ~isfield(Si, Card)
  error('WriteSMARTS:missingcard', ['SMARTS input Card ' Card(2:end) ...
      ' is missing while writing file\r' Si.Filename]);
end
Args = {};
CommentPos = 70;
% Assemble the fprintf arguments
Si.Line = Si.Line + 1; % Count lines as they are written
Fieldnames = '';
Fieldrows = []; % Gets the number of rows in the field
for iField = 1:length(Fields)
  if isfield(Si.(Card), Fields{iField})
      Fieldrows(iField) = size(Si.(Card).(Fields{iField}), 1); % Number of rows in the field
      if ischar(Si.(Card).(Fields{iField}))
        Args{iField} = ['''' Si.(Card).(Fields{iField}) '''']; % Put single quotes back  
      else
        Args{iField} = Si.(Card).(Fields{iField})(1,:);
      end
      Fieldnames = [Fieldnames ' ' Fields{iField}]; % Compile a string containing the field names
  else
      warning('WriteSMARTS:missingvar', ['SMARTS variable ' Fields{iField} ' is missing on Card ' Card(2:end) ...
          ' while writing file\r' strrep(Si.Filename, '\', '/')]);
  end
end
% Write to a string first
Line = sprintf(Format, Args{:});
% Add on the comment if it is there
if ~isfield(Si.(Card), 'Comment') || isempty(Si.(Card).Comment)
    Comment = sprintf('!Card %-3s on Line %03i, Variables :%s', Card(2:end), Si.Line, Fieldnames);
    Line = [Line blanks(max(5, CommentPos - length(Line))) Comment]; %blanks(max(5, CommentPos - length(Line)))
else
    % Need to decide where to put the comment in
    Line = [Line blanks(max(5, CommentPos - length(Line))) '! ' Si.(Card).Comment];
end
fprintf(Si.fid, ['%s\n'], Line); % Write out the main (commented) line
if all(Fieldrows == Fieldrows(1))
    for iRow = 2:Fieldrows(1) % Write the remaining data
        C17aArgs = {};
        for iField = 1:length(Fields)
            C17aArgs{iField} = Si.(Card).(Fields{iField})(iRow,1);
        end
        fprintf(Si.fid, [Format '\n'], C17aArgs{:});
    end
else
    warning('WriteSMARTS:bad17a', ['Inconsistent data lengths for Card 17a data found while writing to file \r'...
           strrep(Si.Filename, '\', '/')]);
end

return;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function RangeCheck(S, Card, Var, Lower, Upper)
% Perform a range check and give warning if a variable is out of expected
% boundaries

if any(S.(Card).(Var) < Lower)
    if isscalar(S.(Card).(Var))
      warning(['WriteSMARTS:' Var 'lBound'], ['SMARTS Input Variable ' Var ' = ' num2str(S.(Card).(Var)) ...
        ' seems below normal range of ' num2str(Lower) ' to ' num2str(Upper) atPlace(S, Card)]);
    else
      warning(['WriteSMARTS:' Var 'lBound'], ['One or more elements of SMARTS Input vector Variable ' Var  ...
        ' seems below normal range of ' num2str(Lower) ' to ' num2str(Upper) atPlace(S, Card)]);        
    end
end

if any(S.(Card).(Var) > Upper)
   if isscalar(S.(Card).(Var))
     warning(['WriteSMARTS:' Var 'uBound'], ['SMARTS Input Variable ' Var ' = ' num2str(S.(Card).(Var)) ...
        ' seems above normal range of ' num2str(Lower) ' to ' num2str(Upper) atPlace(S, Card)]);
   else
      warning(['WriteSMARTS:' Var 'uBound'], ['One or more elements of SMARTS Input vector Variable ' Var ... 
        ' seems above normal range of ' num2str(Lower) ' to ' num2str(Upper) atPlace(S, Card)]);        
       
   end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function iRangeCheck(S, Card, Var, Lower, Upper)
RangeCheck(S, Card, Var, Lower, Upper);
% in addition, variable must be an integer
if any(round(S.(Card).(Var)) ~= S.(Card).(Var))
    if isscalar(S.(Card).(Var))
      warning(['WriteSMARTS:' Var 'notint'], ['SMARTS Input Variable ' Var ' = ' num2str(S.(Card).(Var)) ...
        ' should be an integer' atPlace(S, Card)]);
    else
      warning(['WriteSMARTS:' Var 'notint'], ['One or more elements of SMARTS Input vector Variable ' Var  ...
        ' is not an integer ' atPlace(S, Card)]);        
        
    end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function theFullPlace = atPlace(S, Card)
% Prints out the full location (Card, Line and File) at which a warning or error has occurred
theFullPlace = [' on Card ' Card(2:end) ' at Line ' num2str(S.(Card).Line) '\r in file ' strrep(S.Filename, '\', '/')];