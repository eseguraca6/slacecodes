function Comment = zGetComment(SurfaceNumber)
% zGetComment - Requests comment for a Zemax surface number.
%
% zGetComment(SurfaceNumber)
%
% Returns a string.
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
DDECommand = sprintf('GetComment,%i',SurfaceNumber);
Comment = ddereq(ZemaxDDEChannel, DDECommand, [1 1], ZemaxDDETimeout);

