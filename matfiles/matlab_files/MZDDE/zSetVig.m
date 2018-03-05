function Reply = zSetVig()
% zSetVig - Performs automatic setting of vignetting factors.
%
% Usage : Reply = zSetVig
% Requests ZEMAX to set the vignetting factors automatically. There are no parameters. The reply is
% the string 'OK'.
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
Reply = ddereq(ZemaxDDEChannel, 'SetVig', [1 1], ZemaxDDETimeout);

