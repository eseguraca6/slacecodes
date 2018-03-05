function Status = zNewLens()
% zNewLens - Erases the current lens in the ZEMAX DDE server.
%
% Usage : Status = zNewLens
%
% This function erases the current lens. The 'minimum' lens that remains is identical to the lens in the Lens Data
% Editor when 'File, New' is selected. No prompt to save the existing lens is given.
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
Status = ddereq(ZemaxDDEChannel, 'NewLens', [1 1], ZemaxDDETimeout);

