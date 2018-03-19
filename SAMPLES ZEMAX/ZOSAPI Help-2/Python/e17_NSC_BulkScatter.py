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
    
    # Insert Code Here
    TheSystem = zosapi.TheSystem
    TheApplication = zosapi.TheApplication

    if not os.path.exists(zosapi.TheApplication.SamplesDir + "\\API\\Python"):
        os.makedirs(zosapi.TheApplication.SamplesDir + "\\API\\Python")

    #! [e17s01_py]
    # Create New File
    TheSystem.New(False)
    TheSystem.MakeNonSequential()
    #! [e17s01_py]

    #! [e17s02_py]
    # Define Path Locations
    SamplesFolder = TheApplication.SamplesDir
    SampleFile = SamplesFolder + "\\API\\Python\\e17_NSC_BulkScatter.ZMX"
    TheSystem.SaveAs(SampleFile)
    #! [e17s02_py]

    #! [e17s03_py]
    # Non-sequential component editor
    TheNCE = TheSystem.NCE
    Object_1 = TheNCE.InsertNewObjectAt(1)
    Object_2 = TheNCE.InsertNewObjectAt(2)
    Object_3 = TheNCE.GetObjectAt(3)
    #! [e17s03_py]

    #! [e17s04_py]
    # Source point
    oType_1 = Object_1.GetObjectTypeSettings(constants.ObjectType_SourcePoint)
    Object_1.ChangeType(oType_1)
    Source1_data = Object_1.ObjectData
    Source1_data_cast = CastTo(Source1_data, "IObjectSources")  # Cast to "IObjectSources" interface to get properties
    Source1_data_cast.NumberOfLayoutRays = 3
    Source1_data_cast.NumberOfAnalysisRays = 1000000
    #! [e17s04_py]

    #! [e17s05_py]
    # Rectangular Volume
    # Scattering Properties
    # Draw:opacity set to 50%
    oType_2 = Object_2.GetObjectTypeSettings(constants.ObjectType_RectangularVolume)
    Object_2.ChangeType(oType_2)
    Object_2.ZPosition = 2
    Object_2.Material = "N-BK7"
    RectVolume2_data = Object_2.ObjectData
    RectVolume2_data_cast = CastTo(RectVolume2_data, "IObjectRectangularVolume")
    RectVolume2_data_cast.X1HalfWidth = 12
    RectVolume2_data_cast.Y1HalfWidth = 12
    RectVolume2_data_cast.ZLength = 40
    RectVolume2_data_cast.X2HalfWidth = 12
    RectVolume2_data_cast.Y2HalfWidth = 12
    RectVolume2_volphysdata = Object_2.VolumePhysicsData
    RectVolume2_volphysdata.Model = constants.VolumePhysicsModelType_AngleScattering
    RectVolume2_volphysdata.ModelSettings._S_AngleScattering.MeanPath = 5
    RectVolume2_volphysdata.ModelSettings._S_AngleScattering.Angle = 30
    RectVolume2_DrawData = Object_2.DrawData
    RectVolume2_DrawData.Opacity = constants.ZemaxOpacity_P50
    #! [e17s05_py]

    #! [e17s06_py]
    # Detector Rectangle
    oType_3 = Object_3.GetObjectTypeSettings(constants.ObjectType_DetectorRectangle)
    Object_3.RefObject = 2
    Object_3.ZPosition = 42
    Object_3.Material = "ABSORB"
    Object_3.ChangeType(oType_3)
    DetRect3_data = Object_3.ObjectData
    DetRect3_data_cast = CastTo(DetRect3_data, "IObjectDetectorRectangle")
    DetRect3_data_cast.XHalfWidth = 15
    DetRect3_data_cast.YHalfWidth = 15
    DetRect3_data_cast.NumberXPixels = 25
    DetRect3_data_cast.NumberYPixels = 25
    DetRect3_data_cast.DataType = 0
    DetRect3_data_cast.Color = 2
    DetRect3_data_cast.Smoothing = 1
    #! [e17s06_py]

    #! [e17s07_py]
    # Open a shaded model
    analysis = TheSystem.Analyses.New_Analysis(constants.AnalysisIDM_NSCShadedModel)
    analysis.WaitForCompletion()
    analysisSettings = analysis.GetSettings()
    cfgFile = SamplesFolder + "\\API\\Python\\e17_NSC_BulkScatter.cfg"
    analysisSettings.SaveTo(cfgFile)  # Save current settings to a cfg file
    # MODIFYSETTINGS are defined in ZPL help files: The Programming Tab > About the ZPL > Keywords
    analysisSettings.ModifySettings(cfgFile, "SHA_ROTX", "20")
    analysisSettings.ModifySettings(cfgFile, "SHA_ROTY", "-20")
    analysisSettings.ModifySettings(cfgFile, "SHA_ROTZ", "30")
    analysisSettings.LoadFrom(cfgFile)  # Load in the newly modified settings
    # If you want to overwrite your default CFG, save over it with newly modified CFG file:
    #  CFG_fullname = "C:\\Users\\zachary.Derocher\\Documents\\Zemax\\Configs\\POP.CFG"
    #  import shutil
    #  shutil.copy(cfgFile, CFG_fullname)
    analysis.ApplyAndWaitForCompletion()  # Run analysis
    #! [e17s07_py]

    #! [e17s08_py]
    # Open a detector viewer
    det_analysis = TheSystem.Analyses.New_Analysis(constants.AnalysisIDM_DetectorViewer)
    det_analysisSettings = det_analysis.GetSettings()
    det_cfgFile = SamplesFolder + "\\API\\Python\\e17_DetectorViewer.cfg"
    det_analysisSettings.SaveTo(det_cfgFile)
    det_analysisSettings.ModifySettings(det_cfgFile, "DVW_SHOW", "2")
    det_analysisSettings.ModifySettings(det_cfgFile, "DVW_SMOOTHING", "1")
    det_analysisSettings.LoadFrom(det_cfgFile)
    det_analysis.ApplyAndWaitForCompletion()
    #! [e17s08_py]

    #! [e17s09_py]
    # Run a ray trace
    NSCRayTrace = TheSystem.Tools.OpenNSCRayTrace()
    NSCRayTrace.SplitNSCRays = False
    NSCRayTrace.ScatterNSCRays = True
    NSCRayTrace.UsePolarization = False
    NSCRayTrace.IgnoreErrors = True
    NSCRayTrace.SaveRays = False
    NSCRayTrace.ClearDetectors(0)
    NSCRayTrace_cast = CastTo(NSCRayTrace, "ISystemTool")
    NSCRayTrace_cast.RunAndWaitForCompletion()
    NSCRayTrace_cast.Close()
    #! [e17s09_py]

    TheSystem.SaveAs(SampleFile)

    # This will clean up the connection to OpticStudio.
    # Note that it closes down the server instance of OpticStudio, so you for maximum performance do not do
    # this until you need to.
    del zosapi
    zosapi = None



