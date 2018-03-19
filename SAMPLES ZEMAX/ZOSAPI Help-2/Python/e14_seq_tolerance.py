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

    if not os.path.exists(zosapi.TheApplication.ZemaxDataDir + "\\Samples\\API\\Python"):
        os.makedirs(zosapi.TheApplication.ZemaxDataDir + "\\Samples\\API\\Python")


    TheSystem = zosapi.TheSystem

    # ! [e14s01_py]
    # Open Double Gauss sample file
    dataFolder = zosapi.TheApplication.ZemaxDataDir
    DGfile = dataFolder + "\\Samples\\Sequential\\Objectives\\Double Gauss 28 degree field.zmx"
    TheSystem.LoadFile(DGfile, False)
    # ! [e14s01_py]

    # ! [e14s02_py]
    # Set up Tolerance Wizard and run it
    tWiz = TheSystem.TDE.SEQToleranceWizard
    tWiz_cast = CastTo(tWiz, "IToleranceWizard")
    # Specify surface tolerances
    tWiz_cast.SurfaceRadius = 0.1
    tWiz_cast.SurfaceThickness = 0.1
    tWiz_cast.SurfaceDecenterX = 0.1
    tWiz_cast.SurfaceDecenterY = 0.1
    tWiz_cast.SurfaceTiltX = 0.2
    tWiz_cast.SurfaceTiltY = 0.2
    # Specify element tolerances
    tWiz_cast.ElementDecenterX = 0.1
    tWiz_cast.ElementDecenterY = 0.1
    tWiz_cast.ElementTiltXDegrees = 0.2
    tWiz_cast.ElementTiltYDegrees = 0.2
    # Specify tolerances not to be used
    tWiz_cast.IsSurfaceSandAIrregularityUsed = False
    tWiz_cast.IsIndexUsed = False
    tWiz_cast.IsIndexAbbePercentageUsed = False
    # Select OK (must cast to IWizard to get access to OK method)
    tWiz_IWizard = CastTo(tWiz_cast, "IWizard")
    tWiz_IWizard.OK()
    # ! [e14s02_py]

    # ! [e14s03_py]
    # Create a "Double Gauss" folder in the Samples folder
    import os

    dirLoc = dataFolder + "\\Samples\\API\\Python\\e14_seq_tolerance"
    if not os.path.exists(dirLoc):
        os.makedirs(dirLoc)
    # Save new file to Double Gauss folder
    fileNameSeq = dirLoc + "\\Double Gauss (seq).zmx"
    TheSystem.SaveAs(fileNameSeq)
    # ! [e14s03_py]

    # ! [e14s04_py]
    # Set up Tolerancing analysis and run it
    tol = TheSystem.Tools.OpenTolerancing()
    # Select Sensitivity mode
    tol.SetupMode = constants.SetupModes_Sensitivity
    # Select Criterion and related settings
    tol.Criterion = constants.Criterions_RMSSpotRadius
    tol.CriterionSampling = 3
    tol.CriterionComp = constants.CriterionComps_OptimizeAll_DLS
    tol.CriterionCycle = 2
    tol.CriterionField = constants.CriterionFields_UserDefined
    # Select number of MC runs and files to save
    tol.NumberOfRuns = 20
    tol.NumberToSave = 20
    tol.FilePrefix = "API_test2_"
    # Run the Tolerancing analysis
    tol_Tool = CastTo(tol, "ISystemTool")  # Must cast to ISystemTool to get access to RunAndWaitForCompletion method
    tol_Tool.RunAndWaitForCompletion()
    tol_Tool.Close()
    # ! [e14s04_py]

    # ! [e14s05_py]
    # Convert file to Non-sequential mode
    convertNSmode = TheSystem.Tools.OpenConvertToNSCGroup()
    convertNSmode.ConvertFileToNSC = True
    convert_Tool = CastTo(convertNSmode, "ISystemTool")
    convert_Tool.RunAndWaitForCompletion()
    # Save the Non-sequential file to the Double Gauss folder
    fileNameNS = dirLoc + "\\Double Gauss (NS).zmx"
    TheSystem.SaveAs(fileNameNS)
    # ! [e14s05_py]


    # This will clean up the connection to OpticStudio.
    # Note that it closes down the server instance of OpticStudio, so you for maximum performance do not do
    # this until you need to.
    del zosapi
    zosapi = None



