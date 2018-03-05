function PlotBezierOrbitPS(PlotData)
% PlotBezierOrbitPS : Create PostScript plot of a 2D cubic Bezier orbit
%
% An "orbit" here means a closed curve in a multi-dimensional space. A subset
% of such closed orbital curves can be represented using a series of cubic
% Bezier curves.
% An orbit passing through a sequence of points in (multi-dimensional) space
% can be created using the function FitBezierOrbit. FitBezierOrbit returns the
% Bezier control points for each of the given points on the orbit.
% This function takes the original points together with the control points
% returned by FitBezierOrbit and generates a PostScript or encapsulated
% PostScript file with a plot of the first 2 dimensions of the data as
% an x-y plot.
%
% Usage :
%
%   >> PlotBezierOrbitPS(PlotData)
%
% Where :
%  PlotData is a structure with the following fields. Only the Points are compulsory.
%  The remaining fields will be given default values.
%   Filename is the filename of the PostScript or encapsulated PostScript file to
%     write the plot to. The plot can be rendered by sending it to a PostScript
%     (color) printer, or scan converted to pixel graphics using GhostView,
%     GhostScript or Adobe Acrobat/Distiller. If Filename is given as empty
%     or omitted, a file/save dialog will be presented. If the .eps extension
%     is used for the file, a bounding box is included in the file.
%   Points are the points in space through which the orbital curve passes.
%     This must be a 2D matrix with the coordinates in a particular dimension varying down
%     the rows of the matrix. There must be at least 3 points (i.e 3 by 1
%     input matrix).
%   ControlPoints1 and ControlPoints2 must each be matrices of the same size as
%     the Points field. These matrices must contain the Bezier control point
%     coordinates for the Bezier curve orbit. They can be generated using the
%     function FitBezierOrbit. If these fields are not given, they will
%     be generated using FitBezierOrbit.
%   Flatness is a parameter influencing the shape of the curve if FitBezierOrbit
%     is called to generate the control points (see previous fields). See the
%     documentation for FitBezierOrbit for more information.
%   LineColor is a 3-vector giving the RGB color in which to draw the curve. The
%     default is black.
%   LineWidth is the linewidth in points (1 pt = 1/72 inches) with which to plot
%     the lines. The default is 1 pt.
%   FillColor is the color with which to fill the closed curve. If not given
%     or not a valid color 3-vector no filling will be done.
%   MaxPlotSize is the maximum size of the plotted contour diagram in mm.
%     MaxPlotSize defaults to 100 mm. Note that this only guarantees that
%     the given Points will lie within the MaxPlotSize window. The curve 
%     itself may travel out of the window. In this case, the MaxPlotSize
%     may have to be reduced to keep the entire curve on the page.
%   MarginSize is the size of the margin around the contour spot diagram
%     in mm. MarginSize defaults to 10 mm. MarginSize is used to determine
%     the size of the bounding box around the contour spot.
%   PageSize is the size (in mm) of the page to use when centering the plot.
%     PageSize defaults to A4 []. Letter size is [215.9 279.4] mm.
%
% See also : FitBezierOrbit, GetPointOnBezierOrbit

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

%% Do some input checking
if ~isfield(PlotData, 'Points')
    error('PlotBezierPS:NoPoints','The field Points must be defined for the input PlotData.')
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
% Check enough input Points
if ~all(size(PlotData.Points) >= [3 2])
    error('PlotBezierOrbitPS:NotEnoughPoints','Input Points must have at least 3 rows (points) in 2D (columns).')
end

if isfield(PlotData, 'ControlPoints1') && isfield(PlotData, 'ControlPoints2')
    % Check that control points matrices have same size as points
    if ~all(size(PlotData.Points)==size(PlotData.ControlPoints1)) || ~all(size(PlotData.Points)==size(PlotData.ControlPoints2))
      error('GetPointOnBezierOrbit:BadInputSize','Inputs Points, ControlPoints1 and ControlPoints2 must be the same size.')
    end
else
    % Need the flatness parameter in order to compute
    if ~isfield(PlotData, 'Flatness')
      PlotData.Flatness = 0.55;
    else
      if all(size(PlotData.Flatness)==[1 size(PlotData.Points,2)])
        % Replicate flatness for all data down rows
        PlotData.Flatness = repmat(PlotData.Flatness, size(PlotData.Points,1), 1);
      else
        if ~all(size(PlotData.Flatness)==size(PlotData.Points))
          PlotData.Flatness = PlotData.Flatness(1); % Anything else make it scalar
        end
      end
    end
    % Call FitBezierOrbit to get the control points
    [PlotData.ControlPoints1, PlotData.ControlPoints2] = FitBezierOrbit(PlotData.Points, PlotData.Flatness);
end

if isfield(PlotData, 'LineColor')
  if ~isvector(PlotData.LineColor) || length(PlotData.LineColor) ~= 3 || ~all(PlotData.LineColor <=1) || ~all(PlotData.LineColor >= 0)
    warning('PlotBezierOrbitPS:BadLineColorVector','Input LineColor must be a 3-vector >=0 and <=1. Assuming black.')
    PlotData.LineColor = [0 0 0];
  end
else
    % Default to black
    PlotData.LineColor = [0 0 0];
end

if isfield(PlotData, 'FillColor')
  if ~isvector(PlotData.FillColor) || length(PlotData.FillColor) ~= 3 || ~all(PlotData.FillColor <=1) || ~all(PlotData.FillColor >= 0)
    warning('PlotBezierOrbitPS:BadFillColorVector','Input FillColor must be a 3-vector >=0 and <=1. No filling will be done.')
    PlotData.FillColor = [];
  end
else
    % Default to no filling
    PlotData.FillColor = [];
end

if isfield(PlotData, 'LineWidth')
    PlotData.LineWidth = abs(PlotData.LineWidth(1)); % Linewidth is in 1/72 inches
else
    PlotData.LineWidth = 1; % 2 points = 1/36 inches
end

if isfield(PlotData, 'MaxPlotSize')
    PlotData.MaxPlotSize = abs(PlotData.MaxPlotSize(1));
else
    PlotData.MaxPlotSize = 100; % mm
end

% PlotMargin only used if encapsulated PostScript file is selected
if isfield(PlotData, 'PlotMargin')
    PlotData.PlotMargin = abs(PlotData.PlotMargin(1));
else
    PlotData.PlotMargin = 10; % mm
end

if isfield(PlotData, 'PageSize') && all(size(PlotData.PageSize)==[1 2])
    PageSize = PlotData.PageSize;
else % set size to A4
    PageSize = [210 297];
end
    

%% Find plot limits
% Convert plot size and border to points
ptMaxPlotSize = 72 * PlotData.MaxPlotSize / 25.4; % 72 points per inch
ptPlotMargin = 72 * PlotData.PlotMargin / 25.4;

%% Find the plot limits of the data and transform to the centre of the standard PS page
xmin = min(PlotData.Points(:,1));
xmax = max(PlotData.Points(:,1));
xcent = mean([xmin xmax]);
xsize = xmax - xmin;
ymin = min(PlotData.Points(:,2));
ymax = max(PlotData.Points(:,2));
ycent = mean([ymin ymax]);
ysize = ymax - ymin;
maxsize = max([xsize ysize]);
ptxcent = ptMaxPlotSize * xcent / maxsize;
ptycent = ptMaxPlotSize * ycent / maxsize;
LineWidth = PlotData.LineWidth * maxsize / ptMaxPlotSize;

% % All the following shifting and scaling should be done in PostScript
% % Move the centroid of the Points to zero
% PlotData.Points(:,1) = PlotData.Points(:,1) - xcent;
% PlotData.Points(:,2) = PlotData.Points(:,2) - ycent;
% PlotData.ControlPoints1(:,1) = PlotData.ControlPoints1(:,1) - xcent;
% PlotData.ControlPoints2(:,1) = PlotData.ControlPoints2(:,1) - xcent;
% PlotData.ControlPoints1(:,2) = PlotData.ControlPoints1(:,2) - xcent;
% PlotData.ControlPoints2(:,2) = PlotData.ControlPoints2(:,2) - xcent;
% 
% % Scale the data to the maximum plot dimension in points - 72 points per inch
% PlotData.Points = ptMaxPlotSize * PlotData.Points / maxsize;
% PlotData.ControlPoints1 = ptMaxPlotSize * PlotData.ControlPoints1 / maxsize;
% PlotData.ControlPoints2 = ptMaxPlotSize * PlotData.ControlPoints2 / maxsize;
% 
% % Finally move the data to the centre of the page 
PageCentre = 72 * PageSize ./2 ./ 25.4;
% PlotData.Points(:,1) = PlotData.Points(:,1) + PageCentre(1);
% PlotData.Points(:,2) = PlotData.Points(:,2) + PageCentre(2);
% PlotData.ControlPoints1(:,1) = PlotData.ControlPoints1(:,1) + PageCentre(1);
% PlotData.ControlPoints2(:,1) = PlotData.ControlPoints2(:,1) + PageCentre(1);
% PlotData.ControlPoints1(:,2) = PlotData.ControlPoints1(:,2) + PageCentre(1);
% PlotData.ControlPoints2(:,2) = PlotData.ControlPoints2(:,2) + PageCentre(2);

% Next compute the bounding box, only used for encapsulated PostScript 
xminBB = PageCentre(1) - ptMaxPlotSize*xsize/2/maxsize - ptPlotMargin;
xmaxBB = PageCentre(1) + ptMaxPlotSize*xsize/2/maxsize + ptPlotMargin;
yminBB = PageCentre(2) - ptMaxPlotSize*ysize/2/maxsize - ptPlotMargin;
ymaxBB = PageCentre(2) + ptMaxPlotSize*ysize/2/maxsize + ptPlotMargin;

%% Start the writing of the PostScript file
PSfid = fopen(PlotData.Filename, 'w');
if strcmp(lower(extension), '.eps') % Writing encapsulated PostScript
    % If you want one % sign put in 2, if you want 2, put in 4
    fprintf(PSfid, '%%!PS-Adobe-3.0 EPSF-3.0\n');
    fprintf(PSfid, '%%%%BoundingBox: %f %f %f %f\n', xminBB, yminBB, xmaxBB, ymaxBB);
    fprintf(PSfid, '%%%%BeginProlog\n');
    fprintf(PSfid, '%%%%EndProlog\n');
elseif strcmp(lower(extension), '.ps') % Regular PostScript
    fprintf(PSfid, '%%!PS-Adobe-3.0\n');    
end

% Plot the curve
fprintf(PSfid, '%f %f translate\n',PageCentre(1)-ptxcent, PageCentre(2)-ptycent);
fprintf(PSfid, '%f %f scale\n', ptMaxPlotSize / maxsize, ptMaxPlotSize / maxsize);
fprintf(PSfid, '%f setlinewidth\n', LineWidth);
fprintf(PSfid, 'newpath\n');
fprintf(PSfid, '%f %f moveto\n', PlotData.Points(1,1), PlotData.Points(1,2));
Points2 = circshift(PlotData.Points, -1);
for iPoint = 1:size(PlotData.Points, 1)
    fprintf(PSfid, '%f %f %f %f %f %f curveto\n',PlotData.ControlPoints1(iPoint,1), PlotData.ControlPoints1(iPoint,2), ...
            PlotData.ControlPoints2(iPoint,1),PlotData.ControlPoints2(iPoint,2), Points2(iPoint, 1), Points2(iPoint, 2));
end
fprintf(PSfid, 'closepath\n');
if ~isempty(PlotData.FillColor) % then fill the curve
   fprintf(PSfid, 'gsave %f %f %f setrgbcolor fill grestore\n', PlotData.FillColor(1),PlotData.FillColor(2),PlotData.FillColor(3))
end
if LineWidth > 0 % If linewidth is greater than 0 then stroke the outline as well  
   fprintf(PSfid, '%f %f %f setrgbcolor stroke\n', PlotData.LineColor(1),PlotData.LineColor(2),PlotData.LineColor(3));
end
fprintf(PSfid, 'showpage\n');
fprintf(PSfid, '%%%%EOF\n');
fclose(PSfid);
