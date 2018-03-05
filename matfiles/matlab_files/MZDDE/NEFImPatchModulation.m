function M = NEFImPatchModulation(Filename)
% NEFImPatchModulation : Compute modulation of two patches in a NEF image.
%
% Usage :
%   >> M = NEFImPatchModulation(Filename)
%   >> M = NEFImPatchModulation
%
%  Where :
%   Filename is the name of a NEF (Nikon electronic format) image file.
%      The full path, filename and extension (.nef) must be given.
%
%    If the Filename is not given or is empty, a file open dialog will
%    be presented.
%
% The specified image is displayed with a graphics cursor. Two patches in
% image must be selected by clicking on upper left and lower right corners
% of the patch. The mean value of the pixels in the two patches are computed.
% The modulation is the difference of the means divided by the sum of the
% means. NEF images have 4 channels (red, green1, blue and green2). The
% modulation in each of four channels is returned ina 4 component vector M.
%
% This function is intended to establish contrast modulation in order to
% to estimate visibility.


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

%% Check Filename parameter

if ~exist('Filename', 'var') || isempty(Filename) || ~ischar(Filename)
  % Give file open dialog
  [Filename, Pathname] = uigetfile({'*.nef','Nikon NEF Image'},'Select Nikon NEF Image');
  if ~isempty(Filename)
      Filename = [Pathname Filename];
  else
      M = [];
      return;
  end
end

if ~exist(Filename, 'file')
    error('NEFImPatchModulation:FileNoExist',['NEF File ' Filename 'not found.']);
end

%% Read and process image
NEFIm = nefRead(Filename);
figure;
imagesc(NEFIm(:,:,1)); % Display red matrix, since this generally has highest contrast
% Get 4 input points
[xx, yy] = ginput(4);
xx = round(xx);
yy = round(yy);
Patch1 = NEFIm(yy(1):yy(2), xx(1):xx(2), :);
Patch2 = NEFIm(yy(3):yy(4), xx(3):xx(4), :);
if any(size(Patch1) == 0) || any(size(Patch2) == 0)
    error('NEFImPatchModulation:BadPatchSize','Select upper left followed by lower right corners of patch.')
end
I1 = squeeze(mean(mean(Patch1)));
I2 = squeeze(mean(mean(Patch2)));
for iChan = 1:4
    if I1(iChan) > I2(iChan)
        M(iChan) = (I1(iChan) - I2(iChan))./(I1(iChan) + I2(iChan));
    else
        M(iChan) = (I2(iChan) - I1(iChan))./(I2(iChan) + I1(iChan));
    end
end


