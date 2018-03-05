% Cross correlation of unit circle with circle of radius e.
% This script does the symbolic integration for implementation of the cross correlation.
% Requires symbolic toolbox.

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


syms sigma e x w x_w y1 y2 ln2
% Have circular aperture of radius unity centered at the origin
y1 = sqrt(1-x^2);

% Have another circular aperture of radius e centered at x=w
y2 = sqrt(e^2-(x-w)^2);

% Solve for the intersection of the circles
% The x coordinate of the intersection point between the circles is at x_w
x_w = solve(y1 - y2);


% The area of overlap between the two circles is a sum of two integrals
A = 2 * int(y2,x, w-e, x_w) + 2 * int(y1,x, x_w, 1);

A = simple(A);
sA = subexpr(A);

sigma1 = sqrt(( e+w+1)*(e-w+1)*(e+w-1)*(e-w-1));

% Simplification of sA yields the following
Ce=-sigma/2+(e^2-1)*ln2-e^2*log(-(w^2-1+e^2-sigma)/w)+e^2*log(-e)+log(-(-1-w^2+e^2-sigma)/w);

Cd = e^2 * log(2*e*w / (w^2 + e^2 - sigma - 1)) + log((w^2 - e^2 + sigma + 1)/(2*w)) - sigma/2;

% Attempt to compute the integrals without luck
% intCe = int(Ce,w,1-e,1+e);
