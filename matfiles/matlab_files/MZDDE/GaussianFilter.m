function Filter = GaussianFilter(Wv, WvCentre, WvFWHM)
% GaussianFilter : Create a filter with a gaussian shape
%
% Filter = GaussianFilter(Wv, WvCentre, WvFWHM)
%
% This is a gaussian band pass filter.
%
% Inputs :
%   Wv is a vector of wavelength (or other x-axis variable) at which to
%      compute the filter.
%   WvCentre is the centre wavelength of the filter.
%   WvFWHM is the full width at half maximum of the filter.
%
% See also : GaussianCutOffFilter, GaussianCutOnFilter
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

a = WvCentre;

x = (Wv-a)./(WvFWHM/(sqrt(log(2))*2));
Filter = exp(-(x).^2);

