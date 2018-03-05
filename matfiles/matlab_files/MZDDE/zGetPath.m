function [ZEMAXPath, LensPath] = zGetPath()
% zGetPath - Get the full path name to the directory where ZEMAX is
% installed and the default lens directory path.
%
% Usage : [ZEMAXPath, LensPath] = zGetPath
%
% This item extracts the full path name to the directory where ZEMAX is installed, and the path name to the
% default directory for lenses.
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
Paths = ddereq(ZemaxDDEChannel, 'GetPath', [1 1], ZemaxDDETimeout);
[ZEMAXPath, Paths] = strtok(Paths,',');
ZEMAXPath = deblank(ZEMAXPath);
LensPath = strtok(Paths, ',');
LensPath = deblank(LensPath);




