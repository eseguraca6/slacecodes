% Examples of the use of the cubic Bezier "orbit" functions.
% $Revision: 221 $
% $Id: BezierExample1.m 221 2009-10-30 07:07:07Z DGriffith $
% 
% Set up a 2D example.
% Define points on a diamond shape
Points2D = [1 0; 0 -1; -1 0; 0 1]; % [x1 y1; x2 y2; ....]
% Get control points for a smooth curve through Points2D, approximating a circle
[c1, c2] = FitBezierOrbit(Points2D, 0.55); % Flatness is 0.55 for smooth curve

% Set up the value of the "time" parameter (t) which tracks a points running
% around the orbit. t runs from 0 at the first point, t = 1 at the second point
% t = 2 at the third point, t = 3 at the fourth point and t = 4 back
% at the first point. Higher values of t orbit around the curve repeatedly.
t = 0:0.02:size(Points2D,1); % Suppose t is time in seconds
% Obtain points on the curve at 20 ms intervals
ppA = GetPointOnBezierOrbit(Points2D,c1,c2,t);
% Plot the y position of the point as a function of the x coordinate
figure;
plot(ppA(:,1), ppA(:,2));
% Plot the x and y coordinates as a function of t
% These will look like a sine and a cosine curve
figure;
plot(t,ppA(:,1), t,ppA(:,2))

% Plot an encapsulated PostScript file of the cubic Bezier orbit through the 2D points 
% There are numerous other plot controls - see PlotBezierOrbitPS help
PlotData.Points = Points2D; % Same points as above
PlotData.ControlPoints1 = c1; % Use the control points with Flatness = 0.55
PlotData.ControlPoints2 = c2;
PlotData.MaxPlotSize = 80; % 80 mm plot size
PlotData.LineColor = [0 0 0]; % Black line
PlotData.FillColor = [0 0.3 0]; % Light Green fill
PlotData.Filename = 'BezierExample1A.eps';
PlotBezierOrbitPS(PlotData);

% Next do a 3D example
Points3D = [0 0 0; 1 0 1; 1 2 0; 2 3 2; 1 2 1; 0 1 0];
[c1, c2] = FitBezierOrbit(Points3D, 0.55);
% Again get points at 20 ms intervals along the curve
t = 0:0.02:size(Points3D,1); % Suppose t is time in seconds
ppB = GetPointOnBezierOrbit(Points3D,c1,c2,t);
figure;
plot3(ppB(:,1), ppB(:,2), ppB(:,3));

