function BayIm = Bayerize(Im, UnitCell)
% Bayerize : Simulate effect of Bayer filter on a colour image
%
% A Bayer filter is a colour mosaic filter placed on a CCD or CMOS
% focal plane array. For further information, see
%  Holst, G.C., "CCD Arrays, Cameras and Displays", SPIE Press, 1998
%
% This function is intended to be used after ModelFPAImage in order
% to model the degradation of performance that could be expected
% due to a Bayer colour filter.
%
% Usage :
% >> BayerIm = Bayerize(Image)
% >> BayerIm = Bayerize(Image, UnitCell)
% Where,
%  Image is the 3-channel RGB input image.
%
%  UnitCell is a matrix of four channel numbers giving
%     the pixel order. Only four possibilities are
%     allowed, being [1 2;2 3], [3 2;2 1], [2 3; 1 2]
%     or [2 1;3 2]. The full Bayer filter pattern
%     is created by using repmat to replicate the
%     unit cell to cover the whole image. Channel 1
%     is usually the red channel, 2 is green and 3 is
%     blue.
%
%  This routine uses a form of bilinear interpolation.
%  There are numerous superior methods of interpolation.
%  See the documentation on dcraw (Dave Coffin's RAW
%  camera file processor).
%  See also http://www.csee.wvu.edu/~xinl/demo/demosaic.html
%  and the related paper. 
%  Li, "Demosaicing by Successive Approximation," IEEE Trans. 
%     Image Processing, Feb. 2005 
%
% See also : ModelFPAImage, demosaic (Image Processing Toolbox)

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


if ~exist('UnitCell', 'var')
    UnitCell = [1 2;2 3]; % default
else
    if ~isnumeric(UnitCell)
        error('UnitCell input must be numeric.')
    end
    if all(UnitCell == [1 2;2 3]) || all(UnitCell == [3 2;2 1]) || all(UnitCell == [2 1;3 2]) || all(UnitCell == [2 3;1 2])
    % all is well
    else
      error('UnitCell input is wrong. See help.');  
    end
end

if ~isnumeric(Im) || size(Im,1) < 5 || size(Im,2) < 5 || size(Im,3) ~= 3
    error('Input Image must be numeric RGB with at least 5 by 5 pixels.')
end

% Done Checking
% Create a full bayer pattern mosaic the same size as the Image
Pixrows = size(Im,1);
Pixcols = size(Im,2);
Bayermos = repmat(uint8(UnitCell), ceil(Pixrows/2), ceil(Pixcols/2)); % keep as small as possible
Bayermos = Bayermos(1:Pixrows, 1:Pixcols);
for ichan = 1:3 % Run throught the colour channels
    % Create a working areas that are 1 pixel larger than the image all round
    numerator = zeros(Pixrows + 2, Pixcols + 2);
    denominator = zeros(Pixrows + 2, Pixcols + 2);
    % Find the pixels sampled in this channel
    Chanpix = Bayermos == ichan;
    Chandata = Chanpix .* Im(:,:,ichan);
    % shift and sum in up and down directions for all channels
    numerator(2:(1+Pixrows),2:(1+Pixcols)) = Chandata; % Extract the original pixels we will be using
    denominator(2:(1+Pixrows),2:(1+Pixcols)) = Chanpix;
    % Shift up one pixel
    numerator(1:Pixrows, 2:(1+Pixcols)) = numerator(1:Pixrows, 2:(1+Pixcols)) + Chandata;
    denominator(1:Pixrows, 2:(1+Pixcols)) = denominator(1:Pixrows, 2:(1+Pixcols)) + Chanpix;
    % Shift down one pixel
    numerator(3:(2+Pixrows), 2:(1+Pixcols)) = numerator(3:(2+Pixrows), 2:(1+Pixcols)) + Chandata;
    denominator(3:(2+Pixrows), 2:(1+Pixcols)) = denominator(3:(2+Pixrows), 2:(1+Pixcols)) + Chanpix;
    % Shift left 1 pixel
    numerator(2:(1+Pixrows), 1:Pixcols) = numerator(2:(1+Pixrows), 1:Pixcols) + Chandata;
    denominator(2:(1+Pixrows), 1:Pixcols) = denominator(2:(1+Pixrows), 1:Pixcols) + Chanpix;
    % Shift right 1 pixel
    numerator(2:(1+Pixrows), 3:(2+Pixcols)) = numerator(2:(1+Pixrows), 3:(2+Pixcols)) + Chandata;
    denominator(2:(1+Pixrows), 3:(2+Pixcols)) = denominator(2:(1+Pixrows), 3:(2+Pixcols)) + Chanpix;
        
    if ichan ~= 2 % red and blue channels must be done in diagonal directions as well
        % Shift up and left one pixel
        numerator(1:Pixrows, 1:Pixcols) = numerator(1:Pixrows, 1:Pixcols) + Chandata;
        denominator(1:Pixrows, 1:Pixcols) = denominator(1:Pixrows, 1:Pixcols) + Chanpix;
        % Shift down and right
        numerator(3:(2+Pixrows), 3:(2+Pixcols)) = numerator(3:(2+Pixrows), 3:(2+Pixcols)) + Chandata;
        denominator(3:(2+Pixrows), 3:(2+Pixcols)) = denominator(3:(2+Pixrows), 3:(2+Pixcols)) + Chanpix;
        % Shift down and left
        numerator(3:(2+Pixrows), 1:Pixcols) = numerator(3:(2+Pixrows), 1:Pixcols) + Chandata;
        denominator(3:(2+Pixrows), 1:Pixcols) = denominator(3:(2+Pixrows), 1:Pixcols) + Chanpix;
        % Shift up and right
        numerator(1:Pixrows, 3:(2+Pixcols)) = numerator(1:Pixrows, 3:(2+Pixcols)) + Chandata;
        denominator(1:Pixrows, 3:(2+Pixcols)) = denominator(1:Pixrows, 3:(2+Pixcols)) + Chanpix;        
    end
    BayIm(:,:,ichan) = numerator ./ denominator;
    %Chanpix
    %denominator
end
BayIm = BayIm(2:Pixrows, 2:Pixcols, :); % Crop back to original size
