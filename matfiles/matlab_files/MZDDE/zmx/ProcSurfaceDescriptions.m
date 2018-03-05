% Read and process zemax surface types

% The file ManualSurfaceTypes.csv was obtained by editing text copied from the ZEMAX manual
fid=fopen('ManualSurfaceTypes.csv');

lin = fgetl(fid);
i = 1;
while ~feof(fid)
    disp(lin);
    k = findstr(lin, ',')
    stype{i,2} = lin(1:(k(1)-1));
    if length(k)>1
        for j = 2:length(k)
            lin(k(j)) = ' ';
        end
    end
    stype{i,3} = lin((k(1)+1):end);
    i = i+1;
    lin = fgetl(fid);
end
fclose(fid);

fid = fopen('ZemaxSurfTypes.csv','w');
for i =1:size(stype,1)
    fprintf(fid,'%s,%s,%s\r',stype{i,1},stype{i,2},stype{i,3});
end
fclose(fid);

% After the ZemaxSurfTypes.csv file is written by thos routine, it must be edited manually to make sure the data is properly
% aligned.

% Thereafter, run the routine GenZemaxSurfTypes.m to get the final help file for ZEMAX surface types (ZemaxSurfTypes.m)
% GenZemaxSurfTypes.m reads the edited ZemaxSurfTypescsv and writes the final ZemaxSurfTypes.m routine.
