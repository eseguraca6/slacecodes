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
    TheSystem.New(False)

    #! [e12s01_py]
    # Select 6 wavelengths with Gaussian Quadrature algorithm
    sysWave = TheSystem.SystemData.Wavelengths
    sysWave.GaussianQuadrature(0.45, 0.65, constants.QuadratureSteps_S6)
    #! [e12s01_py]

    #! [e12s02_py]
    # Define fields using Paraxial Image Height
    sysField = TheSystem.SystemData.Fields
    sysField.SetFieldType(constants.FieldType_ParaxialImageHeight)
    #! [e12s02_py]

    # Inserts paraxial lens so there will not be an error message when using ParaxialImageHeight
    TheSystem.SystemData.Aperture.ApertureValue = 10
    s1 = TheSystem.LDE.GetSurfaceAt(1)
    s1_type = s1.GetSurfaceTypeSettings(constants.SurfaceType_Paraxial)
    s1.ChangeType(s1_type)
    s1.Thickness = 100

    #! [e12s03_py]
    # Change field 1 to be x=1.0 and y=2.0
    field1 = sysField.GetField(1)
    field1.X = 1.0
    field1.Y = 2.0
    #! [e12s03_py]

    #! [e12s04_py]
    # Change polarization axis reference to be Y
    sysPol = TheSystem.SystemData.Polarization
    sysPol.Method = constants.PolarizationMethod_YAxisMethod
    #! [e12s04_py]

    #! [e12s05_py]
    # Add Corning Catalog and remove Schott Catalog
    sysCat = TheSystem.SystemData.MaterialCatalogs
    sysCat.AddCatalog("Corning")
    sysCat.RemoveCatalog("Schott")
    #! [e12s05_py]

    #! [e12s06_py]
    # Add Title and Notes
    sysTitleNotes = TheSystem.SystemData.TitleNotes
    sysTitleNotes.Title = "Add Title Here"
    sysTitleNotes.Notes = "Add Notes Here"
    #! [e12s06_py]

    #! [e12s07_py]
    # As default Files choose: COATING.DAT, SCATTER_PROFILE.DAT, AGB_DATA.DAT
    sysFiles = TheSystem.SystemData.Files
    #sysFiles_cast = CastTo(sysFiles, "ISDFiles")
    # Note: These new files must already be present in the correct folder
    sysFiles.CoatingFile = "COATING.DAT"
    sysFiles.ScatterProfile = "SCATTER_PROFILE.DAT"
    sysFiles.ABgDataFile = "ABG_DATA.DAT"
    sysFiles.ReloadFiles()
    #! [e12s07_py]

    #! [e12s08_py]
    # Change lens units to inches
    sysUnits = TheSystem.SystemData.Units
    sysUnits.LensUnits = constants.ZemaxSystemUnits_Inches
    #! [e12s08_py]

    TheSystem.SaveAs(zosapi.TheApplication.SamplesDir + "\\API\\Python\\e12_seq_system_explorer.zmx")

    # This will clean up the connection to OpticStudio.
    # Note that it closes down the server instance of OpticStudio, so you for maximum performance do not do
    # this until you need to.
    del zosapi
    zosapi = None



