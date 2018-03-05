function FirstOrderData = zGetFirst()
% zGetFirst - Requests first order operating data on current lens in ZEMAX.
%
% Usage : FirstOrderData = zGetFirst
% zGetFirst returns a numeric row vector having the following columns focal, pwfn, rwfn, pima, pmag.
% Values in the vector are the EFL, paraxial working F/#, real working F/#, paraxial image height, and paraxial
% magnification.
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
Reply = ddereq(ZemaxDDEChannel, 'GetFirst', [1 1], ZemaxDDETimeout);
[cols, count, errmsg] = sscanf(Reply, '%f,%f,%f,%f,%f');
FirstOrderData = cols';
