function NSCObjectData = zsSetNSCObject(SurfaceNumber, ObjectNumber, ObjectData)
% zsSetNSCObject - Sets NSC Object data from a structure.
%
% Usage : NSCObjectData = zsSetNSCObject(SurfaceNumber, ObjectNumber, ObjectData)
%
% SurfaceNumber is the sequential surface number containing NSC objects (0 if in full non-sequential
% mode). ObjectNumber is the number of the NSC object to set data on. The ObjectData must be a struct
% with any number of the following fields.
%
% Field Name  -   Datum
%  type       -   Object type name. (string)
%  comment    -   Comment, which also defines the file name if the object is defined by a file. (string)
%  color      -   Color. (integer)
%  userap     -   1 if object uses a user defined aperture file, 0 otherwise. (integer)
%  apfile     -   User defined aperture file name, if any. (string)
%  refobj     -   Reference object number. (integer)
%  inobj      -   Inside of object number. (integer)
%  pos        -   Vector containing the x, y and z coordinates of the object
%  tilts      -   Vector containing tilts of the object about the x, y and z axes in degrees.
%  material   -   Name of the material of which the object consists.
%  params     -   Vector of object parameters to set.
%
% To set the position, rotation and material of the NSC object, use zSetNSCPosition.
%
% The returned value is just the Datum.
%
% See also : zGetNSCObjectData, zSetNSCPosition
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




