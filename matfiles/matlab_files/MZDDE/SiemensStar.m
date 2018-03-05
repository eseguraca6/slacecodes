function Star = SiemensStar(NumSectors, NumPixels, GrayLevels, AntiAliasing)
% SiemensStar - Generate image of a sector Siemens Star target
%
% A Siemens star is a starburst target commonly used in optical testing.
%
% Usage :
% >> Star = SiemensStar(NumSectors, NumPixels, GrayLevels)
% >> Star = SiemensStar(NumSectors, NumPixels, GrayLevels, AntiAliasing)
%
% Where :
%   NumSectors is the total number of wedge sector pairs to generate
%      (one pair is a bright and dark sector);
%   NumPixels is the number of pixels to generate in both the horizontal 
%      and vertical directions. The resulting image is square.
%   GrayLevels is a 2 component vector specifying the gray levels to assign
%      to the dark and bright sectors. This can be used to produce stars
%      having various contrast levels. If GrayLevels has 3 components,
%      then the pattern is made circular and the area outside the circle is
%      set to the 3rd level.
%   Antialiasing is an optional parameter. If non-zero, antialiasing is
%      applied by supersampling and then down-sampling again. 
%      The parameter AntiAliasing must be a positive integer indicating what 
%      supersampling factor to use.
%      Note that execution times goes up rapidly with the AntiAliasing
%      and NumPixels parameters.
%
% Examples:
%    >> Star = SiemensStar(11, 512, [0 1], 3);
%    >> imagesc(Star); % Display the Siemens star
%    >> colormap('gray'); % Display using gray scale colormap
%
% The above example creates a Siemens star with 11 sector pairs on a 512 by
% 512 pixel image with values of 0 and 1 assigned to adjacent sector and
% using antialiasing by supersampling at a factor of 3.
% If you have the image processing toolbox, you can use the following to
% display the Siemens Star.
%   >> imshow(Star)
%
%   >> Star = SiemensStar(5, 1024, [0 1 0.5],3);
% The above example generates a 5 sector pair star with a gray surround
%

%% BSD Licence
% This file is subject to the terms and conditions of the BSD licence.
% For further details, see the file BSDlicence.txt
%%
% Contact : dgriffith@csir.co.za
%
% $Date: 2009-10-30 09:07:07 +0200 (Fri, 30 Oct 2009) $
% $Revision: 221 $
% $Author: DGriffith $

%% Do some parameter checking

if ~isscalar(NumSectors) || ~isnumeric(NumSectors)
    error('SiemensStar:BadNumSectors','Parameter NumSectors must be positive, scalar, numeric.');
end
NumSectors = abs(round(NumSectors));

if ~isscalar(NumPixels) || ~isnumeric(NumPixels)
    error('SiemensStar:BadNumPixels','Parameter NumPixels must be positive, scalar, numeric.');
end
NumPixels = abs(round(NumPixels));

if ~any(numel(GrayLevels) == [2 3]) || ~isnumeric(GrayLevels)
    error('SiemensStar:BadGrayLevels','Parameter GrayLevels must be positive scalar numeric with 2 or 3 elements.')
end


if exist('AntiAliasing', 'var')
    if ~isscalar(AntiAliasing) || ~isnumeric(AntiAliasing) || AntiAliasing <= 0
        error('SiemensStar:BadAntiAliasing','Parameter AntiAliasing must be zero or more.');
    end
    AntiAliasing = round(AntiAliasing);
else
    AntiAliasing = 1;
end


%% Calculate the star pattern using the sin function and the sign function
% Calculate the positions of the pixel centres
xa = -(NumPixels-1)/2:1/AntiAliasing:(NumPixels-1)/2;
[x, y] = meshgrid(xa, xa);

% Get angles of pixels
Theta = atan2(y, x);
% Generate a sinusoid in polar coordinates
Sinusoid = sin(NumSectors*Theta);

Star = sign(Sinusoid);
% Set the requested Gray levels
Star(Star > 0) = max(GrayLevels(1:2));
Star(Star <= 0) = min(GrayLevels(1:2));
if numel(GrayLevels) == 3
    % Set all value outside the unit circle to the new value
    Circle = sqrt(x.^2 + y.^2) >= (NumPixels-1)/2;
    Star(Circle) = GrayLevels(3);
end

%% Down-sample if anti-aliasing is requested
if AntiAliasing > 1
   Star = conv2(Star,ones(AntiAliasing)/AntiAliasing.^2, 'same'); 
   % and resample at original pixel positions
   xnew = -(NumPixels-1)/2:1:(NumPixels-1)/2;
   %[xnew, ynew] = meshgrid(xnew, xnew);
   Start = interp2(xa,xa',Star,xnew,xnew','nearest'); % nearest neighbour
end


