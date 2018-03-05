function ObjectDatum = zGetNSCObjectData(Surface, Object, Code)
% zGetNSCObjectData - Requests various data for NSC objects from the ZEMAX DDE server.
%
% Usage : Datum = zGetNSCObjectData(Surface, Object, Code);
%
% Surface and Object refer to the surface number and object number. The Code is one of the integer values in the
% list below; the returned value is the data item indicated. 
%
% Code  -   Data returned
%  0    -   Object type name. (string)
%  1    -   Comment, which also defines the file name if the object is defined by a file. (string)
%  2    -   Color. (integer)
%  3    -   1 if object uses a user defined aperture file, 0 otherwise. (integer)
%  4    -   User defined aperture file name, if any. (string)
%  5    -   Reference object number. (integer)
%  6    -   Inside of object number. (integer)
%
% The following codes get values on the Sources tab of the Object Properties dialog.
%  101 Gets the source object random polarization. 1 is for checked, 0 for unchecked.
%  102 Gets the source object reverse rays option. 1 is for checked, 0 for unchecked.
%  103 Gets the source object Jones X value.
%  104 Gets the source object Jones Y value.
%  105 Gets the source object Phase X value.
%  106 Gets the source object Phase Y value.
%  107 Gets the source object initial phase in degrees value.
%  108 Gets the source object coherence length value.
%  109 Gets the source object pre-propagation value.
%  110 Gets the source object sampling method; 0 for random, 1 for Sobol sampling.
%
% See also zSetNSCObjectData, zSetNSCPosition
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
DDECommand = sprintf('GetNSCObjectData,%i,%i,%i', Surface, Object, Code);
Reply = ddereq(ZemaxDDEChannel, DDECommand, [1 1], ZemaxDDETimeout);
% Decide whether to return string or numeric datum
ObjectDatum = [];
switch Code
  case {0, 1, 4}, ObjectDatum = strtrim(Reply); % string replies
  case {2, 3, 5, 6}, [ObjectDatum, count, errmsg] = sscanf(Reply, '%f');
  case {101, 102, 103, 104, 105, 106, 107, 108, 109, 110}
        [ObjectDatum, count, errmsg] = sscanf(Reply, '%f');
end


