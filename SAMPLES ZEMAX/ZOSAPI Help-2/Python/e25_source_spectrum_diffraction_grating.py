from win32com.client.gencache import EnsureDispatch, EnsureModule
from win32com.client import CastTo, constants
import os, time, ctypes, array
import matplotlib.pyplot as plt
import numpy as np

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

    if not os.path.exists(zosapi.TheApplication.SamplesDir + "\\Samples\\API\\Python"):
        os.makedirs(zosapi.TheApplication.SamplesDir + "\\Samples\\API\\Python")

    TheApplication = zosapi.TheApplication

    # makes system non-seqnuential and adds 2 objects (3 in total)
    TheSystem = TheApplication.CreateNewSystem(constants.SystemType_NonSequential)

    #! [e25s01_py]
    # Initializes NCE and loads surfaces
    # Inserts objects
    TheNCE = TheSystem.NCE
    TheNCE.InsertNewObjectAt(1)
    TheNCE.InsertNewObjectAt(1)
    TheNCE.InsertNewObjectAt(1)
    TheNCE.InsertNewObjectAt(1)
    #! [e25s01_py]

    o1 = TheNCE.GetObjectAt(1)
    o2 = TheNCE.GetObjectAt(2)
    o3 = TheNCE.GetObjectAt(3)
    o4 = TheNCE.GetObjectAt(4)
    o5 = TheNCE.GetObjectAt(5)

    #! [e25s02_py]
    # Changes Object Type
    o1.ChangeType(o1.GetObjectTypeSettings(constants.ObjectType_SourceDiode))
    o2.ChangeType(o2.GetObjectTypeSettings(constants.ObjectType_SourceDiode))
    o3.ChangeType(o3.GetObjectTypeSettings(constants.ObjectType_NullObject))
    o4.ChangeType(o4.GetObjectTypeSettings(constants.ObjectType_DiffractionGrating))
    o5.ChangeType(o5.GetObjectTypeSettings(constants.ObjectType_DetectorColor))
    #! [e25s02_py]

    # Sets positions & materials
    o3.ZPosition = 10
    o3.TiltAboutX = 10
    o4.RefObject = 3
    o4.Material = 'MIRROR'
    o5.YPosition = 8.45
    o5.TiltAboutX = 40

    # Sets parameters
    CastTo(o1.ObjectData, 'IObjectSourceDiode').XMinusDivergence = 5
    CastTo(o2.ObjectData, 'IObjectSourceDiode').XMinusDivergence = 5
    CastTo(o4.ObjectData, 'IObjectDiffractionGrating').LinesPerMicron = 0.6
    CastTo(o4.ObjectData, 'IObjectDiffractionGrating').DiffOrder = 1

    #! [e25s03_py]
    # Changes sourcecolor to Blackbody, sets temperature, min/max wavelength
    o1.SourcesData.SourceColor = constants.SourceColorMode_BlackBodySpectrum
    o1.SourcesData.SourceColorSettings._S_BlackBodySpectrum.TemperatureK = 6000
    o1.SourcesData.SourceColorSettings._S_BlackBodySpectrum.WavelengthFrom = 0.45
    o1.SourcesData.SourceColorSettings._S_BlackBodySpectrum.WavelengthTo = 0.65
    #! [e25s03_py]

    o2.SourcesData.SourceColor = constants.SourceColorMode_BlackBodySpectrum
    o2.SourcesData.SourceColorSettings._S_BlackBodySpectrum.TemperatureK = 6000
    o2.SourcesData.SourceColorSettings._S_BlackBodySpectrum.SpectrumCount = 100
    o2.SourcesData.SourceColorSettings._S_BlackBodySpectrum.WavelengthFrom = 0.4
    o2.SourcesData.SourceColorSettings._S_BlackBodySpectrum.WavelengthTo = 0.7

    #! [e25s04_py]
    # Sets up the MCE, adds configuration & operands
    TheMCE = TheSystem.MCE
    TheMCE.AddConfiguration(False)
    TheMCE.AddOperand()
    TheMCE.AddOperand()
    TheMCE.AddOperand()
    #! [e25s04_py]

    #! [e25s05_py]
    # change MCE to NPAR, modifies the number of Layout Rays for a Source
    for a in range(1, 5):
        TheMCE.GetOperandAt(a).ChangeType(constants.MultiConfigOperandType_NPAR)
    TheMCE.GetOperandAt(1).Param2 = 1
    TheMCE.GetOperandAt(1).Param3 = 1
    TheMCE.GetOperandAt(1).GetOperandCell(1).DoubleValue = 200
    TheMCE.GetOperandAt(1).GetOperandCell(2).DoubleValue = 0
    #! [e25s05_py]

    TheMCE.GetOperandAt(2).Param2 = 1
    TheMCE.GetOperandAt(2).Param3 = 2
    TheMCE.GetOperandAt(2).GetOperandCell(1).DoubleValue = 100000
    TheMCE.GetOperandAt(2).GetOperandCell(2).DoubleValue = 0

    TheMCE.GetOperandAt(3).Param2 = 2
    TheMCE.GetOperandAt(3).Param3 = 1
    TheMCE.GetOperandAt(3).GetOperandCell(1).DoubleValue = 0
    TheMCE.GetOperandAt(3).GetOperandCell(2).DoubleValue = 200

    TheMCE.GetOperandAt(4).Param2 = 2
    TheMCE.GetOperandAt(4).Param3 = 2
    TheMCE.GetOperandAt(4).GetOperandCell(1).DoubleValue = 0
    TheMCE.GetOperandAt(4).GetOperandCell(2).DoubleValue = 100000

    # Setup detector color
    x_width = 1.5
    y_width = 1.5
    x_pixel = 500
    y_pixel = 500

    CastTo(o5.ObjectData, 'IObjectDetectorColor').XHalfWidth = x_width
    CastTo(o5.ObjectData, 'IObjectDetectorColor').YHalfWidth = x_width
    CastTo(o5.ObjectData, 'IObjectDetectorColor').NumberXPixels = x_pixel
    CastTo(o5.ObjectData, 'IObjectDetectorColor').NumberYPixels = y_pixel

    plt.rcParams["figure.figsize"] = (10, 4)
    for a in range(1, TheMCE.NumberOfConfigurations + 1):
        TheMCE.SetCurrentConfiguration(a)
        # Setup and run the ray trace
        NSCRayTrace = TheSystem.Tools.OpenNSCRayTrace()
        NSCRayTrace.ClearDetectors(0)
        NSCRayTrace.SplitNSCRays = False
        NSCRayTrace.ScatterNSCRays = False
        NSCRayTrace.UsePolarization = False
        NSCRayTrace.IgnoreErrors = True
        NSCRayTrace.SaveRays = False
        CastTo(NSCRayTrace, 'ISystemTool').RunAndWaitForCompletion()
        CastTo(NSCRayTrace, 'ISystemTool').Close()

        print('Finished ray trace')

        #! [e25s06_py]
        # Creates a new detector viewer window, changes to true color
        det = TheSystem.Analyses.New_Analysis(constants.AnalysisIDM_DetectorViewer)
        det_setting = det.GetSettings()
        det_settings = CastTo(det_setting, 'IAS_DetectorViewer')
        # ensure detector viewer is true color to extract RGB data
        det_settings.ShowAs = constants.DetectorViewerShowAsTypes_TrueColor
        det.ApplyAndWaitForCompletion()
        #! [e25s06_py]
        
        #! [e25s07_py]
        det_raw = det.GetResults().GetDataGridRgb(0)
        # FillValues() method still in development for Python; need to use GetValue()
        xpix = CastTo(o5.ObjectData, 'IObjectDetectorColor').NumberXPixels
        ypix = CastTo(o5.ObjectData, 'IObjectDetectorColor').NumberYPixels
        data = np.zeros([ypix, xpix, 3])
        for y in range(0, ypix):
            for x in range(0, xpix):
                rgb = det_raw.GetValue(x, y)
                data[y, x, 0] = rgb.R / 255
                data[y, x, 1] = rgb.G / 255
                data[y, x, 2] = rgb.B / 255

        #! [e25s07_py]
        plt.subplot(1, TheMCE.NumberOfConfigurations, a)
        plt.imshow(np.flipud(data), extent=[-x_width, x_width, -y_width, y_width])
        plt.title('Config = ' + str(a))



    TheSystem.SaveAs(TheApplication.SamplesDir + '\\Samples\\API\\Python\\e25_source_spectrum_diffraction_grating.zmx')


    # This will clean up the connection to OpticStudio.
    # Note that it closes down the server instance of OpticStudio, so you for maximum performance do not do
    # this until you need to.
    del zosapi
    zosapi = None

    # place plt.show() after clean up to release OpticStudio from memory
    plt.show()