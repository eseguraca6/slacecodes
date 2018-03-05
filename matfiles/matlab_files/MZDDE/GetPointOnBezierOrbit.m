function [Point, Velocity, Accel] = GetPointOnBezierOrbit(Points, ControlPoints1, ControlPoints2, t)
% GetPointOnBezierOrbit : Compute location of point along a cubic Bezier orbital curve
%
% An cubic Bezier "orbit" in this case is a closed curve in a multi-dimensional space
% defined by a set of cubic Bezier curves. A cubic Bezier curve is defined
% by the starting and ending points and 2 control points (not on the curve)
% that define the direction of departure at the first point on the curve
% and the direction of arrival at the second point on the curve. The
% function FitBezierOrbit can be used to compute a set of control points
% providing a closed orbit passing through a set of specified points.
%
% Usage :
%  >> Point = GetPointOnBezierOrbit(Points, ControlPoints1, ControlPoints2, t);
%    or
%  >> [Point, Velocity] = GetPointOnBezierOrbit(Points, ControlPoints1, ControlPoints2, t);
%    or
%  >> [Point, Velocity, Accel] = GetPointOnBezierOrbit(Points, ControlPoints1, ControlPoints2, t);
%
% Where :
%   Points are the points on the curve. The coordinates of the Points vary
%     down rows and the dimensions of the points (x, y, z ...) vary from
%     column to column.
%   ControlPoints1 and ControlPoints2 are the 2 sets of control points.
%     The size of the matrices Points, ControlPoints1 and ControlPoints2
%     must be the same. These control points can be computed from Points
%     together with a shape parameter (called Flatness) using the function
%     FitBezierOrbit.
%   t is a parameter that runs from 0 at the first of the Points to n-1 at
%     the nth of the Points. If there are a total of N Points, setting t to N will
%     bring you back to the first of the Points. The parameter t can be scalar,
%     or a vector. The returned Point orbits repeatedly around the closed
%     curve as t increases without bound. 
%
% The output Point are the coordinates of the point(s) corresponding to the
%   value(s) of the parameter t.
%   If t is a vector, the returned Point matrix will have columns equal to
%   the number of dimensions (same as the number of column of Points) and
%   rows equal to the length of the vector t.
% The output Velocity is the first derivative of the coordinates with
%   respect to t. Velocity should be a continuous function.
% The output Accel is the acceleration of the point coordinates i.e.
%   second derivative with respect to t. In general, Accel will be
%   discontinuous at the Points on the curve.
%
% Example : See the script BezierExample1.m
%
% See also : FitBezierOrbit, PlotBezierOrbitPS

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

%% Check inputs
if ~all(size(Points)==size(ControlPoints1)) || ~all(size(Points)==size(ControlPoints2))
    error('GetPointOnBezierOrbit:BadInputSize','Inputs Points, ControlPoints1 and ControlPoints2 must be the same size.')
end

t = t(:); % Force t to be a column vector


%% Compute the point position from the t parameter
% Firstly the Bezier segment is isolated as 1 plus the integer part of t 

NBezier = size(Points,1);
iBezier = 1 + mod(floor(t),NBezier);
% Get the Points and ControlPoints for the Beziers in iBezier

Points1 = Points(iBezier,:);
ControlPoints1 = ControlPoints1(iBezier,:);
ControlPoints2 = ControlPoints2(iBezier,:);
Points2 = circshift(Points,-1);
Points2 = Points2(iBezier,:);

% Get the fractional part of t
t = t - floor(t);
% Replicate t to the same size as output
t = repmat(t, 1, size(Points1,2));

% Compute the points using the Adobe PostScript definition
c = 3 * (ControlPoints1 - Points1);
b = 3 * (ControlPoints2 - ControlPoints1) - c;
a = Points2 - Points1 - c - b;
Point = a.*t.^3 + b.*t.^2 + c.*t + Points1;

% Compute velocities if nargout = 2
if nargout >= 2
    Velocity = 3*a.*t.^2 + 2*b.*t + c;
end

% Compute accelerations if nargout = 3
if nargout >= 3
    Accel = 6*a.*t + 2*b;
end
