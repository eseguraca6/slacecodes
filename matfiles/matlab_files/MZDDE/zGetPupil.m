function PupilData = zGetPupil()
% zGetPupil - Gets the aperture stop and pupil data from ZEMAX.
%
% Usage : PupilData = zGetPupil
% The returned row vector is formatted as follows:
% type, value, ENPD, ENPP, EXPD, EXPP, apodization_type, apodization_factor"
% The parameter type is an integer indicating the system aperture type, a number between 0 and 5, for entrance
% pupil diameter, image space F/#, object space NA, float by stop size, paraxial working F/#, or object cone angle,
% respectively. The value is the system aperture value, unless float by stop size is being used, in which case the
% value is the stop surface semi-diameter. The next 4 values are the entrance pupil diameter, entrance pupil
% position, exit pupil diameter, and exit pupil position, all in lens units. The apodization_type is an integer which is
% set to 0 for none, 1 for Gaussian, 2 for Tangential. The apodization_factor is the number shown on the general
% data dialog box.
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
Reply = ddereq(ZemaxDDEChannel, 'GetPupil', [1 1], ZemaxDDETimeout);
[col, count, errmsg] = sscanf(Reply, '%f,%f,%f,%f,%f,%f,%f,%f');
PupilData = col';

