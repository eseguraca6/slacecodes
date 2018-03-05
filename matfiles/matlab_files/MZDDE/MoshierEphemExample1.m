% Example of usage of the function MoshierEphem
% $Revision: 221 $
% $Author: DGriffith $
 clear all 
 close all
%  Compute ephemerides for Sun, Moon and Venus as seen from
%  two locations.
% Set up the parameters of the first site location etc.
 SiteInfo(1).Lat = -27; % degrees latitude
 SiteInfo(1).Long = 28; % degrees longitude
 SiteInfo(1).Alt = 1400; % metres AMSL
 SiteInfo(1).Press = 1012; % millibars atm pressure
 SiteInfo(1).Temp = 25; % degrees C
 SiteInfo(1).UTTDT = 2; % input times will be UTC
% Now set up the second site info
 SiteInfo(2).Lat = -27; % degrees latitude
 SiteInfo(2).Long = 20; % degrees longitude
 SiteInfo(2).Alt = 1200; % metres AMSL
 SiteInfo(2).Press = 1016; % millibars atm pressure
 SiteInfo(2).Temp = 18; % degrees C
 SiteInfo(2).UTTDT = 2; % input times will be UTC
% Set up ephemeris calculation requests for Sun, Moon and Venus
 EphRequests(1).DateTime = [2008 2 13 18 0 0]; % 2008-02-13 18:00:00 UT
 EphRequests(1).Interval = 1; % days between ephemeris points
 EphRequests(1).NumInter = 3; % 3 points 1 day apart
 EphRequests(1).Object = 0; % The sun
 EphRequests(2).DateTime = [2008 2 13 18 0 0]; % 2008-02-13 18:00:00 UT
 EphRequests(2).Interval = 1; % days between ephemeris points
 EphRequests(2).NumInter = 3; % 3 points 1 day apart
 EphRequests(2).Object = 3; % The Moon
 EphRequests(3).DateTime = [2008 2 13 18 0 0]; % 2008-02-13 18:00:00 UT
 EphRequests(3).Interval = 1; % days between ephemeris points
 EphRequests(3).NumInter = 3; % 3 points 1 day apart
 EphRequests(3).Object = 2; % Venus
% Compute the ephemeris
 Ephemeris = MoshierEphem(SiteInfo, EphRequests);
% Print out the rise times for Sun, Moon and Venus at first site
 datestr(Ephemeris(1,1).RisesDT)
 datestr(Ephemeris(1,2).RisesDT)
 datestr(Ephemeris(1,3).RisesDT)
