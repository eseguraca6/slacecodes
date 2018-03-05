function theMTF2D = RevolveMTF(theMTF, padx, pady, method)
% RevolveMTF : Revolve 1D MTF into a 2D MTF for convenient filtering of 2D images
% Usage :
%   MTF2D = RevolveMTF(MTF, padx, pady)
%   MTF2D = RevolveMTF(MTF, padx, pady, interpmethod)
%   MTF2D = RevolveMTF(MTF, [],[], interpmethod) % no padding
% Where MTF is a 1-dimensional MTF as computed by PMTF for example.
% The image is padded with zeroes to dimensions of pady by padx.
% MTF must be a vector and padx, pady must be integer scalar and greater than
% twice the length of MTF.
% The interpolation method is linear unless the interpmethod input is given.
% See interp1 for methods of interpolation.
% Extrapolated values are set to 0. 
% If padx and pady are both empty (i.e. given as []) then no padding is done.
% Example :
% >> sp = 0:50:2000; % Spatial frequencies of 0 to 2000 cy/mm
% >> theMTF = MTFobs(0.0005, 1.0, 0.3, sp); % Monochromatic MTF at 500 nm wavelength, 
%                                           % F/1, central obscuration ratio of 0.3
% >> the2DMTF = RevolveMTF(theMTF, 128, 128); % Make 2d and zero pad to 128 by 128
% >> mesh(the2DMTF); % Show the 2D MTF
%
% In order to use the 2D MTF for filtering an image, fftshift must be used.

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

% Check inputs
if ~isvector(theMTF)
    error('RevolveMTF:MTF input must be a vector.');
end

x = 0:1:(length(theMTF)-1);
fullx = -(length(theMTF)-1):1:(length(theMTF)-1);
[X,Y] = meshgrid(fullx,fullx);
r = sqrt(X.^2 + Y.^2);
if exist('method', 'var')
  im2D = interp1(x, theMTF, r, method, 0);
else
  im2D = interp1(x, theMTF, r, 'linear', 0);  
end

% Pad with zeroes if requested

if ~isempty(padx) && ~isempty(pady)
    % check padx and pady
    padx = round(padx);
    pady = round(pady);
    if padx <= 2*length(theMTF) || pady <= 2*length(theMTF)
        error('RevolveMTF:padx and pady must be greater than twice the length of the 1D MTF input;');
    end
    if ~isscalar(padx) || ~isscalar(pady)
        error('RevolveMTF:padx and pady must be integer and scalar.');
    end
    pady2 = floor((pady - size(im2D,1))/2);
    padx2 = floor((padx - size(im2D,2))/2);
    theMTF2D = padarray(im2D, [pady2 padx2]); % May still be short of 1 element

    if size(theMTF2D,1) < pady
        theMTF2D = padarray(theMTF2D, [1 0], 0, 'pre');
    end

    if size(theMTF2D,2) < padx
        theMTF2D = padarray(theMTF2D, [0 1], 0, 'pre');
    end
else
    theMTF2D = im2D;
end
