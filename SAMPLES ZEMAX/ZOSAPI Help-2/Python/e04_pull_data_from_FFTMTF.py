from __future__ import print_function
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

    # written with ZOSAPI 16.5, 20161019, MRH
    # use http://matplotlib.org/ to plot line graph
    # need to install this package before running this code

    # Set up primary optical system
    TheSystem = zosapi.TheSystem
    TheApplication = zosapi.TheApplication
    sampleDir = TheApplication.SamplesDir
    # Open file
    #file = 'Cooke 40 degree field.zmx'
    #testFile = sampleDir + '\\Sequential\\Objectives\\' + file
    
    testFile = sampleDir + '\\Sequential\\Objectives\\Cooke 40 degree field.zmx'
    TheSystem.LoadFile(testFile, False)

    # Create analysis
    TheAnalyses = TheSystem.Analyses
    newWin = TheAnalyses.New_FftMtf()
    # Settings
    newWin_Settings = newWin.GetSettings()
    newWin_SettingsCast = CastTo(newWin_Settings,'IAS_FftMtf')
    newWin_SettingsCast.MaximumFrequency = 80
    newWin_SettingsCast.SampleSize = constants.SampleSizes_S_256x256
    # Run Analysis
    newWin.ApplyAndWaitForCompletion()

    # Get Analysis Results
    newWin_Results = newWin.GetResults()
    newWin_ResultsCast = CastTo(newWin_Results,'IAR_')

    # Read and plot data series
    # NOTE: numpy functions are used to unpack and plot the 2D tuple for Sagittal & Tangential MTF
    # You will need to import the numpy module to get this part of the code to work
    colors = ('b','g','r','c', 'm', 'y', 'k')
    for seriesNum in range(0,newWin_ResultsCast.NumberOfDataSeries,1):
        data = newWin_ResultsCast.GetDataSeries(seriesNum)
        x = np.array(data.XData.Data)
        y = np.array(data.YData.Data)

        plt.plot(x[:],y[:,0],color=colors[seriesNum])
        plt.plot(x[:],y[:,1],linestyle='--',color=colors[seriesNum])

    # format the plot
    plt.title('FFT MTF: ' + os.path.basename(testFile))
    plt.xlabel('Spatial Frequency in cycles per mm')
    plt.ylabel('Modulus of the OTF')
    plt.legend([r'$0^\circ$ tangential',r'$0^\circ$ sagittal',r'$14^\circ$ tangential',r'$14^\circ$ sagittal',r'$20^\circ$ tangential',r'$20^\circ$ sagittal'])
    plt.grid(True)

    # This will clean up the connection to OpticStudio.
    # Note that it closes down the server instance of OpticStudio, so you for maximum performance do not do
    # this until you need to.
    del zosapi
    zosapi = None
    
    # place plt.show() after clean up to release OpticStudio from memory
    plt.show()


