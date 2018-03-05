% Example of usage of the function MoshierMoon
% $Revision:$
% $Author:$
 clear all 
 close all
% Compute data for Moon for 2 locations
% Set up the parameters of the observer site
 SiteInfo(1).Lat = -27; % degrees latitude
 SiteInfo(1).Long = 28; % degrees longitude
 SiteInfo(1).Alt = 1400; % metres AMSL
 SiteInfo(1).Press = 1012; % millibars atm pressure
 SiteInfo(1).Temp = 25; % degrees C
 SiteInfo(1).UTTDT = 2; % input times will be UTC
 SiteInfo(2).Lat = 27; % degrees latitude
 SiteInfo(2).Long = 30; % degrees longitude
 SiteInfo(2).Alt = 1400; % metres AMSL
 SiteInfo(2).Press = 1012; % millibars atm pressure
 SiteInfo(2).Temp = 25; % degrees C
 SiteInfo(2).UTTDT = 2; % input times will be UTC

% Set up Moon ephemeris calculation request
 MoonRequests(1).DateTime = [2008 2 13 18 0 0]; % 2008-02-13 18:00:00 UT
 MoonRequests(1).Interval = 1; % days between ephemeris points
 MoonRequests(1).NumInter = 3; % 3 points 1 day apart
 MoonRequests(2).DateTime = [2009 3 13 18 0 0]; % 2008-02-13 18:00:00 UT
 MoonRequests(2).Interval = 1; % days between ephemeris points
 MoonRequests(2).NumInter = 3; % 3 points 1 day apart

 % Compute the ephemeris
 MoonData = MoshierMoon(SiteInfo, MoonRequests);
