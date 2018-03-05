function LensFile = zGetFile()
% zGetFile - Requests the filename of the lens currently loaded into ZEMAX.
%
% Usage : LensFilePath = zGetFile
% Returns the full drive, path and name.
%
% Extreme caution should be used if the file is to be tampered with,
% since at any time ZEMAX may read or write from/to this file.
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
LensFile = ddereq(ZemaxDDEChannel, 'GetFile', [1 1], ZemaxDDETimeout);


