function TF = CTF_eye(spf, L, w, numeyes)
% CTF_eye : CTF_eye(spf, L, w, numeyes)
% Calculates the condensed version of the Barten CTF where
%    spf are the spatial frequencies in cycles per milliradian
%    L is the average luminance of the viewing area in cd/m^2
%    w is the angular width of a square viewing area (or the square root of the angular viewing area)
%    numeyes is the number of eyes (1 or 2) used for viewing.
%
% Example :
% >> spf = 0:.01:3; % Spatial frequencies up to 3 cycles per mrad
% >> L = [0.001 0.01 0.1 1 10 100 1000] * 3.43; % Log scale of luminance levels in cd/m^2
% >> w = 10; % Square display of width 10 degrees at eye
% >> theCTF = CTF_eye(spf, L, w, 2); % Compute CTF for 2 eyes at all
%                                    % spatial frequencies and luminance levels.
%                       
% numeyes may not be a vector. Other inputs may be vector or scalar.
% Since CTF in excess of 1 is not defined, Not-a-Number (NaN) is returned
% for any combination of inputs resulting in CTF greater than 1. This can
% cause NaNs in your ultimate outputs.
%
% Reference :
% Barten, P. G. J. (2003),'Formula for the contrast sensitivity of the human eye', Image Quality and System Performance 5294(1), 
% in Yoichi Miyake & D. Rene Rasmussen, ed., SPIE, 231-238.

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

if ~isscalar(numeyes)
    error('CTF_eye::Number of eyes must be scalar.');
end
if ~(numeyes == 1 || numeyes == 2)
    error('CTF_eye::Number of eyes must be one or two !');
end

if (~isscalar(w)) && (~isvector(w))
    error('CTF_eye::Angular size of display must be scalar or vector.')
end
if (~isscalar(spf)) && (~isvector(spf))
    error('CTF_eye::Spatial frequencies spf must be scalar or vector.');
end
if (~isscalar(L)) && (~isvector(L))
    error('CTF_eye::Luminance values must be scalar or vector.');
end

[spf, L, w] = ndgrid(spf, L, w); % Distribute onto a grid

% Convert the spatial frequencies to cycles per degree
u = 1000 * pi * spf ./ 180;
u(find(u==0)) = NaN; % Eliminate divide by zero at spatial frequency of zero

num = (540 * (1 + 0.7 ./ L).^-0.2);
denom = (1 + 12 ./ (w .* (1 + u ./ 3).^2));
c = 0.06;
b = 0.3 * (1 + 100 ./ L).^0.15;


a = num ./ denom;
TF = 1 ./ (a .* u .* exp(-b .* u) .* sqrt(1 + c .* exp(b .* u)));
TF = squeeze(TF); % Squeeze out singleton dimensions

if numeyes == 1
    TF = TF * sqrt(2);
end
TF(find(TF>1)) = NaN; % CTF above 1 means that CTF is undefined

