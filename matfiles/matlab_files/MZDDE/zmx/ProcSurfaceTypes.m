% Reads ZEMAX model with all surface types and extracts the surface type codes.
fid = fopen('AllSurfaceTypes.zmx');

lin = fgetl(fid);
i = 1;
while ~feof(fid)
    
    lin = fgetl(fid);
    [A,count] = sscanf(lin, ' TYPE %s');
    if count==1
        disp(A);
        stype{i,1} = A;
        i = i+1;
    end
end
