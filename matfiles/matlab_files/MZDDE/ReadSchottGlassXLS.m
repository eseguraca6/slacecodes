function GlassData = ReadSchottGlassXLS(Glasses, Filename)
% ReadSchottGlassXLS : Read Schott glass data from original Schott XLS file
%
% This function attempts to read data from a Schott XLS glass database
% which is published and updated periodically on the Schott website.
% If the format of the XLS file should change, this function may not work.
%
% You can read older data (Feb 2008) using the function ReadSchottGlassData.m
%
% Usage :
%  >> GlassData = ReadSchottGlassXLS(Glasses, Filename); % Read specific glasses
%     or
%  >> GlassData = ReadSchottGlassXLS(Glasses); % Read specific glasses
%     or
%  >> GlassData = ReadSchottGlassXLS; % Read all glasses
%
% Where :
%   Glasses is a glass type name or cell array of glass type names e.g. 'N-BK7'.
%     If Glasses is empty ('') or not given, then all glasses are read.
%   Filename is the Schott XLS database filename from which to read the data.
%     If the filename is not given, then the last known Schott XLS file
%     in the Materials sub-folder is read.
%     If the filename is given as empty (''), then a file-open dialog is presented.
%
%   GlassData is a structure array returned with the following fields.
%     Manuf - the manufacturer 'Schott'
%     Type - Glass type e.g. 'N-BK7' in upper case
%     nd - refractive index at 587.5618 nm wavelength (d-line)
%     ne - refractive index at 546.0740 nm wavelength (e-line)
%     vd - Abbe dispersion
%     ve - Abbe number at 587.5618 nm wavelength (d-line)
%     ColorCode - wavelength for transmission 0.80 (0.70) and 0.05; glass thickness: 10 mm
%     StressOpticCoeff - stress optical coefficient in [10^-6 MPa^-1]
%     BubbleClass - bubble class
%     ClimateResistCR - climatic resistance class (ISO/WD 13384)
%     StainResistFR - stain resistance class 
%     AcidResistSR - acid resistance class (ISO 8424)
%     AlkaliResistAR - alkali resistance class (ISO 10629)
%     PhosphateResistPR - phosphate resistance class (ISO 9689)
%     Density - mechanical density in g/cm^3
%     Tg - glass transformation temperature [°C] (ISO 7884-8)
%     T13 - temperature at the glass viscosity of 10^13 dPas
%     T7p6 - temperature at the glass viscosity of 10^7.6 dPas
%     cp - heat capacity [J/g/K]
%     ThermalConduct - heat conductivity [W/m/K]
%     CTEmin30plus70 - coefficient of linear thermal expansion between -30 and 70°C [ppm/K]
%     CTEplus20plus300 - coefficient of linear thermal expansion between 20 and 300°C [ppm/K]
%     YoungsMod - Young's modulus [GPa]
%     Poisson - Poisson ratio
%     KnoopHK - Knoop hardness (ISO 9385)
%     AbrasionHG - Grindability class (ISO 12844)
%     K - stress optical coefficient in [ppm/MPa] (again ?)
%     Glascode - glascode (9 digit)
%     Remarks - any relevant remarks about the glass
%     Date - date of latest information
%     RelPrice - relative price compared to the price of N-BK7
%     DispersionCoeff - coefficients of the dispersion relation
%     DispersionForm - Schott uses Zemax dispersion formula 2 (Sellmeier 1 formula)
%     dndTCoeff - coefficients of the dndT relation [D0;D1;D2;E0;E1;lambda]
%     Trans25mm - internal transmission of 25 mm sample at wavelengths TransWv
%     TransWv - wavelength at which transmission data is given (microns)
%     Trans10mm - internal transmission of 10 mm sample at wavelengths TransWv
%
% Transmission values and other values that are not defined explicitly in the Schott catalogue
%  are returned as NaNs.
% Beware of the order of the coefficients of the dispersion relation and the
%  thermo-refractive relation. Schott uses the "Sellmeier 1" formula 
%  documented in the Zemax manual. The coefficients returned by this function
%  are in the same order as in the Zemax glass catalogues.
%
% Examples :
%  >> GlassData = ReadSchottGlassXLS; % Read all glasses from last known database
%
%  >> GlassData = ReadSchottGlassXLS({'n-bk7', 'n-f2'}, '');
%
% The last example will read data for glasses N-BK7 and N-F2 from
% a .xls Schott database selected with a file-open dialog.
%
% See Also : ReadSchottGlassData, ReadSchottFilters, PlotSchottFilters

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

% $Date:$
% $Revision:$
% $Author:$

% Check on filename parameter
persistent Headers260208 TransWv
DefaultFilename = 'Materials\SchottOpticalGlass260208.xls';

if exist('Filename', 'var') 
    if isempty(Filename) % Open the file open dialog
        [Filename, Path] = uigetfile({'*.xls', 'Microscoft Excel Files'},'Open Schott Glass .xls Database', DefaultFilename');
        if Filename
            Filename = [Path Filename];
        else
            GlassData = [];
            return; % User canceled
        end
    else
        if ~exist(Filename, 'file') 
           error('ReadSchottGlassXLS:FileDoesNotExist', ['File ' Filename ' does not exist.']);
        end
    end
else
    Path = fileparts(which('ReadSchottGlassXLS'));
    Filename = [Path '\' DefaultFilename];
end
% Create an empty structure the same as that returned by other glass data reading functions.
GlassData = GetGlassDataEmptyStruct;
% Load the old headers if not already loaded
if isempty(Headers260208)
   PathMat = fileparts(which('ReadSchottGlassXLS'));
   load([PathMat '\Materials\SchottHeaders260208.mat']);
end


% Attempt to read this file, starting with the column headers
% on row 4
Datatable = 'Datatable'; % Sheet name for the data
Description = 'Description'; % Sheet name for the field descriptions
StartRow = 5; % This is the row on which the data starts
HeaderRange = ['B' num2str(StartRow-1) ':FZ' num2str(StartRow-1)];
StartRow = num2str(StartRow);

[Numbers, Headers] = xlsread(Filename, Datatable, HeaderRange);
Headers = strtrim(Headers); % Remove leading and trailing blanks

% Check that first 160 headers are the same as before
for iHeader = 1:160
    if ~strcmp(Headers{iHeader}, Headers260208{iHeader})
        warning('ReadSchottGlassXLS:HeadersChanged', ...
            'The headers in the Schott database have changed from version 260208.');
    end
end


%% Now read the blocks of data and distribute into a structure

% First read the glass types
TypeRange = ['A' StartRow ':A256']; % Surely Schott won't increase to more than this number of materials ?
[Numbers, Types] = xlsread(Filename, Datatable, TypeRange);
Types = deblank(Types);
nTypes = length(Types);
for iType = 1:nTypes
    GlassData(iType).Catalog = 'Schott';
    GlassData(iType).Type = Types{iType};
end
LastRow = num2str(nTypes + 4);

% Read the refractive indices
Range = ['B' StartRow ':E' LastRow];
Indices = xlsread(Filename, Datatable, Range);

% Read the Color Codes
Range = ['F' StartRow ':F' LastRow];
[Numbers, ColorCodes] = xlsread(Filename, Datatable, Range);
ColorCodes = deblank(ColorCodes);

% Read the dispersion formula and dndT coeffcients
Range = ['G' StartRow ':R' LastRow];
DispersionCoeffs = xlsread(Filename, Datatable, Range);

% Read the stress optical coefficients, transmission data, mechanical properties, thermal properties etc.
Range = ['AK' StartRow ':DL' LastRow];
TransMech = xlsread(Filename, Datatable, Range);
Trans25mm = fliplr(TransMech(:,2:31));
Trans10mm = fliplr(TransMech(:,32:61));

% Read glasscode through to relative price
Range = ['FC' StartRow ':FF' LastRow];
[RelPrice, CodeThruDate] = xlsread(Filename, Datatable, Range);
CodeThruDate = deblank(CodeThruDate);

for iType = 1:nTypes
    GlassData(iType).nd = Indices(iType,1);
    GlassData(iType).ne = Indices(iType,2);
    GlassData(iType).vd = Indices(iType,3);
    GlassData(iType).ve = Indices(iType,4);
    GlassData(iType).ColorCode = ColorCodes{iType};
    GlassData(iType).StressOpticCoeff = TransMech(iType, 1);
    GlassData(iType).BubbleClass = TransMech(iType, 62);
    GlassData(iType).ClimateResistCR = TransMech(iType, 63);
    GlassData(iType).StainResistFR = TransMech(iType, 64);
    GlassData(iType).AcidResistSR = TransMech(iType, 65);
    GlassData(iType).AlkaliResistAR = TransMech(iType, 66);
    GlassData(iType).PhosphateResistPR = TransMech(iType, 67);
    GlassData(iType).Density = TransMech(iType, 68);
    GlassData(iType).Tg = TransMech(iType, 69);
    GlassData(iType).T13 = TransMech(iType, 70);
    GlassData(iType).T7p6 = TransMech(iType, 71);
    GlassData(iType).cp = TransMech(iType, 72);
    GlassData(iType).ThermalConduct = TransMech(iType, 73);
    GlassData(iType).CTEmin30plus70 = TransMech(iType, 74);
    GlassData(iType).CTEplus20plus300 = TransMech(iType, 75);
    GlassData(iType).YoungsMod = TransMech(iType, 76);
    GlassData(iType).Poisson = TransMech(iType, 77);
    GlassData(iType).KnoopHK = TransMech(iType, 78);
    GlassData(iType).AbrasionHG = TransMech(iType, 79);
    GlassData(iType).K = TransMech(iType, 80);
    GlassData(iType).Glascode = CodeThruDate{iType, 1};
    GlassData(iType).Remarks = CodeThruDate{iType, 2};
    GlassData(iType).Date = CodeThruDate{iType, 3};
    GlassData(iType).RelPrice = RelPrice(iType);
    C = DispersionCoeffs(iType, 1:6);
    GlassData(iType).DispersionCoeff = [C(1);C(4);C(2);C(5);C(3);C(6)]; % Zemax order
    GlassData(iType).DispersionForm = 2; % Zemax Sellmeier 2 formula
    GlassData(iType).dndTCoeff = DispersionCoeffs(iType, 7:12)';
    GlassData(iType).Trans25mm = Trans25mm(iType, :)';
    GlassData(iType).TransWv = TransWv/1000; % Convert to microns
    GlassData(iType).Trans10mm = Trans10mm(iType, :)';
end

% Perform data selection
if exist('Glasses', 'var') && ~isempty(Glasses) % User wants to select data
    if ischar(Glasses)
        Glasses = {Glasses}; % Make cell array
    end
else
    return; % All data is returned
end

if ~iscellstr(Glasses)
    error('ReadSchottGlassData:BadGlassesParam','Input parameter Glasses must be a string or cell array of strings.')
end
Glasses = upper(Glasses);

for iSelect = 1:length(Glasses)
  iMatch(iSelect) = 0;
  for iType = 1:length(GlassData)
    if strcmp(Glasses{iSelect}, GlassData(iType).Type);
        SelectGlassData(iSelect) = GlassData(iType);
        iMatch(iSelect) = 1;
    end
  end
  if ~iMatch(iSelect)
      warning('ReadSchottGlassData:GlassTypeNotFound', ['Schott Glass data not found for type "' Glasses{iSelect} '".'])
  end
end
if any(iMatch)
  GlassData = SelectGlassData;
else
  GlassData = [];
end
