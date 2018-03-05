function Status = zDeleteObject(SurfaceNumber, ObjectNumber)
% zDeleteObject - Delete an NSC Object in the ZEMAX DDE server.
%
% Usage : Status = zDeleteObject(SurfaceNumber, ObjectNumber)
%   Deletes the NSC object at the given surface and object number.
% See also zSetNSCObjectData to define data for the new object.
% If the lens is fully NSC mode, then the SurfaceNumber is 1.
%
% See also zInsertObject
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

global ZemaxDDEChannel ZemaxDDETimeout
DDECommand = sprintf('DeleteObject,%i,%i',SurfaceNumber,ObjectNumber);
Status = ddereq(ZemaxDDEChannel, DDECommand, [1 1], ZemaxDDETimeout);

