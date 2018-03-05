function [DLLFilename, SurfaceName] = zGetSurfaceDLL(SurfaceNumber)
% zGetSurfaceDLL - extracts the name of the DLL if the surface is a user defined type.
%
% Usage : [DLLFilename, SurfaceName] = zGetSurfaceDLL(SurfaceNumber)
%
% The DLLFilename is the name of the defining DLL, the SurfaceName is the string displayed by the DLL in the surface
% type column of the Lens Data Editor.
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
DDECommand = sprintf('GetSurfaceDLL,%i', SurfaceNumber);
Reply = ddereq(ZemaxDDEChannel, DDECommand, [1 1], ZemaxDDETimeout);
[DLLFilename, Reply] = strtok(Reply,' ,');
[SurfaceName, count, errmsg] = sscanf(Reply, ',%s');




