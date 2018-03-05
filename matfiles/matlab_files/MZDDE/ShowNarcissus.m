function ShowNarcissus(n, AspectRatio, xres, yres, NETD, Uniformity, DisplayTRange)
% ShowNarcissus : Plots narcissus results from IRNarcissus
% Usage : 
%    ShowNarcissus(IRNarcissusResults, AspectRatio, FPAxResolution, FPAyResolution)
%    ShowNarcissus(IRNarcissusResults, AspectRatio, FPAxResolution, FPAyResolution, NETD)
%    ShowNarcissus(IRNarcissusResults, AspectRatio, FPAxResolution, FPAyResolution, NETD, Uniformity)
%    ShowNarcissus(IRNarcissusResults, AspectRatio, FPAxResolution, FPAyResolution, NETD, Uniformity, DisplayTRange)
%
%     IRNarcissusResults is the structure returned by IRNarcissus. 
%     AspectRatio is the aspect ratio of the the detector. If given as the empty matrix [] or omitted completely,
%          it will default to a ratio of 4:3. The aspect ratio here is the ratio of the horizontal size to the
%          vertical size.
%          The maximum semi-diagonal of the detector is determined from the lens field point that is furthest from
%          the optical axis.
%     FPAxResolution is the number of pixels on the FPA in the x (width) direction.
%     FPAyResolution is the number of pixels on the FPA in the y (height) direction.
%     NETD is the RMS noise-equivalent temperature difference of the detector. If the NETD is given, the narcissus
%          patterns will be rendered with the NETD superimposed. 
%     Uniformity is the RMS percentage non-uniformity of the pixel response. (5% for Sofradir IDMM067)
%     DisplayTRange is the total display temperature range. If this parameter is specified, additional
%          output images are generated where black maps to the scene temperature minus half the display
%          range and white maps to the scene temperature plus half the display range.
%
% Note : If the absolute spectral sensitivity of the detector is given as 1 (unity) for all wavelengths,
%  then it is assumed that you have calculated the FPA band irradiance. The graphs are then labeled in
%  units of W/mm^2 (optical power delivered in the wavelength band per unit area of the FPA) rather than
%  in units of signal current (A/mm^2) per square millimetre of FPA.
%
% Example :
% >> n = IRNarcissus([], 300, 300, 200, 1, [], 30, 60); % Compute narcissus in current lens in Zemax.
% >> ShowNarcissus(n, 4/3, 640, 480);

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

if ~exist('AspectRatio', 'var') || isempty(AspectRatio)
    AspectRatio = 4/3;
end

% Make narcissus image map for "qualitative" impact of this total NITD and uniformity curve
% Compute x and y coordinates of the centres of all pixels
totalheight = sqrt((n.FPASemiDiagonal*2)^2/(AspectRatio^2 + 1));
totalwidth = totalheight * AspectRatio;
horpixelpitch = totalwidth / xres;
verpixelpitch = totalheight / yres;

% If all spectral sensitivities are given as unity, then FPA band irradiance has been computed
% Otherwise, FPA signal has been computed
if all(n.AbsSpecSens == 1)
    yLab = 'FPA Irradiance';
    yUnit = ' (W/mm^2)';
else
    yLab = 'FPA Signal';
    yUnit = ' (A/mm^2)';
end

SurfNumbers = (n.Surfaces)';

h1 = figure;
set(h1, 'Tag', 'NITDps');
plot(n.r, n.normNITD_i(SurfNumbers,:)');
grid;
xlabel('Field Position (mm)');
ylabel('NITD per Surface (K)');
legend(num2str(SurfNumbers), 'Location', 'Best');
title(['NITD: T_a=' num2str(n.T_a) 'K,T_d=' num2str(n.T_d) 'K,T_h=' num2str(n.T_h) 'K,r_c=' num2str(n.r_c) '%']);

h2 = figure;
set(h2, 'Tag', 'TNITD');
plot(n.r, n.normNITD);
grid;
xlabel('Field Position (mm)');
ylabel('Total NITD (K)');
title(['Total NITD: T_a=' num2str(n.T_a) 'K,T_d=' num2str(n.T_d) 'K,T_h=' num2str(n.T_h) 'K,r_c=' num2str(n.r_c) '%']);

h3 = figure;
set(h3, 'Tag', 'IrrUni');
plot(n.r, n.TD);
grid;
xlabel('Field Position (mm)');
ylabel('Equivalent \Delta{T} (K)');
title(['Image Uniformity: T_a=' num2str(n.T_a) 'K,T_d=' num2str(n.T_d) 'K,T_h=' num2str(n.T_h) 'K,r_c=' num2str(n.r_c) '%']);


x = ((-totalwidth + horpixelpitch)/2):horpixelpitch:(totalwidth - horpixelpitch)/2;
y = ((-totalheight + verpixelpitch)/2):verpixelpitch:(totalheight - verpixelpitch)/2;

% Now compute the radial distance of the centre of each pixel from the centre of the image
[Y, X] = meshgrid(x, y);
rr = sqrt(X.^2 + Y.^2);

% Finally, interpolate TD and NITD on this grid of radii
imTD = interp1(n.r, n.TD, rr);
imNITD = interp1(n.r, n.normNITD, rr);
cleanimNITD = imNITD;
% Put in multiplicative noise
if exist('Uniformity', 'var') && Uniformity > 0
    imNITD = imnoise(imNITD,'speckle', (Uniformity/100)^2);
    imTD = imnoise(imTD,'speckle', (Uniformity/100)^2);
end

% Put in additive white gaussian noise
if exist('NETD', 'var') && NETD > 0
    % add NETD noise to the imNITD image
    % the noise will be additive white gaussian noise
    imNITD = imnoise(imNITD,'gaussian', 0, NETD^2);
    imTD = imnoise(imTD,'gaussian', 0, NETD^2);
end


% Perform some scaling and shifting - currently this is not correct to yield a good representation
% SiTF must be taken into account.

minim = min(min(imTD));
imTD = imTD - minim;
imTD = imTD/max(max(imTD));

minim = min(min(imNITD));
imNITD = imNITD - minim;
imNITD = imNITD/max(max(imNITD));

% Display the image non-uniformity representations
figure;
% imshow(imTD);
imagesc(imTD);
colormap(gray);
axis off;
title(['Scene Image Uniformity for T_a=' num2str(n.T_a) 'K,T_d=' num2str(n.T_d) 'K,T_h=' num2str(n.T_h) 'K,r_c=' num2str(n.r_c) '%']);

figure;
% imshow(imNITD);
imagesc(imNITD);
colormap(gray);
axis off;
title(['NITD Uniformity for T_a=' num2str(n.T_a) 'K,T_d=' num2str(n.T_d) 'K,T_h=' num2str(n.T_h) 'K,r_c=' num2str(n.r_c) '%']);

h7 = figure;
% Plot FPA signals per surface and total
plot(n.r, n.S_ik(SurfNumbers,:)');
grid;
xlabel('Field Position (mm)');
ylabel([yLab yUnit]);
title([yLab ': T_a=' num2str(n.T_a) 'K,T_d=' num2str(n.T_d) 'K,T_h=' num2str(n.T_h) 'K,r_c=' num2str(n.r_c) '%']);
legend(num2str(SurfNumbers), 'Location', 'Best');

h8 = figure;
plot(n.r, n.S_k);
grid;
xlabel('Field Position (mm)');
ylabel(['Total ' yLab yUnit]);
title([yLab ': T_a=' num2str(n.T_a) 'K,T_d=' num2str(n.T_d) 'K,T_h=' num2str(n.T_h) 'K,r_c=' num2str(n.r_c) '%']);


% Save the images for later reference and use in discrimination model
imwrite(uint16(65535*imTD), [n.NarcDir 'FieldUniformity.tif']); % Save as 16 bit tiff for discrim
imwrite(uint16(65535*imNITD), [n.NarcDir 'NITDUniformity.tif']); % Save as 16 bit tiff for discrim
imwrite(imTD, [n.NarcDir 'FieldUniformity.jpg']); % Save 8 bit jpg for preview purposes
imwrite(imNITD, [n.NarcDir 'NITDUniformity.jpg']); % Save 8 bit jpg for preview

% Generate and save display images for discrim or visualisation in 16 bit tiff
if exist('DisplayTRange', 'var') && ~isempty(DisplayTRange)
    % First create a uniform grey scale image
    Uniform = 0.5 * ones(yres, xres);
    % put in the noise
    if exist('Uniformity', 'var') && Uniformity > 0
        Uniform = imnoise(Uniform,'speckle', (Uniformity/(100*DisplayTRange))^2);
    end

    % Put in additive white gaussian noise
    if exist('NETD', 'var') && NETD > 0
        % add NETD noise to the imNITD image
        % the noise will be additive white gaussian noise
        Uniform = imnoise(Uniform,'gaussian', 0, (NETD/DisplayTRange)^2);
    end
    % Finally, create the comparison image with NITD added
    UniformPlusNITD = Uniform + cleanimNITD/DisplayTRange;
    imwrite(uint16(65535*Uniform), [n.NarcDir 'Uniform.tif']); % Save as 16 bit tiff for discrim
    imwrite(uint16(65535*UniformPlusNITD), [n.NarcDir 'UniformPlusNITD.tif']); % Save as 16 bit tiff for discrim
    imwrite(Uniform, [n.NarcDir 'Uniform.jpg']); % Save 8 bit jpg for preview purposes
    imwrite(UniformPlusNITD, [n.NarcDir 'UniformPlusNITD.jpg']); % Save 8 bit jpg for preview

end
