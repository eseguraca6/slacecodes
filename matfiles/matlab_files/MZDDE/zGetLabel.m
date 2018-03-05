function Label = zGetLabel(SurfaceNumber)
% zGetLabel -  Retrieve the integer label attached to a surface in the ZEMAX lens.
%
% Usage : Label = zGetLabel(SurfaceNumber)
% The returned value is the label. A return value of NaN (Not-a-Number) indicates that the command has timed out.
% 
% See also : zSetLabel, zFindLabel
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
DDECommand = sprintf('GetLabel,%i',SurfaceNumber);
Reply = ddereq(ZemaxDDEChannel, DDECommand, [1 1], ZemaxDDETimeout);
if (Reply), Label = str2num(Reply); else Label = -998; end;

