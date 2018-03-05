function Cherries = ScanTextFile(Filename, FormatStrings)
% ScacnTextFile : Scans a text file for data lines in a specific format.
%
% This function is useful to cherry-pick data out of a text file.
%
% Usage :
% Cherries = ScanTextFile(Filename, FormatStrings);
%
%  Inputs :
%    Filename is the full name of the text file to scan.
%    FormatStrings is a cell array of format strings as for
%      the sscanf function.
%  Output :
%    Cherries is a cell array of data found in the text file
%      which matches the FormatStrings. In general there will
%      be one cell for each format string.
%
% Do not mix scanning of multiple types of data in one format string.
% Instead use one format string for each type. For example if you want
% To scan the same line for string and numeric data, skip the numeric
% fields in one format string using the * vice versa in the 2nd format.
% Example :
%  Suppose the input file contains the following text
%   Apples : 10
%   Oranges : 20
%   Pears : 300
%   Pomegranates : 120
% If this file is scanned with FormatStrings = {'%*s : %f', '%s : %*f'}
%  the result will be a cell array having two elements with the first
%  element containing the fruit names and the second element containg
%  the numbers.
%
% ScanTextFile tries to match each format string to each line of
% data and is therefore quite slow. It was written originally to
% extract data from the .out.txt output file from SMARTS.
% 
% Bugs :
%  Lines in the input text file starting with * will apparently
%  not be scanned. The workaround is to start the format string
%  with %*c to skip the asterisk.
%
% See Also : ReadSMARTSOutput, sscanf

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

if ~exist(Filename, 'file')
  error([Filename ' not found.']);
end

if ~iscellstr(FormatStrings)
    error(['FormatStrings input must be a cell array of strings conforming to sscanf specifications.']);
end

fid = fopen(Filename, 'r');
Cherries = cell(size(FormatStrings));

while ~feof(fid)
    Line = fgetl(fid); % Read a line of data from the input file
    for iFormat  = 1:length(FormatStrings) % Scan the line using each format in turn
      [Data, Count, ErrMsg] = sscanf(Line, FormatStrings{iFormat});
      % If the format matched, add the data to the cell columnwise
      if Count > 0 && isempty(ErrMsg)
         if isnumeric(Data) % for numeric data do a simple vertical catenation
          Cherries{iFormat} = cat(1, Cherries{iFormat}, Data');
         else
             switch class(Data)
                 case 'char' % do the strvcat thing
                   Cherries{iFormat} = strvcat(Cherries{iFormat}, Data);  
                 otherwise % Try a vertical catention - if this causes an error, add a case above
                   Cherries{iFormat} = cat(1, Cherries{iFormat}, Data');                     
             end
         end
      end
    end
end
fclose(fid);
