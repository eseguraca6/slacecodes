function z = HexBasePyramid(x, y)
% HexBasePyramid - Computes z coordinates of a hexagonal base pyramid of unity height where the edges of the base
% are of unity length.
%
% The vectors or arrays of coordinates must be of the same length (or size).
% The base of the pyramid is orientated as follows in the x-y plane.
%          ------
%         /      \
%        /        \
%        \        /
%         \      /
%          ------
%
% Example :
%   >> tiles = 1;
%   >> delta = 0.025
%   >> x = -tiles:delta:tiles;
%   >> s3 = sqrt(3);
%   >> y = -tiles*s3/2:delta:tiles*s3/2;
%   >> [x,y] = meshgrid(x,y);
%   >> zz = HexBasePyramid(x,y);
%   >> mesh(zz);

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
% $Author: dgriffith $

% First check that x and y are of the same length.
% meshgrid is a useful function for setting up input data for this function.

if ndims(x) ~= ndims(y)
    error('x and y must be the same shape');
end

if sum(size(x)-size(y)) ~= 0
    error('x and y must be of the same length or size.');
end

% Populate result with zeros
z = zeros(size(x));
% Will be using the square root of 3 quite a lot
s3 = sqrt(3);

% There are six faces, and we start with the uppermost sector
% Sector 1
% Select the elements that lie in sector 1
ii = find(y <= s3/2 & y >= s3*x & y >= -s3*x);
z(ii) = 1 - 2 * y(ii) / s3;

% Sector 2
ii = find(y <= -s3*x & y >= 0 & y <= s3*(x+1));
z(ii) = 1 + x(ii) - y(ii)/s3;

% Sector 3
ii = find(y <= 0 & y >=-s3*(x+1) & y >= s3*x);
z(ii) = 1 + x(ii) + y(ii)/s3;

% Sector 4
ii = find(y <= s3*x & y >= -s3/2 & y <= -s3*x);
z(ii) = 1 + 2*y(ii)/s3;

% Sector 5
ii = find(y <= 0 & y >=-s3*x & y >= s3*(x-1));
z(ii) = 1 - x(ii) + y(ii)/s3;

% Sector 6
ii = find(y >=0 & y <= -s3*(x-1) & y <= s3*x);
z(ii) = 1 - x(ii) - y(ii)/s3;
