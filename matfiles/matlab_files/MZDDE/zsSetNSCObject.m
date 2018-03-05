function Success = zsSetNSCObject(SurfaceNumber, ObjectNumber, ObjectData)
% zsSetNSCObject - Sets NSC Object data from a structure.
%
% Usage : Success = zsSetNSCObject(SurfaceNumber, ObjectNumber, ObjectData)
%
% SurfaceNumber is the sequential surface number containing NSC objects (0 if in full non-sequential
% mode). ObjectNumber is the number of the NSC object to set data on. The ObjectData must be a struct
% with any number of the following fields. ObjectData can also be an array of objects, in which case
% ObjectNumber is the starting object number.
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
% Always assign the type field first when creating the structure.
%
% To set the position, rotation and material of the NSC object one can also use zSetNSCPosition.
%
% It is very easy to generate an object that is out or partly out of the non-sequential space or overlaps with another object.
% These cases will generate errors.
%
% The returned value is 0 if the object was altered successfully or -1 if a problem was encountered. 
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

fnames = fieldnames(ObjectData);
i = 0;
for ObjectNum = ObjectNumber:(ObjectNumber + length(ObjectData) - 1)  
  i = i + 1;  
  for fname = 1:length(fnames)
      switch (char(fnames(fname)))
          case 'type'
              zSetNSCObjectData(SurfaceNumber, ObjectNum, 0, ObjectData(i).type);
          case 'comment'
              zSetNSCObjectData(SurfaceNumber, ObjectNum, 1, ObjectData(i).comment);
          case 'color'
              zSetNSCObjectData(SurfaceNumber, ObjectNum, 2, ObjectData(i).color);
          case 'userap'
              zSetNSCObjectData(SurfaceNumber, ObjectNum, 3, ObjectData(i).userap);
          case 'apfile'
              zSetNSCObjectData(SurfaceNumber, ObjectNum, 4, ObjectData(i).apfile);
          case 'refobj'
              zSetNSCObjectData(SurfaceNumber, ObjectNum, 5, ObjectData(i).refobj);
          case 'inobj'
              zSetNSCObjectData(SurfaceNumber, ObjectNum, 6, ObjectData(i).inobj);
          case 'pos'
              zSetNSCPosition(SurfaceNumber, ObjectNum, 1, ObjectData(i).pos(1));
              zSetNSCPosition(SurfaceNumber, ObjectNum, 2, ObjectData(i).pos(2));
              zSetNSCPosition(SurfaceNumber, ObjectNum, 3, ObjectData(i).pos(3));
          case 'tilts'
              zSetNSCPosition(SurfaceNumber, ObjectNum, 4, ObjectData(i).tilts(1));
              zSetNSCPosition(SurfaceNumber, ObjectNum, 5, ObjectData(i).tilts(2));
              zSetNSCPosition(SurfaceNumber, ObjectNum, 6, ObjectData(i).tilts(3));
          case 'material'
              zSetNSCPosition(SurfaceNumber, ObjectNum, 7, upper(ObjectData(i).material));
          case 'params'
              for ParamNumber = 1:length(ObjectData(i).params)
                  zSetNSCParameter(SurfaceNumber, ObjectNum, ParamNumber, ObjectData(i).params(ParamNumber));
              end
          otherwise
              disp(['Unrecognised field : ' fname]);
              Success = -1;
      end
  end
end



