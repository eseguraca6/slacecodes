from win32com.client.gencache import EnsureDispatch, EnsureModule
from win32com.client import CastTo, constants
import os
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

    TheSystem = zosapi.TheSystem
    TheApplication = zosapi.TheApplication

    # Set up primary optical system
    sampleDir = TheApplication.SamplesDir
    file = "Double Gauss 28 degree field.zmx"
    testFile = sampleDir + "\\Samples\\Sequential\\Objectives\\" + file
    TheSystem.LoadFile(testFile, False)

    #! [e22s01_py]
    # Set up Batch Ray Trace
    raytrace = TheSystem.Tools.OpenBatchRayTrace()
    nsur = TheSystem.LDE.NumberOfSurfaces
    max_rays = 30
    normUnPolData = raytrace.CreateNormUnpol((max_rays + 1) * (max_rays + 1), constants.RaysType_Real, nsur)
    #! [e22s01_py]

    #! [e22s02_py]
    # Define batch ray trace constants
    hx = 0.0
    max_wave = TheSystem.SystemData.Wavelengths.NumberOfWavelengths
    num_fields = TheSystem.SystemData.Fields.NumberOfFields
    hy_ary = np.array([0, 0.707, 1])
    #! [e22s02_py]

    # Initialize x/y image plane arrays
    x_ary = np.empty((num_fields, max_wave, ((max_rays + 1) * (max_rays + 1))))
    y_ary = np.empty((num_fields, max_wave, ((max_rays + 1) * (max_rays + 1))))

    #! [e22s03_py]
    # Determine maximum field in Y only
    max_field = 0.0
    for i in range(1, num_fields + 1):
        if (TheSystem.SystemData.Fields.GetField(i).Y > max_field):
            max_field = TheSystem.SystemData.Fields.GetField(i).Y

    plt.rcParams["figure.figsize"] = (15, 4)
    colors = ('b', 'g', 'r', 'c', 'm', 'y', 'k')

    if TheSystem.SystemData.Fields.GetFieldType() == constants.FieldType_Angle:
        field_type = 'Angle'
    elif TheSystem.SystemData.Fields.GetFieldType() == constants.FieldType_ObjectHeight:
        field_type = 'Height'
    elif TheSystem.SystemData.Fields.GetFieldType() == constants.FieldType_ParaxialImageHeight:
        field_type = 'Height'
    elif TheSystem.SystemData.Fields.GetFieldType() == constants.FieldType_RealImageHeight:
        field_type = 'Height'

    #tic
    for field in range(1, len(hy_ary) + 1):
        plt.subplot(1, 3, field, aspect='equal').set_title('Hy: %.2f (%s)' % (hy_ary[field - 1] * max_field, field_type))

        for wave in range(1, max_wave + 1):

            #! [e22s04_py]
            # Adding Rays to Batch, varying normalised object height hy
            normUnPolData.ClearData()
            waveNumber = wave
            #for i = 1:((max_rays + 1) * (max_rays + 1))
            for i in range(1, (max_rays + 1) * (max_rays + 1) + 1):

                px = np.random.random() * 2 - 1
                py = np.random.random() * 2 - 1

                while (px*px + py*py > 1):
                    py = np.random.random() * 2 - 1
                normUnPolData.AddRay(waveNumber, hx, hy_ary[field - 1], px, py, constants.OPDMode_None)
            #! [e22s04_py]

            baseTool = CastTo(raytrace, 'ISystemTool')
            baseTool.RunAndWaitForCompletion()

            #! [e22s05_m]
            # Read batch raytrace and display results
            normUnPolData.StartReadingResults()
            output = normUnPolData.ReadNextResult()

            while output[0]:                                                    # success
                if ((output[2] == 0) and (output[3] == 0)):                     # ErrorCode & vignetteCode
                    x_ary[field - 1, wave - 1, output[1] - 1] = output[4]   # X
                    y_ary[field - 1, wave - 1, output[1] - 1] = output[5]   # Y
                output = normUnPolData.ReadNextResult()
            #! [e22s05_m]
            temp = plt.plot(np.squeeze(x_ary[field - 1, wave - 1, :]), np.squeeze(y_ary[field - 1, wave - 1, :]), '.', ms = 1, color = colors[wave - 1])


    #toc
    plt.suptitle('Spot Diagram: %s' % (os.path.basename(testFile)))
    plt.subplots_adjust(wspace=0.8)
    plt.draw()

    #! [e22s06_py]
    # Spot Diagram Analysis Results
    spot = TheSystem.Analyses.New_Analysis(constants.AnalysisIDM_StandardSpot)
    spot_setting = spot.GetSettings()
    baseSetting = CastTo(spot_setting, 'IAS_Spot')
    baseSetting.Field.SetFieldNumber(0)
    baseSetting.Wavelength.SetWavelengthNumber(0)
    baseSetting.ReferTo = constants.ReferTo_Centroid
    #! [e22s06_py]

    #! [e22s07_py]
    # extract RMS & Geo spot size for field points
    base = CastTo(spot, 'IA_')
    base.ApplyAndWaitForCompletion()
    #spot_results = spot.GetResults()
    spot_results = base.GetResults()
    print('RMS radius: %6.3f  %6.3f  %6.3f' % (spot_results.SpotData.GetRMSSpotSizeFor(1, 1), spot_results.SpotData.GetRMSSpotSizeFor(2, 1), spot_results.SpotData.GetRMSSpotSizeFor(3, 1)))
    print('GEO radius: %6.3f  %6.3f  %6.3f' % (spot_results.SpotData.GetGeoSpotSizeFor(1, 1), spot_results.SpotData.GetGeoSpotSizeFor(2, 1), spot_results.SpotData.GetGeoSpotSizeFor(3, 1)))
    #! [e22s07_py]



    # This will clean up the connection to OpticStudio.
    # Note that it closes down the server instance of OpticStudio, so you for maximum performance do not do
    # this until you need to.
    del zosapi
    zosapi = None

    # place plt.show() after clean up to release OpticStudio from memory
    plt.show()