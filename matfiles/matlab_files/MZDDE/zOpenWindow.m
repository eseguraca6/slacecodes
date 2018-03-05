function Status = zOpenWindow(ButtonCode)
% zOpenWindow - Request ZEMAX DDE server to open a new analysis window on the main ZEMAX screen. 
%
% Usage : Status = zOpenWindow(ButtonCode)
%
% The ButtonCode argument is a 3 character case-sensitive label that indicates the type of analysis to be performed.
% The 3 letter labels are identical to those used for the button bar in ZEMAX. A list of codes can be obtained
% by typing "help zemaxbuttons" in Matlab. The labels are case sensitive. 
%
% NB : The analysis data appearing in the window is for the lens in the LDE, not the lens in the DDE
% server.
%
% See also zGetMetaFile.
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
DDECommand = sprintf('OpenWindow,%s',ButtonCode);
Status = ddereq(ZemaxDDEChannel, DDECommand, [1 1], ZemaxDDETimeout);


