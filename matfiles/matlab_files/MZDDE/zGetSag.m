function SagData = zGetSag(SurfaceNumber, x, y)
% zGetSag - Returns the sag of any lens surface.
%
% Usage : SagData = zGetSag(SurfaceNumber, x, y)
% where SurfaceNumber is the surface number, and x and y are the coordinates on the surface for which 
% the sag is to be computed. The returned row vector is formatted as sag, alternatesag. 
% The values for x, y, and the sag are all in lens units.
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
DDECommand = sprintf('GetSag,%i,%1.20g,%1.20g',SurfaceNumber, x, y);
Reply = ddereq(ZemaxDDEChannel, DDECommand, [1 1], ZemaxDDETimeout);
[col, count, errmsg] = sscanf(Reply, '%f,%f');
SagData = col';


