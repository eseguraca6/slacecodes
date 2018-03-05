function AspectRatio = zGetAspect(FileName)
% zGetAspect - Returns the aspect ratio of a Zemax graphics or print window.
%
% zGetAspect(FileName)
%
% where filename is the name of the temporary file associated with the window being created or updated. If the
% temporary file name is the empty string ''; then the default aspect ratio and width (or height) is returned.
%
% This function extracts the graphic display aspect ratio and the width or height of the printed page in current lens
% units. For example, If the current aspect ratio is 3 x 4, the aspect ratio returned will be 0.75. Knowing the correct
% aspect ratio is required when drawing isometric plots. The format of the returned row vector is aspect, width. If the aspect
% ratio is greater than 1, then the plot is taller than it is wide, and the format of returned row vector is aspect, height.
% 
% See Also : zMakeGraphicWindow, zMakeTextWindow
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
if size(FileName,2) == 0
  DDECommand = 'GetAspect';
else 
  DDECommand = sprintf('GetAspect,%s', FileName);
end
Reply = ddereq(ZemaxDDEChannel, DDECommand, [1 1], ZemaxDDETimeout);
[cols, count, errmsg] = sscanf(Reply, '%f,%f');
AspectRatio = cols';
