function zmxGIm = ReadZemaxGImAnal(File)
% ReadZemaxGImAnal - Read results from a ZEMAX Geometric Image Analysis
%
% Usage : zmxGimAnal = ReadZemaxGImAnal(File);
%
% Reads data written by ZEMAX from a geometric image analysis.
% The associated ZemaxButton is 'Ima'.
% Currently only does pixel data. Not complete.
%
% See also : zGetTextFile, ZemaxButtons

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
zmxGIm.datatype = nexlin;

if zmxGIm.datatype == 'Image analysis histogram listing'
while ~feof(fid) 
   nexlin = fgetl(fid);
   if length(nexlin) > 6 
       ident = nexlin(1:6);
   else
       ident = nexlin;
   end
   switch ident
       case 'File :' 
           zmxGIm.file = nexlin(8:(length(nexlin)));
       case 'Title:' 
           zmxGIm.title = nexlin(8:(length(nexlin)));
       case 'Date :' 
           zmxGIm.date = nexlin(8:(length(nexlin)));
       otherwise
           if length(nexlin) > 30
               ident = nexlin(1:30);
           else
               ident = nexlin;
           end
           switch ident
               case 'Object field                 :'
                  [A, count] = sscanf(nexlin, 'Object field                 : %f, %f deg'); 
                  if count == 2
                      zmxGIm.fieldx = A(1);
                      zmxGIm.fieldy = A(2);
                  end
               case 'Number of pixels             :'
                   [A, count] = sscanf(nexlin, 'Number of pixels             : %f x %f'); 
                  if count == 2
                      zmxGIm.pixelsx = A(1);
                      zmxGIm.pixelsy = A(2);
                  end
               case 'Total Weight of Rays Attemped:'
                   [A, count] = sscanf(nexlin, 'Total Weight of Rays Attemped:  %f'); 
                  if count == 1
                      zmxGIm.rayweightattempt = A(1);
                  end
               case 'Total Weight of Rays Passed  :'
                   [A, count] = sscanf(nexlin, 'Total Weight of Rays Passed  :  %f'); 
                  if count == 1
                      zmxGIm.rayweightpassed = A(1);
                  end
               case 'Percent Efficiency           :'
                   [A, count] = sscanf(nexlin, 'Percent Efficiency           :   %f %%'); 
                  if count == 1
                      zmxGIm.efficiency = A(1);
                  end
               case 'Total flux in watts          :'
                   [A, count] = sscanf(nexlin, 'Total flux in watts          : %f'); 
                  if count == 1
                      zmxGIm.wattspassed = A(1);
                  end
                   
           end
   end

end
end

fclose(fid);
