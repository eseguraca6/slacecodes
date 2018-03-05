function ASDData = ReadASDtxt(Filename)
% ReadASDtxt : Read radiometric text data exported from ASD Viewspec
%
% ASD is Analytical Spectral Devices. This function was written for the
% ASD FieldSpec 3 instrument. The data should be exported from ViewSpec
% with complete headers, which means that there is a single spectrum per
% file. The wavelengths must be exported rather than spectral bin numbers.
%
% Usage :
%  >> ASDData = ReadASDtxt(Filename)
%
% Where :
%   Filename is the name of the text file from which to read the data. If
%   this input is missing or empty, a File/Open dialog will be presented.
%
%   ASDData is a structure which may contain the following fields.
%  
%                 HeaderTxt: The complete text of the file header in a cell
%                            array of strings.
%               txtFilename: The filename of the text file.
%               ASDFilename: The filename of the ASD binary file from which
%                            the text file was exported from ViewSpec.
%                   Comment: A comment entered at the time of export.
%               InstrNumber: The serial number of the ASD radiometer.
%                  ProgVers: The version of ViewSpec which exported the
%                            file.
%                  FileVers: The version of the file format (presumably).
%                   DateVec: Six element numeric date vector of time that
%                            the spectrum was supposedly saved.
%                  DateTime: Text version of the DateVec.
%                SerialDate: Serial date of the DateVec.
%               VNIRintTime: VNIR channel integration time.
%               VNIRChan1Wv: Start wavelength of VNIR channel in nm.
%             VNIRChan1Step: Step in VNIR wavelength in nm.
%           SamplesPerValue: Number of spectra averaged for this spectrum.
%                      xmin: Minimum wavelength.
%                      xmax: Maximum wavelength.
%                      ymin: Minimum y-value (radiance, irradiance or DN)
%                      ymax: Maximim y-value
%                  BitDepth: Bit depth of data digitized by the
%                            radaiometer.
%                 SWIR1Gain: Gain in SWIR 1 channel.
%               SWIR1Offset: Offset in SWIR 1 channel.
%                 SWIR2Gain: Gain in SWIR2 channel.
%               SWIR2Offset: Offset in SWIR 2 channel.
%             VNIRjoinSWIR1: Switchover wavelength from VNIR to SWIR1.
%            SWIR1joinSWIR2: Switchover wavelength from SWIR1 to SWIR2.
%     VNIRDarkSigSubtracted: Flag indicating if VNIR dark signal was
%                            subtracted from data.
%               NumDarkMeas: Number of dark signal spectra averaged.
%          DarkMeasDateTime: Date/Time at which dark signal was measured.
%        DarkMeasSerialDate: Serial date at which dark signal was measured.
%                    DCCVal: DCC value (?).
%                WhiteRefed: Flag indicating if data is referenced to a
%                            white reference or not.
%                 ForeOptic: Description of foreoptic if any.
%               FileContent: Description of file content.
%                    GPSLat: GPS latitude in decimal degrees if available.
%                   GPSLong: GPS longitude if available
%                    GPSAlt: GPS altitude in metres if available.
%                    GPSUTC: Universal Time from GPS.
%                 GPSUTCVec: Universal Time in 3-element numeric vector.
%                        Wv: Wavelengths of the measurement.
%                   RadData: Radiometric data (radiance, irradiance or DN).
% 
% Example :
% >> ASDData = ReadASDtxt('refl00011.asd.txt');
%
% This example reads a single file exported from ViewSpec with headers.


%% $Id: ReadASDtxt.m 221 2009-10-30 07:07:07Z DGriffith $
% All rights reserved.
%
% This file is subject to the conditions of the BSD Licence. For further
% details, see the file BSDLicence.txt.

% Create the structure
ASDData = struct('HeaderTxt', {''}, 'txtFilename', '', 'ASDFilename', '', 'Comment', '', 'InstrNumber', [], 'ProgVers', '', 'FileVers', '', ...
  'DateVec', [], 'DateTime', '', 'SerialDate', [], 'VNIRintTime', [], 'VNIRChan1Wv', [], 'VNIRChan1Step', [], 'SamplesPerValue', [], ...
  'xmin', [], 'xmax', [], 'ymin', [], 'ymax', [], 'BitDepth', [], 'SWIR1Gain', [], 'SWIR1Offset', [], 'SWIR2Gain', [], ...
  'SWIR2Offset', [], 'VNIRjoinSWIR1', [], 'SWIR1joinSWIR2', [], 'VNIRDarkSigSubtracted', [], 'NumDarkMeas', [], 'DarkMeasDateTime', '', ...
  'DarkMeasSerialDate', [], 'NumWhiteMeas', [], 'WhiteMeasDateTime', '', 'WhiteMeasSerialDate', [], ...
  'DCCVal', [], 'WhiteRefed', [], 'ForeOptic','','FileContent', '','GPSLat', [], 'GPSLong', [], 'GPSAlt',[], 'GPSUTC', [], ...
  'GPSUTCVec', [], 'Wv', [], 'RadData', []);

if ~exist('Filename', 'var') || isempty(Filename)
    [Filename, Pathname] = uigetfile('*.txt', 'Select the ASD Text File');
    if ~Filename
        return
    end
    Filename = [Pathname Filename];
end
[pathstr, name] = fileparts(Filename);

ASDData.txtFilename = Filename;
%% Open and read the file
ilin = 0;
ASDFilename = '';
if exist(Filename, 'file')
  fid = fopen(Filename);
  while ~feof(fid)
    lin = fgetl(fid); % Read line by line until header is all done
    ilin = ilin +  1;
    ASDData.HeaderTxt{ilin} = lin;
    [A,count] = sscanf(lin, 'Text conversion of header file %s');
    if count
      [ASDFilePath, ASDFilename] = fileparts(lin(32:end));
      ASDData.ASDFilename = lin(32:end);
    end
    [A,count] = sscanf(lin, 'Wavelength %s');
    if count % scan the rest of the file
      Data = textscan(fid, '%f %f');
      ASDData.Wv = Data{1};
      ASDData.RadData = Data{2};
    end
    if strcmp(strtrim(lin), ASDFilename)
      Data = textscan(fid, '%f');
      ASDData.RadData = Data{1};
    end
    [A,count] = sscanf(lin, 'The instrument number was %s');
    if count
      ASDData.InstrNumber = A;
    end
    % Versions
    [A,count] = sscanf(lin, 'New ASD spectrum file: Program version = %s file version = %s');
    if count
      if length(A) == 8
        ASDData.ProgVers = A(1:4);
        ASDData.FileVers = A(5:8);
      end
    end
    [A,count] = sscanf(lin, 'Spectrum saved: %s at %s');
    if count
      DateVector = datevec(A(1:10), 23);
      TimeVector = datevec(A(11:end), 13);
      ASDData.DateVec = DateVector+[0 0 0 TimeVector(4:6)];
      ASDData.SerialDate = datenum(ASDData.DateVec);
      ASDData.DateTime = datestr(ASDData.DateVec, 0);
    end
    % VNIR integration time
    [A,count] = sscanf(lin, 'VNIR integration time : %f');
    if count, ASDData.VNIRintTime = A; end;
    [A,count] = sscanf(lin, 'VNIR channel 1 wavelength = %f wavelength step = %f');
    if count == 2
      ASDData.VNIRChan1Wv = A(1);
      ASDData.VNIRChan1Step = A(2);
    end
    [A,count] = sscanf(lin,'There were %f samples per data value');
    if count, ASDData.SamplesPerValue = A(1); end;
    [A,count] = sscanf(lin, 'xmin = %f xmax= %f');
    if count==2, ASDData.xmin = A(1); ASDData.xmax = A(2); end;
    [A,count] = sscanf(lin, 'ymin = %f ymax= %f');
    if count==2, ASDData.ymin = A(1); ASDData.ymax = A(2); end;
    [A,count] = sscanf(lin, 'The instrument digitizes spectral values to %f bits');
    if count, ASDData.BitDepth = A(1); end;
    [A,count] = sscanf(lin,'SWIR1 gain was %f offset was %f');
    if count==2, ASDData.SWIR1Gain = A(1); ASDData.SWIR1Offset = A(2); end;
    [A,count] = sscanf(lin,'SWIR2 gain was %f offset was %f');
    if count==2, ASDData.SWIR2Gain = A(1); ASDData.SWIR2Offset = A(2); end;
    [A,count] = sscanf(lin, 'Join between VNIR and SWIR1 was %f nm');
    if count, ASDData.VNIRjoinSWIR1 = A(1); end;
    [A,count] = sscanf(lin, 'Join between SWIR1 and SWIR2 was %f nm');
    if count, ASDData.SWIR1joinSWIR2 = A(1); end;
    if strcmp(strtrim(lin), 'VNIR dark signal subtracted')
      ASDData.VNIRDarkSigSubtracted = 1;
    end
    if strcmp(strtrim(lin), 'VNIR dark signal not subtracted')
      ASDData.VNIRDarkSigSubtracted = 0;
    end
    [A,count] = sscanf(lin, '%f'); % Number of dark or white reference scans

    if count % Process dark or white reference scans
      [AA,countA] = sscanf(lin, '%*f %s');
      if countA && AA(1) == 'd' % dark measurements
        ASDData.NumDarkMeas = A(1);
        [A,count] = sscanf(lin, '%*f dark measurements taken %s %s %*s %*s %*s');
        A = char(A');
        TheWeekDay = A(1:3); TheMonth = A(4:6);
        [A,count] = sscanf(lin, '%*f dark measurements taken %*s %*s %f %f:%f:%f %f');
        DateFormat0 = sprintf('%02i-%3s-%4i %02i:%02i:%02i', A(1), TheMonth, A(5), A(2), A(3), A(4));
        ASDData.DarkMeasDateTime = DateFormat0;
        ASDData.DarkMeasSerialDate = datenum(DateFormat0, 0);
      elseif countA && AA(1) == 'w' % white reference measurements
        ASDData.NumWhiteMeas = A(1);
        [A,count] = sscanf(lin, '%*f white reference measurements taken %s %s %*s %*s %*s');
        A = char(A');
        TheWeekDay = A(1:3); TheMonth = A(4:6);
        [A,count] = sscanf(lin, '%*f white reference measurements taken %*s %*s %f %f:%f:%f %f');
        DateFormat0 = sprintf('%02i-%3s-%4i %02i:%02i:%02i', A(1), TheMonth, A(5), A(2), A(3), A(4));
        ASDData.WhiteMeasDateTime = DateFormat0;
        ASDData.WhiteMeasSerialDate = datenum(DateFormat0, 0);        
      end
    end
    [A,count] = sscanf(lin, 'DCC value was %f');
    if count, ASDData.DCCVal = A(1); end;
    
    if strcmp(strtrim(lin), 'Data is not compared to a white reference')
      ASDData.WhiteRefed = 0;
    end
    if strcmp(strtrim(lin), 'Data is compared to a white reference:')
      ASDData.WhiteRefed = 1;
    end
    if length(lin) >= 11
      % Check for a comment
      if strcmp(lin(1:11), ' ----------')
        lin = fgetl(fid);
        ASDData.Comment = strtrim(lin);
      end
      if strcmp(lin(1:10), 'There was ')
        ASDData.ForeOptic = lin;
      end
      if strcmp(lin(1:11), 'Spectrum fi')
        ASDData.FileContent = lin;
      end
      
      [A,count] = sscanf(lin, 'GPS-Latitude is %s');
      if count && length(A) > 2
        [DegMin, count] = sscanf(A, '%*2c%2i%f');
        ASDData.GPSLat = DegMin(1)+DegMin(2)/60;
        if A(1)=='S'
          ASDData.GPSLat = -ASDData.GPSLat;
        end
      end
      [A,count] = sscanf(lin, 'GPS-Longitude is %s');
      if count && length(A) > 2
        [DegMin, count] = sscanf(A, '%*2c%2i%f');
        ASDData.GPSLong = DegMin(1)+DegMin(2)/60;
        if A(1)=='W'
          ASDData.GPSLong = -ASDData.GPSLong;
        end
        
      end
      [A,count] = sscanf(lin, 'GPS-Altitude is %s');
      if count && length(A) > 2
        ASDData.GPSAlt = str2double(A);
      end
      [A,count] = sscanf(lin, 'GPS-UTC is %s');
      if count && length(A) > 2
        ASDData.GPSUTC = A;
        ASDData.GPSUTCVec = [sscanf(A, '%f:%f:%f')]';
      end
      
    end
    
  end
else
  error('ReadASDtxt:FileDoesNotExist', 'Given File does not exist')
end
fclose(fid);
