function GlassData = ReadZemaxGlassCat(Catalog, Glasses)
% ReadZemaxGlassData : Read data from a Zemax glass catalog
%
% Usage :
%  >> GlassData = ReadZemaxGlassCat(Catalog); % Read complete catalog
%     or
%  >> GlassData = ReadZemaxGlassCat(Catalog, Glasses); % Read specific glasses
%
% Where :
%   Catalog is the full path and filename of the Zemax catalog.
%     If Catalog is specified as empty (''), a file open dialog will
%     be presented.
%   Glasses is an optional string or cell array of strings which
%     give the glass types requested.
%
%   GlassData is a structure returned with the following fields,
%     not all of which will have data since the Zemax catalog
%     is not comprehensive in the data that are specified.
%
%     Catalog - the manufacturer e.g. 'SCHOTT', taken from the filename.
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
% Examples :
%  Read data for glass LAFK55 from the Sumita catalog.
%   >> GlassData = ReadZemaxGlassCat('c:\Program Files\ZEMAX\Glasscat\Sumita.agf', 'LAFK55')
%
%   >> GlassData = ReadZemaxGlassCat('', 'N-BK7') % Presents file open dialog, searches for N-BK7
%
% See Also : ReadSchottGlassData, ReadSchottGlassXLS, ReadSchottFilters



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

PossibleLocations = {'c:\ZEMAX\Glasscat\', 'c:\Program Files\ZEMAX\Glasscat\'};
DefaultLoc = '';
for iLoc = 1:length(PossibleLocations)    
    if exist(PossibleLocations{iLoc}, 'dir')
        DefaultLoc = PossibleLocations{iLoc};
    end
end

if exist('Catalog', 'var') && ~isempty(Catalog) 
    if ~exist(Catalog, 'file') 
       error('ReadZemaxGlassCat:FileDoesNotExist', ['File ' Catalog ' does not exist.']);
    end    
else
    % Open the file open dialog
    [Catalog, Path] = uigetfile({'*.agf', 'Zemax .AGF Glass Catalog'},'Open Zemax Glass Catalog', DefaultLoc);
    if Catalog
        Catalog = [Path Catalog];
    else
        GlassData = [];
        return; % User canceled
    end

end

% Create an empty structure the same as that returned by other glass data reading functions.
GlassData = GetGlassDataEmptyStruct;
% The following is an array of the number of coefficients 
nDispersionCoeff = [6 6 6 5 3 8 4 4 5];
% Open the file and process the data line by line
[Path, CatName] = fileparts(Catalog);
fid = fopen(Catalog,'r');
iType = 0; % This counts the glass types as the catalog is read

while ~feof(fid)
    lin = deblank(fgetl(fid));
    switch lin(1:2)
        case 'CC' % This seems to be a catalogue comment field
        case 'NM' % a new glass type name has been encountered
            % First check reference thickness for last glass type
            if iType > 0
                % If all reference thicknesses are the same, then replace
                % the whole RefThick vector with a scalar
                if all(diff(GlassData(iType).RefThick)==0)
                    GlassData(iType).RefThick = GlassData(iType).RefThick(1);
                end
                if GlassData(iType).RefThick == 25
                    GlassData(iType).Trans25mm = GlassData(iType).Trans;
                end
                if GlassData(iType).RefThick == 10
                    GlassData(iType).Trans10mm = GlassData(iType).Trans;
                end
                
            end
            iIT = 0; % Counter for IT transmission data
            iType = iType + 1;
            [TypeName, count, errmsg, nextindex] = sscanf(lin, 'NM %s');
            GlassData(iType).Catalog = CatName; 
            GlassData(iType).Type = TypeName;
            % Scan the numeric data on the remainder of the line
            [NumData, count] = sscanf(lin(nextindex:end), '%f'); 
            GlassData(iType).DispersionForm = NumData(1);
            if NumData(2) > 1
                GlassData(iType).Glascode = num2str(NumData(2));
            else
                GlassData(iType).Glascode = '';
            end
            GlassData(iType).nd = NumData(3);
            GlassData(iType).vd = NumData(4);
            % The next flag on this line it is the "Ignore Substitution" flag (if present)

        case 'ED' % CTE data and stuff
            [NumData, count] = sscanf(lin(3:end), '%f');
            if NumData(1) > 0, GlassData(iType).CTEmin30plus70 = NumData(1); end;
            if NumData(2) > 0, GlassData(iType).CTEplus20plus300 = NumData(2); end;
            GlassData(iType).Density = NumData(3);
        case 'CD' % Dispersion formula coefficients
            [NumData, count] = sscanf(lin(3:end), '%f');
            
            if GlassData(iType).DispersionForm <= length(nDispersionCoeff)
                GlassData(iType).DispersionCoeff = ...
                    NumData(1:min(nDispersionCoeff(GlassData(iType).DispersionForm),count));
            else
                GlassData(iType).DispersionCoeff = NumData;
            end
            
            %return;
        case 'TD' % Thermal data
            [NumData, count] = sscanf(lin(3:end), '%f');
            GlassData(iType).dndTCoeff = NumData(1:6);
            GlassData(iType).RefTemp = NumData(7);
        case 'OD' % Relative cost and environmental data
            [NumData, count] = sscanf(lin(3:end), '%f');
            if NumData(1) >= 0, GlassData(iType).RelPrice = NumData(1); end;
            if NumData(2) >= 0, GlassData(iType).ClimateResistCR = NumData(2); end;
            if NumData(3) >= 0, GlassData(iType).StainResistFR = NumData(3); end;
            if NumData(4) >= 0, GlassData(iType).AcidResistSR = NumData(4); end;
            if NumData(5) >= 0, GlassData(iType).AlkaliResistAR = NumData(5); end;
            if NumData(6) >= 0, GlassData(iType).PhosphateResistPR = NumData(6); end;
        case 'GC' % Comment on this glass - stored as a remark
            GlassData(iType).Remarks = deblank(lin(4:end));
        case 'LD' % Wavelength range
            [NumData, count] = sscanf(lin(3:end), '%f');
            GlassData(iType).WaveRange = NumData;
        case 'IT' % Transmission data
            iIT = iIT + 1;            
            [NumData, count] = sscanf(lin(3:end), '%f');
            GlassData(iType).TransWv(iIT,1) = NumData(1);
            GlassData(iType).Trans(iIT,1) = NumData(2);
            GlassData(iType).RefThick(iIT,1) = NumData(3);
        otherwise
    end
end
fclose(fid);
% Fix the reference thickness for the last glass type
% If all reference thicknesses are the same, then replace
% the whole RefThick vector with a scalar
if all(diff(GlassData(iType).RefThick)==0)
    GlassData(iType).RefThick = GlassData(iType).RefThick(1);
end
if GlassData(iType).RefThick == 25
    GlassData(iType).Trans25mm = GlassData(iType).Trans;
end
if GlassData(iType).RefThick == 10
    GlassData(iType).Trans10mm = GlassData(iType).Trans;
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
      warning('ReadZemaxGlassCat:GlassTypeNotFound', ...
          ['Glass data not found for type "' Glasses{iSelect} '" in catalog ' Catalog '.'])
  end
end
if any(iMatch)
  GlassData = SelectGlassData;
else
  GlassData = [];
end
