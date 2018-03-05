function auto = ACCircle(e,w)
% ACCircle(e,w) - Autocorrelation of a circular aperture of radius e
% Computes the autocorrelation of a circular aperture of radius e 
% with centre-to-centre displacements of w.

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

% The equation below is only valid up to w = 2*e
w(find(w > 2*e)) = 2*e;

surd = sqrt(w.^2 - 4*e^2);
%auto = -(w .* surd - 4 * e^2 * log(surd + w))/2 - 2 * e^2 * log(2 * e);

auto = 2 * e^2 * log((surd + w)/(2*e)) - w.*surd/2;
auto = abs(auto);
