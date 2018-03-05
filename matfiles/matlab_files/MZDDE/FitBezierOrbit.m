function [ControlPoints1, ControlPoints2] = FitBezierOrbit(Points, Flatness)
% FitBezierOrbit : Fit a closed set of cubic Bezier curves to a set of points in any number of dimensions.
%
% The set of cubic Bezier curves is fitted assuming that the curve returns
% to the starting point. The method is simple and relatively efficient
% compared to more complex methods. The computed sequence of Bezier curves
% pass exactly through the given Points, returning to the starting point.
%
% Usage :
%   >> [ControlPoints1, ControlPoints2] = FitBezierOrbit(Points, Flatness)
%
% Input :
%   Points are a matrix of coordinates lying on the curve. This must be a
%    2D matrix with the coordinates in a particular dimension varying down
%    the rows of the matrix. There must be at least 3 points (i.e 3 by 1
%    input matrix).
%   Flatness is a parameter which controls the shape of the Beziers. A value
%    of about 0.55 gives a relatively smooth curve. Smaller values result in
%    kinks at the Points, while larger values result in kinks between Points.
%    Flatness of 0 creates a polygon passing through Points. A different
%    Flatness for each of the dimensions can be specified by giving a row
%    vector having the same number of columns as the Points input. Flatness can
%    also be specified at each of the Points by giving Flatness as a matrix the
%    same size as Points. Negative values for Flatness can cause cusps at the
%    Points.
% Output :
%   ControlPoints (1 and 2) are the coordinates of the 2 cubic Bezier control points.
%
%   The resulting sequence of Beziers can be rendered very nicely using the
%   PostScript language together with a PostScript printer, GhostView and
%   GhostScript or Adobe Distiller/Acrobat.
%
%   Alternatively, the cubic Bezier equation can be used to compute
%   intermediate points along the orbit. This can be done using the 
%   function GetPointOnBezierOrbit.
%
% See also : GetPointOnBezierOrbit, PlotBezierOrbitPS
%

%% BSD Licence
% This file is subject to the terms and conditions of the BSD licence.
% For further details, see the file BSDlicence.txt
%
% Contact : dgriffith@csir.co.za
%

% $Revision: 221 $
% $Author: DGriffith $

%% Check inputs
if size(Points,1) < 3
   error('FitBezierOrbit:NotEnoughPoints','Input Points must have at least 3 rows (points).')
end
if ~exist('Flatness', 'var')
    Flatness = 0.55;
else
    if all(size(Flatness)==[1 size(Points,2)])
        % Replicate flatness for all data down rows
        Flatness = repmat(Flatness, size(Points,1), 1);
    else
        if ~all(size(Flatness)==size(Points))
          Flatness = Flatness(1); % Anything else make it scalar if not already
        end
    end
end

%% Compute the Control Points
% Compute the differential movement of the points
delta = Points - circshift(Points,1);
% Calculate the mean slope at the Points
meandelta = (delta + circshift(delta,-1))./2;
% Calculate first control point
ControlPoints1 = Points + Flatness .* meandelta;
% Calculate second control Point
ControlPoints2 = circshift(Points,-1) - Flatness .* circshift(meandelta,-1);
