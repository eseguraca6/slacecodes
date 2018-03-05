function ExtraData = zGetExtra(SurfaceNumber, ColumnNumber)
% zGetExtra - Requests extra data on a surface from the Zemax DDE server.
%
% zGetExtra(SurfaceNumber, ColumnNumer)
% Returns numeric data value for surface SurfaceNumber under column ColumnNumber.
%
% See also zSetExtra.
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
DDECommand = sprintf('GetExtra,%i,%i',SurfaceNumber,ColumnNumber);
Reply = ddereq(ZemaxDDEChannel, DDECommand, [1 1], ZemaxDDETimeout);
[ExtraData, count, errmsg] = sscanf(Reply, '%f');


