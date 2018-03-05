function rgb = NEFReadIm(FileName)
% NEFReadIm : Read raw image data from Nikon Electronic Format (NEF) image file
%
% NEF files are raw 14 bit data digitised from the CCD.
%
% Usage :
%   >> Im = NEFReadIm(FileName);
%   >> Im = NEFReadIm;
%
% Where : 
%  FileName is the full path and filename (or just the filename if in the 
%    current directory). If the Filename is not given or is empty, a file
%    open dialog will presented for selection of the file.
%  Im is a 3D matrix of uint16 (unsigned 16 bit integers) read from the NEF
%    file.
%
% Supported cameras are Nikon D100, D1, D70 and D70S. Support for other
% Nikon cameras is generally easy to add. 
%
% This function typically returns a 16-bit matrix of 1007 by 1520 pixels by
% 4 channels. Channel 1 is red, channel 2 is green (upper matrix),
% channel 3 is blue and channel 4 is also green (lower matrix).
% This is required because the Bayer filter pattern has twice as many green
% pixels as red or blue pixels. The green pixels therefore comprise 2
% square matrices that are interleaved. A typical Bayer (D70) pattern is as
% follows:
%
%       BGBGBG ....
%       GRGRGR ....
%       BGBGBG ....
%          .
%          .
% The pattern therefore consists of the 4-unit cell BG
%                                                   GR
% repeated horizontally and vertically. Hence the 4 channels in the
% returned data, with two green matrices referred to as upper right and
% lower left (or upper left and lower right depending on the camera) 
% respectively.
%
% Of the 16 bits returned, the lowest 14 bits contain data and the 2 upper
% bits are zero. To normalise to the saturation level, convert to double
% and divide by 16384 (2^14).
%
% Bugs :
%  1) The original nefRead function from Stanford drops the 3 most
%  insignificant bits, reducing the number of bits to 11. This routine
%  retains the full 14 bits, and is therefore incompatible with nefRead.
%
%  2) This function will crash on the call to rawCamFileRead if the FileName
%  is too long (the maximum length is not currently known). The crash is
%  severe and requires a restart of Matlab.

if ~exist('FileName', 'var') || isempty(FileName) || ~ischar(FileName)
    [FileName, PathName] = uigetfile('*.nef','Open Nikon NEF Image File');
    if FileName
        FileName = [PathName FileName];
    else
        rgb = [];
        return;
    end
end
[a,model]=rawCamFileRead(FileName);
%a=uint16(double(a)'/8); % this is the original downscaling used by
% Stanford. We prefer to keep the orogonal bit depth, but this means that
% this function is incompatible with the original 
a = a';

switch lower(model)
    case 'd100'
	    % Bayer pattern for D100:
	    %       GBGBGB
	    %       RGRGRG
	    %       GBGBGB
		rgb(:,:,1)=a(1:2:end,2:2:end); % Red matrix (is this correct ?)
		rgb(:,:,2)=a(1:2:end,1:2:end); % Green Upper Left matrix
		rgb(:,:,3)=a(2:2:end,1:2:end); % Blue matrix
		rgb(:,:,4)=a(2:2:end,2:2:end); % Green Lower Right matrix
    case {'d1', 'd70', 'd70s'}
	    % Bayer pattern for D70:  
	    %       BGBGBG
	    %       GRGRGR
	    %       BGBGBG
        rgb(:,:,1)=a(2:2:end,2:2:end); % Red matrix
        rgb(:,:,2)=a(1:2:end,2:2:end); % Green Upper Right matrix
        rgb(:,:,3)=a(1:2:end,1:2:end); % Blue matrix
        rgb(:,:,4)=a(2:2:end,1:2:end); % Green Lower Left matrix       
    otherwise
        disp(['An unknown camera type : ' model ' recorded this NEF file.']);
        rgb = [];
end
