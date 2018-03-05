function h = PlotSchottFilters(TheFilters, PlotRange, PlotDensity)
% PlotSchottFilters : Plots a number of Schott filter transmittance graphs
%
% Usage : 
%   >> h = PlotSchottFilters(TheFilters);
%      or
%   >> h = PlotSchottFilters(TheFilters, PlotRange);
%      or
%   >> h = PlotSchottFilters(TheFilters, PlotRange, PlotDensity);
%
% Where :
%   TheFilters is a structure containing Schott filter material data as
%   read by the function ReadSchottFilters.m. TheFilters may be an array
%   of structures. A new graph is created for every column of TheFilters.
% 
%   The optional parameter PlotRange is a vector of 4 numbers giving the
%   limits of the x and y axes, as for the axis function.
%
%   The optional parameter PlotDensity is a flag that if set non-zero will
%   plot the optical density (-log of the transmittance) instead. Give
%   the PlotRange parameter as [] if you don't wish to specify the axis
%   limits, but want a log plot.
%
%   h is a vector of plot handles returned.
%
% See Also : ReadSchottFilters, AlterSchottFilterThickness, axis
%
% Example :
%  >> FilterData = ReadSchottFilters('BG38'); % Filter data for Schott BG38
%  >> NewFilterData = AlterSchottFilterThickness(FilterData, 5); 
%  >> PlotSchottFilters([FilterData NewFilterData]'); % Plot on same graph
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

for iCol = 1:size(TheFilters, 2)
    h(iCol) = figure;
    if exist('PlotDensity', 'var') && PlotDensity
       plot(TheFilters(iCol).TransWv, -log([TheFilters(:, iCol).Trans]));
       ylabel('Optical Density');
       title('Schott Filter Material Optical Density');    
    else
       plot(TheFilters(iCol).TransWv, [TheFilters(:, iCol).Trans]);
       ylabel('Internal Transmittance');
       title('Schott Filter Material Internal Transmittance');    
    end
    xlabel('Wavelength (\mum)');
    grid;
    for iRow = 1:size(TheFilters, 1) % Compile the legends
        TheLegend{iRow} = [TheFilters(iRow, iCol).Type ', ' num2str(TheFilters(iRow, iCol).RefThick) ' mm'];
    end
    legend(TheLegend, 'Location', 'Best');
    if exist('PlotRange', 'var') && ~isempty(PlotRange)
        axis(PlotRange);
    end
end
