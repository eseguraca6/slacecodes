function EphData = MoshierEphem(SiteInfo, EphemRequests)
% MoshierEphem : Interface to Steve Moshier's Ephemeris Program v5.6
%
% See www.moshier.net and www.moshier.net/aadoc.html for
% further details.
%
% Usage :
%  EphData = MoshierEphem(SiteInfo, EphemRequests)
%
% Where
%  SiteInfo is either a structure or a file containing the geographical
%   site information. If SiteInfo is char it is assumed to be a filename,
%   otherwise it must be a structure containing the following fields.
%     SiteInfo.Long   - the site longitude (east positive) in degrees.
%     SiteInfo.Lat    - the site latitude (north positive) in degrees.
%     SiteInfo.Alt    - the site height above mean sea level in metres.
%     SiteInfo.Temp   - temperature at site in celsius.
%     SiteInfo.Press  - air pressure at site in millibar.
%     SiteInfo.UTTDT  - selection of input time. Set to
%                       0 for UT = TDT,
%                       1 for TDT
%                       2 for UT (usually this for basic prediction purposes)
%     SiteInfo.deltaT - If non-zero, this is the difference TDT - UT.
%                       if zero or absent, deltaT will be computed. This
%                       will normally be omitted.
%   UT is Universal Time and TDT is Terrestrial Dynamic Time.
%   If SiteInfo is a valid filename, it contains the same information as
%   above. For an example, see the file aa.ini
%   For more information on time standards, see
%    http://en.wikipedia.org/wiki/Time_standard
%   
%  EphemRequests is a structure or a file containing the ephemeris
%    calculation requests. If EphemRequests is a structure, it must
%    have the following fields.
%     One of two options for specifying the date and time ...
%      EphemRequests.DateTime - an array [Year Month Day Hour Min Sec]
%                               as returned by datevec.
%         Or
%      EphemRequests.SerialDate - a Matlab serial date as returned by
%                                 datenum.
%     as well as
%      EphemRequests.Interval - the ephemeris calculation time step in
%                               decimal days.
%      EphemRequests.NumInter - the number of time points (seperated by
%                               Interval) at which to compute the
%                               ephemeris.
%      EphemRequests.Object - the object for which to compute the
%                             ephemeris. Use ...
%                             0 for the Sun
%                             1 for Mercury
%                             2 for Venus
%                             3 for the Moon
%                             4 for Mars
%                             5 for Jupiter
%                             6 for Saturn
%                             7 for Uranus
%                             8 for Neptune
%                             9 for Pluto
% Output
%  The output structure EphData is a vector structure containing
%  one element per ephemeris point (time and object). The fields
%  present varies depending on the object(s) for which the
%  ephemeris was computed. In particular, the fields returned
%  for the Sun and the Moon include additional fields not used
%  for the other objects. All entries contain the following
%  fields, but not all fields apply to all objects. The field will
%  be empty if not applicable. 
%     ObjectNum -  Object Number 0 = Sun, 3 = Moon, 9 = Pluto
%     ObjectName - Object name (Sun ... Pluto)
%     SiteInfo - Observer site lat, long, alt, temp, pressure
%     JD - Julian date of ephemeris point
%     UTDateTime - Universal Time (UTC) date/time vector (6 elements)
%     UTSerialDate - UT serial date (see Matlab datenum function)
%     UTMonthStr - UT Month (Jan, Feb ...)
%     UTWeekDay -  UT weekday (Mon, Tue ...)   
%     TDTMonthStr - Terrestrial Dynamic Time Month (Jan, Feb ...)
%     TDTDateTime - TDT date/time vector (See Matlab datevec function)
%     TDTSerialDate - TDT serial date
%     TDTWeekDay - TDT weekday (Mon, Tue ...)
%     EclipLong - Ecliptic longitude of object in degrees
%     EclipLat - Ecliptic latitude in degrees
%     EclipRadAU - Ecliptic radius vector in AU (astronomical units)
%     GeomLong - Geometric longitude in degrees
%     GeomLat - Geometric latitude in degrees
%     GeomRadAU - Geometric radius vector in AU
%     AppGeocLong - Apparent geocentric longitude in degrees (Moon)
%     AppGeocLat - Apparent geocentric latitude in degrees (Moon)
%     GeocRadAU - Geocentric radius vector in AU
%     Elong - Elongation from sun in degrees
%     LunarDist - Lunar distance in earth radii (Moon only)
%     LunarHorizPara - Lunar horizontal parallax in degrees (Moon)
%     LunarSemiDia - Lunar apparent semidiameter in degrees (Moon)s
%     LunarIllumFrac - Lunar illuminated fraction (Moon)
%     LightTime - Time for light to travel to/from object in minutes
%     TruGeoDist - True geocentric distance of object in AU
%     EquatDiam - Apparent equatorial diameter in arcseconds
%     LightDeflRA - RA light deflection due to sun in seconds
%     LightDeflDec - Declination deflection in arcseconds
%     AnnAberrRA - RA annual aberration in seconds
%     AnnAberrDec -  Declination annual aberration in arcseconds
%     AberrRA - Instantaneous RA aberration in seconds
%     AberrDec - Instantaneous Dec aberration in arcseconds
%     NutationRA - RA nutation in seconds
%     NutationDec - Declination nutation in arcseconds
%     Constell - Three letter code for constellation in which object appears
%     ApparentRA - Apparent Right Ascension of object in hours
%     ApparentDec - Apparent Declination of object in degrees
%     AstroJ2000RA - J2000 Right Ascension in hours
%     AstroJ2000Dec - J2000 Declination in degrees
%     AstroB1950RA - B1950 Right Ascension in hours
%     AstroB1950Dec - B1950 Declination in degrees
%     LST - Local apparent sidereal time
%     DiurAberrRA - RA Diurnal aberration in seconds
%     DiurAberrDec - Declination aberration in arcseconds
%     DiurParaRA - RA Diurnal parallax in seconds 
%     DiurParaDec - Delination Diurnal parallax in arcseconds
%     AtmosRefrac - Atmospheric refraction in degrees
%     AtmosRefracRA - RA atmospheric refraction in seconds
%     AtmosRefracDec - Declination atmospheric refraction in arcseconds
%     TopoAlt - Topocentric altitude of object in degrees
%     TopoAz - Topocentric azimuth of object in degrees
%     TopoRA - Topocentric Right Ascension of object in hours
%     TopoDec - Topocentric Declination of object in degrees
%     LocMeridTransDT - Date/time vector of local meridian transit
%     LocMeridTransSD - Serial date of local meridian transit
%     LocMeridTransMo - Month of local meridian transit (Jan, Feb ...)
%     LocMeridTransWD - Weekday of local meridian transit (Mon, Tue ...)
%     RisesDT -  Date/time vector of object rising above horizon
%     RisesSD -  Serial date of object rising above horizon
%     RisesMo -  Month of object rising (Jan, Feb ...)
%     RisesWD -  Weekday of object rising
%     SetsDT - Date/time vector of object setting
%     SetsSD - Serial date of object setting
%     SetsMo - Month of object setting (Jan, Feb ...)
%     SetsWD - Weekday of object setting (Mon, Tue ...)
%     VisHours - Hours for which the object is visible above horizon    
%
% All fields in SiteInfo and EphemRequest must be scalar, except for
% EphemRequests.DateTime which must be a 6 element row vector.
%
% SiteInfo and EphemRequests may be vectors, in which case data is
% returned for EVERY combination of site and ephemeris request. This
% can produce a lot of data.
%
% Notes :
%  MoshierEphem uses the files aa.ini, aaInput.txt and aaOutput.txt
%    for the site initialisation, input and output respectively.
%    Do not use these files for other purposes.
%
% Example :
% For and example, see the script MoshierEphemExample1.m

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

% Check inputs

% Determine where the MZDDE directory is

MZPath = fileparts(which('MoshierEphem'));

if ischar(SiteInfo)
    if exist(SiteInfo, 'file')
        % Copy the new ini file to aa.ini
        [Success, Message, MessageID] = copyfile(SiteInfo, [MZPath '\aa.ini'],'f');
        if ~Success
            error(['Unable to copy ' SiteInfo ' to aa.ini : ' Message]);
        end
    else
        error(['File ' SiteInfo ' does not exist.']);
    end
    NumSites = 1;
else
    
    % Write first aa.ini
    if ~isvector(SiteInfo) || ~isstruct(SiteInfo)
        error('Input SiteInfo must be a scalar or vector structure.')
    end
    for iSite = 1:length(SiteInfo) % Check all fields of SiteInfo
        if ~areScalarNumericFields(SiteInfo(iSite), {'Lat','Long','Alt','Temp','Press'})
            error('Input SiteInfo must be a structure with scalar numeric fields Lat, Long, Alt, Temp and Press');
        end
        if ~isScalarNumericField(SiteInfo(iSite), 'UTTDT')
                % default to UT input
                SiteInfo(iSite).UTTDT = 2;
        end
        if ~isScalarNumericField(SiteInfo(iSite), 'deltaT')
                % default to zero deltaT
                SiteInfo(iSite).deltaT = 0;
        end        
    end
    %WriteINIFile([MZPath '\aa.ini'], SiteInfo(1));
    WriteINIFile(['aa.ini'], SiteInfo(1));
    NumSites = length(SiteInfo);
end

% Next check the ephemeris requests
if ~isstruct(EphemRequests) || ~isvector(EphemRequests)
    error('Input EphemRequests must be a vector structure.')
end

for iReq = 1:length(EphemRequests)
    if isfield(EphemRequests(iReq), 'DateTime')
        if isnumeric(EphemRequests(iReq).DateTime) && isvector(EphemRequests(iReq).DateTime) ...
                                                   && length(EphemRequests(iReq).DateTime)==6
           % all is well
        else
           error('Input EphemRequest(i).DateTime must be a 6 component date/time vector.')
        end
    else
        if ~isScalarNumericField(EphemRequests(iReq), 'SerialDate')
            error('Input EphemRequest must have either field DateTime or field SerialDate.')
        else
            EphemRequests(iReq).DateTime = datevec(EphemRequests(iReq).SerialDate); 
        end
    end
    if ~isScalarNumericField(EphemRequests(iReq), 'Interval')
        error('Input EphemRequests must have scalar numeric field Interval.')
    end
    if isScalarNumericField(EphemRequests(iReq), 'NumInter')
        EphemRequests(iReq).NumInter = abs(round(EphemRequests(iReq).NumInter)); 
    else
        error('Input EphemRequests must have scalar numeric integer field NumInter.')
    end
    if ~isScalarNumericField(EphemRequests(iReq), 'Object') || EphemRequests(iReq).Object < 0 || EphemRequests(iReq).Object > 9
        error('Input EphemRequests must have scalar numeric integer field Object that is from 0 to 9.')
    end    
end
% Initialise the structure output
EphData = EmptyEphData;

% In the output data EphData, sites vary down rows and requests vary along columns
% Each request generates a vector of data for each of a number of fields
EphData(1).SiteInfo = SiteInfo(1);
EphData(1).EphemRequests = EphemRequests(1);
% Set up the input file for aa
WriteAAInput([MZPath '\aaInput.txt'], EphemRequests);
% Run aa for the first site
aaCommand = [MZPath '\aa.exe < ' MZPath '\aaInput.txt > ' MZPath '\aaOutput.txt'];
[Status, Result] = dos(aaCommand);
if Status
    error(['Error calling aa.exe : ' Result])
end
EphData = ReadAAOutput([MZPath '\aaOutput.txt'], SiteInfo(1), EphemRequests);

% Read in the output data from aa.exe
% Run through each of the remaining sites
for iSite = 2:NumSites
    % Write out the next aa.ini file
    % WriteINIFile([MZPath '\aa.ini'], SiteInfo(iSite));
    WriteINIFile(['aa.ini'], SiteInfo(iSite));
    % Run aa for each of the remaining sites
    [Status, Result] = dos(aaCommand);
    if Status
        error(['Error calling aa.exe : ' Result])
    end    
    EphData(iSite, :) =  ReadAAOutput([MZPath '\aaOutput.txt'], SiteInfo(iSite), EphemRequests);
end



function Result = isScalarNumericField(Struct, FieldName)
Result = isfield(Struct, FieldName) && isnumeric(getfield(Struct, FieldName)) && isscalar(getfield(Struct, FieldName));

function Result = areScalarNumericFields(Struct, FieldNames)
Result = 1;
for iField = 1:length(FieldNames)
  Result = Result && isScalarNumericField(Struct, FieldNames{iField});
end

function WriteINIFile(FileName, SiteData)
fid = fopen(FileName, 'w');
fprintf(fid, '%10.6f ; Terrestrial east longitude of observer site in degrees\r\n', SiteData.Long);
fprintf(fid, '%10.6f ; Geodetic latitude, degrees\r\n', SiteData.Lat);
fprintf(fid, '%10.2f ; Height above sea level, meters\r\n', SiteData.Alt);
fprintf(fid, '%10.1f ; Atmospheric temperature, deg C\r\n', SiteData.Temp);
fprintf(fid, '%10.1f ; Atmospheric pressure, millibars\r\n', SiteData.Press);
fprintf(fid, '%10i ; 0 - TDT=UT, 1 - input=TDT, 2 - input=UT\r\n', SiteData.UTTDT);
fprintf(fid, '%10.3f ; Use this deltaT (sec) if nonzero, else compute it.\r\n', SiteData.deltaT);
fclose(fid);

function WriteAAInput(FileName, EphReq)
fid = fopen(FileName, 'w');
for iReq = 1:length(EphReq)
    fprintf(fid, '%f\r\n', EphReq(iReq).DateTime(1));
    fprintf(fid, '%f\r\n', EphReq(iReq).DateTime(2));
    fprintf(fid, '%f\r\n', EphReq(iReq).DateTime(3));
    fprintf(fid, '%f\r\n', EphReq(iReq).DateTime(4));
    fprintf(fid, '%f\r\n', EphReq(iReq).DateTime(5));
    fprintf(fid, '%f\r\n', EphReq(iReq).DateTime(6));
    fprintf(fid, '%f\r\n', EphReq(iReq).Interval);
    fprintf(fid, '%i\r\n', EphReq(iReq).NumInter);
    fprintf(fid, '%i\r\n', EphReq(iReq).Object);
end
% Write a dummy entry, followed by -1 for object
fprintf(fid, '%f\r\n', EphReq(end).DateTime(1));
fprintf(fid, '%f\r\n', EphReq(end).DateTime(2));
fprintf(fid, '%f\r\n', EphReq(end).DateTime(3));
fprintf(fid, '%f\r\n', EphReq(end).DateTime(4));
fprintf(fid, '%f\r\n', EphReq(end).DateTime(5));
fprintf(fid, '%f\r\n', EphReq(end).DateTime(6));
fprintf(fid, '%f\r\n', EphReq(end).Interval);
fprintf(fid, '%i\r\n', EphReq(end).NumInter);
fprintf(fid, '%i\r\n', -1);
fclose(fid);

function EphData = ReadAAOutput(FileName, SiteInfo, EphReq)
EphData = EmptyEphData;
fid = fopen(FileName, 'r');
% Read the file line for line and scan for known formats
for iReq = 1:length(EphReq)
    EphData(iReq).ObjectNum = EphReq(iReq).Object;
    EphData(iReq).ObjectName = ObjectName(EphReq(iReq).Object);
    EphData(iReq).SiteInfo = SiteInfo;
    for iInter = 1:EphReq(iReq).NumInter
        % Scan until JD record is found
        Line = fgetl(fid);
        while length(Line) < 3 || ~strcmp(Line(1:3), 'JD ')
            Line = fgetl(fid);
        end
        % Scan the UT and TDT lines, don't yet know which is which
        NumData = ScanLine(Line, 'JD %f,  %f %*s %f %*s %fh %fm %fs  %*s', 6); % scan numeric fields
        Month = ScanLine(Line, 'JD %*f,  %*f %s %*f %*s %*fh %*fm %*fs  %*s', 1); % scan month
        Weekday = ScanLine(Line, 'JD %*f,  %*f %*s %*f %s %*fh %*fm %*fs  %*s', 1); % scan weekday
        UTTDT = ScanLine(Line, 'JD %*f,  %*f %*s %*f %*s %*fh %*fm %*fs  %s', 1); % scan month
        if strcmp(UTTDT, 'UT')
            EphData(iReq).JD(iInter,1) = NumData(1);
            EphData(iReq).UTDateTime(iInter,:) = [NumData(2) MonthNum(Month) NumData(3) NumData(4) NumData(5) NumData(6)];
            EphData(iReq).UTSerialDate(iInter,1) = datenum([NumData(2) MonthNum(Month) NumData(3) NumData(4) NumData(5) NumData(6)]);
            EphData(iReq).UTMonthStr(iInter, 1:3) = Month(1:3);
            EphData(iReq).UTWeekDay(iInter, 1:3) = Weekday(1:3);
        else
            EphData(iReq).JD(iInter,1) = NumData(1);
            EphData(iReq).TDTMonthStr(iInter, 1:3) = Month(1:3); 
            EphData(iReq).TDTDateTime(iInter,:) = [NumData(2) MonthNum(Month) NumData(3) NumData(4) NumData(5) NumData(6)];           
            EphData(iReq).TDTSerialDate(iInter,1) = datenum([NumData(2) MonthNum(Month) NumData(3) NumData(4) NumData(5) NumData(6)]);            
            EphData(iReq).TDTWeekDay(iInter, 1:3) = Weekday(1:3);            
        end
        Line = fgetl(fid);
        NumData = ScanLine(Line, '%f %*s %f %*s %fh %fm %fs  %*s', 5); % scan numeric fields
        Month = ScanLine(Line, '%*f %s %*f %*s %*fh %*fm %*fs  %*s', 1); % scan month
        Weekday = ScanLine(Line, '%*f %*s %*f %s %*fh %*fm %*fs  %*s', 1); % scan weekday
        UTTDT = ScanLine(Line, '%*f %*s %*f %*s %*fh %*fm %*fs  %s', 1); % scan month
        if strcmp(UTTDT, 'UT')
            EphData(iReq).UTDateTime(iInter,:) = [NumData(1) MonthNum(Month) NumData(2) NumData(3) NumData(4) NumData(5)];
            EphData(iReq).UTSerialDate(iInter,1) = datenum([NumData(1) MonthNum(Month) NumData(2) NumData(3) NumData(4) NumData(5)]);            
            EphData(iReq).UTMonthStr(iInter, 1:3) = Month(1:3); 
            EphData(iReq).UTWeekDay(iInter, 1:3) = Weekday(1:3);            
        else
            EphData(iReq).TDTMonthStr(iInter, 1:3) = Month(1:3); 
            EphData(iReq).TDTDateTime(iInter,:) = [NumData(1) MonthNum(Month) NumData(2) NumData(3) NumData(4) NumData(5)];
            EphData(iReq).TDTSerialDate(iInter,1) = datenum([NumData(1) MonthNum(Month) NumData(2) NumData(3) NumData(4) NumData(5)]);            
            EphData(iReq).TDTWeekDay(iInter, 1:3) = Weekday(1:3);            
        end
        % Scan for the formats depending on which object it is
        switch EphReq(iReq).Object
            case 0 % Sun
                EphData = doSun(EphData, fid, iReq, iInter);
            case 3 % Moon
                EphData = doMoon(EphData, fid, iReq, iInter);
            case {1 2 4 5 6 7 8 9} % Planet
                EphData = doPlanet(EphData, fid, iReq, iInter);
            otherwise
                disp(['Unknown Object Number ' num2str(EphReq(iReq).Object)]);
        end        
    end
end
fclose(fid);


function Num = MonthNum(Month)
switch Month
    case 'January', Num = 1;
    case 'February', Num = 2;
    case 'March', Num = 3;
    case 'April', Num = 4;
    case 'May', Num = 5;
    case 'June', Num = 6;
    case 'July', Num = 7;
    case 'August', Num = 8;
    case 'September', Num = 9;
    case 'October', Num = 10;
    case 'November', Num = 11;
    case 'December', Num = 12;
    otherwise Num = 0;
end

function Name = ObjectName(ObjNum)
switch ObjNum
    case 0, Name = 'Sun';
    case 1, Name = 'Mercury';
    case 2, Name = 'Venus';
    case 3, Name = 'Moon';
    case 4, Name = 'Mars';
    case 5, Name = 'Jupiter';
    case 6, Name = 'Saturn';
    case 7, Name = 'Uranus';
    case 8, Name = 'Neptune';
    case 9, Name - 'Pluto';
    otherwise Name = 'Unknown';
end

function EmptyData = EmptyEphData
EmptyData = struct( ...
    'ObjectNum', {}, ...
    'ObjectName', {}, ...
    'SiteInfo', {}, ...
    'JD', {}, ...
    'UTDateTime', {}, ...
    'UTSerialDate', {}, ...
    'UTMonthStr', {}, ...
    'UTWeekDay', {}, ...    
    'TDTMonthStr', {}, ...
    'TDTDateTime', {}, ...
    'TDTSerialDate', {}, ...
    'TDTWeekDay', {}, ...
    'EclipLong', {}, ...
    'EclipLat', {}, ...
    'EclipRadAU', {}, ...    
    'GeomLong', {}, ...
    'GeomLat', {}, ...
    'GeomRadAU', {}, ...
    'AppGeocLong', {}, ...
    'AppGeocLat', {}, ...
    'GeocRadAU', {}, ...
    'LunarDist', {}, ...
    'LunarHorizPara', {}, ...
    'LunarSemiDia', {}, ...
    'LunarIllumFrac', {}, ...
    'LightTime', {}, ...
    'TruGeoDist', {}, ...
    'EquatDiam', {}, ...
    'VisMag', {}, ...
    'Phase', {}, ...
    'Elong', {}, ...
    'LightDeflRA', {}, ...
    'LightDeflDec', {}, ...
    'AnnAberrRA', {}, ...
    'AnnAberrDec', {}, ... 
    'AberrRA', {}, ...
    'AberrDec', {}, ...
    'NutationRA', {}, ...
    'NutationDec', {}, ...
    'Constell', {}, ...
    'ApparentRA', {}, ...
    'ApparentDec', {}, ...
    'AstroJ2000RA', {}, ...
    'AstroJ2000Dec', {}, ...
    'AstroB1950RA', {}, ...
    'AstroB1950Dec', {}, ...
    'LST', {}, ...
    'DiurAberrRA', {}, ...
    'DiurAberrDec', {}, ...
    'DiurParaRA', {}, ...
    'DiurParaDec', {}, ...
    'AtmosRefrac', {}, ...
    'AtmosRefracRA', {}, ...
    'AtmosRefracDec', {}, ...
    'TopoAlt', {}, ...
    'TopoAz', {}, ...
    'TopoRA', {}, ...
    'TopoDec', {}, ...
    'LocMeridTransDT', {}, ...
    'LocMeridTransSD', {}, ...
    'LocMeridTransMo', {}, ...
    'LocMeridTransWD', {}, ...
    'RisesDT', {}, ... % DateTime (6 vector)
    'RisesSD', {}, ... % SerialDate
    'RisesMo', {}, ... % Month
    'RisesWD', {}, ... % Weekday
    'SetsDT', {}, ...
    'SetsSD', {}, ...
    'SetsMo', {}, ...
    'SetsWD', {}, ...
    'VisHours', {} ...
        );

 return;
 
function FixedLine = GetFixedLine(fid)
% Get a line from the file and remove spaces between minus signs and dec or lat numbers
% Caters for up to three spaces after the minus sign
Line = fgetl(fid);
Line = strrep(Line, '-  ', '-');
Line = strrep(Line, '- ', '-');
FixedLine = Line;
return;

function Data = ScanLine(Line, Format, DesiredCount)
[Data, ActualCount, ErrorMsg] = sscanf(Line, Format);
if DesiredCount ~= ActualCount
    error(['Field count mismatch in line "' Line '" against format "' Format '" : ' ErrorMsg]);
end
if size(Data, 1) > 1 && ActualCount == 1
    % This is a fix for string sscanf regression bug in Matlab
    Data = char(Data');
end
return;

function EphData = doSun(EphData, fid, iReq, iInter)
Line = GetFixedLine(fid);
Num = ScanLine(Line, 'ecliptic long  %fd %f'' %f"   lat %fd %f'' %f"   rad %f', 7);
EphData(iReq).EclipLong(iInter,:) = DHMS(Num(1), Num(2), Num(3)); 
EphData(iReq).EclipLat(iInter,:)  = DHMS(Num(4), Num(5), Num(6)); 
EphData(iReq).EclipRadAU(iInter,:)= Num(7);
Line = fgetl(fid);
Num = ScanLine(Line, 'light time %fm,  aberration dRA %fs dDec %f"', 3);
EphData(iReq).LightTime(iInter,:) = Num(1);
EphData(iReq).AberrRA(iInter,:) = Num(2);
EphData(iReq).AberrDec(iInter,:) = Num(3);
Line = fgetl(fid);
Num = ScanLine(Line, 'nutation dRA %fs dDec %f"', 2);
EphData(iReq).NutationRA(iInter,:) = Num(1);
EphData(iReq).NutationDec(iInter,:) = Num(2);
Line = GetFixedLine(fid);
Num = ScanLine(Line, '%*s %*s   Apparent:  R.A.  %fh  %fm  %fs   Dec.  %fd  %f''  %f"', 6);
EphData(iReq).ApparentRA(iInter,:) = DHMS(Num(1), Num(2), Num(3)); 
EphData(iReq).ApparentDec(iInter,:)  = DHMS(Num(4), Num(5), Num(6)); 
Str = ScanLine(Line, '%s  %*s   Apparent:  R.A.  %*fh %*fm %*fs  Dec.  %*fd %*f'' %*f"', 1);
EphData(iReq).Constell(iInter,:) = Str(1:3); 
Line = fgetl(fid);
Num = ScanLine(Line, 'Apparent longitude %f deg', 1);                
EphData(iReq).AppGeocLong(iInter,:) =  Num;
EphData(iReq).AppGeocLat(iInter,:) =  0; % Presumably always 0 for the sun
EphData = doLSTthruVisHours(EphData, fid, iReq, iInter);
return; % end of doSun

function EphData = doMoon(EphData, fid, iReq, iInter)
Line = fgetl(fid);
Num = ScanLine(Line, 'nutation dRA %fs dDec %f"', 2);
EphData(iReq).NutationRA(iInter,:) = Num(1);
EphData(iReq).NutationDec(iInter,:) = Num(2);
Line = fgetl(fid);
Num = ScanLine(Line, 'Geometric lon %f deg, lat %f deg, rad %f au', 3);
EphData(iReq).GeomLong(iInter,:) = Num(1);
EphData(iReq).GeomLat(iInter,:)  = Num(2);
EphData(iReq).GeomRadAU(iInter,:)= Num(3);
Line = fgetl(fid);
Num = ScanLine(Line, 'Apparent geocentric longitude %f deg   latitude %f deg', 2);
EphData(iReq).AppGeocLong(iInter,:) = Num(1);
EphData(iReq).AppGeocLat(iInter,:)  = Num(2);
Line = fgetl(fid);
Num = ScanLine(Line, 'Distance %f Earth-radii', 1);
EphData(iReq).LunarDist(iInter,:) = Num(1);
Line = GetFixedLine(fid);
Num = ScanLine(Line, 'Horizontal parallax    %fd %f'' %f"  Semidiameter    %fd %f'' %f"', 6);
EphData(iReq).LunarHorizPara(iInter,:) = DHMS(Num(1), Num(2), Num(3)); 
EphData(iReq).LunarSemiDia(iInter,:) = DHMS(Num(4), Num(5), Num(6)); 
Line = fgetl(fid);
Num = ScanLine(Line, 'Elongation from sun %f deg,  Illuminated fraction %f', 2);
EphData(iReq).Elong(iInter,:) = Num(1);
EphData(iReq).LunarIllumFrac(iInter,:)  = Num(2);
Line = fgetl(fid); % Skip "Phase 1.2 days past Third Quarter" thingy for now
Line = GetFixedLine(fid);
Num = ScanLine(Line, ' Apparent:  R.A. %fh %fm %fs  Declination %fd %f'' %f" ', 6);
EphData(iReq).ApparentRA(iInter,:) = DHMS(Num(1), Num(2), Num(3)); 
EphData(iReq).ApparentDec(iInter,:)  = DHMS(Num(4), Num(5), Num(6)); 
EphData = doLSTthruVisHours(EphData, fid, iReq, iInter);
return; % end of doMoon

function EphData = doPlanet(EphData, fid, iReq, iInter)
Line = GetFixedLine(fid);
Num = ScanLine(Line, 'ecliptic long  %fd %f'' %f"   lat %fd %f'' %f"   rad %f', 7);
EphData(iReq).EclipLong(iInter,:) = DHMS(Num(1), Num(2), Num(3)); 
EphData(iReq).EclipLat(iInter,:)  = DHMS(Num(4), Num(5), Num(6)); 
EphData(iReq).EclipRadAU(iInter,:)= Num(7);
Line = fgetl(fid);
Num = ScanLine(Line, 'light time %fm,  aberration dRA %fs dDec %f"', 3);
EphData(iReq).LightTime(iInter,:) = Num(1);
EphData(iReq).AberrRA(iInter,:) = Num(2);
EphData(iReq).AberrDec(iInter,:) = Num(3);
Line = fgetl(fid);
Num = ScanLine(Line, 'true geocentric distance %f au    equatorial diameter %f"', 2);
EphData(iReq).TruGeoDist(iInter,:) = Num(1);
EphData(iReq).EquatDiam(iInter,:) = Num(2);
Line = fgetl(fid);
Num = ScanLine(Line, 'approx. visual magnitude %f, phase %f', 2);
EphData(iReq).VisMag(iInter,:) = Num(1);
EphData(iReq).Phase(iInter,:) = Num(2);
Line = GetFixedLine(fid);
Num = ScanLine(Line, 'Astrometric J2000.0:  R.A.   %fh %fm %fs  Dec.     %fd %f'' %f" ', 6);
EphData(iReq).AstroJ2000RA(iInter,:) = DHMS(Num(1), Num(2), Num(3)); 
EphData(iReq).AstroJ2000Dec(iInter,:)  = DHMS(Num(4), Num(5), Num(6)); 
Line = GetFixedLine(fid);
Num = ScanLine(Line, 'Astrometric B1950.0:  R.A.   %fh %fm %fs  Dec.     %fd %f'' %f" ', 6);
EphData(iReq).AstroB1950RA(iInter,:) = DHMS(Num(1), Num(2), Num(3)); 
EphData(iReq).AstroB1950Dec(iInter,:)  = DHMS(Num(4), Num(5), Num(6)); 
Line = fgetl(fid);
Num = ScanLine(Line, 'elongation from sun %f degrees, light defl. dRA %fs dDec %f"', 3);
EphData(iReq).Elong(iInter,:) = Num(1);
EphData(iReq).LightDeflRA(iInter,:)  = Num(2);
EphData(iReq).LightDeflDec(iInter,:)  = Num(3);
Line = fgetl(fid);
Num = ScanLine(Line, 'annual aberration dRA %fs dDec %f"', 2);
EphData(iReq).AnnAberrRA(iInter,:) = Num(1);
EphData(iReq).AnnAberrDec(iInter,:) = Num(2);
Line = fgetl(fid);
Num = ScanLine(Line, 'nutation dRA %fs dDec %f"', 2);
EphData(iReq).NutationRA(iInter,:) = Num(1);
EphData(iReq).NutationDec(iInter,:) = Num(2);
Line = GetFixedLine(fid);
Num = ScanLine(Line, '%*s %*s   Apparent:  R.A.  %fh  %fm  %fs   Dec.  %fd  %f''  %f"', 6);
EphData(iReq).ApparentRA(iInter,:) = DHMS(Num(1), Num(2), Num(3)); 
EphData(iReq).ApparentDec(iInter,:)  = DHMS(Num(4), Num(5), Num(6)); 
Str = ScanLine(Line, '%s  %*s   Apparent:  R.A.  %*fh %*fm %*fs  Dec.  %*fd %*f'' %*f"', 1);
EphData(iReq).Constell(iInter,:) = Str(1:3); 
Line = GetFixedLine(fid);
Num = ScanLine(Line, 'Apparent geocentric ecliptic long   %fd %f'' %f"   lat %fd %f'' %f"   rad %f', 7);
EphData(iReq).AppGeocLong(iInter,:) = DHMS(Num(1), Num(2), Num(3)); 
EphData(iReq).AppGeocLat(iInter,:)  = DHMS(Num(4), Num(5), Num(6)); 
EphData(iReq).GeocRadAU(iInter,:)   = Num(7);
EphData = doLSTthruVisHours(EphData, fid, iReq, iInter);
return; % end of doPlanet


function EphData = doLSTthruVisHours(EphData, fid, iReq, iInter)
% Scan local apparent sidereal time through to visible hours
Line = fgetl(fid);
Num = ScanLine(Line, 'Local apparent sidereal time  %fh %fm %fs', 3);
EphData(iReq).LST(iInter,:) = DHMS(Num(1), Num(2), Num(3)); 
Line = fgetl(fid);
Num = ScanLine(Line, 'diurnal aberration dRA %fs dDec %f"', 2);
EphData(iReq).DiurAberrRA(iInter,:) = Num(1);
EphData(iReq).DiurAberrDec(iInter,:) = Num(2);
Line = fgetl(fid);
Num = ScanLine(Line, 'diurnal parallax dRA %fs dDec %f"', 2);
EphData(iReq).DiurParaRA(iInter,:) = Num(1);
EphData(iReq).DiurParaDec(iInter,:) = Num(2);
Line = fgetl(fid);
Num = ScanLine(Line, 'atmospheric refraction %f deg  dRA %fs dDec %f"', 3);
EphData(iReq).AtmosRefrac(iInter,:) = Num(1);
EphData(iReq).AtmosRefracRA(iInter,:) = Num(2);
EphData(iReq).AtmosRefracRA(iInter,:) = Num(3);
Line = fgetl(fid);
Num = ScanLine(Line, 'Topocentric:  Altitude %f deg, Azimuth %f deg', 2);
EphData(iReq).TopoAlt(iInter,:) = Num(1);
EphData(iReq).TopoAz(iInter,:) = Num(2);
Line = GetFixedLine(fid);
Num = ScanLine(Line, 'Topocentric: R.A. %fh %fm %fs   Dec. %fd %f'' %f"', 6);
EphData(iReq).TopoRA(iInter,:) = DHMS(Num(1), Num(2), Num(3)); 
EphData(iReq).TopoDec(iInter,:)  = DHMS(Num(4), Num(5), Num(6)); 
Line = fgetl(fid);
Num = ScanLine(Line, 'local meridian transit %f %*s %f %*s %fh %fm %fs  %*s', 5); % scan numeric fields
Month = ScanLine(Line, 'local meridian transit %*f %s %*f %*s %*fh %*fm %*fs  %*s', 1); % scan month
Weekday = ScanLine(Line, 'local meridian transit %*f %*s %*f %s %*fh %*fm %*fs  %*s',1); % scan weekday
UTTDT = ScanLine(Line, 'local meridian transit %*f %*s %*f %*s %*fh %*fm %*fs  %s',1); % scan UT/Other
if strcmp(UTTDT, 'UT')
    EphData(iReq).LocMeridTransDT(iInter,:) = [Num(1) MonthNum(Month) Num(2) Num(3) Num(4) Num(5)];
    EphData(iReq).LocMeridTransSD(iInter,1) = datenum([Num(1) MonthNum(Month) Num(2) Num(3) Num(4) Num(5)]);
    EphData(iReq).LocMeridTransMo(iInter, 1:3) = Month(1:3);
    EphData(iReq).LocMeridTransWD(iInter, 1:3) = Weekday(1:3);
else
    error('Local Meridian Transit not given in UT');
end
Line = fgetl(fid);
Num = ScanLine(Line, 'rises %f %*s %f %*s %fh %fm %fs  %*s', 5); % scan numeric fields
Month = ScanLine(Line, 'rises %*f %s %*f %*s %*fh %*fm %*fs  %*s', 1); % scan month
Weekday = ScanLine(Line, 'rises %*f %*s %*f %s %*fh %*fm %*fs  %*s',1); % scan weekday
UTTDT = ScanLine(Line, 'rises %*f %*s %*f %*s %*fh %*fm %*fs  %s',1); % scan UT/Other
if strcmp(UTTDT, 'UT')
    EphData(iReq).RisesDT(iInter,:) = [Num(1) MonthNum(Month) Num(2) Num(3) Num(4) Num(5)];
    EphData(iReq).RisesSD(iInter,1) = datenum([Num(1) MonthNum(Month) Num(2) Num(3) Num(4) Num(5)]);
    EphData(iReq).RisesMo(iInter, 1:3) = Month(1:3);
    EphData(iReq).RisesWD(iInter, 1:3) = Weekday(1:3);
else
    error('Rise time not given in UT');
end
Line = fgetl(fid);
Num = ScanLine(Line, 'sets %f %*s %f %*s %fh %fm %fs  %*s', 5); % scan numeric fields
Month = ScanLine(Line, 'sets %*f %s %*f %*s %*fh %*fm %*fs  %*s', 1); % scan month
Weekday = ScanLine(Line, 'sets %*f %*s %*f %s %*fh %*fm %*fs  %*s',1); % scan weekday
UTTDT = ScanLine(Line, 'sets %*f %*s %*f %*s %*fh %*fm %*fs  %s',1); % scan UT/Other
if strcmp(UTTDT, 'UT')
    EphData(iReq).SetsDT(iInter,:) = [Num(1) MonthNum(Month) Num(2) Num(3) Num(4) Num(5)];
    EphData(iReq).SetsSD(iInter,1) = datenum([Num(1) MonthNum(Month) Num(2) Num(3) Num(4) Num(5)]);
    EphData(iReq).SetsMo(iInter, 1:3) = Month(1:3);
    EphData(iReq).SetsWD(iInter, 1:3) = Weekday(1:3);
else
    error('Set time not given in UT');
end
Line = fgetl(fid);
Num = ScanLine(Line, 'Visible hours %f', 1);
EphData(iReq).VisHours(iInter,:) = Num(1);                


function LD = DHMS(dh, m, s)
if dh < 0
    LD = dh - m/60 - s/3600;
else
    LD = dh + m/60 + s/3600;
end
