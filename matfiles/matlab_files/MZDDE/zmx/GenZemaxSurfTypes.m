% Generates the file ZemaxSurfTypes.m, which lists all the ZEMAX Surface types.

fin = fopen('ZemaxSurfTypes.csv');

lin = fgetl(fin);
clear stype
i=1;
while ~feof(fin)
    disp(lin);
    k = findstr(lin, ',');
    if length(k)~=2
        error('3 Commas not found');
    end
    stype{i,1} = lin(1:(k(1)-1));
    stype{i,2} = lin((k(1)+1):(k(2)-1));
    stype{i,3} = lin((k(2)+1):end);
    i = i+1;
    lin = fgetl(fin);
end
fclose(fin);
% Now write the output

fout = fopen('ZemaxSurfTypes.m','w');

% first the help text

fprintf(fout,'%% ZEMAX Surface Types : Generates List of Surface Type Codes and Descriptions\r%%\r');
fprintf(fout,'%% Usage : ZemaxSurfTypes\r%%\r')
fprintf(fout,'%% Creates a cell array called stype with the ZEMAX surface type codes and descriptions.\r%%\r')

for i=1:size(stype,1)
    blk = blanks(30-length(stype{i,2}));
    fprintf(fout, '%% %s %s%s%s\r', stype{i,1},stype{i,2},blk,stype{i,3});
end
fprintf(fout,'%%\r%% See Also : zSetSurfaceData and zGetSurfaceData\r');

% then the damn licence and stuff

fprintf(fout,'\r%% MZDDE - The ZEMAX DDE and Optronics Toolbox for Matlab.\r');
fprintf(fout,'%% Copyright (C) 2002-2009 DPSS, CSIR\r');
fprintf(fout,'%% Contact : dgriffith@csir.co.za\r');
fprintf(fout,'%% This file is subject to the conditions of the BSD Licence.\r'); 
fprintf(fout,'%% For further details, see the file BSDlicence.txt\r');
fprintf(fout,'%%\r');


% Lastly the code to set the cell array
fprintf(fout,'stype = {...\r')
for i = 1:size(stype,1)
    blk = blanks(30-length(stype{i,2}));
    fprintf(fout, '''%s'' ''%s''%s''%s'';...\r', stype{i,1},stype{i,2},blk,stype{i,3});
end
fprintf(fout,'}\r')
fclose(fout);
