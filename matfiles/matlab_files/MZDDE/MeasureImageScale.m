function Scale = MeasureImageScale(Distance, ImageFile)
% MeasureImageScale : Determine the scale of an image in mm per pixel
%
% Usage :
%   Scale = MeasureImageScale(Distance, ImageFile)
%   Scale = MeasureImageScale(Distance)
%   Scale = MeasureImageScale
%
% Where ..
%   Distance is the distance in the plane of the image between 2 points
%   that must be specified by clicking on the first point and double
%   clicking on the second point. Distance must be in mm.
%
%   ImageFile is the full filename of the image to measure.
%
% If ImageFile is not specified, an image open dialog will be presented.
% If Distance is also not specified, or specified as zero, then it will
%   be prompted for.
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
% $Author: DGriffith $

if ~exist('Distance', 'var') 
    Distance = 0;
else
    if ~isfloat(Distance) || ~isscalar(Distance)
        error('Distance input must be scalar double.');
    end
end

if ~exist('ImageFile', 'var') % use file open dialog
     
     ImageFile = uiGetImageFile;
     if ImageFile == 0
         Scale = [];
         return;
     end
end

if ~exist(ImageFile, 'file')
    error(['The image file ' ImageFile ' was not found.']);
end

TheImage = imread(ImageFile);
image(TheImage);

hold on;
% Get the two points
pt1 = ginput(1);
plot(pt1(1), pt1(2), 'r+'); % Plot a plus sign at the point
pt2 = ginput(1);
plot(pt2(1), pt2(2), 'r+');
hold off;


while Distance == 0
    % Prompt for the Distance
    Distance = input('Enter the distance in mm between the two selected points >> ');
end

% Get the distance in pixels between the two points.
PixDistance = sqrt((pt1(1) - pt2(1))^2 + (pt1(2) - pt2(2))^2);

% The Scale is the ratio
Scale = Distance/PixDistance;
