function FilterData = ReadSchottFilters(Filter)
% ReadSchottFilters : Read in data for a Schott colored filter glass material
%
% Usage :
%  >> FilterData = ReadSchottFilters(Filter); % Read specific filters
%     or
%  >> FilterData = ReadSchottFilters; % Read all filters
%
% Where :
%  Filter is the name of a Schott colored filter glass e.g. 'BG7'.
%    Filter can also be a cell array of strings e.g. {'BG7', 'UG11'}
%    If the filter parameter is left out, all filters are read.
%
%  FilterData is a structure array returned with the following fields.
%
% Type             : the filter type name 'BG7' etc.
% RefThick         : Reference thickness for the transmittance data in mm
% ReflFactor       : This is the reflection factor loss. Multiply the
%                    internal transmittance by this factor to get the total
%                    transmittance. Valid only for normal incidence without
%                    coating.
% nd               : Refractive index at the d line (587.6 nm)
% BubbleClass      : The bubble class of the material.
% StainResistFR    : Stain resistance class
% AcidResistSR     : Acid resistance class
% AlkaliResistAR   : Alkali resistance class
% Tg               : Transformation temperature in degrees Celcius.
% CTEmin30plus70   : Coefficient of thermal expansion in the -30 to +70 Celsius range
% CTEplus20plus300 : Coefficient of thermal expansion in the +20 to +300 Celsius range
% TempCoeff        : Temperature coefficient
% Remarks          : Description of the material
% Density          : Mechanical density of the material in g/cm^3
%                    NOT optical density
% TransWv          : Wavelengths at which the internal transmittance is given in microns
% Trans            : Internal transmittance of the material for the given
%                    reference thickness (RefThick field).
%                    To get total transmittance, including reflection
%                    losses at the surface for normal incidence, multiply by the
%                    ReflectionFactor field.
%
% See the Schott filter data catalogue for more information.
% http://www.schott.com/advanced_optics/english/download/catalogs.html
%       - Accessed last on 2008-09-05.
%
% Example :
%  >> SomeFilters = ReadSchottFilters({'UG11', 'BG38'}); % Reads two Schott filters
%  >> PlotSchottFilters(SomeFilters'); % Plot on same axes
%
% See Also : AlterSchottFilterThickness, PlotSchottFilters
%
% Warning :
%  This function currently reads Schott 2004 data. Schott catalogue
%  material properties are subject to change without notice. Consult
%  the latest datasheets from Schott before making any engineering
%  decisions.
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
% $Author: DGriffith $

% Prepare the empty output structure so there is uniformity for glasses and
% filter materials.
FilterData = GetGlassDataEmptyStruct;
%
% Open and read the filter type data

Path = fileparts(which('ReadSchottFilters'));
fid = fopen([Path '\Materials\SchottFilterData2004.csv']);
nData = textscan(fid, '%f', 2, 'Delimiter', ',');
nTypes = nData{1}(1); % Number of filter glass types
nFields = nData{1}(2); % Number of fields to be read
FieldNames = textscan(fid, '%s', nFields, 'Delimiter',',');
FieldNames = FieldNames{1};
TypeData = textscan(fid, '%s%f%f%f%f%f%f%f%f%f%f%f%f%s', nTypes, 'Delimiter',',');
TransmissionData = textscan(fid, repmat('%f', 1, nTypes + 1),'Delimiter',',');
fclose(fid);
%FilterData = TypeData;

for iType = 1:nTypes
    FilterData(iType).Catalog = 'Schott';
    % Synthesize the data into a structure
    for iField = 1:nFields
      if iscell(TypeData{iField}(iType))
        FilterData(iType).(FieldNames{iField}) = TypeData{iField}{iType};
      else
        FilterData(iType).(FieldNames{iField}) = TypeData{iField}(iType);  
      end
    end
    FilterData(iType).TransWv = TransmissionData{1}/1000; % Convert to microns
    FilterData(iType).Trans = TransmissionData{iType + 1};
end

if exist('Filter', 'var') % User wants to select data
    if ischar(Filter)
        Filter = {Filter}; % Make cell array
    end
else
    return; % All data is returned
end
Filter = upper(Filter); % Change to upper case
if ~iscellstr(Filter)
    error('ReadSchottFilters:BadFilterParam','Input parameter filter must be a string or cell array of strings.')
end


for iSelect = 1:length(Filter)
  iMatch(iSelect) = 0;
  for iType = 1:nTypes
    if strcmp(Filter{iSelect}, FilterData(iType).Type);
        SelectFilterData(iSelect) = FilterData(iType);
        iMatch(iSelect) = 1;
    end
  end
  if ~iMatch(iSelect)
      warning('ReadSchottFilters:FilterTypeNotFound', ['Schott filter data not found for type "' Filter{iSelect} '".'])
  end
end
if any(iMatch)
  FilterData = SelectFilterData;
else
  FilterData = [];
end
