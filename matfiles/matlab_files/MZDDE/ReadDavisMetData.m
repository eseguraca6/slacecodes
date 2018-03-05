function [Headers, MetData] = ReadDavisMetData(Filename, WantStruct, TheseHeaders, DateFormat)
% ReadDavisMetData : Reads met data exported in text format from Davis Weatherlink software
%
% Usage : 
%      >> [Headers, MetData] = ReadDavisMetData(Filename, WantStruct)
%      >> [Headers, MetData] = ReadDavisMetData(Filename, WantStruct, TheseHeaders)
%      >> [Headers, MetData] = ReadDavisMetData(Filename, WantStruct, TheseHeaders, DateFormat)
%      >> Headers = ReadDavisMetData(Filename)
%
% If the Filename parameter is the empty string, a file-open dialog will be
%   presented.
% If WantStruct is 1, data is returned in a structure with one field per column.
% If WantStruct is 0, data is returned in a cell array. WantStruct will
%   default to 0.
% Data is assumed to be tab-delimited free-form text format.
% Column headers are assumed to take up the first two lines in the data file. 
% These column headers are used to build the field names. Field names are not identical to the column headers in the
% file, as illegal characters must be removed. All non-alphabetic characters are removed.
% Thus sanitized column header names are returned in the first output parameter Headers as a cell array of strings.
% If the parameter TheseHeaders (cell array of strings) is given, only the given data columns are returned. They
% are returned in the same column order as in the data file (ie. in the order of the Headers output parameter), rather
% than in the order specified in the input TheseHeaders parameter. The column order of TheseHeaders does not matter.
% If the input parameter TheseHeaders is omitted, all data is read.
% Numeric data is detected and converted to class double.
% If date and time data are read, another field is added called SerialDate. See Matlab documentation
% on the meaning of a serial date. Serial dates are convenient for plotting the data and/or aligning
% the data with other data recorded on a different time grid. A problem may
% be encountered with the order of the month, day and year in the met data.
% The date format is assumed to be yy/mm/dd. If you have a different format
% in the data, specify the format in an additional parameter DateFormat
% e.g. 'mm/dd/yy'.
%
% Every line of data, including headers, must contain the same number of tab-delimited fields.
%
% Bad numeric data in the input file is converted to NaN. Check for NaNs before manipulating the
% data, computing stats etc. Matlab ignores NaNs when plotting data.
%
% Example 1 :
% >> [h,d] = ReadDavisMetData('export_5June2007.txt',1); % Read met data into a struct
% >> plot([d.SerialDate],[d.HiTemp; d.LowTemp]); % plot low and high temperatures
% Check for NaNs with ..
% >> if any(isnan([d.HiTemp])) etc.
% 
%
% Example 2 :
% >> Headers = ReadDavisMetData('export_5June2007.txt'); % Just gets the headers
%
% Example 3 :
% >> [h,d] = ReadDavisMetData('export_5June2007.txt',1, {'LowTemp', 'Time', 'Date', 'TempOut'});
% This last example reads the 4 given columns of data into a struct. A warning is issued if any
% requested columns are not found. An error is issued if none are found.
%
% Example 4 :
% >> [h,d] = ReadDavisMetData('',1,{},'mm/dd/yy');
% This example will open a file dialog to select the input file, return a
% structure with all available headers in the file and interpret the date
% field in the data as mm/dd/yy.
%
% See also : datenum, datevec, datestr

% $Author: DGriffith $
% $Revision: 221 $

if ~exist('Filename', 'var') || isempty(Filename)
    % Open the file select dialog
    [Filename, Path] = uigetfile({'*.txt', 'Text Files'},'Open Davis Met Data File');
    if Filename
        Filename = [Path Filename];
    else
        Headers = [];
        Metdata = [];
        return; % User canceled
    end    
end

% Check file exists
if ~exist(Filename, 'file')
    error(['ReadDavisMetData:File "' Filename '" does not seem to exist.']);
end

if nargin >= 3
    if ~iscellstr(TheseHeaders)
        error('ReadDavidMetData:TheseHeaders input parameter must be cell array of strings. e.g. {''Date'', ''Time''}');
    end    
end

fid = fopen(Filename, 'r');

% Get the header data
head1 = fgetl(fid);
head2 = fgetl(fid);

% Split the headers at tab characters (SplitStringAt function is below)
Header1 = SplitStringAt(head1, 9); % tab is ASCII 9
Header2 = SplitStringAt(head2, 9);

if length(Header1) ~= length(Header2)
    error('ReadDavisMetData:Header Error. Cannot compose headers.');
end

% Compose the headers (ComposeHeaders function is below)
Headers = ComposeHeaders(Header1, Header2);

if nargout == 1 % user only wants the headers
    fclose(fid);
    return;
end

WantedColumns = 1:length(Headers); % First assume all columns are wanted
if nargin == 3
    WantedColumns = [];
    for ii = 1:length(TheseHeaders)
        WantedCol = strmatch(TheseHeaders{ii}, Headers, 'exact'); % Look for exact column header name match
        if isempty(WantedCol)
          warning(['ReadDavisMetData: Requested column header "' TheseHeaders{ii} '" was not found in this data file.']);
        else
          WantedColumns = [WantedColumns WantedCol]; 
        end
    end
    % Sort TheseHeaders into the same order in which they were found in the data file
    if isempty(WantedColumns)
        error('ReadDavisMetData:No wanted columns were found.');
    end
    WantedColumns = sort(WantedColumns);
    for ii = 1:length(WantedColumns)
        SortedHeaders{ii} = Headers{WantedColumns(ii)};
    end
    TheseHeaders = SortedHeaders;
end


% Now read the rest of the file, splitting each line
iline = 1;
while ~feof(fid)
    lin = strtrim(fgetl(fid));
    if ~isempty(lin)
        lin = SplitStringAt(lin, 9); % Get data in a cell array, splitting at tab characters
        MetDataCol = 1;
        for jj = 1:length(lin)
          if any(jj == WantedColumns)
            MetData{iline, MetDataCol} = lin{jj};
            MetDataCol = MetDataCol + 1;
          end
        end
        iline = iline + 1;
    end
end
fclose(fid);


% If there are date and time fields, add a SerialDate field at the far right column
DateField = strmatch('Date', Headers, 'exact');
TimeField = strmatch('Time', Headers, 'exact');

if any(DateField == WantedColumns) && any(TimeField == WantedColumns)
    Headers{end+1} = 'SerialDate';
    if nargin == 3
        TheseHeaders{end+1} = 'SerialDate';
    end
    MetData{1,end+1} = 0; % insert column
    if ~exist('DateFormat', 'var')
        DateFormat = 'mm/dd/yy';
    end
    for iline = 1:size(MetData, 1)
        TheDate = MetData{iline, DateField};
        TheTime = MetData{iline, TimeField};
        DateTime = datevec(TheDate, DateFormat);
%         DateTime(1) = str2num(TheDate(1:2)); % year
%         DateTime(2) = str2num(TheDate(4:5)); % month
%         DateTime(3) = str2num(TheDate(7:8)); % day
        DateTime(4) = sscanf(TheTime, '%i:%*i %*s'); % hour
        DateTime(5) = sscanf(TheTime, '%*i:%i %*s'); % minute
        ampm = TheTime(end);
        if DateTime(1) < 100
            DateTime(1) = DateTime(1) + 2000; % Assume this data is post 2000
        end
        if ampm == 'p' && DateTime(4) < 12 %  pm
            DateTime(4) = DateTime(4) + 12; % add 12 hours
        end
        if ampm == 'a' && DateTime(4) >= 12 %  am
            DateTime(4) = DateTime(4) - 12; % subtract 12 hours
        end
        DateTime(6) = 0; % seconds taken to be zero
        MetData{iline, end} = datenum(DateTime);
    end
end

% Scan the data and convert to numerics where possible
% First run through the first 40 rows of data
% if any element is a number, assume all must be numbers
isDoubleMetData = false(size(MetData,2));
for jj = 1:size(MetData, 2) % Run through columnwise
    for ii = 1:max(20, size(MetData, 1))
        num = str2double(MetData{ii,jj});
        if ~isnan(num)
          isDoubleMetData(jj) = 1;  
        end
    end
    for ii = 1:size(MetData, 1)
        if isDoubleMetData(jj)
          MetData{ii,jj} = str2double(MetData{ii,jj});
        end
    end
    
end

if exist('WantStruct', 'var') && WantStruct
    if nargin == 3
    % Convert the cell array to a structure
      MetData = cell2struct(MetData, TheseHeaders, 2);
    else
      MetData = cell2struct(MetData, Headers, 2);        
    end
end

if nargin == 3
    Headers = TheseHeaders;
end

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


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function HeaderNames = ComposeHeaders(h1, h2)
% Composes header names from two cell arrays
% Number of cells in each must be the same - otherwise error.

if length(h1) ~= length(h2)
    error('Number of headers in each header line must be the same.')
end

% First kill any characters that are not alphabetical using the isletter function
for ii = 1:length(h1)
    if ~isempty(h1{ii})
        alphachars = isletter(h1{ii});
        alphachars = alphachars .* (1:length(alphachars));
        h1{ii} = h1{ii}(alphachars(find(alphachars)));
    end
    
    if ~isempty(h2{ii})
        alphachars = isletter(h2{ii});
        alphachars = alphachars .* (1:length(alphachars));
        h2{ii} = h2{ii}(alphachars(find(alphachars)));
    end

end
% then concatenate
for ii = 1:length(h1)
    HeaderNames{ii} = [h1{ii} h2{ii}];
end

