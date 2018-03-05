function SystemApertureData = zSetSystemAper(Type, StopSurf, ApertureValue)
% zSetSystemAper - Sets lens system aperture data.
%
% Usage : SystemApertureData = zSetSystemAper(Type, StopSurf, ApertureValue)
% The returned row vector is also formatted as follows:
% Type, StopSurf, ApertureValue
% This function sets the system aperture type (0, 1, 2, 3, 4, or 5 for Entrance Pupil Diameter, Image Space F/#,
% Object Space NA, Float by Stop Size, Paraxial Working F/#, or Object Cone Angle, respectively), the stop surface
% number, and the system aperture value. If the aperture type is Float by Stop Size, the aperture value is the stop
% surface semi-diameter.
% 
% See also zGetSystem and zGetSystemAper
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

global ZemaxDDEChannel ZemaxDDETimeout
DDECommand = sprintf('SetSystemAper,%i,%i,%1.20g', Type, StopSurf, ApertureValue);
Reply = ddereq(ZemaxDDEChannel, DDECommand, [1 1], ZemaxDDETimeout);
[col, count, errmsg] = sscanf(Reply, '%f,%f,%f');
SystemApertureData = col';
