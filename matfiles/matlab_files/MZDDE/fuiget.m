function fullfilename = fuiget(varargin)
% fuiget - Simplified uiget
% Usage : As for uiget, except that the full path and filename of the selected file is returned.
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

% $Revision: 221 $
% $Author: DGriffith $

[filename, pathname] = uigetfile(varargin{:});
fullfilename = [pathname filename];



