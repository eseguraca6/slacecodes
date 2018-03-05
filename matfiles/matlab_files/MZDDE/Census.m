% Census Script
% This script established the revision and copyright status of all m-files 
% in the MZDDE directory.
% Usage : census
%         report census
% 
% Running the report requires the Matlab Report Generator to write the HTML
% report (Census.html). The script census alone will just display the major 
% and minor revision sums, as well as the overall toolbox version number.
%
% See Also : docgen, mzddeVersion, ToolTest

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

% Get a directory of all the .m files in this directory
% Of course, there may be other files in the directory under revision control and these should be
% included in future versions of this script.

myself = which('Census'); % Get the directory from which this census is running (presumably)
[mypath,name,ext,versn] = fileparts(myself); % Get the path

% Now get all the .m files

mfiles = dir([mypath '\*.m']);

% Set up the cell array headings
VersionSummary{1,1} = 'Filename';
VersionSummary{1,2} = 'SVN Revision';
VersionSummary{1,3} = 'GPL';

majsum = 0;


% Set up GPL Column
for i = 1:length(mfiles)
    VersionSummary{i+1,3} = 'No';
end

% Loop through all .m files and and get the versions

for i = 1:length(mfiles)
    mfid = fopen([mypath '\' mfiles(i).name]);
    VersionSummary{i+1,1} = mfiles(i).name;
    % Read lines in the .m file until the version information is found
    while 1
      mline = fgetl(mfid);
      if ~ischar(mline), break, end
      % Check the line to see if there is a $Revision line
      head = strfind(mline, '$Revision: ');
      if ~isempty(head)
          mline = mline(head(1):end);
          mrev = [];
          [mrev, count] = sscanf(mline, '$Revision: %i');
          if count == 1
            VersionSummary{i+1,2} = mrev(1); majsum = majsum + mrev(1);
          end
          break;
      end
      % Check the line to see if the GNU licence is found
      gnu = strfind(mline, 'GNU General Public License');
      if ~isempty(gnu)
          VersionSummary{i+1,3} = 'Yes';
      end
    end
    fclose(mfid);
end

VersionSummary{length(mfiles)+2,1} = 'Version number sum =';
VersionSummary{length(mfiles)+2,2} = majsum;
load MZDDERelease
toolboxversion = [num2str(MZDDERelease) '.' num2str(majsum)]
save MZDDEVersion toolboxversion

