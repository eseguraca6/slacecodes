from win32com.client.gencache import EnsureDispatch, EnsureModule
from win32com.client import CastTo, constants
import os, time
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

    TheSystem = zosapi.TheSystem
    TheApplication = zosapi.TheApplication

    # Set up primary optical system
    sampleDir = TheApplication.SamplesDir
    testFile = sampleDir + "\\Sequential\\Objectives\\Double Gauss 28 degree field.zmx"
    TheSystem.LoadFile(testFile, False)

    max_rays = 150
    #! [e23s01_py]
    max_field = 0
    for i in range(1,TheSystem.SystemData.Fields.NumberOfFields + 1):
        if TheSystem.SystemData.Fields.GetField(i).Y > max_field:
            max_field = TheSystem.SystemData.Fields.GetField(i).Y
    #! [e23s01_py]

    max_num_field = TheSystem.SystemData.Fields.NumberOfFields

    # sets up plot
    plt.close('all')
    plt.rcParams["figure.figsize"] = (15, 8)
    colors = ('b', 'g', 'r', 'c', 'm', 'y', 'k')

    tic = time.time()

    #! [e23s02_py]
    # Set up Batch Ray Trace
    raytrace = TheSystem.Tools.OpenBatchRayTrace()
    nsur = TheSystem.LDE.NumberOfSurfaces
    normUnPolData = raytrace.CreateNormUnpol(max_rays + 1, constants.RaysType_Real, nsur)
    #! [e23s02_py]

    #! [e23s03_py]
    # define batch ray trace constants
    hx = 0
    # since python doesn't include STOP number in range, need to use STOP value slightly more than 1
    py_ary = np.arange(0, 1.0001, 1 / max_rays) * 2 - 1
    px = 0
    max_wave = TheSystem.SystemData.Wavelengths.NumberOfWavelengths
    #! [e23s03_py]

    # initilize x/y image plane arrays
    y_ary = np.zeros((max_num_field + 1, max_wave + 1, max_rays + 1))

    #! [e23s04_py]
    # image surface number and primary wavelength
    nsur = TheSystem.LDE.NumberOfSurfaces
    pwav = 0
    for a in range(1, TheSystem.SystemData.Wavelengths.NumberOfWavelengths + 1):
        if TheSystem.SystemData.Wavelengths.GetWavelength(a).IsPrimary == 1:
            pwav = a

    # creates array of Y coordinate chief ray values
    chief_ary = np.zeros(max_num_field)
    for field in range(1, max_num_field + 1):
        #hy = TheSystem.SystemData.Fields.GetField(field).Y / max_field
        hy = 1 if max_field == 0 else TheSystem.SystemData.Fields.GetField(field).Y / max_field
        # gets single value without using MFE (see ZPL OPEV)
        chief_ary[field - 1] = TheSystem.MFE.GetOperandValue(constants.MeritOperandType_REAY, nsur, pwav, 0, hy , 0, 0, 0, 0)
    # ! [e23s04_py]

    # setup plot
    for field in range(1, max_num_field + 1):
        plt.subplot(2, max_num_field, field + max_num_field)
        hy = 1 if max_field == 0 else TheSystem.SystemData.Fields.GetField(field).Y / max_field

        for wave in range(1, max_wave + 1):
            #! [e23s05_py]
            # Adding Rays to Batch, varying normalized object height hy
            normUnPolData.ClearData()
            for i in range(0, max_rays + 1):
                py = py_ary[i]
                normUnPolData.AddRay(wave, hx, hy, px, py, constants.OPDMode_None)
            #! [e23s05_py]

            #! [e23s06_py]
            # Run Batch Ray Trace
            CastTo(raytrace, 'ISystemTool').RunAndWaitForCompletion()
            #! [e23s06_py]

            #! [e23s07_py]
            # Read and display results
            normUnPolData.StartReadingResults()
            output = normUnPolData.ReadNextResult()
            while output[0]:
                if (output[2] == 0 and output[3] == 0):
                    y_ary[field, wave, output[1] - 1] = output[5]
                output = normUnPolData.ReadNextResult()
            plt.plot(py_ary[:], np.squeeze((y_ary[field, wave,:] - chief_ary[field - 1]) * 1000), '-', ms = 4)
            #! [e23s07_py]
    CastTo(raytrace, 'ISystemTool').Close()
    manual = round(time.time() - tic, 3)

    tic = time.time()

    #! [e23s08_py]
    ray = TheSystem.Analyses.New_Analysis(constants.AnalysisIDM_RayFan)
    ray_settings = ray.GetSettings()
    settings = CastTo(ray_settings, 'IAS_Fan')
    settings.NumberOfRays = max_rays / 2
    settings.Field.UseAllFields()
    settings.Wavelength.UseAllWavelengths()

    ray.ApplyAndWaitForCompletion()
    ray_results = ray.GetResults()
    #! [e23s08_py]

    results = CastTo(ray_results, 'IAR_')

    for field in range(1, max_num_field + 1):
        #! [e23s09_py]
        # Read and display results
        plt.subplot(2, max_num_field, field)
        x = results.GetDataSeries(field * 2 - 2).XData.Data
        y = results.GetDataSeries(field * 2 - 2).YData.Data

        plt.plot(x, y)
        hy = 1 if max_field == 0 else TheSystem.SystemData.Fields.GetField(field).Y / max_field
        plt.title('Field: %4.3f' % (hy))
        #! [e23s09_py]

    native = round(time.time() - tic, 3)

    print('Tracing ' + str(max_rays + 1) + ' number of rays')
    print('Elapsed time is ' + str(native) + ' seconds with native code')
    print('Elapsed time is ' + str(manual) + ' seconds with manual code')
    print('The native code is ' + str(round((manual - native) / native * 100, 2)) + '% faster')

    plt.subplot(2, max_num_field, 1)
    plt.ylabel('Native Code (%.3fs)' % (native))
    plt.subplot(2, max_num_field, max_num_field + 1)
    plt.ylabel('Manual Code (%.3fs)' % (manual))

    plt.subplots_adjust(wspace=0.5)



    # This will clean up the connection to OpticStudio.
    # Note that it closes down the server instance of OpticStudio, so you for maximum performance do not do
    # this until you need to.
    del zosapi
    zosapi = None

    # place plt.show() after clean up to release OpticStudio from memory
    plt.show()