function dnum = datenumSpectraWin(SWinData)
% datenumSpectraWin : Returns the date number of the data read with ReadPR715txt
%
% Usage :
% >> dnum = datenumSpectraWin(SWinData)
%
% Where dnum is a date number (see datenum function) and SWinData is a structure
% returned by the function ReadPR715txt.
%
% NOTE: This routine adds one hour to the date reported by SpectraWin, since there
% seems to be a bug in SpectraWin or in the PR715 that makes it report a time
% one hour behind the time set on the internal clock in the PR715.
%
% Use the function datestr to convert the serial date returned by this function to
% the date in various text formats.
%
% Example :
% >> SpecData = ReadPR715txt('MyPR715Spectrum.txt');
% >> SerialDate = datenum(SpecData);
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

dnum = [];
if ~isfield(SWinData, 'datetime')
    return;
end

for ii = 1:numel(SWinData)
    if ~isempty(SWinData(ii).datetime)
        [A,count] = sscanf(SWinData(ii).datetime, '%*s %*s %f %f %f:%f:%f'); % Read the day, year, hour minute and second
        if count == 5
            TheDay = A(1);
            TheYear = A(2);
            TheHour = A(3);
            TheMinute = A(4);
            TheSecond = A(5);
            [A,count] = sscanf(SWinData(ii).datetime, '%*s %s %*i %*f %*f:%*f:%*f'); % Get the month
            if count == 1
              TheMonth = char(A');
            else
                return
            end
        else
            disp('stuffup')
            return;
        end

        % Synthesize a date and get the datenum
        DateString = sprintf('%02i-%3s-%4i %02i:%02i:%02i', TheDay, TheMonth, TheYear, TheHour, TheMinute, TheSecond);
        dnum(ii) = datenum(DateString) + 1/24; % Add one hour, since SpectraWin reports one hour earlier
    else
        dnum(ii) = 0;
    end
end

dnum = reshape(dnum, size(SWinData));
