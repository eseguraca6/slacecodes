function zmxRMS = ReadZemaxRMS(File)
% zmxRMS = ReadZemaxRMS(Filename)
%
% Reads text written from a Zemax RMS Wavefront, Spot size or Strehl Ratio Analysis.
% The text can be written from an RMS analysis window, or generated using the zGetTextFile with the 'Rmf', 'Rms', or 'Rmw' 
% codes (see help ZemaxButtons)
% The results are returned in a struct in which the following fields are defined :
%      datatype: Type of data in the data field e.g. 'RMS Wave Error vs. Focus'
%          file: Name of the ZEMAX file from which the data was computed e.g. 'C:\Projects\MSMI\Concepts\baf(960)mak.ZMX'
%         title: Title of the ZEMAX file from which the data was computed e.g. 'mak U.S.Patent 2701983 Variant a'
%          date: Date on which the data was computed e.g. 'THU NOV 6 2003'
%          ylab: Data plotted on the y-axis
%          xlab: Data plotted on the x-axis
%           ref: Reference for the data - either Centroid or Chief Ray
%        yunits: Units for the y-axis
%        xunits: Units for the x-axis
% Additional fields are dependent on what data is present.
% For ylab == 'Field' (ie an RMS vs. Field datatype)
%        orient: The orientation of the data vector, +y, -y, +x or -x
%         waves: The wavelengths at which the values (yunits) have been computed. One column per
%                wavelength.
%          poly: Set to 1 if the polychromatic data appear. If so, found in first data column.
%        fields: The field values for the data in units given by xunits.
%          data: The RMS or strehl data, one column for polychromatic data (if poly=1) and one per wavelength. 
% For ylab == 'Focus' (ie an RMS vs. Focus datatype)
%         focus: The focus positions in xunits for which the data is computed.
%          data: The RMS or strehl data, one column for each field position, one row for each focus
%                position.
% For ylab == 'Wavelength' (ie an RMS vs. Wavelength datatype)
%         waves: The wavelengths in yunits at which the data have been computed.
%          data: The RMS or strehl data, one column per field position, one row per wavlength.
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
lin = 1;
nexlin = fgetl(fid);
zmxRMS.datatype = nexlin;

% Determine the x an y lables
start = regexp(nexlin, 'vs.');
if ~isempty(start)
    zmxRMS.ylab = nexlin(1:(start-2));
    zmxRMS.xlab = nexlin((start+4):end);
else
    zmxRMS.ylab = '';
    zmxRMS.xlab = '';
end

while ~feof(fid) 
   nexlin = fgetl(fid); lin = lin+1;
   if lin <= 8
       if length(nexlin) > 6 
           ident = nexlin(1:6);
       else
           ident = nexlin;
       end
       switch ident
           case 'File :' 
               zmxRMS.file = nexlin(8:end);
           case 'Title:' 
               zmxRMS.title = nexlin(8:end);
           case 'Date :' 
               zmxRMS.date = nexlin(8:end);
           case 'Refere'
               zmxRMS.ref = nexlin(12:(end-1));
           case 'RMS un'
               start = regexp(nexlin, ' in ');
               zmxRMS.yunits = nexlin((start+4):(end-1));
           case 'Strehl'
               zmxRMS.yunits = 'dimensionless';
        end
   end
   switch zmxRMS.xlab
       case 'Field'
           switch lin
               case {1,2,3,4,5,6,7,8} % Do nothing
               case 9 % The x units are given
                   start = regexp(nexlin, ' in ');
                   zmxRMS.xunits = nexlin((start+4):(end-1));
               case 10 
                   zmxRMS.orient = sscanf(nexlin, 'Field is oriented along the %s direction.');
               case 11 % Blank line - ignore
               case 12 % These are the column headers
                   start = regexp(nexlin, 'Poly');
                   if isempty(start)
                       zmxRMS.waves = sscanf(nexlin(6:end),'%f',inf);
                       zmxRMS.poly = 0;
                   else
                       zmxRMS.waves = sscanf(nexlin((start+4):end),'%f',inf);
                       zmxRMS.poly = 1;
                   end
                   data = [];
               otherwise % This is data
                   arow = sscanf(nexlin, '%f', inf);
                   data(end+1,:)=arow';
           end       
       case 'Focus'
           switch lin
               case {1,2,3,4,5,6,7,8} % Do nothing
               case 9
                   start = regexp(nexlin, ' in ');
                   zmxRMS.xunits = nexlin((start+4):(end-1));                   
               case {10,11} % Blank and header lines - ignore
                   data = [];
               otherwise % This is data
                   arow = sscanf(nexlin, '%f', inf);
                   data(end+1,:)=arow';
           end
       case 'Wavelength'
           switch lin
               case {1,2,3,4,5,6,7,8,9} % Do nothing
               case 10
                   start = regexp(nexlin, ' are ');
                   zmxRMS.xunits = nexlin((start+5):(end-1));    
               case {11,12,13} % Blank and header lines
                   data = [];
               otherwise
                   arow = sscanf(nexlin, '%f', inf);
                   data(end+1,:)=arow';                   
           end
   end
end
switch zmxRMS.xlab
    case 'Field'
        zmxRMS.data = data(:,2:end);
        zmxRMS.fields = data(:,1);
    case 'Focus'
        zmxRMS.data = data(:,2:end);
        zmxRMS.focus = data(:,1);
    case 'Wavelength'
        zmxRMS.data = data(:,2:end);
        zmxRMS.waves = data(:,1);        
end

fclose(fid);
