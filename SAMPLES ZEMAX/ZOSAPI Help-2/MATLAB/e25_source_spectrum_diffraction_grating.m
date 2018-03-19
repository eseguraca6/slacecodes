function [ r ] = MATLABStandalone_source_spectrum_diffraction_grating( args )

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
    if (exist(char(apiPath)) == 0) mkdir(char(apiPath)); end;
    
    % Set up primary optical system
    TheSystem = TheApplication.PrimarySystem;
    ZemaxDataDir = TheApplication.ZemaxDataDir;
    testFile = System.String.Concat(ZemaxDataDir, '\Samples\API\Python\e25_source_spectrum_diffraction_grating.zmx');
    TheSystem.LoadFile(testFile,false);
    
    x_width = 1.5;
    y_width = 1.5;
    x_pixel = 500;
    y_pixel = 500;
        
    % Setup and run the ray trace
    NSCRayTrace = TheSystem.Tools.OpenNSCRayTrace();
    NSCRayTrace.ClearDetectors(0);
    NSCRayTrace.SplitNSCRays = false;
    NSCRayTrace.ScatterNSCRays = false;
    NSCRayTrace.UsePolarization = false;
    NSCRayTrace.IgnoreErrors = true;
    NSCRayTrace.SaveRays = true;
    NSCRayTrace.SaveRaysFile = 'Color_translator_RGB.ZRD';
    NSCRayTrace.RunAndWaitForCompletion();
    NSCRayTrace.Close();
    fprintf('Finished ray trace\n');

    %! [e25s06_m]
    % Creates a new detector viewer window, changes to true color
    det = TheSystem.Analyses.New_Analysis(ZOSAPI.Analysis.AnalysisIDM.DetectorViewer);
    det_settings = det.GetSettings();
    det_settings.ShowAs = ZOSAPI.Analysis.DetectorViewerShowAsTypes.TrueColor;
    det.ApplyAndWaitForCompletion();
    %! [e25s06_m]

    % Creates System.Single[] buffers to store pixel data
    rData = NET.createArray('System.Single', (x_pixel * y_pixel));
    gData = NET.createArray('System.Single', (x_pixel * y_pixel));
    bData = NET.createArray('System.Single', (x_pixel * y_pixel));

    %! [e25s07_m]
    % Loads RGB data into System.Single buffer
    det_raw = det.GetResults().DataGridsRgb.Get(0);
    det_raw.FillValues((x_pixel * y_pixel), rData, gData, bData);
    %! [e25s07_m]

    % Converts buffer to RGB array; rotates & resizes RGB array
    dData = zeros(y_pixel, x_pixel, 3) - 1;
    dData(:,:,1) = rot90(reshape(rData.double ./ 255, x_pixel, y_pixel));
    dData(:,:,2) = rot90(reshape(gData.double ./ 255, x_pixel, y_pixel));
    dData(:,:,3) = rot90(reshape(bData.double ./ 255, x_pixel, y_pixel));

    % Plots detector color values
    % subplot(1, double(TheMCE.NumberOfConfigurations), double(1))
    imagesc(dData,'X',[-x_width x_width],'Y',[-y_width y_width]);
    axis equal tight;colormap('jet');
    str = sprintf('Config = %i',1);
    title(str);
    
    
    

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
NET.addAssembly('C:\Users\zachary.Derocher\Documents\Zemax\ZOS-API\Libraries\ZOSAPI_NetHelper.dll');

% success = ZOSAPI_NetHelper.ZOSAPI_Initializer.Initialize();
% Note -- uncomment the following line to use a custom initialization path
success = ZOSAPI_NetHelper.ZOSAPI_Initializer.Initialize('C:\Program Files\Zemax OpticStudio 17 Alpha 2017_07_10\');
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


