function DefaultPolState = zSetPolState(nIsPolarized, Ex, Ey, Phax, Phay)
% zGetPolState - Sets the default polarization state used for ZEMAX polarization ray tracing.
%
% Usage : DefaultPolState = zSetPolState(nIsPolarized, Ex, Ey, Phax, Phay)
% If nIsPolarized is anything other than zero, then the default polarization state is unpolarized. Otherwise, the
% Ex, Ey, Phax, and Phay values are used to define the polarization state. Ex and Ey should each be normalized
% to a magnitude of unity, although this is not required. Phax and Phay are in degrees. 
%
% The row vector returned is formatted as follows:
% nIsPolarized, Ex, Ey, Phax, Phay
%
% See also zGetPolState.
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
DDECommand = sprintf('SetPolState,%i,%1.20g,%1.20g,%1.20g,%1.20g', nIsPolarized, Ex, Ey, Phax, Phay);
Reply = ddereq(ZemaxDDEChannel, DDECommand, [1 1], ZemaxDDETimeout);
[col, count, errmsg] = sscanf(Reply, '%f,%f,%f,%f,%f');
DefaultPolState = col';
