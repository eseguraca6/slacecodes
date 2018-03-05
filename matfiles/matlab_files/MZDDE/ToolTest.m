% ToolTest - This script performs regression testing of the ZEMAX DDE Toolbox for
% Matlab.
% 
% This script will ask for the reference run, and will perform a difference
% analysis using CSDIFF from Component Software (www.componentsoftware.com).
% The script expects a conventional installation of CSDIFF at
% C:\Program Files\ComponentSoftware\CSDIFF\CSDIFF.exe
%
% Usage : >> ToolTest
%

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


% First get ZEMAX going
status = zDDEStart;

if status ~= 0
    error('Unable to start/access ZEMAX. Please start ZEMAX manually and try again.');
end

% Open the results file for this run

% First get versions of everything
zemaxversion = num2str(zGetVersion);
matlabversion = version;
load MZDDEVersion % Loads up the toolboxversion


% Get path and synthesize the output filename
path = which('ToolTest');
path = [fileparts(path) '\RegressionTests\'];
outfilename = ['z ' zemaxversion ' m ' matlabversion ' t ' toolboxversion '.txt'];

% Open the output file
outfile = fopen([path outfilename], 'w');

% Scribble some headers - just the versions of the various packages to
% start with

Revision = '$Revision: 221 $';
Revision = Revision(11:(size(Revision,2)-1));

fprintf(outfile, 'ToolTest Revision : %s executed on %s.\r\n', Revision, date); 
fprintf(outfile, 'Zemax    Version  : %s\r\n', zemaxversion);
fprintf(outfile, 'Matlab   Version  : %s\r\n', matlabversion);
fprintf(outfile, 'Toolbox  Version  : %s\r\n\r\n', toolboxversion);

%--------------------------------------------------------------------------
% Run lots of tools and log results to the output file

% zGetDate
fprintf(outfile, 'zGetDate : ');
zdate = zGetDate;
[A,count] = sscanf(zdate, '%3c %3c %i %4i');
if (count ~= 5)
    [A,count] = sscanf(zdate, '%3c %3c %i %2i:%2i:%2i %4i');
    if (count ~= 8)
        fprintf(outfile, 'ZEMAX Date NOT OK\r\n');
    else
        fprintf(outfile, 'ZEMAX Date OK\r\n');   
    end
else
    fprintf(outfile, 'ZEMAX Date OK\r\n');  
end

% zGetPath
[zpath, lpath] = zGetPath;
ztype = exist(zpath, 'dir');
ltype = exist(lpath, 'dir');
if (ztype == 7) && (ltype == 7)
    fprintf(outfile, 'zGetPath : ZEMAX paths exist.\r\n');
else
    fprintf(outfile, 'zGetPath : ZEMAX paths do NOT seem to exist.\r\n');
end

% zLoadFile
zLoadFileReturnCode = zLoadFile([path '\..\zmx\Double Gauss 5 degree field.zmx']);
fprintf(outfile, 'zLoadFile : returns %i\r\n', zLoadFileReturnCode);


%--------------------------------------------------------------------------
% Close the output file and move on
fclose(outfile);
% Perform file comparison if user wants that
reply = input('Do you wish to perform the file comparison now ? Y/N [Y]: ','s');
if isempty(reply)
    reply = 'Y';
end
if strcmp(reply, 'Y')

	[comparisonfile, pathname] = uigetfile([path '*.txt'], 'Select Base Comparison File');
	diffresultfile = [pathname comparisonfile ' ' outfilename '.html'];
	comparisonfile = [pathname, comparisonfile];
	
	% Set up the command to perform the file comparison
	CSDIFFCom = ['"C:\Program Files\ComponentSoftware\CSDIFF\CSDIFF.exe" /Oh"' diffresultfile '"'];
	diffcomm = [CSDIFFCom ' "' comparisonfile '" "' outfilename '" '];
	
	% Perform File comparison
	returncode = system(diffcomm);
	
	if returncode ~= 0
        error('A problem was encountered trying to run the file comparison utility CSDIFF.');
	end
end



