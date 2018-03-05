function Filter = GaussianCutOnFilter(Wv, WvHalf, WvHalfWidth)
% GaussianCutOnFilter : Create a cuton filter with a gaussian shape
%
% Filter = GaussianCutOnFilter(Wv, WvHalf, WvHalfWidth)
%
% This is a gaussian-edge high pass filter.
%
% Inputs :
%   Wv is a vector of wavelength (or other x-axis variable) at which to
%      compute the filter.
%   WvHalf is the wavelength at which the filter declines to 50%
%      transmission.
%   WvHalfWidth is the half width of the gaussian filter.
%      i.e. the filter reaches 100% transmission at WvHalf + WvHalfWidth.
%
% See also : GaussianFilter, GaussianCutOffFilter
%

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
% $Author:$

a = WvHalf + WvHalfWidth;

x = (Wv-a)/(WvHalfWidth/sqrt(log(2)));
Filter = exp(-(x).^2);

Filter(x>=0) = 1;
