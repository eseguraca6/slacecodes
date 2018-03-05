function [Ratios, RefMean, TargMean] = ImageROIMeanRatio(ImFilename)
% ImageROIMeanRatio : Computes the ratio of the mean pixel values in image ROIs
%
%
% ROI stands for region of interest and is a polygonal area of an image in
% this case, selected by means of the roipoly function in the Image
% Processing Toolbox, which is required for this function to work.
%
% Usage :
%    >> Ratios = ImageROIMeanRatio(ImFilename)
%
% Where ImFilename is the full path and filename (or filename in the
% current directory) of the image.
%
% The image is displayed and the reference ROI is first selected, followed
% by the target ROI with which to calculate the ratio of the mean pixel
% values inside the ROI. Once all of the target ROIs have been selected,
% press the escape key to proceed to the calculation of the ratios.
%
% Ratios is a matrix containing the ratios of the mean pixel values inside
% the target ROI to the mean pixel value in the reference ROI. There is one
% column per colour channel in the image, and one row for each target ROI.
%
% See Also : roipoly (Image Processing Toolbox), uiGetImFile, 
%% BSD Licence
% This file is subject to the terms and conditions of the BSD Licence.
% See the file BSDlicence.txt for further details.
%% 
% $Id: ImageROIMeanRatio.m 221 2009-10-30 07:07:07Z DGriffith $
%

%% Read the image and scale
if ~exist(ImFilename, 'file')
  error('ImageROIMeanRatio:FileNotFound','Image file not found.')
end
% Determine the image type
[fn, pn, ext] = fileparts(ImFilename);
% Use NEFReadIm if it is a NEF file.
ext = ext(2:end);
if strcmpi(ext, 'nef')
  TheImage = NEFReadIm(ImFilename);
else
  fmt = imformats(ext);
  if isempty(fmt)
    error('ImageROIMeanRatio:UnknownImageFormat','The image format of the file is unknown.')
  else
    TheImage = imread(ImFilename);
  end
end
TheImage = double(TheImage); % Convert to double
% Display only the first 3 channels
nChan = size(TheImage,3);
DisplayIm = TheImage(:,:,1:min([3 nChan]));
DisplayIm = uint8(255 * DisplayIm / max(DisplayIm(:)));
hIm = imshow(DisplayIm);
% Get the reference ROI
Ratios = [];
RefROI = roipoly;
if isempty(RefROI)
  close(hIm);
  return
end
% Obtain the reference mean pixel value
% size(TheImage(RefROI))
for iChan = 1:nChan
  RefMean(iChan) = sum(sum((TheImage(:,:,iChan) .* RefROI))) ./ sum(RefROI(:));
end
TargetROI = roipoly;
iTargROI = 1;
while ~isempty(TargetROI)
  for iChan = 1:nChan
    TargMean(iTargROI, iChan) = sum(sum((TheImage(:,:,iChan) .* TargetROI))) ./ sum(TargetROI(:));
  end
  Ratios(iTargROI, :) = TargMean(iTargROI, :) ./ RefMean;
  TargetROI = roipoly;
  iTargROI = iTargROI + 1;
end
%close(hIm);  
end
