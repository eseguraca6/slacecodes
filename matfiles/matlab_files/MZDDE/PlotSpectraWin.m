function h = PlotSpectraWin(PR715Data)
% PlotSpectraWin - Plots radiometric data exported by Spectrawin from PhotoResearch PR-715
% spectroradiometer.
%
% Usage : h = PlotSpectraWin(PR715Data);
% where PR715Data is the structure returned by ReadPR715txt.
% Returns a handle to the plotted figure.
%
% If the input is a matrix, then a number of figures equal to the number of
% columns is produced with all data in the rows plotted on one graph.
% The graph legend is taken from the description field in the data. The
% graph title is taken from the title field in the data. If there are multiple
% columns in the dataset, the title and axis labels are taken from the structure
% at the top of each column.
%
% See Also : ReadPR715txt

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
% $Date: 2009-10-30 09:07:07 +0200 (Fri, 30 Oct 2009) $

for icol = 1:size(PR715Data, 2)
    h(icol) = figure;
    hold all;
    title(PR715Data(1, icol).title);
    TheLegend = {};
    for irow = 1:size(PR715Data, 1)
        plot(PR715Data(irow, icol).wav, PR715Data(irow, icol).radphot);
        TheLegend{irow} = PR715Data(irow, icol).description;
        if isempty(TheLegend{irow})
            % Use the filename in desperation
            TheLegend{irow} = PR715Data(irow, icol).filename;
        end
    end
    xlabel(['Wavelength (' PR715Data(1, icol).wavunits ')']);
    if strcmp(PR715Data(1, icol).radiometricmode, 'Unknown')
        yquantity = 'Unknown Quantity';
    else
        yquantity = PR715Data(irow, icol).radiometricmode;
    end
    if strcmp(PR715Data(1, icol).radphotunits, 'Unknown')
        yunits = 'Unknown Units';
    else
        yunits = PR715Data(irow, icol).radphotunits;
    end
    grid;
    ylabel([yquantity ' (' yunits ')']);
    legend(TheLegend, 'Location','Best');
    hold off;
end
