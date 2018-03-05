function SystemData = zGetSystem()
% zGetSystem - Gets a number of lens system operating data.
%
% Usage : SystemData = zGetSystem
% The returned row vector  is formatted as follows:
% numsurfs, unitcode, stopsurf, nonaxialflag, rayaimingtype, useenvdata, temp, pressure, globalrefsurf
% This item returns the number of surfaces, the unit code (0, 1, 2, or 3 for mm, cm, in , or M), the stop surf number,
% a flag to indicate if the system is non-axial symmetric (0 for false, that is it is axial, or 1 if the system is not axial),
% the ray aiming type (0, 1, 2 for none, paraxial, real), the use environment data flag (0 for no, 1 for yes), the current
% temperature and pressure, and the global coordinate reference surface number.
%
% See also zSetSystem and zGetSystemAper
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
Reply = ddereq(ZemaxDDEChannel, 'GetSystem', [1 1], ZemaxDDETimeout);
[ParmsCol,count,errmsg]= sscanf(Reply, '%f,%f,%f,%f,%f,%f,%f,%f,%f');
SystemData = ParmsCol';
