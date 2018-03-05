function NSCData = zsGetAllNSCData(SurfaceNumber, ObjectNumber)
% zsGetAllNSCData : Get all spreadsheet data defining an NSC object in a structure.
%
% Usage :
%  >> NSCData = zsGetAllNSCData(SurfaceNumber, ObjectNumber)
%   or
%  >> NSCData = zsGetAllNSCData(SurfaceNumber)
%
% Where SurfaceNumber is the surface number and ObjectNumber is the
% object number of the NSC object for which the data is desired.
% If ObjectNumber is not given, then data for all NSC objects
% at the given surface are returned in a vector structure.
% ObjectNumber can also be a vector of object numbers.
%
% NSCData is a structure returned with the following fields
%  Type     - Object type name. (string)
%  Comment  - a comment which also defines the file name if the object is 
%               defined by a file. (string)
%  Color    - color number (integer)
%  UserAper - 1 if object uses a user defined aperture file, 0 otherwise. (integer)
%  UserAperFile - User aperture file name, if any. (string)
%  RefObj    - Reference object number. (integer)
%  InsideObj - Inside of object number. (integer)
%  x - x position of object relative to the reference object.
%  y - y position of object relative to the reference object.
%  z - z position of object relative to the reference object.
%  xTilt - Rotation of object about x-axis relative to the reference object.
%  yTilt - Rotation of object about y-axis relative to the reference object.
%  zTilt - Rotation of object about z-axis relative to the reference object.
%  Material - Material of object (string)
%  Parms - Vector of parameters defining additional object characteristics.
%  RotMat - The global rotation matrix of the object. See zGetNSCMatrix.
%  GlobalPos - The global position of the object as a column vector.
%
% See also : zSetAllNSCData

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

iSurfCounter = 1;
iObjectCounter = 1;
for iSurf = SurfaceNumber
    NumObjects = zGetNSCData(iSurf, 0); % Get the number of objects at the surface
    if isempty(NumObjects)
        error('zGetAllNSCData::BadSurfNumber',['No NSC objects at surface number ' num2str(iSurf)])
    end
    if ~exist('ObjectNumber', 'var')
        ObjectNumber = 1:NumObjects; % Get Data for all objects
    else
        if ~isnumeric(ObjectNumber) || ~isvector(ObjectNumber)
            error('zGetAllNSCData::BadObjectNumber','ObjectNumber input must be vector numeric.')
        end
    end
    if ~all(ObjectNumber <= NumObjects)
        error('zGetAllNSCData::BadObjectNumber','One or more object numbers exceed number of existing objects.')
    end
    for iObject = ObjectNumber
        Data.Type = zGetNSCObjectData(iSurf, iObject, 0); 
        Data.Comment = zGetNSCObjectData(iSurf, iObject, 1);
        Data.Color = zGetNSCObjectData(iSurf, iObject, 2);
        Data.UserAper = zGetNSCObjectData(iSurf, iObject, 3);
        Data.UserAperFile = zGetNSCObjectData(iSurf, iObject, 4);
        Data.RefObj = zGetNSCObjectData(iSurf, iObject, 5);
        Data.InsideObj = zGetNSCObjectData(iSurf, iObject, 6);
        [PosData, Material] = zGetNSCPosition(iSurf, iObject);
        Data.x = PosData(1);
        Data.y = PosData(2);
        Data.z = PosData(3);
        Data.xTilt = PosData(4);
        Data.yTilt = PosData(5);
        Data.zTilt = PosData(6);
        Data.Material = Material;
        iParm = 1;
        Parm = zGetNSCParameter(iSurf, iObject, 1);
        Parms = [];
        while ~isempty(Parm)
            Parms(iParm) = Parm;
            iParm = iParm + 1;
            Parm = zGetNSCParameter(iSurf, iObject, iParm);
        end
        Data.Parms = Parms;
        [Data.RotMat, Data.GlobalPos] = zGetNSCMatrix(iSurf, iObject);
        NSCData(iSurfCounter, iObjectCounter) = Data;
        iObjectCounter = iObjectCounter + 1;
    end
    iSurfCounter = iSurfCounter + 1;
end
