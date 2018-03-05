function [Signal, ImFiles, FileNames, Connectedness] = GetImagePatchSignal(FileSpec, RefImage, DarkImage, Level, Dilate)
% GetImagePatchSignal : Threshold and retrieve signal from an image file
%
% Usage :
%  >> [Signal, ImFiles, FileNames, Connectedness] = GetImagePatchSignal(FileSpec, RefImage, DarkImage, Level, Dilate)
%
% Where :
%   FileSpec is the specification of the image files to process.
%   
%   RefImage is the image file to use as a reference for finding the image
%   patch (region of interest or ROI) from which to compute the signal. If
%   RefImage is given as 'self', then the each image is assumed to be it's
%   own reference. If RefImage is empty or omitted, then a file open dialog
%   is presented to select the reference image.
%
%   DarkImage is the DarkImage to subtract from the images before
%   processing. If DarkImage is given as 'none', then no DarkImage is
%   subtracted. If DarkImage is empty or omitted, then a file open dialog
%   is presented to select the dark image. If DarkImage is given as
%   'alternate', then every second image is used as the dark image to
%   subtract from the previous image.
%
%   The ROI is obtained by thresholding the reference image at
%   50% (default) of the maximum pixel value in the image. If the input
%   Level is given then the given percentage overrides the default.
%
%   Dilate is the number of pixels to include around the thresholded ROI.
%   If Dilate is omitted or empty, a value of 2 is used as the default.
%
%   If the output argument Connectedness is given, the connected components
%   of the roi is computed using the image processing function bwconncomp.
%
%   The Image Processing Toolbox is required for this function. Two IP
%   Toolbox functions are used, viz. imdilate and bwconncomp. imdilate is
%   fairly easy to replace using simple matrix functions, but bwconncomp is
%   not. However, bwconncomp is only required if the Connectedness output
%   parameter is required.


%% Do defaults for Level and Dilate inputs
if ~exist('Level', 'var') || isempty(Level)
    Level = 0.5;
else
    Level = Level/100;
end

if ~exist('Dilate', 'var') || isempty(Dilate)
    Dilate = 2;
end

%% Get the reference image filename if not specified
if ~exist('RefImage', 'var') || isempty(RefImage)
    RefImage = uiGetImageFile;
end

[PathName, FileName, Ext] = fileparts(RefImage);
if ~(FileName)
    return
end
% Read the reference image if images are not self-referencing
if strcmpi(RefImage, 'self')
    RefIm = [];
else
    if strcmpi(Ext, '.nef')
        RefIm = NEFReadIm(RefImage);
    else
        RefIm = imread(RefImage);
    end
end

%% Get the dark image filename if not specified 
if ~exist('DarkImage', 'var') || isempty(RefImage)
    RefImage = uiGetImageFile;
end

[PathName, FileName, Ext] = fileparts(RefImage);
if ~(FileName)
    return
end
% Read the dark image if there is one
if strcmpi(DarkImage, 'none')
    DarkIm = 'n';
elseif strcmpi(DarkImage, 'alternate')
    DarkIm = 'a';
else
    if strcmpi(Ext, '.nef')
        RefIm = NEFReadIm(RefImage);
    else
        RefIm = imread(RefImage);
    end
end

[PathName, FileName, Ext] = fileparts(FileSpec);

% Extract signals
if isempty(RefIm) % Images each define own roi
    ImFiles = dir(FileSpec);
    if ischar(DarkIm) && DarkIm == 'n' % Dont subtract any dark image
        for iImFile = 1:length(ImFiles)
            if strcmpi(Ext, '.nef')
                [PathName ImFiles(iImFile).name]    
                NextIm = NEFReadIm([PathName ImFiles(iImFile).name]);
            else
                NextIm = imread([PathName ImFiles(iImFile).name]);
            end
            MaxIm = max(max(NextIm(:,:,1)));
            roi = NextIm(:,:,1) > (Level*MaxIm);
            SE = strel('disk',Dilate); % dilate using a disk structuring element
            roi = imdilate(roi, SE);
            if nargout >= 4
                Connectedness(iImFile) = bwconncomp(roi);
            end
            
            for iChan = 1:size(NextIm,3)
                Chan = NextIm(:,:,iChan); % First get the whole colour channel
                SelectPix = Chan(roi); % Next get the roi in that channel
                if any(SelectPix > 0.9 * 2^16)
                    warning(['Image ' ImFiles(iImFile).name ' may be too close (>90%) to saturation.']);
                end
                Signal(iImFile,iChan) = sum(double(SelectPix));
            end
        end
    elseif ischar(DarkIm) && DarkIm == 'a' % Subtract alternate image as dark image
        for iImFile = 1:2:length(ImFiles)
            if strcmpi(Ext, '.nef')
                NextIm = NEFReadIm([PathName ImFiles(iImFile).name]);
            else
                NextIm = imread([PathName ImFiles(iImFile).name]);
            end
            if strcmpi(Ext, '.nef')
                TheDarkIm = NEFReadIm([PathName ImFiles(iImFile+1).name]);
            else
                TheDarkIm = imread([PathName ImFiles(iImFile+1).name]);
            end
            NextIm = NextIm - TheDarkIm;
            MaxIm = max(max(NextIm(:,:,1)));
            roi = NextIm(:,:,1) > (Level*MaxIm);
            SE = strel('disk',Dilate); % dilate using a disk structuring element
            roi = imdilate(roi, SE);
            if nargout >= 4
                Connectedness(ceil(iImFile/2)) = bwconncomp(roi);
            end
            
            for iChan = 1:size(NextIm,3)
                Chan = NextIm(:,:,iChan); % First get the whole colour channel
                SelectPix = Chan(roi); % Next get the roi in that channel
                if any(SelectPix > 0.9 * 2^16)
                    warning(['Image ' ImFiles(iImFile).name ' may be too close (>90%) to saturation.']);
                end
                Signal(ceil(iImFile/2),iChan) = sum(double(SelectPix));
            end
        end
    
    else % subtract the single universal dark image
        for iImFile = 1:length(ImFiles)
            if strcmpi(Ext, '.nef')
                NextIm = NEFReadIm([PathName ImFiles(iImFile).name]);
            else
                NextIm = imread([PathName ImFiles(iImFile).name]);
            end
            NextIm = NextIm - DarkIm;
            MaxIm = max(max(NextIm(:,:,1)));
            roi = NextIm(:,:,1) > (Level*MaxIm);
            SE = strel('disk',Dilate); % dilate using a disk structuring element
            roi = imdilate(roi, SE);
            if nargout >= 4
                Connectedness(iImFile) = bwconncomp(roi);
            end
            
            for iChan = 1:size(NextIm,3)
                Chan = NextIm(:,:,iChan); % First get the whole colour channel
                SelectPix = Chan(roi); % Next get the roi in that channel
                if any(SelectPix > 0.9 * 2^16)
                    warning(['Image ' ImFiles(iImFile).name ' may be too close (>90%) to saturation.']);
                end
                Signal(iImFile,iChan) = sum(double(SelectPix));
            end
        end

    end
    
else
    % Threshold the single reference image
    % If the image is multichannel, take the first channel
    MaxIm = max(max(RefIm(:,:,1)));
    roi = RefIm(:,:,1) > (Level*MaxIm);
    SE = strel('disk',Dilate); % dilate using a disk structuring element
    roi = imdilate(roi, SE);
    if nargout >= 4
        Connectedness = bwconncomp(roi);
    end
    
    % figure;
    % imshow(roi);
    %% Read the images one at a time and extract the signal
    % Assume that the images are in the same directory as the reference image
    if isempty(PathName)
        ImFiles = dir(FileSpec);
    else
        ImFiles = dir([PathName '\\' FileSpec]);
    end
    if ischar(DarkIm) && DarkIm == 'n' % Dont subtract any dark image
        for iImFile = 1:length(ImFiles)
            if strcmpi(Ext, '.nef')
                NextIm = NEFReadIm([PathName ImFiles(iImFile).name]);
            else
                NextIm = imread([PathName ImFiles(iImFile).name]);
            end
            for iChan = 1:size(NextIm,3)
                Chan = NextIm(:,:,iChan); % First get the whole colour channel
                SelectPix = Chan(roi); % Next get the roi in that channel
                if any(SelectPix > 0.9 * 2^16)
                    warning(['Image ' ImFiles(iImFile).name ' may be too close (>90%) to saturation.']);
                end
                Signal(iImFile,iChan) = sum(double(SelectPix));
            end
        end
    elseif ischar(DarkIm) && DarkIm == 'a' % Subtract alternate image as dark image
        for iImFile = 1:2:length(ImFiles)
            if strcmpi(Ext, '.nef')
                NextIm = NEFReadIm([PathName ImFiles(iImFile).name]);
            else
                NextIm = imread([PathName ImFiles(iImFile).name]);
            end
            if strcmpi(Ext, '.nef')
                TheDarkIm = NEFReadIm([PathName ImFiles(iImFile+1).name]);
            else
                TheDarkIm = imread([PathName ImFiles(iImFile+1).name]);
            end
            NextIm = NextIm - TheDarkIm;
            for iChan = 1:size(NextIm,3)
                Chan = NextIm(:,:,iChan); % First get the whole colour channel
                SelectPix = Chan(roi); % Next get the roi in that channel
                if any(SelectPix > 0.9 * 2^16)
                    warning(['Image ' ImFiles(iImFile).name ' may be too close (>90%) to saturation.']);
                end
                Signal(ceil(iImFile/2),iChan) = sum(double(SelectPix));
            end
        end
    
    else % subtract the single universal dark image
        for iImFile = 1:length(ImFiles)
            if strcmpi(Ext, '.nef')
                NextIm = NEFReadIm([PathName ImFiles(iImFile).name]);
            else
                NextIm = imread([PathName ImFiles(iImFile).name]);
            end
            NextIm = NextIm - DarkIm;
            for iChan = 1:size(NextIm,3)
                Chan = NextIm(:,:,iChan); % First get the whole colour channel
                SelectPix = Chan(roi); % Next get the roi in that channel
                if any(SelectPix > 0.9 * 2^16)
                    warning(['Image ' ImFiles(iImFile).name ' may be too close (>90%) to saturation.']);
                end
                Signal(iImFile,iChan) = sum(double(SelectPix));
            end
        end

    end
end
FileNames = strvcat(ImFiles.name);
