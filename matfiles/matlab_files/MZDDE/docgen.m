% Docgen script
% This script generates documentation from all the help text of the .m files in the toolbox.
% Usage : docgen
%
% See Also : Census

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


%
% This file is part of MZDDE, the ZEMAX DDE Toolbox for Matlab.
%
%    This Matlab toolbox is free software; you can redistribute it and/or 
%    modify it under the terms of the GNU General Public License as published
%    by the Free Software Foundation; either version 2 of the License, or
%    (at your option) any later version.
%
%    This toolbox is distributed in the hope that it will be useful,
%    but WITHOUT ANY WARRANTY; without even the implied warranty of
%    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
%    GNU General Public License for more details.
%
%    You should have received a copy of the GNU General Public License
%    along with this toolbox (see COPYING.html); if not, write to the 
%    Free Software Foundation, Inc., 59 Temple Place, Suite 330,
%    Boston, MA  02111-1307  USA
%
% $Revision: 221 $

myself = which('docgen'); % Get the directory from which this docgen is running (presumably)
[mypath,name,ext,versn] = fileparts(myself); % Get the path

% Now get all the .m files
mfiles = dir([mypath '\*.m']);

% Get a list of all functions and scripts, but exclude the Contents
mnames(1).name = 'MZDDE';
j = 2;
for i = 1:length(mfiles)
    if strcmp(mfiles(i).name,'Contents.m') ~= 1
        mnames(j).name = mfiles(i).name(1:(end-2));
        j = j + 1;
    end
end


% Open a html file for the output
docfid = fopen([mypath '\Documents\MZDDE Function Reference.html'], 'w');
% Write the HTML file headers
fprintf(docfid, '<html>\n<head>\n');
fprintf(docfid, '<meta http-equiv="Content-Language" content="en-us">\n');
fprintf(docfid, '<meta http-equiv="Content-Type" content="text/html; charset=windows-1252">\n');
fprintf(docfid, '<title>MZDDE Function Reference</title>\n');
fprintf(docfid, '</head>\n<body>\n');

% Loop through all .m files and get the help text
for i = 1:length(mfiles)
    helptext = help(mnames(i).name);
    fprintf(docfid,'<P>\n');
    fprintf(docfid, ['<A name = "' mnames(i).name '"><H2>' mnames(i).name '</H2></A>\n']);
    % replace all % signs with a %%
    helptext = strrep(helptext, '%', '%%');
    % replace all \ with \\
    helptext = strrep(helptext, '\', '\\');
    % put mailto and CSIR links in
    helptext = strrep(helptext, 'dgriffith@csir.co.za', '<A href = "mailto:dgriffith@csir.co.za">Derek Griffith</A>');
    helptext = strrep(helptext, 'CSIR', '<A href = "http://www.csir.co.za">CSIR</A>');
    helptext = strrep(helptext, 'COPYING', '<A href = "../COPYING.html">COPYING</A>');
    % helptext = strrep(helptext, 'ZEMAX', '<A href = "http://www.zemax.com">ZEMAX</A>');
    helptext = strrep(helptext, 'Matlab', '<A href = "http://www.mathworks.com">Matlab</A>');
    
    
    % do a search and replace on all the names is the help text, and insert a link
    for j = 2:length(mnames)
        helptext = strrep(helptext, [' ' mnames(j).name ' '], [' <a href = "#' mnames(j).name '">' mnames(j).name '</a> ']);
        helptext = strrep(helptext, [' ' mnames(j).name ','], [' <a href = "#' mnames(j).name '">' mnames(j).name '</a>,']);
        helptext = strrep(helptext, [' ' mnames(j).name '.'], [' <a href = "#' mnames(j).name '">' mnames(j).name '</a>.']);
        helptext = strrep(helptext, [' ' mnames(j).name ')'], [' <a href = "#' mnames(j).name '">' mnames(j).name '</a>)']);
        helptext = strrep(helptext, [' ' mnames(j).name char(10)], [' <a href = "#' mnames(j).name '">' mnames(j).name '</a>' char(10)]);
    end
    fprintf(docfid,'<PRE>\n');    
    fprintf(docfid, helptext);
    fprintf(docfid,'</PRE>\n');
    fprintf(docfid,'</P>\n');
end

fprintf(docfid, '</body>\n</html>\n');
fclose(docfid);
