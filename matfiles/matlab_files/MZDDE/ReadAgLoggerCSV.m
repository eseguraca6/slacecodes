function AgData = ReadAgLoggerCSV(filename, Encoding)
% ReadAgLoggerCSV : Read .csv data exported by Agilent Benchlink from 34970A data logger
%
% Usage
%  >> AgData = ReadAgLoggerCSV(filename);
%
% Returns a structure which may contain the following fields, depending on the contents
% of the data file.
%
% Notes : the .csv file from Benchlink Data Logger must have UTF-16-LE unicode byte
% encoding. Benchlink 3 seems to export .csv files in this encoding by default.
% See http://blogs.mathworks.com/loren/2006/09/20/working-with-low-level-file-io-and-encodings/
%
% This function is slow for encoding other than US-ASCII as a result of the workaround 
% required because textscan does not support unicode. 
% Should ask Mathworks to fix this. The UTF-16-LE files can be converted to normal
% US-ASCII using the ConvertUnicodeToASCII function. This is a much quicker way
% to deal with these files
%
% If the file has encoding other than UTF-16-LE, specify this as a second parameter.
% Example :
% >> AgData = ReadAgLoggerCSV('MyFile.csv', 'US-ASCII');
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

% $Date: 2009-10-30 09:07:07 +0200 (Fri, 30 Oct 2009) $
% $Revision: 221 $
% $Author: DGriffith $

%% Check file existence and open file
if ~exist(filename, 'file')
    error(['File ' filename ' not found.']);
end

if ~exist('Encoding', 'var')
    Encoding = 'UTF16-LE';
end

% There is a file encoding issue with .csv export files from Agilent Benchlink
% See article http://blogs.mathworks.com/loren/2006/09/20/working-with-low-level-file-io-and-encodings/
% Last accessed 2008-04-16

warning off MATLAB:iofun:UnsupportedEncoding; % get rid of unsupported encoding format
fid = fopen(filename, 'r', 'l', Encoding);
if ~strcmp(Encoding, 'US-ASCII')
 fseek(fid, 2, 0); % Skip the byte at the beginning of the file (255)
end

%% Perform line orientated processing until block data is detected 
AgData = [];
LineData = fgetl(fid);
while ~feof(fid)
  toks = Tokenise(LineData, ','); % read line and split into tokens at commas
  if ~isempty(toks)
     if toks{1}(end) == ':'
         % interpret the line as fieldname:,fieldvalue, etc.
         iTok = 1;
         while iTok < length(toks)
            FieldName = strrep(toks{iTok}(1:end-1), ' ', ''); % Remove colon and blanks
            FieldData = toks{iTok+1};
            if FieldData(end) == ':'
                iTok = iTok + 1; % Skip if data also ends with a colon
                continue;
            end
            % Certain field names have issues - wish they could be more consistent
            switch FieldName
                case 'Name' 
                    FieldName = 'DataName';
            end
            AgData = setfield(AgData, FieldName, toks{iTok+1}); 
            iTok = iTok + 2;
         end
         LineData = fgetl(fid);
     else
         % interpret line as headers for a block of data
         % Process headers to remove nasties
         BlockFormat = '';
         for iTok = 1:length(toks)
             % if the token starts with a number it is most likely a channel number
             [ChanAndUnits, Count] = sscanf(toks{iTok}, '%f %s');
             if Count > 0
                 toks{iTok} = ['Ch' num2str(ChanAndUnits(1))];
                 % Deal with the units
                 AgData = setfield(AgData, [toks{iTok} 'Units'], char(ChanAndUnits(3:end-1)')); 
                 BlockFormat = [BlockFormat, '%f'];
             else
                 % Just remove blanks
                 toks{iTok} = strrep(toks{iTok}, ' ', '');
                 switch toks{iTok}
                     case {'Scan', 'Channel'}
                       BlockFormat = [BlockFormat, '%f'];
                     otherwise
                         BlockFormat = [BlockFormat '%s'];
                 end
             end
         end
         if ~strcmp(Encoding, 'US-ASCII')
             % The following workaround really sucks, all because textscan does not handle unicode
             iLine = 0;
             while ~feof(fid)
               iLine = iLine + 1;
               LineData = fgetl(fid); % Read and process line for line - very slow
               sLineData = textscan(LineData, BlockFormat, 'Delimiter', ',');
               if ~isempty(sLineData{1})
                   for iTok = 1:length(toks)
                       AgData = setfield(AgData, {1,1}, toks{iTok}, {iLine}, sLineData{iTok});
                       if strcmp(toks(iTok),'Time')
                           % Make up a serial time field
                           sT = char(sLineData{iTok});
                           size(sT);
                           class(sT);
                           sT(1:19);
                           AgData = setfield(AgData, {1,1}, 'SerialTime', {iLine}, datenum(sT(1:19), 'yyyy/mm/dd HH:MM:SS') ...
                                + str2num(sT(21:end))/(1000*60*60*24)); % Convert milliseconds to days
                       end
                   end
               else
                   break; % bail out of loop
               end
             end
         else
             % The encoding is ASCII, can therefore use textscan
             BlockData = textscan(fid, BlockFormat, 'Delimiter', ','); % much faster than line processing
             % Assign the cells to various fields of AgData
             for iTok = 1:length(toks)
                 AgData = setfield(AgData, toks{iTok}, BlockData{iTok});
                 if strcmp(toks{iTok}, 'Time')
                     sT = strvcat(AgData.Time);
                     AgData = setfield(AgData, 'SerialTime', datenum(sT(:,1:19), 'yyyy/mm/dd HH:MM:SS') ...
                        + str2num(sT(:, 21:end))/(1000*60*60*24)); % Convert milliseconds to days 
                 end
             end
             % Read the next line.
             LineData = fgetl(fid); 
         end
     end
  end

end
fclose(fid);

%% Add in a few bonus fields before returning the data
if isfield(AgData, 'AcquisitionDate')
    AgData.SerialAcqDate = datenum(AgData.AcquisitionDate, 'yyyy/mm/dd HH:MM:SS');
end
