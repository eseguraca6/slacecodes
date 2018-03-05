function zsSystemParms = zsGetSystem()
% zsGetSystem - Get lens system global operating parameters in a struct.
%
% Usage : zsSystemParms = zsGetSystem
% Returns a structure with the following fields.
% numsurfs, unitcode, stopsurf, nonaxialflag, rayaimingtype, useenvdata, temp, pressure, globalrefsurf
% This structure contains the number of surfaces, the unit code (0, 1, 2, or 3 for mm, cm, in , or M), the stop surf number,
% a flag to indicate if the system is non-axial symmetric (0 for false, that is it is axial, or 1 if the system is not axial),
% the ray aiming type (0, 1, 2 for none, paraxial, real), the use environment data flag (0 for no, 1 for yes), the current
% temperature and pressure, and the global coordinate reference surface number.
%
% See also zSetSystem, zsSetSystem, zGetSystem

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
ZemaxParms = zGetSystem;
zsSystemParms = struct('numsurfs',ZemaxParms(1),'unitcode', ZemaxParms(2), 'stopsurf', ZemaxParms(3), 'nonaxialflag', ZemaxParms(4), 'rayaimingtype', ZemaxParms(5), 'useenvdata', ZemaxParms(6), 'temp', ZemaxParms(7), 'pressure', ZemaxParms(8), 'globalrefsurf', ZemaxParms(9));







