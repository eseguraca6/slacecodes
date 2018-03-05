function zmxWaveMap = ReadZemaxWaveMap(File)
% zmxWaveMap = ReadZemaxWaveMap(File)
%
% Reads text written from a Zemax Wavefront Map (Wfm) analysis.
% The text can be written from the Wavefront Map window, or generated using the zGetTextFile with the 'Wfm' code (see help ZemaxButtons)
% The results are returned in a struct in which the following fields are defined :
%      datatype: Type of data in the data field e.g. 'Listing of Wavefront Map Data'
%          file: Name of the ZEMAX file from which the data was computed e.g. 'C:\Projects\MSMI\Concepts\baf(960)mak.ZMX'
%         title: Title of the ZEMAX file from which the data was computed e.g. 'mak U.S.Patent 2701983 Variant a'
%          date: Date on which the data was computed e.g. 'THU NOV 6 2003'
%           wav: Wavelength of the computation
%         field: Field Position of computation
%         funit: Field position units e.g. 'mm' or 'deg'.
%            pv: Peak to valley error of the wavefront as reported by ZEMAX
%          grid: Size of the data grid e.g. [64 64]
%        center: Location of the centre point of the data e.g. [33 33]
%          data: The wavefront map data. The size of this matrix is given by grid.
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
zmxWaveMap.datatype = nexlin;
zmxWaveMap.data = [];
while ~feof(fid) 
   nexlin = fgetl(fid);
   if length(nexlin) > 6 
       ident = nexlin(1:6);
   else
       ident = nexlin;
   end
   switch ident
       case 'File :' 
           zmxWaveMap.file = nexlin(8:(length(nexlin)));
       case 'Title:' 
           zmxWaveMap.title = nexlin(8:(length(nexlin)));
       case 'Date :' 
           zmxWaveMap.date = nexlin(8:(length(nexlin)));
       case 'Peak t' % Peak to valley OPD
           [A, count] = sscanf(nexlin, 'Peak to valley is %f waves.');
           if count == 1
               zmxWaveMap.pv = A;
           end
       case 'Pupil ' % Pupil grid size
           [A, count] = sscanf(nexlin, 'Pupil grid size: %f by %f');
           if count == 2
               zmxWaveMap.grid = A';
           end
       case 'Center' % Centre pixel
           [A, count] = sscanf(nexlin, 'Center point is: %f, %f');
           if count == 2
               zmxWaveMap.center = A';
           end
       otherwise
           % Try various scans to see what the data might be
           [A, count] = sscanf(nexlin, '%f');
           if isfield(zmxWaveMap, 'grid')
               grid = zmxWaveMap.grid;
           else
               grid = [-1 -1];
           end
           if count == grid(1)
               % Presumably we have hit data, now stored as column vector in A
              zmxWaveMap.data = cat(1, zmxWaveMap.data, A');
           else
               [A, count] = sscanf(nexlin, '%f microns at %f %*s');
               if count == 2
                 % Found the wavelength and field for this analysis
                 zmxWaveMap.wav = A(1);
                 zmxWaveMap.field = A(2);
                 [A, count] = sscanf(nexlin, '%*f microns at %*f %s');
                 if (count == 1) 
                     zmxWaveMap.funit = A(1:(end-1));
                 end
               end
                 
           end
   end

end

fclose(fid);
