function [FileList] = ConvertGPLtoBSDLicence(Filespec)
% ConvertGPLtoBSDLicence : Remove GPL Licence and insert BSD Licence

% Usage :
%   [FileList] = ConvertGPLtoBSDLicence(Filespec)

%% BSD Licence
% This file is subject to the terms and conditions of the BSD licence.
% For further details, see the file BSDlicence.txt

%% $Id: ConvertGPLtoBSDLicence.m 221 2009-10-30 07:07:07Z DGriffith $   

FileList = dir(Filespec);
%% The GPL licence data to be replaced is as follows
% Match only the first 30 or so characters
GPL = {
'%% MZDDE - The ZEMAX DDE Tool', ...
'% MZDDE - The ZEMAX DDE Toolb', ...
'% This file is part of MZDDE.', ...
'%  MZDDE is free software; yo', ...
'%  it under the terms of the ', ...
'%  the Free Software Foundati', ...
'%  (at your option) any later', ...
'%  MZDDE is distributed in th', ...
'%  but WITHOUT ANY WARRANTY; ', ...
'%  MERCHANTABILITY or FITNESS', ...
'%  GNU General Public License', ...
'%  You should have received a', ...
'%  along with MZDDE (COPYING.', ...
'%  Foundation, Inc., 59 Templ'};

lenfirst = length(GPL{1});

% The text will be replaced by the following text

BSD = {'%% Copyright 2002-2009, DPSS, CSIR', ...
       '% This file is subject to the terms and conditions of the BSD Licence.', ...
       '% For further details, see the file BSDlicence.txt', ...
       '%'};


%% Open files one by one and perform the replacement
for iFile = 1:length(FileList)
  % Copy the file to an old version with the GPL
 
  [status,message,messageid] = copyfile(FileList(iFile).name,[FileList(iFile).name '.GPL'],'f');
  if status
    fidi = fopen([FileList(iFile).name '.GPL'],'r');
    fido = fopen(FileList(iFile).name, 'w');
    % Read the file line by line
    %lin = fgetl(fidi);
    while ~feof(fidi)
      lin = fgetl(fidi); % get the next line from the file        
      if length(lin) >= lenfirst
        imatch = strcmp(lin(1:lenfirst), GPL);
        if imatch(1) || imatch(2)
          % Write in the BSD licence
          for iBSD = 1:length(BSD)
            fprintf(fido, '%s\n', BSD{iBSD});
          end
        end
        if ~any(imatch) % Have not found one of the lines of the GPL
            if length(lin) >= 12 && strcmp(lin(1:12), '% Copyright ') % Don't write copyright notice 
                % Do nothing
            else
              fprintf(fido, '%s\n', lin); % write the line as is
            end
        end
      else % write the line as is, it is too short to be a match to any line in the GPL text
          fprintf(fido, '%s\n', lin);        
      end
    end
    fclose(fidi);
    fclose(fido);
  else
    warning(['Unable to copy file ' FileList(iFile).name ' - skipping. ' message]);
  end
end

end

