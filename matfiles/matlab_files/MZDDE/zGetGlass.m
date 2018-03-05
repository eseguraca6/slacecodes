function [GlassName,nd,vd,dpgf] = zGetGlass(SurfaceNumber)
% zGetGlass - Requests data on the glass at a lens surface from the Zemax DDE server.
%
% Usage : [GlassName,nd,vd,dpgf] = zGetGlass(SurfaceNumber)
% 
% name is the glass name as a string, nd is the refractive index at the d line, vd is the Abbe dispersion and 
% dpgf is the relative partial dispersion. The last three are numeric.
%
% If the specified surface is not valid, is not made of glass, or is gradient index, the returned vector is empty.
% Data may be meaningless for glasses defined only outside of the FdC band.
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
DDECommand = sprintf('GetGlass,%i',SurfaceNumber);
Reply = ddereq(ZemaxDDEChannel, DDECommand, [1 1], ZemaxDDETimeout);
if size(Reply,2) > 1
   [GlassName, Reply] = strtok(Reply, ' ,');
   [col, count, errmsg] = sscanf(Reply, ',%f,%f,%f');
   nd = col(1);
   vd = col(2);
   dpgf = col(3);
else
   GlassName = [];
   nd = []; vd = []; dpgf = [];
end




