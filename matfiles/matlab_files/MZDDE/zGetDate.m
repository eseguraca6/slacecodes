function Date = zGetDate()
% zGetDate - Requests current date from the Zemax DDE server.
% 
% Usage : Date = zGetDate
% zGetDate returns a string.
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
Date = ddereq(ZemaxDDEChannel, 'GetDate', [1 1], ZemaxDDETimeout);

