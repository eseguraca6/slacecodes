function RenIm = RenderNarcissus(n, AspectRatio, xres, yres, RMSNoise, DisplayTRange)
% RenderNarcissus : Render visual representation of narcissus artefact computed with IRNarcissus
% Usage : 
%    RenderNarcissus(IRNarcissusResults, AspectRatio, FPAxResolution, FPAyResolution)
%    RenderNarcissus(IRNarcissusResults, AspectRatio, FPAxResolution, FPAyResolution, RMSNoise)
%    RenderNarcissus(IRNarcissusResults, AspectRatio, FPAxResolution, FPAyResolution, RMSNoise)
%    RenderNarcissus(IRNarcissusResults, AspectRatio, FPAxResolution, FPAyResolution, RMSNoise, DisplayTRange)
%    RenderedIm = RenderNarcissus( ...
%
%     IRNarcissusResults is the structure returned by IRNarcissus. IRNarcissusResults is stored by the function
%          IRNarcissus in the .Narcissus directory of the analysed lens in a file called Results.mat.
%          IRNarcissusResults is a structure array, and may have either one or two elements. If there are
%          two elements, then the difference between the two results is rendered. The NITD in the first
%          element is subtracted from the NITD in the second element. This is useful for rendering a change
%          in NITD perhaps due to a change in housing temperature, where the NITD in the first element has
%          been removed by non-uniformity correction (NUC). Both elements must have the same pupil sampling,
%          field sampling and wavelength data in order for this calculation to succeed and to be valid.
%     AspectRatio is the aspect ratio of the the detector. If given as the empty matrix [] or omitted completely,
%          it will default to a ratio of 4:3. The aspect ratio here is the ratio of the horizontal size to the
%          vertical size.
%          The maximum semi-diagonal of the detector is determined from the lens field point that is furthest from
%          the optical axis.
%     FPAxResolution is the number of pixels on the FPA in the x (width) direction.
%     FPAyResolution is the number of pixels on the FPA in the y (height) direction.
%     RMSNoise is the total RMS noise to render the NITD with. If the RMSNoise is given, the narcissus
%          patterns will be rendered with the RMSNoise superimposed. Noise is assumed to be additive
%          white gaussian noise.
%     DisplayTRange is the total display temperature range. If this parameter is specified, additional
%          output images are generated where black maps to the scene temperature minus half the display
%          range and white maps to the scene temperature plus half the display range. If this parameter is
%          missing, empty or zero, then the NITD is rendered full scale only.
%
% Image outputs are saved in a number of formats in the results directory from which IRNarcissusResults
% was obtained. If there are two elements in IRNarcissusResults, the results are saved in the directory
% from which IRNarcissusResults(2) was obtained. If IRNarcissusResults has only one element the filenames are ...
%    RenderNITD.jpg (8 bit .jpg)
%    RenderNITD.tif (16 bit .tif)
%    RenderNITD.mat (floating point result in .mat format, along with ancillary data)
%    RenderNITDdiscrim.mat (floating point results as for input to discrim vision model)
%    RenderdiscrimUni.mat (uniform reference image with same noise as previous image for discrim)
%
% If IRNarcissusResults has 2 elements the filenames are the same as above, but extended with the
% name of the file that served as the reference (NUC) preceded by a minus sign (-).
%    
%
% Example :
% >> n = IRNarcissus([], 300, 300, 200, 1, [], 30, 60); % Compute narcissus in current lens in Zemax.
% >> RenderNarcissus(n, 4/3, 640, 480);

%%
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

% $Revision:$
% $Author: dgriffith $

%% Check input parameters and defaults
if isempty(n) || numel(n) > 2 || ~isstruct(n)
    error('IRNarcissusResults input must be a structure with one or two elements.')
end

if ~exist('AspectRatio', 'var') || isempty(AspectRatio)
    AspectRatio = 4/3;
end

% Default display temperature range to unity if not given in the function input
if ~exist('DisplayTRange', 'var') || isempty(DisplayTRange) || DisplayTRange == 0
    DisplayTRange = 1;
end


%% Interpolate narcissus artefact onto a 2D image array

% Make narcissus image map for "qualitative" impact of this total NITD and uniformity curve
% Compute x and y coordinates of the centres of all pixels
totalheight = sqrt((n(1).FPASemiDiagonal*2)^2/(AspectRatio^2 + 1));
totalwidth = totalheight * AspectRatio;
horpixelpitch = totalwidth / xres;
verpixelpitch = totalheight / yres;
x = ((-totalwidth + horpixelpitch)/2):horpixelpitch:(totalwidth - horpixelpitch)/2;
y = ((-totalheight + verpixelpitch)/2):verpixelpitch:(totalheight - verpixelpitch)/2;

% Now compute the radial distance of the centre of each pixel from the centre of the image
[Y, X] = meshgrid(x, y);
rr = sqrt(X.^2 + Y.^2);

%% Compute the NITD to be rendered
if numel(n) == 2
    NITD = n(2).normNITD - n(1).normNITD;
else
    NITD = n.normNITD;
end

% Finally, interpolate NITD on this grid of radii (rr)
imNITD = interp1(n(1).r, NITD, rr);

%% Generate the image noise if requested

% Put in additive white gaussian noise if specified in the inputs
if exist('RMSNoise', 'var') && isscalar(RMSNoise) && ~isempty(RMSNoise) && RMSNoise > 0
    % add RMSNoise noise to the imNITD image
    % the noise will be additive white gaussian noise
    % imNITD = imnoise(imNITD,'gaussian', 0, RMSNoise^2); % This requires IP toolbox, so rather use randn
    imNoise = randn(size(imNITD));
    % The mean is zero and the standard deviation is unity, therefore scale the standard deviation
    % to the RMSNoise divided by the Display temperature range
    imNoise = imNoise * RMSNoise / DisplayTRange;
else
    imNoise = zeros(size(imNITD)); % zero noise
end


%% Perform shifting and scaling into desired rendering temperature range

% Scale the imNITD according to the display temperature range
imNITD = imNITD / DisplayTRange;
% Shift the mean to 0.5
imNITD = imNITD - mean(mean(imNITD)) + 0.5;
% add in the noise
imNITDNoise = imNITD + imNoise;


%% Display the image non-uniformity representation
% 
% figure;
% % imshow(imTD);
% imagesc(imTD);
% colormap(gray);
% axis off;
% title(['Scene Image Uniformity for T_a=' num2str(n.T_a) 'K    T_d=' num2str(n.T_d) 'K    T_h=' num2str(n.T_h) 'K    r_c=' num2str(n.r_c) '%']);

figure;
colormap(colormap(repmat([0:1/255:1]',1,3))); % Colormap is 255 gray levels
imshow(imNITDNoise);
% image(imNITDNoise*256);
axis off;
%title(['NITD Uniformity for T_a=' num2str(n.T_a) 'K    T_d=' num2str(n.T_d) 'K    T_h=' num2str(n.T_h) 'K    r_c=' num2str(n.r_c) '%']);

%% Save non-uniformity renderings, and data in a .mat file

% Set up directory and filenames for results

switch length(n)
    case 1
        ResultDir = n.NarcDir;
        ResultRef = '';
    case 2
        ResultDir = n(2).NarcDir;
        [d, ResultRef] = fileparts(n(1).LensFile);
        ResultRef = ['-' ResultRef];
    otherwise
        error('Input IRNarcissusResults may have 1 or 2 elements only.');
end


% Save the images for later reference 
imwrite(imNITDNoise, [ResultDir 'RenderNITD' ResultRef '.jpg']); % Save as 8 bit jpg for preview purposes
imwrite(uint16(65535*imNITDNoise), [ResultDir 'RenderNITD' ResultRef '.tif']); % Save as 16 bit tiff
save([ResultDir 'RenderNITD' ResultRef '.mat'], 'imNITD', 'imNITDNoise', 'imNoise', 'RMSNoise'); % save in matlab format for full double accuracy


%% Generate and save display images for discrim in floating point format
% Note : discrim requires a .mat file with the image saved in the variable discrim_img
% This image must be on the scale -1 to 1, whereas in Matlab for display purposes the
% the image range is zero to 1. Therefore to change to the discrim range, it is necessary
% to multiply by 2 and subtract 1.

Uniform = 0.5 * ones(yres, xres);
% Convert to discrim image range
discrim_img = 2 * Uniform - 1;
% Save the uniform reference image
save([ResultDir 'RenderdiscrimUni' ResultRef '.mat'], 'discrim_img');

% Convert the NITD rendering to discrim range
discrim_img = 2 * imNITD - 1;
% Save the NITD rendering for discrim
save([ResultDir 'Renderdiscrim' ResultRef '.mat'], 'discrim_img');


%% Return resultant image
RenIm = imNITDNoise;
