function Dates = FileDates(FileSpec, WhichDate)
% FileDates : Crude method of obtaining file creation, modify and access dates.
%
% For some reason, Matlab does not seem to be able to access all file dates
% stored by Windows. This function is a brute force method using the old DOS dir
% command and writing to a file, consequently rather slow.
%
% Usage : 
%   >> Dates = FileDates(FileSpec, WhichDate)
%
% FileSpec is the file specification for the files e.g. '*.txt'
%
% WhichDate is one of 'c' for Creation Date/Time, 'a' for Last Accessed and
% 'w' for Written Date/Time. If no WhichDate is given, then all dates are
% reported
%
% Dates is a structure containing the file information, including the
% following.
%     name - filename
%     date - text date reported by Matlab - sometimes complete nonsense
%     bytes - size of the file
%     isdir - flag indicating if the item is a directory rather than a file
%     datenum - serial date corresponding to above (suspect) date field
%     CreationDate
%     CreationSerialDate
%     AccessDate
%     AccessSerialDate
%     WriteDate
%     WriteSerialDate
%
% Example :
%  >> DirData = FileDates('*.txt', 'ca');
%
% The above example retrieves data for all .txt files in the current
% directory. The "creation" and "access" dates will be included in the 
% returned structure. 

% Copyright 2009, CSIR
% $Id: FileDates.m 221 2009-10-30 07:07:07Z DGriffith $

%% BSD Licence
% This file is subject to the terms and conditions of the BSD licence.
% For further details, see the file BSDlicence.txt
%

if ~exist('WhichDate', 'var')
  WhichDate = 'caw';
else
  WhichDate = lower(WhichDate);
end
Dates = dir(FileSpec); % Get the stuff Matlab supplies
Names = strtrim(cellstr(strvcat(Dates.name)));
% Then get the dates that windows reports

for iType = 1:length(WhichDate)
  switch WhichDate(iType)
    case 'c'
      [status, DirData] = dos(['dir /tc ' FileSpec ' > DirData.txt']);
      if status
        error('dir command failed.')
      end
    case 'a'
      [status, DirData] = dos(['dir /ta ' FileSpec ' > DirData.txt']);
      if status
        error('dir command failed.')
      end

    case 'w'
      [status, DirData] = dos(['dir /tw ' FileSpec ' > DirData.txt']);
      if status
        error('dir command failed.')
      end

    otherwise
      error('Bad date code, must be c, a and or w.')     
  end
  fid = fopen('DirData.txt');
  Acount = 0;
  Pcount = 0;

  while ~feof(fid)
    lin = fgetl(fid);
    [A, count] = sscanf(lin, '%f/%f/%f  %f:%f %*s %*s %*s');
    if count==5
      [mmddyyyy, count] = sscanf(lin, '%s  %*f:%*f %*s %*s %*s');
      mmddyyyy = char(mmddyyyy');
      [hhmm, count] = sscanf(lin, '%*f/%*f/%*f  %s %*s %*s %*s');
      hhmm = char(hhmm');
      [AMPM, count] = sscanf(lin, '%*f/%*f/%*f  %*f:%*f %s %*s %*s');
      AMPM = char(AMPM');
      DateString = [mmddyyyy ' ' hhmm ' ' AMPM];
      DateVector = datevec(mmddyyyy, 13);
      TimeVector = datevec([hhmm ' ' AMPM], 16);
      DateVector(4:6) = TimeVector(4:6);
      SerialDate = datenum(DateVector);
      [ThisFile, count] = sscanf(lin, '%*f/%*f/%*f  %*f:%*f %*s %*s %s');
      ThisFile = char(ThisFile');
      iThisFile = find(strcmp(ThisFile, Names));
      if ~isempty(iThisFile)
        %Dates(iThisFile).AMPM = AMPM;
        switch WhichDate(iType)
          case 'c'
            Dates(iThisFile).CreationDate = DateVector;
            Dates(iThisFile).CreationSerialDate = SerialDate;
          case 'a'
            Dates(iThisFile).AccessDate = DateVector;
            Dates(iThisFile).AccessSerialDate = SerialDate;
          case 'w'
            Dates(iThisFile).WriteDate = DateVector;
            Dates(iThisFile).WriteSerialDate = SerialDate;
          otherwise
            error('Bad date code, must be c, a and or w.')
        end
      else
        warning('FileDates:Filenotfound',['Date not found for ' ThisFile] );
      end
    end
  end
  fclose(fid);
end


