function MoonData = MoshierMoon(SiteInfo, MoonRequests, CalcSunEarthAU)
% MoshierMoon : Interface to Moshier Ephemeris and Selenographic Calcs
%
% This function computes Moon-related data for the given dates and
% times.
% See www.moshier.net and the information on "selenog" for further
% details.
%
% Usage:
%   MoonData = MoshierMoon(SiteInfo, MoonRequests)
%     or
%   MoonData = MoshierMoon(SiteInfo, MoonRequests, CalcSunEarthAU)
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
%   UT is Universal Time and TDT is Terrestrial Dynamic Time. For the
%   major intended use of this routine UT input is normal.
%   If SiteInfo is a valid filename, it contains the same information as
%   above. For an example, see the file aaSample.ini
%   For more information on time standards, see
%    http://en.wikipedia.org/wiki/Time_standard
%
%  MoonRequests is a structure containing the Moon ephemeris
%    calculation requests. MoonRequests must have the following fields.
%     One of two options for specifying the date and time ...
%      MoonRequests.DateTime - an array [Year Month Day Hour Min Sec]
%                               as returned by datevec.
%         Or
%      MoonRequests.SerialDate - a Matlab serial date as returned by
%                                 datenum.
%     as well as
%      MoonRequests.Interval - the ephemeris calculation time step in
%                               decimal days.
%      MoonRequests.NumInter - the number of time points (separated by
%                               Interval) at which to compute the
%                               lunar ephemeris data.
%
% CalcSunEarthAU - Set this (optional) flag to 1 if the Sun-Earth
%                  distance (in astronomical units) must also be 
%                  calculated. This calculation requires Eran Ofek's earth
%                  ephemeris code for Matlab (ple_earth.m), which can be
%                  downloaded from 
%                  http://wise-obs.tau.ac.il/~eran/MATLAB/Ephem.html
%                  (last accessed 2008-04-04).
%
% Output : 
%  The output structure MoonData is a vector structure containing
%  one element per ephemeris point (date and time). The fields
%  present varies depending on the object(s) for which the
%  ephemeris was computed. This routine calls MoshierEphem to compute
%  the lunar ephemeris, so not all output fields are relevent to the
%  Moon. Irrelevent fields will be empty.
%     ObjectNum -  3 for the Moon
%     ObjectName - Object name - 'Moon'
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
%     EclipLong - Ecliptic longitude of moon in degrees
%     EclipLat - Ecliptic latitude in degrees
%     EclipRadAU - Ecliptic radius vector in AU (astronomical units)
%     GeomLong - Geometric longitude in degrees
%     GeomLat - Geometric latitude in degrees
%     GeomRadAU - Geometric radius vector in AU
%     AppGeocLong - Apparent lunar geocentric longitude in degrees
%     AppGeocLat - Apparent lunar geocentric latitude in degrees
%     GeocRadAU - Geocentric radius vector in AU
%     VisMag - Approximate visual magnitude
%     Phase - Phase angle of object (not given for Moon, see PhaseAngle)
%     Elong - Elongation from sun in degrees
%     LunarDist - Lunar distance in earth radii 
%     LunarHorizPara - Lunar horizontal parallax in degrees
%     LunarSemiDia - Lunar apparent semidiameter in degrees
%     LunarIllumFrac - Lunar illuminated fraction
%     LightTime - Time for light to travel to/from moon in minutes
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
%     Constell - Three letter code for constellation in which moon appears
%     ApparentRA - Apparent Right Ascension of moon in hours
%     ApparentDec - Apparent Declination of moon in degrees
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
%     TopoAlt - Topocentric altitude of moon in degrees
%     TopoAz - Topocentric azimuth of moon in degrees
%     TopoRA - Topocentric Right Ascension of moon in hours
%     TopoDec - Topocentric Declination of moon in degrees
%     LocMeridTransDT - Date/time vector of local meridian transit
%     LocMeridTransSD - Serial date of local meridian transit
%     LocMeridTransMo - Month of local meridian transit (Jan, Feb ...)
%     LocMeridTransWD - Weekday of local meridian transit (Mon, Tue ...)
%     RisesDT -  Date/time vector of moon rising above horizon
%     RisesSD -  Serial date of moon rising above horizon
%     RisesMo -  Month of moon rising (Jan, Feb ...)
%     RisesWD -  Weekday of moon rising
%     SetsDT - Date/time vector of moon setting
%     SetsSD - Serial date of moon setting
%     SetsMo - Month of moon setting (Jan, Feb ...)
%     SetsWD - Weekday of moon setting (Mon, Tue ...)
%     VisHours - Hours for which the moon is visible above horizon
% In addition, the following data is obtained from the Moshier selenog
% programme. All of the following depend only on julian date and not
% on the site location.
%     LibEul - Lunar Libration Euler angles re mean ecliptic and equinox of date (radians)
%     SelenoPoleEclip - Selenocentric unit vector toward pole of ecliptic
%     GeoLongMoon - Geocentric Longitude of the moon in degrees
%     GeoLatMoon - Geocentric Latitude of the moon in degrees
%     GeoDistMoon - Geocentric distance of the moon in Astronomical Units
%                   This value should be close to GeomRadAU.
%     SelenoVecEarth - Selenocentric unit vector toward the earth
%     SelenoLongEarth - Selenocentric longitude of the earth in degrees
%     SelenoLatEarth - Selenocentric latitude of the earth in degrees
%     J2000MeanLibEul - J2000 mean equatorial libration Euler angles in radians
%     GeoJ2000MeanMoon - Geocentric J2000 mean equatorial moon coords (x,y,z in AU)
%     HelioJ2000MeanEarth - Heliocentric J2000 mean equatorial earth (x,y,z in AU)
%     GeoLongSun - Geocentric longitude of the sun in degrees
%     GeoLatSun - Geocentric latitude of the sun in ARCSECONDS
%     GeoDistSun - Geocentric distance of the sun in AU
%     SelenoLongSun - Selenocentric longitude of the sun in degrees
%     SelenoLatSun - Selenocentric latitude of the sun in degrees
%     SelenoVecSun - Selenocentric unit vector towards the sun
%     PhaseAngle - Lunar phase angle in radians
% The following fields are also calculated if the CalcSunEarthAU flag
% has been specified non-zero.
%     SunEarthAU - Distance between sun and earth in AU. Accuracy is
%                  better than about 0.001 AU.
%     SunMoonAU - Distance between sun and moon in AU.
%     HelioEarthLong - Heliocentric longitude of earth in radians.
%     HelioEarthLat - Heliocentric latitude of the earth in radians.
%                     Accuracy of lat and long is better than 1'.
%
% All fields in SiteInfo and MoonRequest must be scalar, except for
% MoonRequests.DateTime which must be a 6 element row vector.
%
% SiteInfo and MoonRequests may be vectors, in which case data is
% returned for EVERY combination of site and ephemeris request. This
% can produce a lot of data.
%
% Notes:
% This function calls MoshierEphem to compute the Lunar ephemeris.
% MoshierEphem uses the files aa.ini, aaInput.txt and aaOutput.txt.
% MoshierMoon uses selenogInput.txt and selenogOutput.txt. Do not
% use these files for other purposes.

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

% Prepare EphRequests for call to MoshierEphem

% Check the Moon ephemeris requests for most basic properties
% Remainder of checking will be left to MoshierEphem
if ~isstruct(MoonRequests) || ~isvector(MoonRequests)
    error('Input MoonRequests must be a vector structure.')
end
for iReq = 1:length(MoonRequests)
    MoonRequests(iReq).Object = 3; % Set object to Moon for all requests
end

% Compute the Moon ephemeris
MoonData = MoshierEphem(SiteInfo, MoonRequests);

% Now compute all the data offered by selenog and populate the additional
% fields into the MoonData
% There is one call to selenog foe each Julian Date. There is one Julian Date
% for each ephemeris point.
AllJD = []; % Accumulate Julian Dates of all ephemeris points
for iSite = 1:length(SiteInfo)
    for iReq = 1:length(MoonRequests)
        for iInter = 1:length(MoonData(iSite, iReq).JD)
          AllJD = [AllJD; MoonData(iSite, iReq).JD(iInter)];
        end
    end
end
% That was a bit crude, but at least the JD data order is clear

% Calculate the earth-sun radius vector in au if requested.

if exist('CalcSunEarthAU', 'var') && CalcSunEarthAU
  if exist('ple_earth') == 2 % the ple_earth function is available
    [HelioEarthLong, HelioEarthLat, SunEarthAU] = ple_earth(AllJD);
    % HelioEarthLong and HelioEarthLat are heliocentric longitude and
    % latitude in radians
    % Reshape these vectors into matrices of the correct size
    HelioEarthLong = reshape(HelioEarthLong, [length(SiteInfo) length(MoonRequests) length(MoonData(iSite, iReq).JD)]);
    HelioEarthLat  = reshape(HelioEarthLat,  [length(SiteInfo) length(MoonRequests) length(MoonData(iSite, iReq).JD)]);
    SunEarthAU     = reshape(SunEarthAU,     [length(SiteInfo) length(MoonRequests) length(MoonData(iSite, iReq).JD)]);
    
  else
    warning('Oran Ofek function ple_earth is not on the Matlab path. Please download.');
  end
else
  CalcSunEarthAU = 0;
end

% Generate the input file for selenog
MZPath = fileparts(which('MoshierMoon'));
fid = fopen([MZPath '\selenogInput.txt'], 'w');
fprintf(fid, '%f\n', AllJD);
fprintf(fid, '-1\n');
fclose(fid);
selenogCommand = [MZPath '\selenog.exe < ' MZPath '\selenogInput.txt > ' MZPath '\selenogOutput.txt'];
[Status, Output] = dos(selenogCommand);
if Status
    error(['Error encountered running selenog.exe : ' Output]);
end

% Open and read the output from selenog, adding it to the existing MoonData
fid = fopen([MZPath '\selenogOutput.txt'], 'r');
for iSite = 1:length(SiteInfo)
    for iReq = 1:length(MoonRequests)
        for iInter = 1:length(MoonData(iSite, iReq).JD)
          Line = fgetl(fid);
          while length(Line) < 3 || ~strcmp(Line(1:3), 'JED') % Scan lines until Julian Date Line found
            Line = fgetl(fid);
          end    
          Line = fgetl(fid);  % Libration Euler angles re mean ecliptic and equinox of date (radians):
          Line = fgetl(fid);
          Num = ScanLine(Line, ' phi  %f, theta  %f, psi %f', 3);
          MoonData(iSite, iReq).LibEul(iInter,:) = [Num(1) Num(2) Num(3)];
          Line = fgetl(fid); % Selenocentric unit vector toward pole of ecliptic:
          Line = fgetl(fid);
          Num = ScanLine(Line, ' p1  %f, p2  %f, p3  %f', 3);
          MoonData(iSite, iReq).SelenoPoleEclip(iInter,:) = [Num(1) Num(2) Num(3)] ;
          Line = fgetl(fid); % Geocentric Moon:
          Line = fgetl(fid);
          Num = ScanLine(Line, '  longitude %f, latitude %f degrees, distance %f au', 3);
          MoonData(iSite, iReq).GeoLongMoon(iInter,:) = Num(1);
          MoonData(iSite, iReq).GeoLatMoon(iInter,:)  = Num(2); 
          MoonData(iSite, iReq).GeoDistMoon(iInter,:)= Num(3);             
          Line = fgetl(fid); % Selenocentric unit vector toward the earth:
          Line = fgetl(fid);
          Num = ScanLine(Line, ' u1  %f, u2 %f, u3 %f', 3);
          MoonData(iSite, iReq).SelenoVecEarth(iInter,:) = [Num(1) Num(2) Num(3)];
          Line = fgetl(fid); % Selenographic direction of the earth:
          Line = fgetl(fid);
          Num = ScanLine(Line, '  longitude %f, latitude %f degrees', 2);
          MoonData(iSite, iReq).SelenoLongEarth(iInter,:) = Num(1);
          MoonData(iSite, iReq).SelenoLatEarth(iInter,:)  = Num(2); 
          EarthLat = deg2rad(Num(2));
          EarthLong = deg2rad(Num(1));
          EarthVec = [cos(EarthLat)*cos(EarthLong) cos(EarthLat)*sin(EarthLong) sin(EarthLat)]; 
          % MoonData(iSite, iReq).SelenoVecEarthCheck(iInter,:) = EarthVec; % Check SelenoVecEarth          
          Line = fgetl(fid); % J2000 mean equatorial libration Euler angles:
          Line = fgetl(fid);
          Num = ScanLine(Line, '   phi  %f, theta  %f, psi %f radians', 3);
          MoonData(iSite, iReq).J2000MeanLibEul(iInter,:) = [Num(1) Num(2) Num(3)];
          Line = fgetl(fid); % Geocentric J2000 mean equatorial moon:
          Line = fgetl(fid);
          Num = ScanLine(Line, '   x %f, y %f, z %f au', 3);
          MoonData(iSite, iReq).GeoJ2000MeanMoon(iInter,:) = [Num(1) Num(2) Num(3)];
          Line = fgetl(fid); % Heliocentric J2000 mean equatorial earth:
          Line = fgetl(fid);
          Num = ScanLine(Line, '   x %f, y  %f, z  %f au', 3);
          MoonData(iSite, iReq).HelioJ2000MeanEarth(iInter,:) = [Num(1) Num(2) Num(3)];
          Line = fgetl(fid); % Geocentric sun:
          Line = fgetl(fid);
          Num = ScanLine(Line, '   longitude %f degrees, latitude %f", distance %f au', 3);
          MoonData(iSite, iReq).GeoLongSun(iInter,:) = Num(1);
          MoonData(iSite, iReq).GeoLatSun(iInter,:)  = Num(2); 
          MoonData(iSite, iReq).GeoDistSun(iInter,:)= Num(3);             
          Line = fgetl(fid); % Selenocentric sun latitude:
          Line = fgetl(fid);
          Num = ScanLine(Line, '    longitude %f, latitude %f degrees', 2);
          MoonData(iSite, iReq).SelenoLongSun(iInter,:) = Num(1);
          MoonData(iSite, iReq).SelenoLatSun(iInter,:)  = Num(2);
          SunLat = deg2rad(Num(2));
          SunLong = deg2rad(Num(1));
          SunVec = [cos(SunLat)*cos(SunLong) cos(SunLat)*sin(SunLong) sin(SunLat)];
          MoonData(iSite, iReq).SelenoVecSun(iInter,:) = SunVec;
          MoonData(iSite, iReq).PhaseAngle(iInter,:) = acos(SunVec * EarthVec'); % Lunar phase angle in radians
          % Lunar phase angle for earth centre is very close to complementary to Elongation
          % Finally, if calculation of sun-earth radius vector was requested, add in those fields
          if CalcSunEarthAU
            MoonData(iSite, iReq).SunEarthAU(iInter, :) = SunEarthAU(iSite, iReq, iInter);
            MoonData(iSite, iReq).HelioEarthLong(iInter, :) = HelioEarthLong(iSite, iReq, iInter);
            MoonData(iSite, iReq).HelioEarthLat(iInter, :) = HelioEarthLat(iSite, iReq, iInter);
            % Use the cosine rule to compute the sun-moon distance
            MoonData(iSite, iReq).SunMoonAU(iInter, :) = sqrt(MoonData(iSite, iReq).SunEarthAU(iInter)^2 + ...
              MoonData(iSite, iReq).GeoDistMoon(iInter)^2 - ...
              2 * MoonData(iSite, iReq).SunEarthAU(iInter) * MoonData(iSite, iReq).GeoDistMoon(iInter) * ...
              cos(deg2rad(MoonData(iSite, iReq).Elong(iInter))));
                
          end
        end
    end
end
fclose(fid);

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

