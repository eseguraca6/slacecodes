function [cross,sigma] = CCCircle(e,w)
% CCCircle(e,w) - Cross correlation of unit circle with circle of radius e.
% Computes the cross-correlation of a circular aperture of unit radius at the origin, 
% with a circular aperture of radius e, with centre-to-centre displacements of w.
% e must be >=0 and e < 1

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

if (e < 0) || (e >=1)
    error('e must be >=0 and e < 1');
end

% Find the values that are out of range
% The formula below is only valid for w=1-e to w=1+e
w(find(w < 1-e)) = 1-e;
w(find(w > 1+e)) = 1+e;

sigma = sqrt(( e+w+1).*(e-w+1).*(e+w-1).*(e-w-1));
%cross = -sigma/2+(e^2-1)*log(2)-e^2*log(-(w.^2-1+e^2-sigma)./w)+e^2*log(-e)+log(-(-1-w.^2+e^2-sigma)./w);
% Cross check
%   Ce = -sigma/2+(e^2-1)*ln2   -e^2*log(-(w^2 -1+e^2-sigma) /w)+e^2*log(-e)+log(-(-1-w^2 +e^2-sigma) /w);

% A simplified expression
cross = e^2 * log(2*e*w ./ (w.^2 + e^2 - sigma - 1)) + log((w.^2 - e^2 + sigma + 1)./(2*w)) - sigma/2;
cross = abs(cross); % Actually the imaginary part
