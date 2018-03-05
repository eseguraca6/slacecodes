function Value = zSetExtra(SurfaceNumber, ColumnNumber, Value)
% zSetExtra - Sets extra data at a lens surface.
%
% Usage : Value = zSetExtra(SurfaceNumber, ColumnNumber, Value)
%
% The returned data is the Value 
%
% See also zGetExtra

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
DDECommand = sprintf('SetExtra,%i,%i,%1.20g',SurfaceNumber,ColumnNumber,Value);
Reply = ddereq(ZemaxDDEChannel, DDECommand, [1 1], ZemaxDDETimeout);
[Value, count, errmsg] = sscanf(Reply, '%f');



