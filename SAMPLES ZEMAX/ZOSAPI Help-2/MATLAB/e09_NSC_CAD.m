function [ r ] = MATLABStandalone_NSC_CAD( args )

if ~exist('args', 'var')
    args = [];
end

% Initialize the OpticStudio connection
TheApplication = InitConnection();
if isempty(TheApplication)
    % failed to initialize a connection
    r = [];
else
    try
        r = BeginApplication(TheApplication, args);
        CleanupConnection(TheApplication);
    catch err
        CleanupConnection(TheApplication);
        rethrow(err);
    end
end
end


function [r] = BeginApplication(TheApplication, args)

import ZOSAPI.*;
    
    % creates a new API directory
    apiPath = System.String.Concat(TheApplication.SamplesDir, '\API\Matlab');
    if (exist(char(apiPath),'dir') == 0); mkdir(char(apiPath)); end;
    
    %! [e09s01_m]
    % Open new NS system and save
    TheSystem = TheApplication.CreateNewSystem(ZOSAPI.SystemType.NonSequential);    % Create New NSC File
    filename = System.String.Concat(TheApplication.SamplesDir, '\API\Matlab\e09_NSC_CAD.zmx');   % Define file path and name
    TheSystem.SaveAs(filename);  % Save New NSC File
    %! [e09s01_m]
    
    %! [e09s02_m]
    % Insert CAD object
    NSCE = TheSystem.NCE;
    Obj1 = NSCE.GetObjectAt(1);
    Obj1.ZPosition = -5;
    Obj1_Type = Obj1.GetObjectTypeSettings(ZOSAPI.Editors.NCE.ObjectType.CADPartSTEPIGESSAT);  % create CAD object type
    % print(Obj1_Type.GetFileNames1())  % return names of valid solidworks part files in proper directory
    % Set object 1 as CAD object if CAD file exists in proper directory
    if exist(char(System.String.Concat(TheApplication.ObjectsDir, '\\CAD Files\\ExtPoly.stp')), 'file')  % Check if the CAD part exists in correct directory
        Obj1_Type.FileName1 = 'ExtPoly.stp';  % set CAD file to be used (file must be in valid directory)
        Obj1.ChangeType(Obj1_Type);  % Set Object 1 as the previously specified CAD file
    else
        HandleError('ImportError("CAD file not found")');
    end
    %! [e09s02_m]
    
    %! [e09s03_m]
    % Expose CAD parts in NS Component Editor
    Obj1_CAD = Obj1.CADData;  % Retrieve CAD data
    if Obj1_CAD.IsCADAvailable
        Obj1_CAD.SurfaceTolerance = 2;  % Set surface tolerance (2 corresponds to 10^-6 lens units)
        Obj1_CAD.SetAllPartsExposed(true);  % expose all CAD parameters in NS Component Editor
        % Show all available parameters (should show exposed CAD parameters)
        fprintf('Available Parameters:\n%s\n', strjoin(cell(Obj1.AvailableParameters()), ', '));
    end
    %! [e09s03_m]
    
    %! [e09s04_m]
    % Change Face Values of CAD part
    if Obj1_CAD.HasFaceData
        Obj1_CAD.FaceMode = 1;  % Set face mode to "Use Angles of Normal Vectors"
        Obj1_CAD.FaceAngle = 3.1415;  % Change setting for face mode
        if Obj1_CAD.NumberOfSurfaces > 1
            Obj1_CAD.SetSurfaceFace(0, Obj1_CAD.NumberOfSurfaces-1);  % set face 0 to the last surface (combine 2 faces)
        end
    end
    
    %! [e09s04_m]
    
    
    %! [e09s05_m]
    POBfile = fopen(char(System.String.Concat(TheApplication.ObjectsDir, '\\Polygon Objects\\API_cube_demo.POB')), 'w'); % Open new POB file
    % Append new POB file with polygon definitions (see help files for syntax information)
    fprintf(POBfile, '! A cube\n'); 
    fprintf(POBfile, '! front face vertices\nV 1 -1 -1 0\nV 2 1 -1 0\nV 3 1 1 0\nV 4 -1 1 0\n');
    fprintf(POBfile, '! back face vertices\nV 5 -1 -1 2\nV 6 1 -1 2\nV 7 1 1 2\nV 8 -1 1 2\n');
    fprintf(POBfile, '! Front\nR 1 2 3 4 0 0\n! Back\nR 5 6 7 8 0 0\n');
    fprintf(POBfile, '! Top\nR 4 3 7 8 0 0\n! Bottom\nR 1 2 6 5 0 0\n');
    fprintf(POBfile, '! Left Side\nR 1 4 8 5 0 0\n! Right Side\nR 2 3 7 6 0 0');
    fclose(POBfile);
    Obj2 = NSCE.InsertNewObjectAt(2);  % Add new line to NSCE
    Obj2_Type = Obj2.GetObjectTypeSettings(ZOSAPI.Editors.NCE.ObjectType.PolygonObject);
    Obj2_Type.FileName1 = 'API_cube_demo.POB';
    Obj2.ChangeType(Obj2_Type);
    %! [e09s05_m]
    
    % opens 3d layout
    TheSystem.Analyses.New_Analysis(ZOSAPI.Analysis.AnalysisIDM.NSC3DLayout);
    TheSystem.Save(); % Save New NSC File
    
    r = [];
end

function app = InitConnection()

import System.Reflection.*;

% Find the installed version of OpticStudio.

% This method assumes the helper dll is in the .m file directory.
% p = mfilename('fullpath');
% [path] = fileparts(p);
% p = strcat(path, '\', 'ZOSAPI_NetHelper.dll' );
% NET.addAssembly(p);

% This uses a hard-coded path to OpticStudio
NET.addAssembly('C:\Program Files\Zemax OpticStudio\ZOS-API\Libraries\ZOSAPI_NetHelper.dll');

success = ZOSAPI_NetHelper.ZOSAPI_Initializer.Initialize();
% Note -- uncomment the following line to use a custom initialization path
% success = ZOSAPI_NetHelper.ZOSAPI_Initializer.Initialize('C:\Program Files\OpticStudio\');
if success == 1
    LogMessage(strcat('Found OpticStudio at: ', char(ZOSAPI_NetHelper.ZOSAPI_Initializer.GetZemaxDirectory())));
else
    app = [];
    return;
end

% Now load the ZOS-API assemblies
NET.addAssembly(AssemblyName('ZOSAPI_Interfaces'));
NET.addAssembly(AssemblyName('ZOSAPI'));

% Create the initial connection class
TheConnection = ZOSAPI.ZOSAPI_Connection();

% Attempt to create a Standalone connection

% NOTE - if this fails with a message like 'Unable to load one or more of
% the requested types', it is usually caused by try to connect to a 32-bit
% version of OpticStudio from a 64-bit version of MATLAB (or vice-versa).
% This is an issue with how MATLAB interfaces with .NET, and the only
% current workaround is to use 32- or 64-bit versions of both applications.
app = TheConnection.CreateNewApplication();
if isempty(app)
   HandleError('An unknown connection error occurred!');
end
if ~app.IsValidLicenseForAPI
    HandleError('License check failed!');
    app = [];
end

end

function LogMessage(msg)
disp(msg);
end

function HandleError(error)
ME = MXException(error);
throw(ME);
end

function  CleanupConnection(TheApplication)
% Note - this will close down the connection.

% If you want to keep the application open, you should skip this step
% and store the instance somewhere instead.
TheApplication.CloseApplication();
end


