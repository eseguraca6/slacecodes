function Reply = zSetFloat()
% zSetFloat - sets all surfaces without surface apertures to have floating apertures.
%
% Usage : Reply = zSetFloat
% This function sets all surfaces without surface apertures to have floating apertures. Floating apertures will vignette
% rays which trace beyond the semi-diameter. 
% The returned value is the string 'OK'.
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
Reply = ddereq(ZemaxDDEChannel, 'SetFloat', [1 1], ZemaxDDETimeout);


