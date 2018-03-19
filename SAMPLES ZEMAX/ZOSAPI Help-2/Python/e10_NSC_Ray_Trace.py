from win32com.client.gencache import EnsureDispatch, EnsureModule
from win32com.client import CastTo, constants
import os

# Notes
#
# The python project and script was tested with the following tools:
#       Python 3.4.3 for Windows (32-bit) (https://www.python.org/downloads/) - Python interpreter
#       Python for Windows Extensions (32-bit, Python 3.4) (http://sourceforge.net/projects/pywin32/) - for COM support
#       Microsoft Visual Studio Express 2013 for Windows Desktop (https://www.visualstudio.com/en-us/products/visual-studio-express-vs.aspx) - easy-to-use IDE
#       Python Tools for Visual Studio (https://pytools.codeplex.com/) - integration into Visual Studio
#
# Note that Visual Studio and Python Tools make development easier, however this python script should should run without either installed.

class PythonStandaloneApplication(object):
    class LicenseException(Exception):
        pass

    class ConnectionException(Exception):
        pass

    class InitializationException(Exception):
        pass

    class SystemNotPresentException(Exception):
        pass

    def __init__(self):
        # make sure the Python wrappers are available for the COM client and
        # interfaces
        EnsureModule('ZOSAPI_Interfaces', 0, 1, 0)
        # Note - the above can also be accomplished using 'makepy.py' in the
        # following directory:
        #      {PythonEnv}\Lib\site-packages\wind32com\client\
        # Also note that the generate wrappers do not get refreshed when the
        # COM library changes.
        # To refresh the wrappers, you can manually delete everything in the
        # cache directory:
        #	   {PythonEnv}\Lib\site-packages\win32com\gen_py\*.*
        
        self.TheConnection = EnsureDispatch("ZOSAPI.ZOSAPI_Connection")
        if self.TheConnection is None:
            raise PythonStandaloneApplication.ConnectionException("Unable to intialize COM connection to ZOSAPI")

        self.TheApplication = self.TheConnection.CreateNewApplication()
        if self.TheApplication is None:
            raise PythonStandaloneApplication.InitializationException("Unable to acquire ZOSAPI application")

        if self.TheApplication.IsValidLicenseForAPI == False:
            raise PythonStandaloneApplication.LicenseException("License is not valid for ZOSAPI use")

        self.TheSystem = self.TheApplication.PrimarySystem
        if self.TheSystem is None:
            raise PythonStandaloneApplication.SystemNotPresentException("Unable to acquire Primary system")

    def __del__(self):
        if self.TheApplication is not None:
            self.TheApplication.CloseApplication()
            self.TheApplication = None

        self.TheConnection = None

    def OpenFile(self, filepath, saveIfNeeded):
        if self.TheSystem is None:
            raise PythonStandaloneApplication.SystemNotPresentException("Unable to acquire Primary system")
        self.TheSystem.LoadFile(filepath, saveIfNeeded)

    def CloseFile(self, save):
        if self.TheSystem is None:
            raise PythonStandaloneApplication.SystemNotPresentException("Unable to acquire Primary system")
        self.TheSystem.Close(save)

    def SamplesDir(self):
        if self.TheApplication is None:
            raise PythonStandaloneApplication.InitializationException("Unable to acquire ZOSAPI application")

        return self.TheApplication.SamplesDir

    def ExampleConstants(self):
        if self.TheApplication.LicenseStatus is constants.LicenseStatusType_PremiumEdition:
            return "Premium"
        elif self.TheApplication.LicenseStatus is constants.LicenseStatusType_ProfessionalEdition:
            return "Professional"
        elif self.TheApplication.LicenseStatus is constants.LicenseStatusType_StandardEdition:
            return "Standard"
        else:
            return "Invalid"


if __name__ == '__main__':
    zosapi = PythonStandaloneApplication()
    value = zosapi.ExampleConstants()

    if not os.path.exists(zosapi.TheApplication.SamplesDir + "\\API\\Python"):
        os.makedirs(zosapi.TheApplication.SamplesDir + "\\API\\Python")

    TheSystem = zosapi.TheSystem

    #! [e10s01_py]
    # Open File, Save to New Name
    file = "\\Non-Sequential\\Ray Splitting\\Beam splitter.zmx"
    TheSystem.LoadFile(zosapi.TheApplication.SamplesDir + file, False)
    TheSystem.SaveAs(zosapi.TheApplication.SamplesDir + "\\API\\Python\\e10_NSC_ray_trace.zmx")
    #! [e10s01_py]

    #! [e10s02_py]
    # Run an NSC Ray Trace, Save .zrd file
    NSCRayTrace = TheSystem.Tools.OpenNSCRayTrace()  # Open NSC RayTrace tool
    NSCRayTrace.ClearDetectors(0)  # Clear all detectors
    # Set up RayTrace tool
    NSCRayTrace.IgnoreErrors = True
    NSCRayTrace.SaveRays = True
    NSCRayTrace.SaveRaysFile = "e10_API_RayTrace.ZRD"  # Saves to same directory as lens file
    TraceTool = CastTo(NSCRayTrace, "ISystemTool")  # Cast RayTrace to system tool interface to access Run and Close
    TraceTool.RunAndWaitForCompletion()
    TraceTool.Close()
    #! [e10s02_py]

    #! [e10s03_py]
    # Open Detector Viewer, view previously saved .zrd file
    DetectorView = TheSystem.Analyses.New_DetectorViewer()
    DetectorView_Settings = DetectorView.GetSettings()
    DetectorView_Set = CastTo(DetectorView_Settings, "IAS_DetectorViewer")  # Gain access to settings properties
    DetectorView_Set.RayDatabaseFilename = "e10_API_Raytrace.ZRD"
    DetectorView_Set.ShowAs = constants.DetectorViewerShowAsTypes_FalseColor
    DetectorView_Set.Filter = "X_HIT(2, 4)"  # Detector will only display rays which hit object 2 exactly 4 times

    DetectorView.ApplyAndWaitForCompletion()  # Apply Settings to Detector Viewer
    #! [e10s03_py]

    #! [e10s04_py]
    # Retrieve detector data and detector information
    TheNCE = TheSystem.NCE
    hits_bool_return, total_hits = TheNCE.GetDetectorData(4, -3, 0)  # Object Number=4, Pix -3 & Data=0 (total hits)
    flux_bool_return, total_flux = TheNCE.GetDetectorData(4, 0, 0)  # Object Number=4, Pix=0 & Data=0 (total flux)
    print(" total hits  = ",total_hits, "\n", "total flux =  ",total_flux)

    dims_bool_return, X_detectorDims, Y_detectorDims = TheNCE.GetDetectorDimensions(4)  # get number of pixels in X, Y

    pix = []  # Create array to store flux data for each pixel
    length = pix.__len__()
    while pix.__len__() < X_detectorDims*Y_detectorDims:  # loop through pixels, store value in pix
        length += 1
        pix_bool, value = TheNCE.GetDetectorData(4, length, 0)
        pix.append(value)
    #! [e10s04_py]

    #! [e10s05_py]
    # Save Ray Path Analysis to Text File
    if (zosapi.TheApplication.LicenseStatus == constants.LicenseStatusType_PremiumEdition):
        # there is a bug in ZOS16.5 SP4 with COM; need to use ZOS16.5 SP5 or higher to run this code successfully
        RayPath = TheSystem.Analyses.New_Analysis(constants.AnalysisIDM_PathAnalysis)

        RayPath_settings = CastTo(RayPath.GetSettings(), 'IAS_PathAnalysis')
        zrd = "e10_API_RayTrace.ZRD"
        RayPath_settings.RayDatabaseFile = zrd
        RayPath.ApplyAndWaitForCompletion()

        Rays = CastTo(RayPath.GetResults(), 'IAR_')
        Rays.GetTextFile(zosapi.TheApplication.SamplesDir + "\\API\\Python\\e10_RayPathAnalysis.txt")
    #! [e10s05_py]

    # Save!
    TheSystem.Save()


    # This will clean up the connection to OpticStudio.
    # Note that it closes down the server instance of OpticStudio, so you for maximum performance do not do
    # this until you need to.
    del zosapi
    zosapi = None



