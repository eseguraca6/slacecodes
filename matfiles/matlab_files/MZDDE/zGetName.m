function LensName = zGetName()
% zGetName - Get the name of the lens in ZEMAX.
%
% Usage : Name = zGetName
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
LensName = ddereq(ZemaxDDEChannel, 'GetName', [1 1], ZemaxDDETimeout);


