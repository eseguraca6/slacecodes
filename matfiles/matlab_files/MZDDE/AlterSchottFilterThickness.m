function NewFilterData = AlterSchottFilterThickness(OldFilterData, NewThickness)
% AlterSchottFilterThickness : Recomputes filter transmittance for different thickness
%
% Usage :
%   >> NewFilterData = AlterSchottFilterThickness(OldFilterData, NewThickness);
%
% Where :
%   OldFilterData is the filter data as read by ReadSchottFilters.m
%   NewFilterData is the filter data with the transmittance scaled to a
%      different reference thickness. The reference thickness is given
%      in the field RefThickness of the filter data.
%  If OldFilterData comprises a number of filters, they are all  scaled
%      to the new thickness.
%
% Example :
%  >> FilterData = ReadSchottFilters('BG38'); % Filter data for Schott BG38
%  >> NewFilterData = AlterSchottFilterThickness(FilterData, 5); 
%  >> PlotSchottFilters([OldFilterData NewFilterData]');
%
% See Also : ReadSchottFilters, PlotSchottFilters
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
% %Author:$

if ~isscalar(NewThickness) || ~isfloat(NewThickness)
    error('AlterSchottFilterThickness:BadThickness','Input parameter NewThickness must be scalar float.');
end
NewFilterData = OldFilterData;
for iFilter = 1:prod(size(OldFilterData))
    NewFilterData(iFilter).RefThick = NewThickness;
    NewFilterData(iFilter).Trans = NewFilterData(iFilter).Trans .^ (NewThickness / OldFilterData(iFilter).RefThick);
end
