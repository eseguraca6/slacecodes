function ContourPSPlot(PlotData)
% CountourPSPlot : Write PostScript plot of ContourPupil data
%
% Usage :
%   >> ContourPSPlot(PlotData)
%
% Where :
%  PlotData is a structure having the following fields :
%   Filename is the filename of the PostScript or encapsulated PostScript file to
%     write the plot to. The plot can be rendered by sending it to a PostScript
%     (color) printer, or scan converted to pixel graphics using GhostView,
%     GhostScript or Adobe Acrobat/Distiller. If Filename is given as empty
%     or omitted, a file/save dialog will be presented.
%   xContourPupilData is the x data from the ContourPupil function. Complete contours
%     are required by this function (i.e. there can be no ray failures in
%     the execution of ContourPlot, which would result in NaNs in the data). If
%     there are NaNs in ContourPupilData, this function will terminate with an
%     error.
%   yContourPupilData is the y data from the ContourPupil function. The x and y
%     matrices must have the same shape.
%   PupilRadii are the relative pupil radii at which the ContourPupilData were
%     computed. If not given, the PupilRadii are assumed equally spaced between
%     zero and unity.
%   ColorPalette is the RGB color palette (color map) to use. 
%     Plotting colours are interpolated from the color palette for each 
%     contour line. A user-created map can be specified, or name one of
%     the built-in Matlab color maps (see the colormap function). A color
%     palette/map must comprise at least 2 colors (2 by 3 matrix). A color
%     palette per wavelength can be specified in the 3rd dimension. If no
%     color palette is given, the built-in 'jet' color map is used.
%   LineWidth is the linewidth in points (1/72 inches) with which to plot
%     the lines. If linewidth is given as 0, the contour is instead filled
%     with the interpolated color. The appearance of the plot will be
%     affected by the order of the contour pupil radii in the data.
%   MaxPlotSize is the maximum size of the plotted contour diagram in mm.
%     MaxPlotSize defaults to 100 mm.
%   MarginSize is the size of the margin around the contour spot diagram
%     in mm. MarginSize defaults to 10 mm. MarginSize is used to determine
%     the size of the bounding box around the contour spot.
%
% Example :
%
% See also : ContourPupil, colormap

% Copyright, 2009, CSIR, South Africa
% This file is subject to the BSD. See the file BSDLicence.txt for further
% details.

% $Id: ContourPSPlot.m 221 2009-10-30 07:07:07Z DGriffith $

%% Perform some input checking
if ~isfield(PlotData, 'xContourPupilData') || ~isfield(PlotData, 'yContourPupilData') 
    error('ContourPSPlot:NoContourData','No ContourPupilData given. See the function ContourPupil.')
else
    AnyNaNs = isnan(PlotData.xContourPupilData) + isnan(PlotData.yContourPupilData);
    if any(AnyNaNs(:))
      error('ContourPSPlot:NoNaNs','NaNs in the ContourPupilData cannot currently be handled.');
    end
end


if ~isfield(PlotData, 'Filename') || isempty(PlotData.Filename)
    [fn, pn] = uiputfile({'*.ps', 'PostScript Files (*.ps)';'*.eps', 'Encapsulated PostScript Files (*.eps)'},...
                          'Save PostScript File');
    if ~isempty(fn)
        PlotData.Filename = [pn fn];
    else
        return;
    end
end
[pn, fn, extension] = fileparts(PlotData.Filename); % Get the file extension
if isfield(PlotData, 'PupilRadii')
    if any(PupilRadii > 1)
        error('ContourPSPlot:BadPupilRadii','Pupil radii must be less than or equal to unity.')
    end
else
    PupilStep = 1/size(PlotData.xContourPupilData,2);
    PlotData.PupilRadii = PupilStep:PupilStep:1;
end

if isfield(PlotData, 'ColorPalette')
    if size(PlotData.ColorPalette,2) ~= 3 || size(PlotData.ColorPalette,1) < 2
        warning('ContourPSPlot:BadColorMap', 'Color palette must have at least 2 rows and exactly 3 columns. Using jet instead.');
        PlotData.ColorPalette = jet;
    end
else
    PlotData.ColorPalette = jet;
end

% Interpolate the colours at each of the pupil radii
ColStep = 1/size(PlotData.ColorPalette,1);
xCol = ColStep:ColStep:1;
nWaves = size(PlotData.xContourPupilData,3);

% Run through each of the wavelengths and interpolate the colours
for iWave = 1:nWaves
    Color(1:3,iWave) = interp1(xCol, PlotData.ColorPalette, PlotData.PupilRadii, 'linear');
end

if isfield(PlotData, 'MaxPlotSize')
    PlotData.MaxPlotSize = abs(PlotData.MaxPlotSize(1));
else
    PlotData.MaxPlotSize = 100; % mm
end
if isfield(PlotData, 'PlotMargin')
    PlotData.PlotMargin = abs(PlotData.PlotMargin(1));
else
    PlotData.PlotMargin = 10; % mm
end

% Convert plot size and border to points
ptMaxPlotSize = 72 * PlotData.MaxPlotSize / 25.4; % 72 points per inch
ptPlotMargin = 72 * PlotData.PlotMargin / 25.4;

%% Find the plot limits of the data and transform to the centre of the standard PS page
xmin = min(PlotData.xContourPupilData(:));
xmax = max(PlotData.xContourPupilData(:));
xcent = mean([xmin xmax]);
xsize = xmax - xmin;
ymin = min(PlotData.yContourPupilData(:));
ymax = max(PlotData.yContourPupilData(:));
ycent = mean([ymin ymax]);
ysize = ymax - ymin;
maxsize = max([xsize ysize]);

% Move the centre to zero
PlotData.xContourPupilData = PlotData.xContourPupilData - xcent;
PlotData.yContourPupilData = PlotData.yContourPupilData - ycent;
% Scale the data to the maximum plot dimension in points - 72 points per inch
PlotData.xContourPupilData = ptMaxPlotSize * PlotData.xContourPupilData / maxsize;
PlotData.yContourPupilData = ptMaxPlotSize * PlotData.yContourPupilData / maxsize;
% Finally move the data to the centre of the page (A4)
PageCentre = 72 * [210 297] ./ 25.4;
PlotData.xContourPupilData = PlotData.xContourPupilData + PageCentre(1);
PlotData.yContourPupilData = PlotData.yContourPupilData + PageCentre(2);

% Next compute the bounding box 
xminBB = PageCentre(1) - ptMaxPlotSize*xsize/2/maxsize - ptPlotMargin;
xmaxBB = PageCentre(1) + ptMaxPlotSize*xsize/2/maxsize + ptPlotMargin;
yminBB = PageCentre(2) - ptMaxPlotSize*ysize/2/maxsize - ptPlotMargin;
ymaxBB = PageCentre(2) + ptMaxPlotSize*ysize/2/maxsize + ptPlotMargin;


%% Open up the output file and write the PostScript
PSfid = fopen(PlotData.Filename, 'w');

% If you want one % sign put in 2, if you want 2, put in 4
fprintf(PSfid, '%%!PS-Adobe-3.0 EPSF-3.0\n');
fprintf(PSfid, '%%%%BoundingBox: %f %f %f %f\n', xminBB, yminBB, xmaxBB, ymaxBB);
fprintf(PSfid, '%%%%BeginProlog\n');
fprintf(PSfid, '%%%%EndProlog\n');
% Write a contour for each pupil radius and 
for iContour = 1:size(PlotData.xContourPupilData,2)
    fprintf(PSfid, 'newpath\n');
    fprintf(PSfid, '%f %f moveto\n', PlotData.xContourPupilData(1,iContour), PlotData.yContourPupilData(1,iContour));
    for iRay = 1:size(PlotData.xContourPupilData,1)
        fprintf(PSfid, '%f %f lineto\n', PlotData.xContourPupilData(iRay,iContour), PlotData.yContourPupilData(iRay,iContour));
    end
    fprintf(PSfid, 'closepath\n');
    fprintf(PSfid, '2 setlinewidth\n');
    fprintf(PSfid, 'stroke\n');

end
fprintf(PSfid, 'showpage\n');
fprintf(PSfid, '%%%%EOF\n');
fclose(PSfid);
