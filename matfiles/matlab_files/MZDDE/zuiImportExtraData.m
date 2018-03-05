function  Status = zuiImportExtraData(SurfaceNumber)
% zImportExtraData - imports extra data and grid surface data values into an existing surface.
%
% Usage : Status = zuiImportExtraData(SurfaceNumber)
%
% Identical to zImportExtraData, except that a file dialog box is opened to navigate to the target file.
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
[fn, pn] = uigetfile('*.dat', 'Open ZEMAX Extra Data File');
FileName = [pn fn];
DDECommand = sprintf('ImportExtraData,%i,%s', SurfaceNumber, FileName);
Status = ddereq(ZemaxDDEChannel, DDECommand, [1 1], ZemaxDDETimeout);



