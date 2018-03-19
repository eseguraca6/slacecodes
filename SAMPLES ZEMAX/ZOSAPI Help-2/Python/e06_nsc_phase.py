from win32com.client.gencache import EnsureDispatch, EnsureModule
from win32com.client import CastTo, constants
import os
import matplotlib.pyplot as plt
import numpy as np


# Notes
#
# The graphics for this file to run properly require the pip module 'matplotlib'
# If you have the latest version of pip installed with python, you can install the required module by using the following CLI command:
#
#    python -m pip install matplotlib
#
# For more information, please see our Knowledgebase
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

    # creates a new API directory
    if not os.path.exists(zosapi.TheApplication.SamplesDir + "\\API\\Python"):
        os.makedirs(zosapi.TheApplication.SamplesDir + "\\API\\Python")

    TheApplication = zosapi.TheApplication

    #! [e06s01_py]
    # Create new non-sequential file
    TheSystem = TheApplication.CreateNewSystem(constants.SystemType_NonSequential)
    TheNCE = TheSystem.NCE
    #! [e06s01_py]

    #! [e06s02_py]
    # inserts objects and changes type
    TheNCE.InsertNewObjectAt(2)
    o1 = TheNCE.GetObjectAt(1)
    o2 = TheNCE.GetObjectAt(2)
    o1.ChangeType(o1.GetObjectTypeSettings(constants.ObjectType_SourcePoint))
    o2.ChangeType(o2.GetObjectTypeSettings(constants.ObjectType_DetectorRectangle))
    #! [e06s02_py]

    #! [e06s03_py]
    # modify object's cell values in the NCE
    CastTo(o1.ObjectData, 'IObjectSources').NumberOfAnalysisRays = 1e6
    CastTo(o1.ObjectData, 'IObjectSources').NumberOfLayoutRays = 10
    CastTo(o1.ObjectData, 'IObjectSourcePoint').ConeAngle = 2.5

    o2.ZPosition = 1
    CastTo(o2.ObjectData, 'IObjectDetectorRectangle').XHalfWidth = 0.1
    CastTo(o2.ObjectData, 'IObjectDetectorRectangle').YHalfWidth = 0.1
    CastTo(o2.ObjectData, 'IObjectDetectorRectangle').NumberXPixels = 100
    CastTo(o2.ObjectData, 'IObjectDetectorRectangle').NumberYPixels = 100
    #! [e06s03_py]

    #! [e06s04_py]
    # Setup and run the ray trace
    NSCRayTrace = TheSystem.Tools.OpenNSCRayTrace()
    NSCRayTrace.SplitNSCRays = False
    NSCRayTrace.ScatterNSCRays = True
    NSCRayTrace.UsePolarization = False
    NSCRayTrace.IgnoreErrors = True
    NSCRayTrace.SaveRays = False
    NSCRayTrace.ClearDetectors(0)

    CastTo(NSCRayTrace, 'ISystemTool').RunAndWaitForCompletion()
    CastTo(NSCRayTrace, 'ISystemTool').Close()
    #! [e06s04_py]

    plt.rcParams["figure.figsize"] = (12, 4)
    plt.set_cmap('jet')
    plt.subplot(1, 2, 1)
    det = 2

    #! [e06s05_py]
    # extracts the irradiance data from detector
    irradiance = np.flipud(TheSystem.NCE.GetAllDetectorDataSafe(det, 1))
    plt.imshow(irradiance)
    #! [e06s05_py]

    # irradiance plot formatting
    plt.colorbar()
    plt.title('Inchoerent Irradiance')
    plt.xticks([])
    plt.yticks([])

    plt.subplot(1, 2, 2)

    #! [e06s06_py]
    # Calculates phase data from Er & Ei
    real = TheSystem.NCE.GetAllCoherentDataSafe(det, constants.DetectorDataType_Real)
    imag = TheSystem.NCE.GetAllCoherentDataSafe(det, constants.DetectorDataType_Imaginary)
    phase = np.flipud(np.arctan2(imag, real) * 180 / np.pi)
    plt.imshow(phase)
    #! [e06s06_py]

    # phase plot formatting
    plt.colorbar()
    plt.title('Phase')
    plt.xticks([])
    plt.yticks([])

    TheSystem.SaveAs(TheApplication.SamplesDir + '\\API\\Python\\e06_nsc_phase.zmx')

    # This will clean up the connection to OpticStudio.
    # Note that it closes down the server instance of OpticStudio, so you for maximum performance do not do
    # this until you need to.
    del zosapi
    zosapi = None

    # place plt.show() after clean up to release OpticStudio from memory
    plt.show()