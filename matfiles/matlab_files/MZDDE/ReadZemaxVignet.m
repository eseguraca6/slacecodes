function zmxVignet = ReadZemaxVignet(File)
% zmxVignet = ReadZemaxVignet(File)
%
% Reads text written from a Zemax Vignetting (Vig) analysis.
% The text can be written from the Vignetting window, or generated using zGetTextFile with the 'Vig' code (see help ZemaxButtons)
% The results are returned in a struct in which the following fields are defined :
%      datatype: Type of data in e.g. 'Vignetting Data'
%          file: Name of the ZEMAX file from which the data was computed e.g. 'C:\Projects\MSMI\Concepts\baf(960)mak.ZMX'
%         title: Title of the ZEMAX file from which the data was computed e.g. 'mak U.S.Patent 2701983 Variant a'
%          date: Date on which the data was computed e.g. 'THU NOV 6 2003'
%    fieldunits: The units of the field position data (e.g. millimetres or degrees)
%         field: The field position data in fieldunits.
%           vig: The vignetting data.
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
zmxVignet.datatype = nexlin;
datacount = 0; % Count the data lines
while ~feof(fid) 
   nexlin = fgetl(fid);
   if length(nexlin) > 6 
       ident = nexlin(1:6);
   else
       ident = nexlin;
   end
   switch ident
       case 'File :' 
           zmxVignet.file = nexlin(8:(length(nexlin)));
       case 'Title:' 
           zmxVignet.title = nexlin(8:(length(nexlin)));
       case 'Date :' 
           zmxVignet.date = nexlin(8:(length(nexlin)));
       
       otherwise
           % Try various scans to see what the data might be
           [A, count] = sscanf(nexlin, 'Wavelength: %f ');
           if count == 1
               zmxVignet.wav = A(1);
              
           else
               [A, count] = sscanf(nexlin, '%f %f');
               if count == 2
                  % Presumably we have hit data, now stored as column vector in A
                  datacount = datacount + 1;
                  zmxVignet.field(datacount) = A(1);
                  zmxVignet.vig(datacount) = A(2);
               else
                   [A, count] = sscanf(nexlin, 'Field values are in %s');
                   if count == 1
                       zmxVignet.fieldunits = A;
                   else
                       % Put any new code in here
                   end
               end
                 
           end
   end

end

fclose(fid);
