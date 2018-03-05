function Label = zSetLabel(SurfaceNumber,LabelNumber)
% zSetLabel - Attach an integer label to a surface in the ZEMAX lens.
%
% zSetLabel(SurfaceNumber, LabelNumber)
% The returned value is the label number.
% A return value of -998 indicates that the command has timed out.
%
% See also : zGetLabel, zFindLabel
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
DDECommand = sprintf('SetLabel,%i,%i',SurfaceNumber,LabelNumber);
Reply = ddereq(ZemaxDDEChannel, DDECommand, [1 1], ZemaxDDETimeout);
if (Reply), Label = str2num(Reply); else Label = -998; end;
