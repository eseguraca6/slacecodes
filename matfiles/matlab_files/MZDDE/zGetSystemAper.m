function SystemApertureData = zGetSystemAper()
% zGetSystemAper - Gets lens system aperture data.
%
% Usage : SystemApertureData = zGetSystemAper
% The returned row vector is formatted as follows:
% type, stopsurf, aperture_value
% This item returns the system aperture type (0, 1, 2, 3, 4, or 5 for Entrance Pupil Diameter, Image Space F/#,
% Object Space NA, Float by Stop Size, Paraxial Working F/#, or Object Cone Angle, respectively), the stop surface
% number, and the system aperture value. If the aperture type is Float by Stop Size, the aperture value is the stop
% surface semi-diameter.
% 
% See also zGetSystem and zSetSystemAper
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
Reply = ddereq(ZemaxDDEChannel, 'GetSystemAper', [1 1], ZemaxDDETimeout);
[col, count, errmsg] = sscanf(Reply, '%f,%f,%f');
SystemApertureData = col';
