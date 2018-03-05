function BIMwrite(image, BIMfilename)
% BIMwrite - write ZEMAX format BIM file from a double image array.
%
% Usage : BIMWrite(Image, BIMfilename);
%
% Writes ZEMAX style BIM image to the given file. The .bim file extension will be appended.
% See Geometric Image Analysis in the Analysis Menu chapter of the ZEMAX Manual.
% Currently ZEMAX only supports BIM files generated from square image arrays.

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

fid = fopen([BIMfilename '.bim'], 'wb');
if fid == -1
    disp(['Unable to open file ' BIMfilename '.bim']);
else
    fwrite(fid, uint32(size(image,2)), 'uint32');
    fwrite(fid, uint32(size(image,1)), 'uint32');
    fwrite(fid, double(image), 'double');
end
fclose(fid);

