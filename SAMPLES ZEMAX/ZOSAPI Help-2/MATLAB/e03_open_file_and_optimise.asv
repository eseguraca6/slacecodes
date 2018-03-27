function [ r ] = MATLABStandalone_open_file_and_optimise( args )

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
    %apiPath = System.String.Concat(TheApplication.SamplesDir, '\API\Matlab');
    %if (exist(char(apiPath)) == 0) mkdir(char(apiPath)); end;
    
    % Set up primary optical system
    TheSystem = TheApplication.PrimarySystem;
    %sampleDir = TheApplication.SamplesDir;
    
    %! [e03s01_m]
    % Open file
    testFile = "C:\Users\pwfa-facet2\Desktop\slacecodes\centroid_test.zmx";
    %System.String.Concat(sampleDir, '\API\Matlab\e01_new_file_and_quickfocus.zmx');
    if (exist(char(testFile)) == 0)
        fprintf('You need to run Example 01 before running this example\n');
        r = [];
        return;
    end
    TheSystem.LoadFile(testFile,false);

    %! [e03s01_m]
    
    %! [e03s02_m]
    % Get Surfaces
    TheLDE = TheSystem.LDE;
    %Surface_1 = TheLDE.GetSurfaceAt(1);
    %Surface_2 = TheLDE.GetSurfaceAt(2);
    %Surface_3 = TheLDE.GetSurfaceAt(3);
    %! [e03s02_m]
    
    %! [e03s03_m]
    % Make thicknesses and radii variable
    %Surface_1.ThicknessCell.MakeSolveVariable();
    %Surface_2.ThicknessCell.MakeSolveVariable();
    %Surface_2.RadiusCell.MakeSolveVariable();
    %Surface_3.ThicknessCell.MakeSolveVariable();
    %! [e03s03_m]
    
   
    % Save and close
    TheSystem.Save();
    
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


