function Reply = zWindowMaximize(WindowNumber)
% zWindowMaximize - Maximize a ZEMAX window.
%
% Usage : Reply = zWindowMaximize(WindowNumber)
%
% Use WindowNumber of 0 to Maximize the main ZEMAX window.
% Replies with the string 'OK' when done.
%
% See also zWindowMinimize
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
DDECommand = sprintf('WindowMaximize,%i', WindowNumber);
Reply = ddereq(ZemaxDDEChannel, DDECommand, [1 1], ZemaxDDETimeout);
