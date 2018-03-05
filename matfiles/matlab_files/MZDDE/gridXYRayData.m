function RayDataOut = gridXYRayData(x, y, xname, yname, radius)
% gridXYRayData - Generate a 2D grid of data in a struct with the given field names.
%
% RayDataOut = gridXYRayData(x, y, xname, yname, radius);
%
% x and y are are numeric vectors, xname and yname are strings, radius is a numeric scalar.
% Creates a vector struct (RayDataOut) with two fields called xname and yname. The elements of the struct have a
% meshgrid of values taken from the x and y vector inputs. Only elements with a hypotenuse (sqrt(x^2+y^2)) of less
% than or equal to the given value are included in the struct. This function is useful for generating data
% compatible for input to zArrayTrace. The "radius" input is used to include only points within a circular
% pupil for example to generate data for a mode 0 call to zArrayTrace with rays spread evenly over the pupil
% in a rectangular grid ...
%
% Example :
% >> x = -1:0.1:1; y = -1:0.1:1;
% >> RayData = gridXYRayData(x, y, 'z', 'l', 1.0);
%
% The "radius" input is only used if specified greater than 0.
%
% See also zArrayTrace, genRayDataMode0

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


[X,Y] = meshgrid(x,y);
if radius > 0.0
    r = sqrt(X.*X + Y.*Y); % Find the distance of each point from the origin
    list = find(r <= radius); % Get a list of indices for which the distance is less than radius
    % Create a struct with two fields having the given names 
    RayDataOut = struct(xname, num2cell(X(list)), yname, num2cell(Y(list)));
else
    RayDataOut = struct(xname, num2cell(reshape(X,1,numel(X))), yname, num2cell(reshape(Y,1,numel(Y))));
end
