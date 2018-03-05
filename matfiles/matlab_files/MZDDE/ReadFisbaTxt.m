function [Headers, Units, FisbaData] = ReadFisbaTxt(Filename)
% ReadFisbaTxt : Read text saved with continuous export function of Fisba interferometer software
%
% The Fisba MicroPhase interferometer software can be set to export user-selectable data
% to a tab-delimited text file every time a measurement is made.
%
% This function will read both headers and data into a cell array. The headers are assumed to take
% up the first two lines and the data all subsequent lines, so of multiple headers occur, the 
% function may produce errors or corrupted data.
%
% Usage:
% >> [Headers, Units, FisbaData] = ReadFisbaTxt(Filename);
% Where Headers are the headers from the first line in the file.
%       Units are the units or other data from the second line in the file
%       FisbaData is a cell array of data from the remainder of the file.
%
% Data is converted to numeric data where possible. 
%
% DateMeas and TimeMeas columns are converted to vector date and time.
% If both DateMeas and TimeMeas fields are found, a column is added at the
% end of FisbaData called SerialDate, which contains the serial date.
% See datenum.
%
% This function requires the strtrim function to be available in Matlab.
% If strtrim is not available, substitute strtrim(x) with
% deblank(fliplr(deblank(fliplr(x))))
% in the sub-function SplitString at the bottom of this code.
%
% Examples :
% >> [Headers, Units, FisbaData] = ReadFisbaTxt('C:\MyFisbaProjects\MeasurementText.txt');
% To search for a particular header name, use something like
% >> DesiredColumn = strmatch(DesiredHeader, Headers, 'exact'); 
% perhaps
% >> SerialDates = FisbaData{strmatch('SerialDate', Headers, 'exact')}; % Gets the serial date
% strmatch will return empty if there are no header matches.
% >> MTFColumns = strmatch('MTF', Headers}; % Get all header columns starting with 'MTF'
%
% >> strvcat(Headers{strmatch('MTFs_', Headers)}); % List all headers starting with 'MTFs_'
%
% Bugs : Make sure there is a carriage return after the last line of data, otherwise 
% the last line will not be read.

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

% $Date: 2009-10-30 09:07:07 +0200 (Fri, 30 Oct 2009) $
% $Revision: 221 $
% $Author: DGriffith $

% Check file exists
if ~exist(Filename, 'file')
    error(['ReadFisbaTxt:File "' Filename '" does not seem to exist.']);
end


fid = fopen(Filename, 'r');

% Get the header data
head1 = fgetl(fid);
head2 = fgetl(fid);

% Split the headers at tab characters (SplitStringAt function is below)
Headers = SplitStringAt(head1, 9); % tab is ASCII 9
Units = SplitStringAt(head2, 9);

if length(Headers) ~= length(Units)
    error('ReadFisbaTxt:Header Error. Top two lines have different number of tab-delimited fields.');
end

lin = fgetl(fid);
if isempty(lin)
    error(['No Data Found in file ' Filename]);
end
% Preallocate output
FisbaData = cell(1, length(Headers));
iRow = 1;
while ~feof(fid)
    DataLine = SplitStringAt(lin, 9);
    for iCol = 1:length(DataLine)
        FisbaData{iCol} = strvcat(FisbaData{iCol}, DataLine{iCol}); % Vertical catenate
    end
    lin = fgetl(fid);
    iRow = iRow + 1;
end

% Run through and convert known fields
for iCol = 1:length(Headers)
    switch Headers{iCol}
        case 'DateMeas'
           DateData =  datevec(FisbaData{iCol}, 2); % format 2, mm/dd/yy
           if DateData(1,1) < 1900
               DateData(:,1) = DateData(:,1) + 2000; % Assume beyond 2000 if before 1900
           end
           DateData = DateData(:,1:3);
           FisbaData{iCol} = DateData;
        case 'TimeMeas'
           TimeData = datevec(FisbaData{iCol}, 13); % format 13 HH:MM:SS
           TimeData = TimeData(:,4:6);
           FisbaData{iCol} = TimeData;
    end
end

% Run through and convert numerical data
for iCol = 1:length(FisbaData)
    if ischar(FisbaData{iCol})
        NumData = str2num(FisbaData{iCol});
        if ~isempty(NumData)
            FisbaData{iCol} = NumData; % Convert to numeric where possible
        end
    end
end


% Add a serial date field at the end if DateMeas and TimeMeas were found
if exist('DateData', 'var') && exist('TimeData', 'var')
    FisbaData{end+1} = datenum([DateData TimeData]);
    Headers{end+1} = 'SerialDate';
    Units{end+1} = '';
end

fclose(fid);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function SplitString = SplitStringAt(String, delim)
% This sub-function splits a string up at the given delimiter

% Find all the delimiters in the string
k = strfind(String, delim);

% strtrim removes leading and trailing white space
SplitString{1} = strtrim(String(1:k(1)));
for ii = 1:length(k)-1
    SplitString{ii+1} = strtrim(String(k(ii):k(ii+1)));
end
SplitString{length(k)} = strtrim(String(k(end):end));


