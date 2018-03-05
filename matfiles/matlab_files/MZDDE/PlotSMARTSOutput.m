function h = PlotSMARTSOutput(Data, Headers, Title, AxisBounds, YLabel)
% PlotSMARTSOutput : Plot data read by ReadSMARTSOutput
% 
% SMARTS is the Simple Model of the Atmospheric Radiative Transfer of
% Sunshine, available at http://www.nrel.gov/rredc/smarts/
% SMARTS Author : Christian A. Gueymard
% This function is written for SMARTS 2.9.5
%
% Usage :
%  h = PlotSMARTSOutput(Data)
%  h = PlotSMARTSOutput(Data, Headers)
%  h = PlotSMARTSOutput(Data, Headers, Title)
%  h = PlotSMARTSOutput(Data, Headers, Title, AxisBounds)
%  h = PlotSMARTSOutput(Data, Headers, Title, AxisBounds, YLabel)
%
% Where
%  Data is a cell array of columns of data from a SMARTS output file
%    read with the function ReadSMARTSOutput. It is usually best to plot
%    only a single block of data on each figure. Use multiple calls to
%    this function for multiple plots. If you use subscripting to select
%    certain columns and blocks, use enclosure in {} to make sure
%    the input is a cell array. See the example.
%  Headers is a cell array of strings with which to label the plot.
%  Title is the title of the graph.
%  AxisBounds is an optionsl 4 element vetor giving the bounds of
%    the plot in the x and y axes.
%  YLabel is the label to put on the y-axis. The label defaults to
%    'As For Legend (Irradiance in W/m^2/nm)'. 
%
% Headers, Title and AxisBounds can be given as [] if you wish to
% prescribe subsequent parameters in the function call.
%
% Units of measure of SMARTS output quantities are given in the
% documentation. Irradiance quantities are in W/m^2/nm. Photon flux
% quantities are in quanta/cm^2/s/nm. Photonic energy is in eV.
% Photon flux per eV is in quanta/cm^2/s/eV. Photosynthetic photon
% flux is in micromol/m^2/s/nm.
%    
%  The figure graphics handle is returned in h.
%
% Example:
% % After running SMARTS for the desired scenario and assuming you have at
% % least 3 output quantities in addition to wavelength.
% [a,b] = ReadSMARTSOutput('D:\SMARTS\smarts295.ext.txt'); % Read the data
% % Plot the first four quantities in the first block of data.
% PlotSMARTSOutput({b{1,1:4}},{a{1:4}}, '10:00 am',[400 1000 0 1.3], 'W/m^2/nm')
% % Plot the first four quantities in the second block of data.s
% PlotSMARTSOutput({b{2,1:4}},{a{1:4}}, '11:00 am',[400 1000 0 1.3], 'W/m^2/nm')

% See also : ReadSMARTSInput, TweakSMARTSInput, CheckSMARTSInput, 
%   ReadSMARTSOutput, ScanTextFile

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

% Copyright 2008, DPSS, CSIR
% $Revision: 221 $
% $Author: DGriffith $

% If this is a cell array of dissimilar cases, recursively call for each
% cell and return

if isempty(Data)
    h = [];
    return
end

if iscell(Data{1})
    % disp('Recurring');
    for iCase = 1:numel(Data)
      switch nargin
        case 1, h{iCase} = PlotSMARTSOutput(Data{iCase});
        case 2, h{iCase} = PlotSMARTSOutput(Data{iCase}, Headers{iCase});
        case 3, h{iCase} = PlotSMARTSOutput(Data{iCase}, Headers{iCase}, Title{iCase});
        case 4, h{iCase} = PlotSMARTSOutput(Data{iCase}, Headers{iCase}, Title{iCase}, AxisBounds{iCase});
        case 5, h{iCase} = PlotSMARTSOutput(Data{iCase}, Headers{iCase}, Title{iCase}, AxisBounds{iCase}, YLabel{iCase});
      end
    end
    return;
end

if exist('Headers', 'var')
  if ~iscellstr(Headers)
    error('Input Headers must be a cell array of strings.')    
  end
  if size(Data,2) ~= length(Headers) || ~strcmp(Headers{1}, 'Wvlgth')
      warning('Headers should have same number of entries as there are columns in Data. Include the Wvlgth header.');
  end
end

h = figure;
for iBlock = 1:size(Data,1)
    plot(Data{iBlock,1},[Data{iBlock,2:end}]);
end

% If Headers were given, plot those as legends

if exist('Headers', 'var')
    % First replace underscores with spaces
    Headers = strrep(Headers, '_', ' ');
    Headers = strrep(Headers, 'Difuse', 'Diffuse');
    legend(Headers{2:end}, 'Location', 'Best');
end

grid;
xlabel('Wavelength (nm)');
if exist('YLabel', 'var') && ischar(YLabel)
    ylabel(YLabel)
else
    ylabel('As For Legend (Irradiance in W/m^2/nm)');
end
if exist('AxisBounds', 'var') && length(AxisBounds) == 4
    axis(AxisBounds)
end
if exist('Title', 'var') && ischar(Title)
    title(Title);
else
    title('SMARTS Output Data');
end
