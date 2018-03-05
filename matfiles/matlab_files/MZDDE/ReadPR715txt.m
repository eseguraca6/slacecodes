function data = ReadPR715txt(filename)
% ReadPR715txt - Read text file exported by SpectraWin from PhotoResearch PR-715 spectroradiometer.
%
% Usage : data = ReadPR715txt(filename);
% 
% Returns a structure with the following fields.
%              wav - wavelenghts of the measurement
%         wavunits - units of the wavelength
%          radphot - the radiometric or photometric data
%     radphotunits - the units of the radiometric or photometric data
%            title - title of the measurement
%      description - description of the measurement
%      modelnumber - model number of the spectroradiometer
%     serialnumber - serial number of the spectroradiometer
%     exposuretime - exposure time for the measurement
%         datetime - date and time the measurement was made (see caveat below)
%         aperture - angular aperture of the measurement in degrees
%      accessories - accessories attached during the measurement
%  radiometricmode - mode in which the measurement was made e.g. 'Radiance'
%    totalradiance - total band radiance in W/m^2/sr
%   photonradiance - total photon radiance in photons/s/m^2/sr
%       serialdate - serial date/time of the measurement as reported by the PR715
%         filedate - date of the file as reported by the OS
%   serialfiledate - serial date/time of the file as reported by the OS
%
%
% Only wave, waveunits, radphot and radphotunits will always be returned.
% Other fields are dependent on what is present in the file. The value 'Unknown' will be returned in
% some instances. The serialdate field is returned only if the file containes the date and time of
% the measurement.
% If the text data has been saved without the header and other info ("Spectral Only"), then it may
% be simpler just to read the file with the following dlmread command :
% >> dlmread(filename, ',', 4, 0);
% This function will, however, attempt to detect if the data is "Spectral Only" and read
% accordingly.
% 
% Not all calculated data are currently read by this function. Fields may include
%          obs2deg.lumcd - luminance in candela/m^2 for 2 degree observer
%          obs2deg.lumfl - luminance in foot lamberts for 2 degree observer
%            obs2deg.CCT - correlated colour temperature for 2 degree observer in Kelvin
%              obs2deg.X - X colour coordinate for 2 deg observer
%              obs2deg.Y - Y colour coordinate for 2 deg observer
%              obs2deg.Z - Z colour coordinate for 2 deg observer
%          obs2deg.uvdev - u-v deviation for the 2 deg observer
%         obs10deg.lumcd - luminance in candela/m^2 for 10 degree observer
%         obs10deg.lumfl - luminance in foot lamberts for 10 degree observer
%           obs10deg.CCT - correlated colour temperature for 10 degree observer in Kelvin
%             obs10deg.X - X colour coordinate for 10 deg observer
%             obs10deg.Y - Y colour coordinate for 10 deg observer
%             obs10deg.Z - Z colour coordinate for 10 deg observer
%         obs10deg.uvdev - u-v deviation for the 10 deg observer
%            scotopiclum - the scotopic luminance in cd/m^2
%
% Fields may appear in the substructures obs2deg and obs10deg for x,y,u,v,u',v' (uprime and vprime)
% as well as L* (Lstar), a* (astar), b* (bstar), u* (ustar), v* (vstar), C* (labCstar and luvCstar), 
% H* (labHstar and luvHstar), labdeltaE, luvdeltaE, labdeltaH and luvdeltaH.
% Illuminants for CIELAB and CIELUV occur in the substructure fields labIlluminant and
% luvIlluminant.
%
%
% Bugs : PhotoResearch, in their wisdom, have changed the export text format in SpectraWin version
% 2.1.4. This gives rise to some issues. Also, some calculated parameters do not seem to make it
% into the output.
% Only the first line of the 'description' field gets through the import intot Matlab.
%
% Caveats : To get SpectraWin 2 to export specific data all in one text file, you must click on the 
% "Custom" tab on the data panel and add data to the custom view by right-clicking on the column
% headers and checking (ticking) the data you want exported. For more information, search the SpectraWin 
% help file for the keywords "custom tab". To export the text for the custom view, make sure the custom
% view is selected (left click on the custom tab), then go the File menu and select Export. Use the 
% "Export to ascii text file" option, rather than the "Spectral Only" option.
%
% The time reported by the PR715/SpectraWin software in the text data appears to be 1 hour earlier
% than the actual time of measurement.
%
% See Also : PlotSpectraWin

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

if ~exist('filename', 'var') || isempty(filename) || ~ischar(filename)
    [filename, PathName] = uigetfile('*.txt','Open SpectraWin Text File');
    if filename
        filename = [PathName filename];
    else
        data = [];
        return;
    end
end


% Check existence
if exist(filename, 'file')
    data.filename = filename;
    filedata = dir(filename);
    data.filedate = filedata.date;
    data.serialfiledate = datenum(filedata.date);
else
    error(['File ' filename ' does not exist.']);
end

fid = fopen(filename, 'r');
dataline = 0;


% Intialise some of the fields
data.wav = [];
data.radphot = [];
data.wavunits = 'nm';
data.radphotunits = 'Unknown';
data.title = 'Unknown';
data.description = 'Unknown';
data.modelnumber = 'Unknown';
data.serialnumber = 'Unknown';
data.exposuretime = 'Unknown';
data.datetime = 'Unknown';
data.aperture = 'Unknown';
data.accessories = 'Unknown';
data.radiometricmode = 'Unknown';
data.totalradiance = NaN;
data.photonradiance = NaN;
data.serialdate = 0;

noHEADER = 1; % This switch will be flipped if the HEADER section is found
noSPECTRAL = 1; % This switch will be flipped if the SPECTRAL section is found
noCALCULATED = 1; % This switch will be flipped if the CALCULATED section is found

while ~feof(fid)
    % Get next line in the data
    lin = fgetl(fid);
    
    % Look for header information
    if strcmp(lin, '[HEADER]')
        noHEADER = 0;
        while ~strcmp(lin, '[END OF SECTION]') && ~feof(fid)
            lin = fgetl(fid);
            [key, rest] = strtok(lin, ':');
            if isempty(key)
                key = 'empty';
            end
            % Deblank start and end
            rest = rest(2:end);
            rest = deblank(fliplr(deblank(fliplr(rest))));
            switch deblank(key)
                case 'Title'
                    data.title = rest;
                case 'Description' 
                    data.description = rest;
                case 'Model Num.'
                    data.modelnumber = rest;
                    if ~strcmp(data.modelnumber, 'PR-715')
                        disp('Warning - this function may not work for models other than the PR-715.');
                    end
                case 'Serial Num.'
                    data.serialnumber = rest;
                case 'Exp. Time'
                    data.exposuretime = rest;
                case 'Date / Time'
                    data.datetime = rest;
                    data.serialdate = datenumSpectraWin(data);
                case 'Aperture'
                    data.aperture = rest;
                case 'Accessories'
                    data.accessories = rest;
                case 'Radiometric Mode'
                    data.radiometricmode = rest;
                case '[END OF SECTION]'
                case 'empty'
                otherwise
                    disp(['Unknown header line encountered in PR-715 text file -' lin]);
            end
          end
    end
    
    % Get Calculated outputs
    if strcmp(lin, '[CALCULATED]')
        noCALCULATED = 0;
        while ~feof(fid)
            lin = fgetl(fid);
            [key, rest] = strtok(lin);
            if isempty(key)
                key = 'empty';
            end
            switch key
                case '2'
                    observer = 2; % Spectrawin 2.1.4
                case '10'
                    observer = 10; % Spectrawin 2.1.4
                case 'Obs:'
                    observer = sscanf(rest, ' %i'); % Get the observer
                case 'Luminance'
                    lin = fgetl(fid); % Get the footlambert value on the next line
                    switch observer
                        case 2
                           data.obs2deg.lumcd = sscanf(rest, ' %f');
                           data.obs2deg.lumfl = sscanf(lin, ' %f');
                           data.obs2deg.Y = data.obs2deg.lumcd;
                        case 10
                           data.obs10deg.lumcd = sscanf(rest, ' %f ');
                           data.obs10deg.lumfl = sscanf(lin, ' %f');
                           data.obs10deg.Y = data.obs10deg.lumcd;                           
                    end
                case 'Luminance(cd/m²):'
                    switch observer
                        case 2
                           data.obs2deg.lumcd = sscanf(rest, ' %f');
                        case 10
                           data.obs10deg.lumcd = sscanf(rest, ' %f ');
                    end
                case 'Luminance(fl):'
                    switch observer
                        case 2
                           data.obs2deg.lumfl = sscanf(rest, ' %f');
                        case 10
                           data.obs10deg.lumfl = sscanf(rest, ' %f ');
                    end
                case 'Scotopic'
                     data.scotopiclum = sscanf(rest, ' %*s %f');
                case {'Radiance', 'Radiance(watts/sr/m²):'}
                     data.totalradiance = sscanf(rest, ' %f');
                case 'Photon'
                     data.photonradiance = sscanf(rest, ' %*s  %f');
                case {'CCT', 'CCT:'}
                    switch observer
                        case 2
                           data.obs2deg.CCT = sscanf(rest, ' %f');
                        case 10
                           data.obs10deg.CCT = sscanf(rest, ' %f ');
                    end                    
                case {'X', 'X:'}
                    switch observer
                        case 2
                           data.obs2deg.X = sscanf(rest, ' %f');
                        case 10
                           data.obs10deg.X = sscanf(rest, ' %f ');
                    end                
                case {'Y', 'Y:'}
                    switch observer
                        case 2
                           data.obs2deg.Y = sscanf(rest, ' %f');
                        case 10
                           data.obs10deg.Y = sscanf(rest, ' %f ');
                    end                    
                case {'Z', 'Z:'}
                    switch observer
                        case 2
                           data.obs2deg.Z = sscanf(rest, ' %f');
                        case 10
                           data.obs10deg.Z = sscanf(rest, ' %f ');
                    end                      
                case {'mk', 'MK'}
                    switch observer
                        case 2
                           data.obs2deg.mired = sscanf(rest, ' %*s %f');
                        case 10
                           data.obs10deg.mired = sscanf(rest, ' %*s %f ');
                    end 
                case {'x', 'x:'}
                    switch observer
                        case 2
                           data.obs2deg.x = sscanf(rest, ' %f');
                        case 10
                           data.obs10deg.x = sscanf(rest, ' %f ');
                    end                
                case {'y', 'y:'}
                    switch observer
                        case 2
                           data.obs2deg.y = sscanf(rest, ' %f');
                        case 10
                           data.obs10deg.y = sscanf(rest, ' %f ');
                    end                    
                case {'u', 'u:'}
                    switch observer
                        case 2
                           data.obs2deg.u = sscanf(rest, ' %f');
                        case 10
                           data.obs10deg.u = sscanf(rest, ' %f ');
                    end                
                case {'v', 'v:'}
                    switch observer
                        case 2
                           data.obs2deg.v = sscanf(rest, ' %f');
                        case 10
                           data.obs10deg.v = sscanf(rest, ' %f ');
                    end                    
                case {'u''', 'u'':'}
                    switch observer
                        case 2
                           data.obs2deg.uprime = sscanf(rest, ' %f');
                        case 10
                           data.obs10deg.uprime = sscanf(rest, ' %f ');
                    end                
                case {'v''', 'v'':'}
                    switch observer
                        case 2
                           data.obs2deg.vprime = sscanf(rest, ' %f');
                        case 10
                           data.obs10deg.vprime = sscanf(rest, ' %f ');
                    end                                       
                case 'u-v'
                    switch observer
                        case 2
                           data.obs2deg.uvdev = sscanf(rest, ' %*s %f');
                        case 10
                           data.obs10deg.uvdev = sscanf(rest, ' %*s %f ');
                    end  
                % CIELAB and CIELUV Stuff
                case 'CIELAB'
                    CIE = 'Lab';
                case 'CIELUV'
                    CIE = 'Luv';
                case 'Illuminant:'
                    switch observer
                        case 2
                          switch CIE
                            case 'Lab'
                              data.obs2deg.labIlluminant = sscanf(rest, ' %s ');
                            case 'Luv'
                              data.obs2deg.luvIlluminant = sscanf(rest, ' %s ');
                          end
                        case 10
                          switch CIE
                            case 'Lab'
                              data.obs10deg.labIlluminant = sscanf(rest, ' %s ');
                            case 'Luv'
                              data.obs10deg.luvIlluminant = sscanf(rest, ' %s ');                                
                          end
                    end                    
                case 'L*:'
                    switch observer
                        case 2
                           data.obs2deg.Lstar = sscanf(rest, ' %f');
                        case 10
                           data.obs10deg.Lstar = sscanf(rest, ' %f ');
                    end
                case 'a*:'
                    switch observer
                        case 2
                           data.obs2deg.astar = sscanf(rest, ' %f');
                        case 10
                           data.obs10deg.astar = sscanf(rest, ' %f ');
                    end 
                case 'b*:'
                    switch observer
                        case 2
                           data.obs2deg.bstar = sscanf(rest, ' %f');
                        case 10
                           data.obs10deg.bstar = sscanf(rest, ' %f ');
                    end
                case 'u*:'
                    switch observer
                        case 2
                           data.obs2deg.ustar = sscanf(rest, ' %f');
                        case 10
                           data.obs10deg.ustar = sscanf(rest, ' %f ');
                    end 
                case 'v*:'
                    switch observer
                        case 2
                           data.obs2deg.vstar = sscanf(rest, ' %f');
                        case 10
                           data.obs10deg.vstar = sscanf(rest, ' %f ');
                    end                    
                 case 'C*:'
                    switch observer
                        case 2
                          switch CIE
                            case 'Lab'
                              data.obs2deg.labCstar = sscanf(rest, ' %f');
                            case 'Luv'
                              data.obs2deg.luvCstar = sscanf(rest, ' %f ');
                          end
                        case 10
                          switch CIE
                            case 'Lab'
                              data.obs10deg.labCstar = sscanf(rest, ' %f');
                            case 'Luv'
                              data.obs10deg.luvCstar = sscanf(rest, ' %f ');
                          end
                    end
                case 'H*:'
                    switch observer
                        case 2
                          switch CIE
                            case 'Lab'
                              data.obs2deg.labHstar = sscanf(rest, ' %f');
                            case 'Luv'
                              data.obs2deg.luvHstar = sscanf(rest, ' %f ');
                          end
                        case 10
                          switch CIE
                            case 'Lab'
                              data.obs10deg.labHstar = sscanf(rest, ' %f');
                            case 'Luv'
                              data.obs10deg.luvHstar = sscanf(rest, ' %f ');
                          end
                    end
                case 'Delta'
                  [EorH, rest] = strtok(rest);
                  switch EorH
                   case 'E:'
                    switch observer
                        case 2
                          switch CIE
                            case 'Lab'
                              data.obs2deg.labdeltaE = sscanf(rest, ' %f');
                            case 'Luv'
                              data.obs2deg.luvdeltaE = sscanf(rest, ' %f ');
                          end
                        case 10
                          switch CIE
                            case 'Lab'
                              data.obs10deg.labdeltaE = sscanf(rest, ' %f');
                            case 'Luv'
                              data.obs10deg.luvdeltaE = sscanf(rest, ' %f ');
                          end
                    end % switch observer
                   case 'H:'
                    switch observer
                        case 2
                          switch CIE
                            case 'Lab'
                              data.obs2deg.labdeltaH = sscanf(rest, ' %f');
                            case 'Luv'
                              data.obs2deg.luvdeltaH = sscanf(rest, ' %f ');
                          end
                        case 10
                          switch CIE
                            case 'Lab'
                              data.obs10deg.labdeltaH = sscanf(rest, ' %f');
                            case 'Luv'
                              data.obs10deg.luvdeltaH = sscanf(rest, ' %f ');
                          end
                    end % switch observer                       
                  end % switch EorH
                otherwise % something for otherwise ? not thought of anything
            end % switch key           
        end % while not end of [CALCULATED] section
    end
    
    % Get the spectral data
    if strcmp(lin, '[SPECTRAL]')
        noSPECTRAL = 0;
        % Get start and end wavelengths, as well as wavelength increment
        lin = fgetl(fid);
        [A,count] = sscanf(lin, '%f');
        if count == 1
            startwav = A(1);
        end
        lin = fgetl(fid);
        [A,count] = sscanf(lin, '%f');
        if count == 1
            endwav = A(1);
        end
        lin = fgetl(fid);
        [A,count] = sscanf(lin, '%f');
        if count == 1
            incwav = A(1);
        end
        data.wav = (startwav:incwav:endwav)';
        % Get the spectral data
        while ~strcmp(lin, '[END OF SECTION]') && ~feof(fid)
            lin = fgetl(fid);
            [A,count] = sscanf(lin, '%f');
            if count == 1
                dataline = dataline + 1;
                data.radphot(dataline) = A(1);
            end
        end
    end
    
end
fclose(fid);

% Want column vector
data.radphot = data.radphot';


% Try to figure out the units of the radphot data
switch data.radiometricmode
    case 'Unknown'
        data.radphotunits = 'Unknown';
    case 'Radiance'
        data.radphotunits = 'W/m^2/sr/nm';
    case 'Irradiance'
        data.radphotunits = 'W/m^2/nm';
    otherwise
        data.radphotunits = ['As for ' data.radiometricmode];
end

% If no HEADER, SPECTRAL or CALCULATED data was found, assume text was exported as "Spectral Only"
if noHEADER && noSPECTRAL && noCALCULATED
  disp('Assuming "Spectral Only" text was exported from SpectraWin.');
  wavlimits = dlmread(filename, ',' ,[1 0 3 0]);
  data.wav = (wavlimits(1):wavlimits(3):wavlimits(2))';
  data.radphot = dlmread(filename, ',', 4, 0);
  % Final desperate effort to get some sort of title for the data
  fid = fopen(filename, 'r');
  data.title = fgetl(fid);
  fclose(fid);
end
