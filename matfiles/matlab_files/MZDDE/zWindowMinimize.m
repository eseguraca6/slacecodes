function Reply = zWindowMinimize(WindowNumber)
% zWindowMinimize - Minimize a ZEMAX window.
%
% Usage : Reply = zWindowMinimize(WindowNumber)
%
% Use WindowNumber of 0 to minimize the main ZEMAX window.
% Replies with the string 'OK' when done.
%
% See also zWindowMaximize
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
DDECommand = sprintf('WindowMinimize,%i', WindowNumber);
Reply = ddereq(ZemaxDDEChannel, DDECommand, [1 1], ZemaxDDETimeout);
