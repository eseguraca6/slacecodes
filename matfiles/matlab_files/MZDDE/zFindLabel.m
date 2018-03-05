function Surface = zFindLabel(Label)
% zFindLabel - Finds a previously labeled surface in the Zemax DDE client lens.
%
% Example : 
% LabeledSurface = zFindLabel(10)
%
% Finds the surface number which was labeled number 10 using the zSetLabel function.
%
% The returned value is the surface number of the first surface with the identical integer label, or -1 
% if no surface has the specified label. A return value of NaN (Not-a-Number) indicates that the command has timed out.
%
% See also zSetLabel and zGetLabel.
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
DDECommand = sprintf('FindLabel,%i',Label);
Reply = ddereq(ZemaxDDEChannel, DDECommand, [1 1], ZemaxDDETimeout);
if (Reply), Surface = str2num(Reply); else Surface = NaN; end;

