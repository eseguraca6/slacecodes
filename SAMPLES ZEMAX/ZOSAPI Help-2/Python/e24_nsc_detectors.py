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

    if not os.path.exists(zosapi.TheApplication.SamplesDir + "\\API\\Python"):
        os.makedirs(zosapi.TheApplication.SamplesDir + "\\API\\Python")

    TheApplication = zosapi.TheApplication

    # makes system non-seqnuential and adds 2 objects (3 in total)
    TheSystem = TheApplication.CreateNewSystem(constants.SystemType_NonSequential)

    #! [e24s01_py]
    # Initializes NCE and loads surfaces
    # Inserts objects
    TheNCE = TheSystem.NCE
    for a in range(1,5):
        TheNCE.InsertNewObjectAt(1)
    #! [e24s01_py]

    #! [e24s02_py]
    # Gets reference to specific object
    o1 = TheNCE.GetObjectAt(1)
    o2 = TheNCE.GetObjectAt(2)
    o3 = TheNCE.GetObjectAt(3)
    o4 = TheNCE.GetObjectAt(4)
    o5 = TheNCE.GetObjectAt(5)
    #! [e24s02_py]

    #! [e24s03_py]
    # Changes Object Type
    TheNCE.GetObjectAt(1).ChangeType(o1.GetObjectTypeSettings(constants.ObjectType_SourceEllipse))
    o2.ChangeType(o2.GetObjectTypeSettings(constants.ObjectType_AsphericSurface2))
    o3.ChangeType(o3.GetObjectTypeSettings(constants.ObjectType_StandardLens))
    o4.ChangeType(o4.GetObjectTypeSettings(constants.ObjectType_DetectorColor))
    o5.ChangeType(o5.GetObjectTypeSettings(constants.ObjectType_DetectorRectangle))
    #! [e24s03_py]

    #! [e24s04_py]
    # Sets positions & materials
    TheNCE.GetObjectAt(2).XPosition = 1.5
    TheNCE.GetObjectAt(2).ZPosition = 9.99
    TheNCE.GetObjectAt(2).Material = 'ABSORB'
    #! [e24s04_py]
    o3.YPosition = 1.5
    o3.ZPosition = 8.99
    o3.Material = 'N-BK7'
    o4.ZPosition = 10
    o5.RefObject = 4
    o5.ZPosition = 1e-3

    #! [e24s05_py]
    # Sets layout rays based on parameter number
    TheNCE.GetObjectAt(1).GetObjectCell(constants.ObjectColumn_Par1).IntegerValue = 100
    # Sets analysis rays based on object data column
    o1_data = CastTo(o1.ObjectData, 'IObjectSources')
    o1_data.NumberOfAnalysisRays = 1E6
    #! [e24s05_py]
    
    o1.GetObjectCell(constants.ObjectColumn_Par10).DoubleValue = 50
    o1.GetObjectCell(constants.ObjectColumn_Par11).DoubleValue = 50

    o2.GetObjectCell(constants.ObjectColumn_Par3).DoubleValue = 0.5
    o2.GetObjectCell(constants.ObjectColumn_Par4).DoubleValue = 1
    o2.GetObjectCell(constants.ObjectColumn_Par9).IntegerValue = 1

    o4.GetObjectCell(constants.ObjectColumn_Par1).DoubleValue = 8.223
    o4.GetObjectCell(constants.ObjectColumn_Par2).DoubleValue = 2.565
    o4.GetObjectCell(constants.ObjectColumn_Par3).IntegerValue = 200
    o4.GetObjectCell(constants.ObjectColumn_Par4).IntegerValue = 150

    o5_x = 10
    o5_y = 12.23
    o5.GetObjectCell(constants.ObjectColumn_Par1).DoubleValue = o5_x
    o5.GetObjectCell(constants.ObjectColumn_Par2).DoubleValue = o5_y
    o5.GetObjectCell(constants.ObjectColumn_Par3).IntegerValue = 100
    o5.GetObjectCell(constants.ObjectColumn_Par4).IntegerValue = 100

    #! [e24s06_py]
    # changes face type and coating properties
    TheNCE.GetObjectAt(3).CoatScatterData.GetFaceData(0).FaceIs = constants.FaceIsType_Absorbing
    TheNCE.GetObjectAt(3).CoatScatterData.GetFaceData(1).FaceIs = constants.FaceIsType_ObjectDefault
    TheNCE.GetObjectAt(3).CoatScatterData.GetFaceData(1).Coating = 'I.50'
    #! [e24s06_py]
    
    #! [e24s07_py]
    # changes scatter profile on face
    o3_Scatter = TheNCE.GetObjectAt(3).CoatScatterData.GetFaceData(2).CreateScatterModelSettings(constants.ObjectScatteringTypes_Lambertian)
    o3_Scatter._S_Lambertian.ScatterFraction = 0.5
    TheNCE.GetObjectAt(3).CoatScatterData.GetFaceData(2).ChangeScatterModelSettings(o3_Scatter)
    TheNCE.GetObjectAt(3).CoatScatterData.GetFaceData(2).NumberOfRays = 2
    #! [e24s07_py]

    #! [e24s08_py]
    # removes pixel interpolation for the detector
    o4.TypeData.UsePixelInterpolation = False
    #! [e24s08_py]
    
    #! [e24s09_py]
    # Setup and run the ray trace
    NSCRayTrace = TheSystem.Tools.OpenNSCRayTrace()
    NSCRayTrace.SplitNSCRays = False
    NSCRayTrace.ScatterNSCRays = True
    NSCRayTrace.UsePolarization = False
    NSCRayTrace.IgnoreErrors = True
    NSCRayTrace.SaveRays = False
    NSCRayTrace.ClearDetectors(0)
    
    baseTool = CastTo(NSCRayTrace, 'ISystemTool')
    baseTool.RunAndWaitForCompletion()
    baseTool.Close()
    #! [e24s09_py]

    # saves file to disk to expose all objects
    TheSystem.SaveAs(TheApplication.SamplesDir + '\\API\\Python\\e24_nsc_detectors.zmx')

    RDB = TheSystem.Analyses.New_Analysis(constants.AnalysisIDM_RayDatabaseViewer)
    print(RDB.HasAnalysisSpecificSettings)
    a = RDB.GetResults().GetTextFile('C:\\Users\\zachary.Derocher\\Documents\\Zemax\\Zach Zemax\\hi.txt')



    """
    tic = time.time()
    #! [e24s10_py]
    # Creates a new detector viewer analysis reference, changes to TrueColor for RGB extraction
    d4 = TheSystem.Analyses.New_Analysis(constants.AnalysisIDM_DetectorViewer)
    det_setting = d4.GetSettings()
    det_settings = CastTo(det_setting, 'IAS_DetectorViewer')
    det_settings.ShowAs = constants.DetectorViewerShowAsTypes_TrueColor
    d4.ApplyAndWaitForCompletion()
    d4_Results = d4.GetResults()
    d4_raw = d4_Results.GetDataGridRgb(0)
    #! [e24s10_py]

    # Reads in values from NCE for detector settings
    obj = 4
    x_half = TheSystem.NCE.GetObjectAt(obj).GetObjectCell(constants.ObjectColumn_Par1).DoubleValue
    y_half = TheSystem.NCE.GetObjectAt(obj).GetObjectCell(constants.ObjectColumn_Par2).DoubleValue
    x_pixels = TheSystem.NCE.GetObjectAt(obj).GetObjectCell(constants.ObjectColumn_Par3).IntegerValue
    y_pixels = TheSystem.NCE.GetObjectAt(obj).GetObjectCell(constants.ObjectColumn_Par4).IntegerValue

    #! [e24s11_py]
    # FillValues() method still in development for Python; need to use GetValue()
    #! [e24s11_py]

    #! [e24s12_py]
    # FillValues() method still in development for Python
    # creates 3D array to store normalized RGB data
    data = np.zeros([y_pixels, x_pixels, 3])

    for y in range(0, y_pixels):
        for x in range(0, x_pixels):
            rgb = d4_raw.GetValue(x, y)
            data[y, x, 0] = rgb.R / 255
            data[y, x, 1] = rgb.G / 255
            data[y, x, 2] = rgb.B / 255
    #! [e24s12_py]

    plt.figure()
    plt.imshow(np.flipud(data), extent=[-x_half, x_half, -y_half, y_half])


    #! [e24s13_py]
    # changes default values for Detector Viewer
    # pltos the Incoherent Irradiance in False Color
    d5 = TheSystem.Analyses.New_Analysis(constants.AnalysisIDM_DetectorViewer)
    d5_set = d5.GetSettings()
    setting = CastTo(d5_set, 'IAS_DetectorViewer')
    setting.Detector.SetDetectorNumber(5)
    setting.ShowAs = constants.DetectorViewerShowAsTypes_FalseColor
    d5.ApplyAndWaitForCompletion()
    d5_results = d5.GetResults()
    results = CastTo(d5_results, 'IAR_')
    d5_values = results.GetDataGrid(0).Values
    #! [e24s13_py]

    plt.figure()
    plt.imshow(np.flipud(d5_values), cmap='jet', extent=[-o5_x, o5_x, -o5_y, o5_y])
    plt.colorbar()

    toc = round(time.time() - tic, 3)
    print('Elapsed time is ' + str(toc) + ' seconds.')
    """

    #! [e24s14_py]
    # saves current system in memory
    TheSystem.Save()
    #! [e24s14_py]

    # This will clean up the connection to OpticStudio.
    # Note that it closes down the server instance of OpticStudio, so you for maximum performance do not do
    # this until you need to.
    del zosapi
    zosapi = None

    # place plt.show() after clean up to release OpticStudio from memory
    plt.show()