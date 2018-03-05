function Status = zSetNSCNull(SurfaceNumber, FirstObject, LastObject)
% zSetNSCNull - Sets NSC objects to the Null Object at specified surface
%
% Usage : Status = zSetNSCNull(SurfaceNumber, FirstObject, LastObject)
%
% Sets the NSC objects FirstObject through to LastObject at the surface SurfaceNumber to
% be the 'Null Object'
%
% 
% Returns a status of 0 if successfull or -1 if not all objects could be set.

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

Status = 0;
for ObjectNumber = FirstObject:LastObject
    NSCObjectDatum = zSetNSCObjectData(SurfaceNumber, ObjectNumber, 0, 'Null Object');
    if strncmp(NSCObjectDatum, 'BAD COMMAND', 11)
        Status = -1;
    end
end

