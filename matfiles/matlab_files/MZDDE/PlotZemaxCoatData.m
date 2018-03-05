function h = PlotZemaxCoatData(CoatData, ColumnHeaders)
% PlotZemaxCoatData - Plots coating data read with ReadZemaxCoatData
%
% Usage : PlotHandle = PlotZemaxCoatData(CoatData, ColumnHeaders)
%
% Plots data written from a Zemax coating analysis and read into Matlab using ReadZemaxCoatData.
% Will plot specified data as a function of incidence angle or as a function of wavelength.
% ColumnHeaders must be a cell array of strings. All data gets plotted on the same axes. It is therefore
% better not to mix phase and reflectance data.
%
% Example:
% >> CoatData = ReadZemaxCoatData; % Opens dialog to find the .txt coating data file written by Zemax
% >> PlotZemaxCoatData(CoatData, {'S-Reflect', 'P-Reflect}); % Plots coating S and P reflectances
%
% See also : ReadZemaxCoatData, zGetTextFile, ZemaxButtons

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

if ~iscellstr(ColumnHeaders)
    error('ColumnHeaders must be a cell array of strings.')
end

if nargout == 1
 h = figure;
else
  figure;
end

% Find the headers


WantedColumns = [];
for ii = 1:length(ColumnHeaders)

    WantedCol = strmatch(ColumnHeaders{ii}, CoatData.Headers, 'exact'); % Look for exact column header name match
    if isempty(WantedCol)
      warning(['Requested column header "' ColumnHeaders{ii} '" was not found in this coating data.']);
    else
      WantedColumns = [WantedColumns WantedCol]; 
    end
end
hold all;
for ii = 1:length(WantedColumns)
    plot(CoatData.Data{1}, CoatData.Data{WantedColumns(ii)});
end

grid;
xlabel(CoatData.Headers{1});
ylabel('Coating Property as per Legend');
if strcmp(lower(CoatData.Headers{1}), 'wavelength')
    plottitle = ['Coating ' CoatData.CoatName '. Angle ' num2str(CoatData.AngleOfIncidence) ' deg. Incident Med ' ...
                   CoatData.IncidentMedium '. Substrate ' CoatData.Substrate '.'];
    xlabel([CoatData.Headers{1} ' (\mum)']);
    title(plottitle);
else 
    if strcmp(lower(CoatData.Headers{1}), 'angle')
          plottitle = ['Coating ' CoatData.CoatName '. Wavelength ' num2str(CoatData.EvalWave) ' \mum. Incident Med ' ...
                          CoatData.IncidentMedium '. Substrate ' CoatData.Substrate '.'];

          xlabel([CoatData.Headers{1} ' (degrees)']);
          title(plottitle);  
    end
end
legend(CoatData.Headers{WantedColumns});
hold off;
