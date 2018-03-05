function data = SortSpectraWin(SpecData, Field)
% SortSpectraWin : Sorts SpectraWin spectral data according to the given field.
%
% This function is generally used to sort spectral data according to serial date.
% If SpecData is a matrix, it is returned as a sorted column vector. If the Field
% input is omitted, the serialdate field is assumed. Only numeric fields can be given.
%
% Example :
% >> specfiles = dir('SpecDir\*.txt'); % Get all text file names in a directory
% >> specdata = ReadAllPR715txt('SpecDir', specfiles); % Read all the data
% >> specdata = SortSpectraWin(specdata, 'serialdate'); % Sort data on date

if ~exist('Field', 'var')
    Field = 'serialdate';
end

SpecData = reshape(SpecData, numel(SpecData), 1); % Reshape into a column vector

if ~isnumeric(getfield(SpecData, Field))
    error('Field to sort on must be numeric.');
end

for ii = 1:numel(SpecData)
  SortData(ii,1) = getfield(SpecData(ii), Field);
  SortData(ii,2) = ii;
end

SortData = sortrows(SortData);

for ii = 1:numel(SpecData)
    data(ii) = SpecData(SortData(ii,2));
end

data = reshape(data, size(SpecData));
