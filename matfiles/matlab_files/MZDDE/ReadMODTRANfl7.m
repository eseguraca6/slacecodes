function [wavenumbers, data, headers] = ReadMODTRANfl7(filename, columnheaders)
% ReadMODTRANfl7 : Reads data from a results file (.fl7) written by MODTRAN (3.7)
%
% Usage : [wavenumbers, data, headers] = ReadMODTRANfl7(filename, columnheaders);
% The file must be PCModWin '.fl7' format or a 'tape7' file direct MODTRAN output.
% The wavenumbers in the file are returned in the vector wavenumbers.
% The data columns in the results file you wish to extract must be given as a cell array
% of strings in the columnheaders parameter.
% The full filename of the data must be given, including path and extension.
% Iterated data e.g. over range or observer height is put in subsequent columns of the output
% in the third dimension. 
% The headers found in the data are returned in the "headers" variable.
% If you give the columnheaders as {'ALL'}, then all columns will be read.
% If you omit the columnheaders input altogether, then all columns will be
% read.
% This routine assumes that the wavenumber always appears in column 1.
%
% Example : >> [wavenumbers, data, h] = ReadMODTRANfl7('case14.fl7', {'TOTAL TRANS'})
% This example will read the total transmission column.
%           >> [wavenumbers, data, h] = ReadMODTRANfl7('case14.fl7', {'ALL'})
% This example reads all columns in the file.
%
% Notes: MODTRAN tape7 spectral radiance outputs are in units of W/cm^2/sr/cm^-1
%        i.e. given with respect to wavenumber. Conversion to W/cm^2/sr/nm (with respect to
%        wavelength) involves an important subtlety. Notice that the dimensionalty of the two units
%        is different, and this is the clue that a simple conversion factor does not apply.
%        if wn is wavenumber (in cm^-1) and wv is wavelenth (in nm), then wv = 1e7 wn^-1 and
%        delta_wv = -1e7 wn^-2 * delta_wn and delta_wn = -wn^2 / 1e7
%        Converting radiance to W/cm^2/sr/cm^-1 to W/cm^2/sr/nm therefore involves multiplying by
%        the factor wn^2/1e7 and flipping the result to get it into order of increasing wavelength.
%
%        Typical code is
%        >> [wavenumbers, wnradiance, h] = ReadMODTRANfl7('tape7', {'TOTAL RAD'});
%        >> wavelengths = flipud(1e7 ./ wavenumbers);
%        >> wvradiance = flipud(wnradiance .* wavenumbers.^2 ./ 1e7);
%
%        MODTRAN tape7 spectral irradiance (e.g. solar/lunar) output are in units of W/cm^2/cm^-1
%        Conversion to W/cm^2/nm is the same as the above.
%
%        The constant 1e7 becomes 1e4 if you want to convert to W/cm^2/sr/micron.
%
%        Transmission factors are not affected in this way.
%
% Bugs : Some header output formats from MODTRAN are a bit pathological.
% Look at the output from the test case 'casem4.fl7'. The headers in this case do not line up
% with the data columns exactly.
% For this case, change your header requests to the (misaligned) headers returned by this routine.
% That is, first read all data, and then look at the headers.
%
% Comments :
%     This routine seems to work for output from MODTRAN4 v1r1.
%     This routine also works for the degraded (convolved) resolution output files.
%     Convolved output is written to tape7.scn in the bin directory of your
%     PCModWin installation.


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

%% Check Parameters
if ~exist(filename, 'file')
    error(['File ' filename ' does not seem to exist. Give full path and filename.']);
end

if exist('columnheaders', 'var')
  if ~iscellstr(columnheaders)
    error('Headers must be a cell array of strings.');
  end
else
    columnheaders = {'ALL'};
end

%% Open file, scan/read contents and close file
fid = fopen(filename, 'r');

% This variable counts the number of datablocks in the file
datablock = 0;

lin = fgetl(fid);
% Read and process the file
while ~feof(fid)
    lin = fgetl(fid);
    tok = strtok(lin, ' ');
    if strcmp(tok, 'FREQ') % Found a data header
        datablock = datablock + 1;
        headlin1 = lin;
        headlin2 = fgetl(fid); % Get what is possibly another header line
        % Check to see if this is data
        tok2 = strtok(headlin2, ' ');
        if isletter(tok2(1))
            % Compose the headers from 2 lines
            % First read a line of data
            lin = fgetl(fid);
            % Find the blanks between the data column
            start = regexp(lin, '\s\S');
            start(1) = 1; % Force start of first header at start of line            
            % headlin1(start) % debug
            % Split up the header lines at these positions
            for iii = 1:(length(start))
                if iii == length(start)
                    thestart = start(iii);
                    theendc1 = length(headlin1);
                    theendc2 = length(headlin2);
                else
                    thestart = start(iii);
                    theendc1 = start(iii+1);
                    theendc2 = start(iii+1);
                end
                headers{iii} = headlin1(thestart:theendc1);
                % Deblank
                headers{iii} = deblank(fliplr(deblank(fliplr(headers{iii}))));
                % Header continues on next line (headlin2)
                headers2{iii} = headlin2(thestart:theendc2);
                headers2{iii} = deblank(fliplr(deblank(fliplr(headers2{iii}))));
                % Merge
                headers{iii} = [headers{iii} ' ' headers2{iii}];
            end
            % Seek backwards to the start of the line of data that has been
            % read
            status = fseek(fid, -(length(lin)+2), 'cof'); % Seek back to the top of the data block
            if status
                error('Error seeking start of data block.')
            end            
        else
            % We have the case that the headers are on one row
            %length(headlin1) % Debug
            %length(headlin2) % debug
            start = regexp(headlin2, '\s\S');
            start(1) = 1; % Force start of first header at start of line
            % headlin1(min(start, length(headlin1))) % debug
            for iii = 1:(length(start))
                if iii == length(start)
                    thestart = min(start(iii),length(headlin1));
                    theendc1 = length(headlin1);
                else
                    thestart = min(start(iii), length(headlin2));
                    theendc1 = min(start(iii+1), length(headlin1));
                end
                headers{iii} = headlin1(thestart:theendc1);
                % Deblank
                headers{iii} = deblank(fliplr(deblank(fliplr(headers{iii}))));
            end
            
            lin = headlin2; % The last line read is data already
            status = fseek(fid, -(length(headlin2)+2), 'cof'); % Seek back to the top of the data block
            if status
                error('Error seeking start of data block.')
            end

% Check that the backseek works OK            
%             checklin = fgetl(fid);
%             strvcat(lin,checklin)
%             length(checklin)
%             length(lin)
%             status = fseek(fid, -(length(headlin2)+2), 'cof'); % Seek back to the top of the data block
        end
        % Scan for the headers that the user wants and get the column numbers
        % Ignore the case of the headers
        % MODTRAN is irritating because sometimes it is TOT TRANS and sometimes TOTAL TRANS
        %headers % Debug
        %headers2 % Debug
        if strcmp(columnheaders{1}, 'ALL')
            columnnumbers = 2:length(headers);
        else
        columnnumbers = [];
            for ii = 1:length(columnheaders)
                found = 0;
                for jj = 1:length(headers)
                    if strcmpi(columnheaders{ii}, headers{jj})
                        found = 1;
                        columnnumbers(end+1) = jj;
                    else
                        if (strcmp(columnheaders{ii}, 'TOT TRANS') && strcmp(headers{jj}, 'TOTAL TRANS')) || ...
                           (strcmp(columnheaders{ii}, 'TOTAL TRANS') && strcmp(headers{jj}, 'TOT TRANS'))
                           found = 1;
                           columnnumbers(end+1) = jj;
                        end
                    end
                end
                if ~found
                    disp(['Header "' columnheaders{ii} '" not found in this file.']);
                    disp('The following headers were found.');
                    disp(headers);
	%                 for jj = 1:length(columnheaders)
	%                     disp(headers{jj})'
	%                 end
                    error('Please check your header names.');              
                end
            end
        end
        
% There are two ways to read the data block, one line for line, which is very
% slow, and one using textscan, which is much faster
        % Read the data block line for line and scan the numbers
%         at9999 = 0; % The data block ends when we get to -9999 alone on a line
%         wavenumbers = [];
%         rownumber = 0;
%         while ~at9999
%             lindata = sscanf(lin, '%f');
%             lin = fgetl(fid);
%             if lindata ~= -9999
%                 wavenumbers(end+1,1) = lindata(1);
%                 rownumber = rownumber + 1;
%                 for ii = 1:length(columnnumbers)
%                     data(rownumber, ii, datablock) = lindata(columnnumbers(ii));
%                 end
%             else
%                 at9999 = 1;
%             end           
%         end

        % Read the entire data block
        Format = repmat('%f', 1, length(headers));        
        blockdata = textscan(fid, Format);
        % Omit the last element since it is the -9999 marker at the end of
        % the block.
        wavenumbers = blockdata{1}(1:end-1); % Wavennumbers are in the first column (I trust)
        for ii = 1:length(columnnumbers)
          data(:, ii, datablock) = blockdata{columnnumbers(ii)}(1:end-1);
        end
    end
end
fclose(fid);
