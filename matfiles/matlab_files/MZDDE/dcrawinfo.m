function infostruct = dcrawinfo(inputfile, outputfile, defaultF)
% dcrawinfo : converts information output from dcraw into a .csv file or
% returns information in a structure.
% 
% This function is used to extract information about RAW digital images
% supported by Dave Coffin's dcraw image converter.
%
% Usage :
%   >> dcrawinfo(InputFile, OutputFile)
%   >> InfoStruct = dcraw(InputFile, OutputFile)
%   >> InfoStruct = dcraw(InputFile, OutputFile, DefaultF)
%   >> InfoStruct = dcraw(InputFile, DefaultF)
%
% Where :
%  InputFile is a text file written by dcraw with the -i and -v flags.
%    For example 
%     >> dcraw('*.nef', '-i -v', 'info.txt');
%    If InputFile is given as empty or not provided, a file open dialog
%    will be given. If the InputFile is any file specification with the
%    extension .nef (or .NEF), then dcraw -i -v is run on the file
%    specification, the output is redirected to a file in the current
%    directory called dcrawInfo.txt, and the information is read from this
%    file.
%
%  OutputFile is a text file in which to write the information in
%     comma-delimited format. If OutputFile is specified as empty (''), a
%     file save dialog will be given.
%
% DefaultF is the default focal ratio and focal length to apply if focal
%  ratios (Aperture) or focal lengths (FocalLength)
%  of zero are encountered in the image information. This is useful to
%  compute correct EV (exposure value) data when manual (non-CPU) lenses
%  are used. The first elelemt is assumed to be the default focal ratio and
%  the second element the default focal length. A warning that the log of 0
%  was taken will be issued if the Aperture is zero in the input data for
%  any image.
%
% InfoStruct is an output structure containing all the image data extracted
% from InputFile. It typically contains the following fields.
%
% Filename -------------- The filename of the image  (string)
% Timestamp ------------- Date and time at which the image was taken (string)
% Camera ---------------- Camera make an model (string)
% ISOSpeed -------------- ISO speed setting of the camera (numeric)
% Shutter --------------- Shutter setting of the camera (string)
% Aperture -------------- Aperture setting of the camera (string)
% FocalLength ----------- Focal length setting of the camera (string)
% EmbeddedICCProfile ---- Don't know what this is yet
% NumberOfRawImages ----- Number of raw images contained in the file (numeric)
% ThumbSize ------------- Size of thumbnail in file (numeric array)
% FullSize -------------- Full image size  (numeric array)
% ImageSize ------------- Actual image size (numeric array)
% OutputSize ------------ Output image size (numeric array)
% RawColors ------------- Number of colour channels in image (numeric)
% FilterPattern --------- Bayer filter sequence pattern (string)
% DaylightMultipliers --- Daylight white balance multipliers (numeric array)
% CameraMultipliers ----- Camera channel sensitivity multipliers (numeric array)
% SerialDate ------------ Matlab serial date derived from the Timestamp (numeric)
% ExposureTime ---------- Exposure time in seconds derived from Shutter (numeric)
% FocalRatio ------------ Focal ratio derived from Aperture setting (numeric)
% EFL ------------------- Focal length, derived from FocalLength (numeric)
% EV -------------------- The EV (exposure value) of the image (numeric)
% LightHarvest ---------- The light harvest of the camera for this image
%
% Light harvest is defined as the product of the exposure time and ISO
% setting divided by the square of the focal ratio.
% 
% Note that some fields, such as FocalLength are given as a string, but a
% numeric version (EFL) is provided, derived from the string. Thus the
% ExposureTime field is derived from the Shutter setting (string), the
% SerialDate field from the Timestamp etc.
%
% Also note that only FocalRatio is replaced with the DefaultF parameter if
% that parameter is given. The Aperture field is not changed from what is
% given in InputFile. The same applies to FocalLength and EFL. Only EFL is
% given the value DefaultF(2).
% 
% Examples :
% Numerous calling sequences are possible. Perhaps the simplist is
%
% >> sinfo = dcrawinfo('*.nef');
%
% This will return all the available information on all NEF files in the
% current directory.
%
% Alternatively, first get the information from DCRAW at the windows 
% command prompt, by directly invoking dcraw.
% C:\MyDirectory> dcraw -i -v *.nef > NEFInfo.txt
%
% Then in Matlab, convert to .csv for example
% >> dcrawinfo('C:\MyDirectory\NEFInfo.txt', 'NEFInfo.csv');
%
% The same can be accomplished from within Matlab using the following.
% 
% >> successcode = dcraw('*.nef', '-i -v', 'info.txt'); % Get all NEF file information
% >> dcrawinfo('info.txt', 'info.csv');
%
% The information can be obtained in a structure as follows.
% >> sinfo = dcrawinfo('info.txt');
%
% >> sinfo = dcrawinfo('',[5.6 300]); 
% The latter will set default values for focal ratio (5.6) and focal length
% (300 mm), and a dialog will be presented to select the info file produced
% by dcraw.
%
% If the extension of the input file spec is .NEF, then the info data will
% be extracted to a temporary text file file using dcraw, and the
% information read from there. e.g.
% >> sinfo = dcrawinfo('*.nef'); % returns info for all NEF files in
%                                  current directory

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

%% If the input file specification ends in .nef, use dcraw to extract the
% information and then open the temp file dcrawInfo.txt.

if exist('inputfile', 'var') || ~isempty(inputfile)
    [Path, FileName, Extension] = fileparts(inputfile);
    if isempty(Path), Path = '.'; end;
    if strcmp(lower(Extension), '.nef')
        inputfile = [Path '\' FileName Extension];
        NEFFiles = dir(inputfile);
        if isempty(NEFFiles)
            warning('No NEF files found to process.')
            infostruct = [];
            return;
        end
        [successcode, output] = dcraw(inputfile, '-i -v', 'dcrawInfo.txt');
        if successcode
            disp('dcraw has failed with the following error ... ');
            disp(output);
            error('dcrawinfo::dcrawfail - Unable to run dcraw -i - v on this file specification.')
        end
        inputfile = 'dcrawInfo.txt';
    end
end

if ~exist('inputfile', 'var') || isempty (inputfile)
    [inputfile, Path] = uigetfile({'*.txt', 'Text Files (*.txt)'; '*.*', 'All Files (*.*)'}, 'Open dcraw -i Output');
    if inputfile
        inputfile = [Path inputfile];
    else % user canceled
        infostruct = [];
        return;
    end
end

infil = fopen(inputfile, 'r');
if infil == -1
    error(['Unable to open input file ' inputfile]);
end

if exist('outputfile', 'var')
    if isfloat(outputfile)
        defaultF = outputfile;
    else
      if isempty(outputfile)
          % Open a gui
          [outputfile, Path] = uiputfile({'*.txt', 'Text Files';'*.csv','CSV Files'; '*.*', 'All Files'},'Save dcraw Image Information');
          if outputfile
              outputfile = [Path outputfile];
          else
              infostruct = [];
              return;
          end
      end
      outfil = fopen(outputfile, 'wt');
      if outfil == -1
        fclose(infil);
        error(['Unable to open output file' outputfile]);
      end
    end
end

ColumnNumber = 1;
RowNumber = 0;
while ~feof(infil)
      % Read line for line
      lin = fgetl(infil); % Read one line
      lin = deblank(lin); % Remove any trailing blanks
      if isempty(lin)
          % Reset column counter to 1 and increment the row number
          ColumnNumber = 1;
          RowNumber = RowNumber + 1;
          continue;
      end
      % The stuff up to the first colon is the header
      colonpos = strfind(lin, ':');
      if isempty(colonpos)
          error(['No colon found on ' lin]);
          fclose(infil);
          fclose(outfil);
      else
          HeaderName{ColumnNumber} = lin(1:colonpos(1)-1);
          Info{RowNumber, ColumnNumber} = fliplr(deblank(fliplr(lin(colonpos(1)+1 : end))));
          ColumnNumber = ColumnNumber + 1;
      end
end

if exist('outfil', 'var')
    % Write the column headers into the output file
    for ColumnNumber = 1:length(HeaderName)-1
        fprintf(outfil, '%s,', HeaderName{ColumnNumber});
    end
    fprintf(outfil, '%s\n', HeaderName{end});

    % Write the information, separated by commas
    for RowNumber = 1:size(Info,1)
      for ColumnNumber = 1:length(HeaderName)-1
          fprintf(outfil, '%s,', Info{RowNumber, ColumnNumber});
      end  
      fprintf(outfil, '%s\n', Info{RowNumber, end});
    end

    fclose(outfil);
end
% Create the output structure if requested
if nargout == 1
    % create a structure with the information in it
    % First capitalize and remove spaces in the field names
    for ColumnNumber = 1:length(HeaderName)
        HeaderName{ColumnNumber} = capitalize(HeaderName{ColumnNumber});
        HeaderName{ColumnNumber} = strrep(HeaderName{ColumnNumber}, ' ', '');
    end
    % Convert certain fields to numeric values and add bonus fields
    MoreInfo = {}; % Prepare to add new columns to the data
    MoreHeaders = {};
    for iRow = 1:size(Info,1) % Run down the rows
        % Run across columns and do numerical conversions
        for iCol = 1:length(HeaderName)
            switch HeaderName{iCol}
                case {'ISOSpeed', 'NumberOfRawImages', 'RawColors'}
                    Info{iRow, iCol} = str2double(Info{iRow, iCol}); % simple numerical conversion
                case 'CameraMultipliers'
                    Info{iRow, iCol} = transpose(sscanf(Info{iRow, iCol}, '%f'));
                case 'DaylightMultipliers'
                    Info{iRow, iCol} = transpose(sscanf(Info{iRow, iCol}, '%f'));
                case 'Shutter'
                    ShutterSpeed = sscanf(Info{iRow, iCol}, '%s', 1);
                    MoreInfo{iRow, iCol} = eval(ShutterSpeed);
                    MoreHeaders{iCol} = 'ExposureTime';
                case {'ThumbSize', 'ImageSize', 'FullSize', 'OutputSize'}
                    Info{iRow, iCol} = fliplr(transpose(sscanf(Info{iRow, iCol}, '%f x %f')));
                case 'Timestamp' % Get the serial date
                    Month = sscanf(Info{iRow, iCol}, '%*s %s %*f %*f:%*f:%*f %*f', 1); % 3-letter month
                    DTY = sscanf(Info{iRow, iCol}, '%*s %*s %f %f:%f:%f %f'); % Date, Time and Year
                    MoreInfo{iRow, iCol} = datenum(sprintf('%02g-%3s-%04g %02g:%02g:%02g', ...
                                                           DTY(1), Month, DTY(5), DTY(2), DTY(3), DTY(4)), 1);
                    MoreHeaders{iCol} = 'SerialDate';
                case 'Aperture'
                    MoreInfo{iRow, iCol} = sscanf(Info{iRow, iCol}, 'f/%f');
                    if MoreInfo{iRow, iCol} == 0 && exist('defaultF', 'var')
                       MoreInfo{iRow, iCol} = defaultF(1); 
                    end
                    MoreHeaders{iCol} = 'FocalRatio';
                case 'FocalLength'
                    MoreInfo{iRow, iCol} = sscanf(Info{iRow, iCol}, '%f', 1);
                    if MoreInfo{iRow, iCol} == 0 && exist('defaultF', 'var') && length(defaultF) >= 2
                       MoreInfo{iRow, iCol} = defaultF(2); 
                    end
                    MoreHeaders{iCol} = 'EFL';                   
            end
        end
    end
    
    % Add the new info and headers
    for iNew = 1:length(MoreHeaders)
        if ~isempty(MoreHeaders{iNew})
            HeaderName = [HeaderName MoreHeaders(iNew)]; 
            Info = [Info MoreInfo(:, iNew)];
        end
    end
    % Finally convert the cell array to a structure
    infostruct = cell2struct(Info', HeaderName);
    % Add the exposure value field
    if isfield(infostruct, 'FocalRatio') && isfield(infostruct, 'ExposureTime')
      EV = log2([infostruct.FocalRatio].^2 ./ [infostruct.ExposureTime]);
      for iRow = 1:length(infostruct)
          infostruct(iRow).EV = EV(iRow);
      end
      % add the light harvest field if ISO is also available
      if isfield(infostruct, 'ISOSpeed')
          LightHarvest = [infostruct.ISOSpeed] .* [infostruct.ExposureTime] ./ [infostruct.FocalRatio].^2;
          for iRow = 1:length(infostruct)
              infostruct(iRow).LightHarvest = LightHarvest(iRow);
          end
      end
    end
end
