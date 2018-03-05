function GlassData = ReadSchottGlassData(Glasses)
% ReadSchottGlassData : Read data for the given Schott glasses
%
% This function reads glass data extracted in .csv format from
% the Schott Excel spreadsheet data table obtained from the Schott
% website. The date of the file update is 2008-02-26.
%
% Usage :
%  >> GlassData = ReadSchottGlassData(Glasses); % Read specific glasses
%     or
%  >> GlassData = ReadSchottGlassData; % Read all glasses
%
% Where :
%   Glasses is a string naming a Schott glass type, or a cell array
%    of strings naming a number of types. If the parameter is omitted
%    completely, then data for all glass types is returned.
%
%   GlassData is a structure array containing the following fields :
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
%     DispersionForm - Schott uses the Zemax dispersion formula 2 (Sellmeier 1 formula)
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
% Example :
%   >> GlassData = ReadSchottGlassData({'n-bk7', 'n-sf2'});
%
% Warning : The data returned from this function is as for Schott glass data
%  on 2008-02-26. Schott material data is subject to change without notice.
%  Check the latest data on the Schott website before making any engineering
%  decisions. Always check reported refractive indices carefully.
%
% If you have a fairly recent version of Microsoft Excel installed on your computer
%  you can try to read a more recent version of the Schott database in Excel
%  format using the function ReadSchottGlassXLS. This function depends on Excel.
%
% See Also : ReadSchottFilters, PlotSchottFilters, ReadSchottGlassXLS

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


% $Revision:$
% %Author:$

% Get an empty glass data structure
%
GlassData = GetGlassDataEmptyStruct;

Path = fileparts(which('ReadSchottGlassData'));
fid = fopen([Path '\Materials\SchottOpticalGlass260208Edited.csv']);
% There are 30 string headers
FieldNames = textscan(fid, '%s',30, 'Delimiter',',');
FieldNames = FieldNames{1};
% Read the rest of the data, the format is a little complicated
TheFormat = ['%s%f%f%f%f%s' repmat('%f',1,20) '%s%s%s%f'];
RawData = textscan(fid, TheFormat, 'Delimiter', ',');
fclose(fid);


% Distribute the data into a structure the inefficient way
for iGlass = 1:length(RawData{1})
    GlassData(iGlass).Catalog = 'Schott';
     for iField = 1:length(FieldNames)
       Data = RawData{iField}(iGlass);
       if iscell(Data)
         GlassData(iGlass).(FieldNames{iField}) = deblank(Data{1}); % String
       else
         GlassData(iGlass).(FieldNames{iField}) = Data; % double
       end
     end
end
 
% Now read the dispersion coefficients data
fid = fopen([Path '\Materials\SchottGlassDispersionCoeff.csv']);
DispersionData = textscan(fid, repmat('%f',1,length(GlassData)), 'Delimiter', ',');
fclose(fid);

% Distribute the dispersion data into the structure
for iGlass = 1:length(GlassData)
    C = DispersionData{iGlass};
    GlassData(iGlass).DispersionCoeff = [C(1);C(4);C(2);C(5);C(3);C(6)]; % Zemax order
    GlassData(iGlass).DispersionForm = 2; % Zemax Sellmeier 2 formula    
end

% Read thermal dndT coefficients data
fid = fopen([Path '\Materials\SchottGlassThermoRefractiveCoeff.csv']);
ThermalData = textscan(fid, repmat('%f',1,length(GlassData)), 'Delimiter', ',');
fclose(fid);

% Distribute the dndT data into the structure
for iGlass = 1:length(GlassData)
    GlassData(iGlass).dndTCoeff = ThermalData{iGlass};
end

% Read 25 mm thickness transmission data
fid = fopen([Path '\Materials\SchottGlassTransmittance25mm.csv']);
Data = textscan(fid, repmat('%f',1,length(GlassData)+1), 'Delimiter', ',');
fclose(fid);

% Distribute the 25 mm transmission data into the structure
for iGlass = 1:length(GlassData)
    GlassData(iGlass).Trans25mm = flipud(Data{iGlass+1});
    GlassData(iGlass).TransWv = flipud(Data{1})/1000; % Convert to microns
end

% Read 10 mm thickness transmission data
fid = fopen([Path '\Materials\SchottGlassTransmittance10mm.csv']);
Data = textscan(fid, repmat('%f',1,length(GlassData)+1), 'Delimiter', ',');
fclose(fid);

% Distribute the 10 mm transmission data into the structure
for iGlass = 1:length(GlassData)
    GlassData(iGlass).Trans10mm = flipud(Data{iGlass+1});
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
