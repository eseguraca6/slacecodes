function  Status = zImportExtraData(SurfaceNumber, FileName)
% zImportExtraData - imports extra data and grid surface data values into an existing surface.
%
% Usage : Status = zImportExtraData(SurfaceNumber, FileName)
%
% This import function is used to load extra data values for extra data surfaces from an ASCII file rather than
% by typing the numbers in directly. SurfaceNumber specifies which surface number should
% receive the data. Numerical data must be in the ASCII file exactly as it appears in the extra data spreadsheet.
% The format of the ASCII file is a single column of free-format numbers, and the file should end in the DAT
% extension. 
% 
% For details of the ASCII format for grid sag surfaces, see the Chapter on 'Surface Types' in the ZEMAX manual.
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
DDECommand = sprintf('ImportExtraData,%i,%s', SurfaceNumber, FileName);
Status = ddereq(ZemaxDDEChannel, DDECommand, [1 1], ZemaxDDETimeout);


