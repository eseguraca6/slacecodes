from win32com.client.gencache import EnsureDispatch, EnsureModule
from win32com.client import CastTo, constants
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

    # written with ZOSAPI 16.5, 20161019, MRH
    # use http://matplotlib.org/ to plot 2D graph
    # need to install this package before running this code

    # Set up primary optical system
    TheSystem = zosapi.TheSystem
    TheApplication = zosapi.TheApplication
    sampleDir = TheApplication.SamplesDir
    
    #! [e02s01_py]
    # Open file
    testFile = sampleDir + '\\Non-sequential\\Miscellaneous\\Digital_projector_flys_eye_homogenizer.zmx'
    TheSystem.LoadFile(testFile, False)
    #! [e02s01_py]
    
    #! [e02s02_py]
    # Create ray trace
    NSCRayTrace = TheSystem.Tools.OpenNSCRayTrace()
    NSCRayTrace.SplitNSCRays = True
    NSCRayTrace.ScatterNSCRays = False
    NSCRayTrace.UsePolarization = True
    NSCRayTrace.IgnoreErrors = True
    NSCRayTrace.SaveRays = False

    NSCRayTraceCast = CastTo(NSCRayTrace,'ISystemTool')
    NSCRayTraceCast.Run()
    #! [e02s02_py]
    
    lastValue = []
    lastValue.append(0)
    print('Beginning ray trace:')
    while NSCRayTraceCast.IsRunning:
        currentValue = NSCRayTraceCast.Progress
        if currentValue % 2 == 0:
            if lastValue[len(lastValue) - 1] != currentValue:
                lastValue.append(currentValue)
                print(currentValue)
    NSCRayTraceCast.WaitForCompletion()
    NSCRayTraceCast.Close()
    
    # Non-sequential component editor
    TheNCE = TheSystem.NCE
    
    DetObj = 4
    ObjCast = CastTo(TheNCE.GetObjectAt(DetObj), 'IEditorRow')
    numXPixels = int(ObjCast.GetCellAt(TheNCE.GetObjectAt(DetObj).GetObjectCell(constants.ObjectColumn_Par3).Col).Value)
    numYPixels = int(ObjCast.GetCellAt(TheNCE.GetObjectAt(DetObj).GetObjectCell(constants.ObjectColumn_Par4).Col).Value)
    pltWidth   = 2*float(ObjCast.GetCellAt(TheNCE.GetObjectAt(DetObj).GetObjectCell(constants.ObjectColumn_Par1).Col).Value)
    pltHeight  = 2 * float(ObjCast.GetCellAt(TheNCE.GetObjectAt(DetObj).GetObjectCell(constants.ObjectColumn_Par2).Col).Value)

    pix = 0
    # note that you can use either xrange(num) in 2.7 or range(num) in 3.x, but NumPy allows for cross compatibility
    
    #! [e02s03_py]
    # Get detector data
    detectorData = [[0 for x in np.arange(numYPixels)] for x in np.arange(numXPixels)]
    for x in range(0,numYPixels,1):
        for y in range(0,numXPixels,1):
            ret, pixel_val = TheNCE.GetDetectorData(DetObj,pix,1)
            pix += 1
            if ret == 1:
                detectorData[y][x] = pixel_val
            else:
                detectorData[x][y] = -1
    #! [e02s03_py]
    
    # end of default code
    # everything below here is based on numpy/matplotlib and is not supported by ZOSAPI or Zemax
    # https://docs.scipy.org/doc/numpy/index.html
    # http://matplotlib.org/
    

    # This will clean up the connection to OpticStudio.
    # Note that it closes down the server instance of OpticStudio, so you for maximum performance do not do
    # this until you need to.
    del zosapi
    zosapi = None
    
    # text output & FOR loops for OpticStudio will invert the vertical image
    # place plt.show() after clean up to release OpticStudio from memory
    plt.imshow(np.rot90(detectorData))
    plt.show()



