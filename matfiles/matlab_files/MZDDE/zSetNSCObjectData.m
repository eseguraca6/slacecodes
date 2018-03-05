function NSCObjectDatum = zSetNSCObjectData(SurfaceNumber, ObjectNumber, ItemCode, Datum)
% zSetNSCObjectData - Sets one of the NSC data items in the NSC data editor.
%
% Usage : NSCObjectDatum = zSetNSCObjectData(SurfaceNumber, ObjectNumber, ItemCode, Datum)
% SurfaceNumber is the sequential surface number containing NSC objects (0 if in full non-sequential
% mode). ObjectNumber is the number of the NSC object to set a data item on, ItemCode is one of the
% following codes and Datum is the value to which the item should be set. Ensure that the Datum has
% the correct type as per the table.
%
% Code  -   Datum to be set
%  0    -   Object type name. (string)
%  1    -   Comment, which also defines the file name if the object is defined by a file. (string)
%  2    -   Color. (integer)
%  3    -   1 if object uses a user defined aperture file, 0 otherwise. (integer)
%  4    -   User defined aperture file name, if any. (string)
%  5    -   Reference object number. (integer)
%  6    -   Inside of object number. (integer)
%
% The following codes set values on the Sources tab of the Object Properties dialog.
%  101 Sets the source object random polarization. Use 1 for checked, 0 for unchecked.
%  102 Sets the source object reverse rays option. Use 1 for checked, 0 for unchecked.
%  103 Sets the source object Jones X value.
%  104 Sets the source object Jones Y value.
%  105 Sets the source object Phase X value.
%  106 Sets the source object Phase Y value.
%  107 Sets the source object initial phase in degrees value.
%  108 Sets the source object coherence length value.
%  109 Sets the source object pre-propagation value.
%  110 Sets the source object sampling method; 0 for random, 1 for Sobol sampling.
%
% To set the position, rotation and material of the NSC object, use zSetNSCPosition.
%
% The returned value is just the Datum as returned in zGetNSCObjectData.
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

global ZemaxDDEChannel ZemaxDDETimeout
% Decide whether item is string or numeric - should check that the user has sent the right thing
switch ItemCode
  case {0, 1, 4},    DDECommand = sprintf('SetNSCObjectData,%i,%i,%i,%s', SurfaceNumber, ObjectNumber, ItemCode, Datum);
  case {2, 3, 5, 6}, DDECommand = sprintf('SetNSCObjectData,%i,%i,%i,%1.20g', SurfaceNumber, ObjectNumber, ItemCode, Datum);
  case {101, 102, 103, 104, 105, 106, 107, 108, 109, 110}
      DDECommand = sprintf('SetNSCObjectData,%i,%i,%i,%1.20g', SurfaceNumber, ObjectNumber, ItemCode, Datum);     
end
Reply = ddereq(ZemaxDDEChannel, DDECommand, [1 1], ZemaxDDETimeout);
% Decide whether to return string or numeric datum
NSCObjectDatum = [];
switch ItemCode
  case {0, 1, 4}, NSCObjectDatum = Reply;
  case {2, 3, 5, 6}, [NSCObjectDatum, count, errmsg] = sscanf(Reply, '%f');
  case {101, 102, 103, 104, 105, 106, 107, 108, 109, 110}
        [ObjectDatum, count, errmsg] = sscanf(Reply, '%f');      
end


