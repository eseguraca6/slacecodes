function Status = zInsertObject(SurfaceNumber, ObjectNumber)
% zInsertObject - Insert a NULL NSC Object in the ZEMAX DDE server.
%
% Usage : Status = zInsertObject(SurfaceNumber, ObjectNumber)
% The new null object will be placed at the location indicated by the parameters 
%  SurfaceNumber and ObjectNumber.
% See also zSetNSCObjectData to define data for the new object.
% If the lens is fully NSC mode, then the SurfaceNumber is 1.
%
% See also zDeleteObject
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
DDECommand = sprintf('InsertObject,%i,%i',SurfaceNumber,ObjectNumber);
Status = ddereq(ZemaxDDEChannel, DDECommand, [1 1], ZemaxDDETimeout);

