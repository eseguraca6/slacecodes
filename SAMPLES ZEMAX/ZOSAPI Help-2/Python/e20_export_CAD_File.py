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
    TheApplication = zosapi.TheApplication
    # Load a non-sequential file
    TheSystem.LoadFile(TheApplication.SamplesDir +'\\Non-Sequential\\Miscellaneous\\Digital_projector_flys_eye_homogenizer.zmx', False)

    #! [e20s01_py]
    # Get interface of IExportCAD
    ToolExportCAD = TheSystem.Tools.OpenExportCAD()
    #! [e20s01_py]

    #! [e20s02_py]
    # default option settings
    ToolExportCAD.FirstObject = 1
    ToolExportCAD.LastObject = 8
    ToolExportCAD.RayLayer = 1
    ToolExportCAD.LensLayer = 0
    ToolExportCAD.DummyThickness = 1
    ToolExportCAD.SplineSegments = constants.SplineSegmentsType_N_032
    ToolExportCAD.FileType = constants.CADFileType_STEP
    ToolExportCAD.Tolerance = constants.CADToleranceType_N_TenEMinus4
    ToolExportCAD.SetCurrentConfiguration()
    # For other configuration choices, use following methods.
    # ToolExportCAD.SetConfigurationAllAtOnce()
    # ToolExportCAD.SetConfigurationAllByFile()
    # ToolExportCAD.SetConfigurationAllByLayer()
    # ToolExportCAD.SetSingleConfiguration(1)
    #! [e20s02_py]

    #! [e20s03_py]
    # default check boxes settings
    ToolExportCAD.SurfacesAsSolids = True
    ToolExportCAD.ScatterNSCRays = False
    ToolExportCAD.ExportDummySurfaces = False
    ToolExportCAD.SplitNSCRays = False
    ToolExportCAD.UsePolarization = False
    #! [e20s03_py]

    #! [e20s04_py]
    # set output file name
    ToolExportCAD.OutputFileName = TheApplication.ObjectsDir + '\\CAD Files\\API_CADexport_sample.step'
    #! [e20s04_py]

    #! [e20s05_py]
    # Starting exporting
    # Run with a 3 minites timeout
    print('Starting exporting...')
    baseTool = CastTo(ToolExportCAD, 'ISystemTool')
    baseTool.Run()
    runstatus = baseTool.WaitWithTimeout(float(3 * 60))

    # Report the status
    if runstatus == constants.RunStatus_Completed:
        print('Completed!')
    elif runstatus == constants.RunStatus_FailedToStart:
        print('Failed To Start!')
    elif runstatus == constants.RunStatus_InvalidTimeout:
        print('Invalid Timeout')
    else:
        print('Timed Out!')

    print('Progress: ', baseTool.Progress)

    # If the exporting is not completed and can be cancelled, cancel the work
    if (runstatus != constants.RunStatus_Completed and baseTool.CanCancel):
        baseTool.Cancel()

    # Close the tool
    baseTool.Close()
    #! [e20s05_py]


    # This will clean up the connection to OpticStudio.
    # Note that it closes down the server instance of OpticStudio, so you for maximum performance do not do
    # this until you need to.
    del zosapi
    zosapi = None