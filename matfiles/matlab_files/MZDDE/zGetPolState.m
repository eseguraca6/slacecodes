function DefaultPolState = zGetPolState()
% zGetPolState - Gets the default polarization state set by the user.
%
% Usage : DefaultPolState = zGetPolState
% The row vector returned is formatted as follows:
% nIsPolarized, Ex, Ey, Phax, Phay
% If nIsPolarized is anything other than zero, then the default polarization state is unpolarized. Otherwise, the
% Ex, Ey, Phax, and Phay values are used to define the polarization state. Ex and Ey should each be normalized
% to a magnitude of unity, although this is not required. Phax and Phay are in degrees. 
%
% See also zSetPolState.
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
Reply = ddereq(ZemaxDDEChannel, 'GetPolState', [1 1], ZemaxDDETimeout);
[col, count, errmsg] = sscanf(Reply, '%f,%f,%f,%f,%f');
DefaultPolState = col';
