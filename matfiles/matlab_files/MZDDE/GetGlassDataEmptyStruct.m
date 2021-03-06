function EmptyGlassDataStruct = GetGlassDataEmptyStruct
% GetGlassDataEmptyStruct : Get an empty structure template for glass data
%
% Usage :
%  >> EmptyGlassDataStruct = GetGlassDataEmptyStruct;
%
% Returns an empty struct used for storing glass and filter material
% data. This structure format is used by various functions,including
%   ReadSchottGlassData - Reads data from processed text (.csv) files
%   ReadSchottGlassXLS  - Reads data from Schott .xls glass database
%   ReadSchottFilters   - Reads data for Schott colored glasses
%   ReadZemaxGlassCat   - Reads data from a Zemax .agf catalog file
%
% The fields in the structure are defined as follows. Depending on the
% source of the data, some fields may be empty.
%
%     Catalog - the catalog or manufacturer e.g. 'SCHOTT'
%     Type - Glass type e.g. 'N-BK7' in upper case
%     nd - refractive index at 587.5618 nm wavelength (d-line)
%     ne - refractive index at 546.0740 nm wavelength (e-line)
%     vd - Abbe dispersion
%     ve - Abbe number at 587.5618 nm wavelength (d-line)
%     ReflFactor - this is the reflection factor loss. Multiply the
%                  internal transmittance by this factor to get the total
%                  transmittance. Valid only for normal incidence without
%                  coating. Usually given only for Schott filter materials.
%     ColorCode - wavelength for transmission 0.80 (0.70) and 0.05; glass thickness: 10 mm
%     StressOpticCoeff - stress optical coefficient in [10^-6 MPa^-1]
%     BubbleClass - bubble class
%     ClimateResistCR - climatic resistance class (ISO/WD 13384)
%     StainResistFR - stain resistance class 
%     AcidResistSR - acid resistance class (ISO 8424)
%     AlkaliResistAR - alkali resistance class (ISO 10629)
%     PhosphateResistPR - phosphate resistance class (ISO 9689)
%     Density - mechanical density in g/cm^3
%     Tg - glass transformation temperature [�C] (ISO 7884-8)
%     T13 - temperature at the glass viscosity of 10^13 dPas
%     T7p6 - temperature at the glass viscosity of 10^7.6 dPas
%     cp - heat capacity [J/g/K]
%     ThermalConduct - heat conductivity [W/m/K]
%     CTEmin30plus70 - coefficient of linear thermal expansion between -30 and 70�C [ppm/K]
%     CTEplus20plus300 - coefficient of linear thermal expansion between 20 and 300�C [ppm/K]
%     TempCoeff - temperature coefficient for Schott filter glasses 
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
%     WaveRange - recommended wavelength range for dispersion formula data
%     dndTCoeff - coefficients of the dndT relation [D0;D1;D2;E0;E1;lambda]
%     RefTemp - reference temperature for material properties
%     RefThick - reference material thickness at which the transmission field (Trans) is given
%     Trans - internal transmission of the material of thickness RefThick given at TransWv
%     Trans25mm - internal transmission of 25 mm sample at wavelengths TransWv
%     TransWv - wavelength at which transmission data is given (microns)
%     Trans10mm - internal transmission of 10 mm sample at wavelengths TransWv
%
% See Also : ReadSchottGlassData, ReadSchottGlassXLS, ReadZemaxGlassCat
%            ReadSchottFilters

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

EmptyGlassDataStruct = struct( ... 
	'Catalog', {}, ...
	'Type', {}, ...
	'nd', {}, ...
	'ne', {}, ...
	'vd', {}, ...
	've', {}, ...
    'ReflFactor', {}, ...
	'ColorCode', {}, ...
	'StressOpticCoeff', {}, ...
	'BubbleClass', {}, ...
	'ClimateResistCR', {}, ...
	'StainResistFR', {}, ...
	'AcidResistSR', {}, ...
	'AlkaliResistAR', {}, ...
	'PhosphateResistPR', {}, ...
	'Density', {}, ...
	'Tg', {}, ...
	'T13', {}, ...
	'T7p6', {}, ...
	'cp', {}, ...
	'ThermalConduct', {}, ...
	'CTEmin30plus70', {}, ...
	'CTEplus20plus300', {}, ...
    'TempCoeff', {}, ...
	'YoungsMod', {}, ...
	'Poisson', {}, ...
	'KnoopHK', {}, ...
	'AbrasionHG', {}, ...
	'K', {}, ...
	'Glascode', {}, ...
	'Remarks', {}, ...
	'Date', {}, ...
	'RelPrice', {}, ...
	'DispersionCoeff', {}, ...
	'DispersionForm', {}, ...
    'WaveRange', {}, ...
	'dndTCoeff', {}, ...
    'RefTemp', {}, ...
    'RefThick', {}, ...
    'Trans', {}, ...
    'TransWv', {}, ...    
	'Trans25mm', {}, ...
	'Trans10mm', {});

