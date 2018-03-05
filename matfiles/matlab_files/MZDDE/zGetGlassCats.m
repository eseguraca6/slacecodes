function GlassCatList = zGetGlassCats()
% zGetGlassCats - Get a list of available glass catalogs from the ZEMAX Glasscat directory.
%
% Usage : GlassCatList = zGetGlassCats
%
% Returns a cell array of all available glass catalogs in the glass catalog directory
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
% $Author: DGriffith $

[ZEMAXPath, LensPath] = zGetPath;
GlassCatDir = [ZEMAXPath '\Glasscat'];
GlassCats = dir([GlassCatDir '\*.agf']);
for i = 1:size(GlassCats)
    [Path, GlassCatList{i}] = fileparts(GlassCats(i).name); 
end
GlassCatList = GlassCatList';
