function NumSurfs = zNumSurfs
% zNumSurfs - Returns the number of surfaces in the current lens.
%
% Usage : NumSurfs = zNumSurfs
%
% See also : zGetSystem, zsGetSystem
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

LenSys = zGetSystem;
NumSurfs = LenSys(1);
