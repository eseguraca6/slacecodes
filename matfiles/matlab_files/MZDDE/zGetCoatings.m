function CoatingList = zGetCoatings()
% zGetCoatings - Get a list of available coatings from the ZEMAX coatings.dat file
%
% Usage : CoatingList = zGetCoatings
%
% Returns a cell array of all available coatings in the coatings.dat file.
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

[ZEMAXPath, LensPath] = zGetPath;
CoatingFile = [ZEMAXPath '\Coatings\COATING.DAT'];
CoatingFID = fopen(CoatingFile, 'rt');
Count = 0;
while 1
    tline = fgetl(CoatingFID);
    if ~ischar(tline), break, end
    [Token, Rest] = strtok(tline, ' ');
    if (strcmp(upper(Token),'COAT'))
        Count = Count+1;
        Token = strtok(Rest, ' ');
        CoatingList{Count} = Token;
    end
end
fclose(CoatingFID);
CoatingList = CoatingList';
