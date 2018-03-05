function zmxOTF = ReadZemaxOTF(File)
% zmxOTF = ReadZemaxOTF(Filename)
%
% Reads text written from a Zemax thru-frequency, thru-focus or thru-field OTF/MTF analysis.
% The text can be written from the Mtf analysis window, or generated using the zGetTextFile with the 'Mtf' code (see help ZemaxButtons)
% The codes for thru-focus and thru-field MTF/OTF computations are respectively 'Tfm' and 'Mth'.
% The results are returned in a struct in which the following fields are defined :
%      datatype: Type of data in the data field e.g. 'Polychromatic Diffraction MTF'
%          file: Name of the ZEMAX file from which the data was computed e.g. 'C:\Projects\MSMI\Concepts\baf(960)mak.ZMX'
%         title: Title of the ZEMAX file from which the data was computed e.g. 'mak U.S.Patent 2701983 Variant a'
%          date: Date on which the data was computed e.g. 'THU NOV 6 2003'
%           wav: Wavelength range for the computation e.g. [0.4500 0.5150]
%         sfreq: Spatial frequencies at which data is presented.
%    sfrequnits: Units of spatial frequency scale e.g. 'Cycles per mm.'
%      fieldpos: Field position data in cell array e.g. {'Diffraction limit'  '0.00 mm'  '20.00 mm'  '40.00 mm'  '40.00 mm'}
%       colhead: Column headings in a cell array e.g {'Spatial frequency'  'Tangential'   'Sagittal'}
%        abscis: The abscissa - Spatial frequencies, focus or field position e.g. [102x1 double]
%          data: The actual data e.g. [102x10 double]
%        fieldx: The x values of the field positions e.g. [0 0 0 0 0]
%        fieldy: The y values of the field positions e.g. [0 0 20 40 40]
%    fieldunits: The units of the field positions e.g. 'mm'
%        fcount: The number of field positions (thru-focus and thru-frequency) or spatial frequencies (thru-field). The
%                number of data columns will be twice this value (for Tangential and Sagittal data).
%
% See also zGetTextFile

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

[fid, err] = fopen(File, 'r');
if fid==-1
    disp(['Unable to open specified file ' File ' - ' err]);
    return;
end
nexlin = fgetl(fid);
zmxOTF.datatype = nexlin;
fnum = 0;
while ~feof(fid) 
   nexlin = fgetl(fid);
   if length(nexlin) > 6 
       ident = nexlin(1:6);
   else
       ident = nexlin;
   end
   switch ident
       case 'File :' 
           zmxOTF.file = nexlin(8:(length(nexlin)));
       case 'Title:' 
           zmxOTF.title = nexlin(8:(length(nexlin)));
       case 'Date :' 
           zmxOTF.date = nexlin(8:(length(nexlin)));
       case 'Field:' % Have found a field specifier for thru-focus and thru-frequency OTFs
           fnum = fnum + 1;
           datanum = 1; % Start a data line counter
           fieldata = nexlin(8:(length(nexlin)));
           zmxOTF.fieldpos{fnum} = fieldata;
           [A, count] = sscanf(fieldata, '%f, %f %s');
           if count == 3
               zmxOTF.fieldx(fnum) = A(1);
               zmxOTF.fieldy(fnum) = A(2);
               zmxOTF.fieldunits = char(A(3:length(A))');
           else
               [A, count] = sscanf(fieldata, '%f %s');
               if count == 2
                   zmxOTF.fieldx(fnum) = 0;
                   zmxOTF.fieldy(fnum) = A(1);
                   zmxOTF.fieldunits = char(A(2:length(A))');
               end
           end
           
           colhead = fgetl(fid); % Get the data column headings which should always occur on the very next line
       otherwise
           % Try various scans to see what the data might be
           [A, count] = sscanf(nexlin, ' %f %f %f');
           if count == 3
               % Presumably we have hit data
               zmxOTF.abscis(datanum,1) = A(1);
               zmxOTF.data(datanum,fnum*2-1) = A(2);
               zmxOTF.data(datanum,fnum*2) = A(3);
               datanum = datanum + 1;
           else
               [A, count] = sscanf(nexlin, 'Data for %f to %f microns.');
               if count == 2
                 % Found the wavelength range for this analysis
                 zmxOTF.wav = A';
               else
                   [A, count] = sscanf(nexlin, 'Spatial Frequency units are cycles per %s');
                   if count == 1
                       % Found the specifier for spatial frequency units
                       zmxOTF.sfrequnits = ['Cycles per ' A];
                   else
                       [A, count] = sscanf(nexlin, 'Spatial frequency: %f cycles per %s');
                       if count == 2
                           % Found the spatial frequency for thru-focus data
                           zmxOTF.sfreq = A(1);
                           zmxOTF.sfrequnits = ['cycles per ' char(A(2:end)')];
                       else
                           [A, count] = sscanf(nexlin, 'Data for Spatial frequency: %f cycles per %s');
                           if count == 2
                               % Found the spatial frequency specifier for thru-field data
                               fnum = fnum + 1;
                               datanum = 1;
                               zmxOTF.sfreq(fnum) = A(1);
                               zmxOTF.sfrequnits = ['cycles per ' char(A(2:end)')];
                               colhead = fgetl(fid); % Get the data column headings hopefully on the very next line
                           else
                               [A, count] = sscanf(nexlin, 'Maximum Y field: %f %s');
                               if count == 2 % Found the maximum Y field specifier for thru-field MTF/OTF
                                   zmxOTF.fieldy(1) = A(1);
                                   zmxOTF.fieldx(1) = 0;
                                   zmxOTF.fieldunits = char(A(2:end)');
                               else
                                 [A, count] = sscanf(nexlin, 'Maximum X field: %f %s');
                                 if count == 2 % Found the maximum X field specifier for thru-field MTF/OTF
                                   zmxOTF.fieldy(1) = 0;
                                   zmxOTF.fieldx(1) = A(1);
                                   zmxOTF.fieldunits = char(A(2:end)');
                                 else
                                   [A, count] = sscanf(nexlin, 'Data for %f microns.');
                                     if count == 1
                                       % Found the wavelength for this analysis
                                       zmxOTF.wav = A;
                                     end
                                 end
                               end
                           end
                       end
                   end
               end
           end
   end

end
zmxOTF.fcount = fnum;

% Deal with colhead, getting the various individual headings

% Scan for headings using regular expression
pat = '\s*((\S+\s?)+\s*)\s*';
[start,finish] = regexp(colhead, pat);
for i = 1:length(start)
    head{i} = deblank(colhead(start(i):finish(i)));
end

zmxOTF.colhead = head;
fclose(fid);
