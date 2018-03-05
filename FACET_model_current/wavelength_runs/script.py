from win32com.client.gencache import EnsureDispatch, EnsureModule
from win32com.client import CastTo, constants


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

    # Insert Code Here
    TheSystem = zosapi.TheSystem
    TheSystem.New(False)
    file = r'C:\Users\pwfa-facet2\Desktop\slacecodes\FACET_model_current\wavelength_runs\test.zmx';#
    TheSystem.LoadFile(file, False)


    TheAnalyses = TheSystem.Analyses
    TheLDE = TheSystem.LDE



    POP = TheAnalyses.New_Analysis(constants.AnalysisIDM_PhysicalOpticsPropagation)
    POP.Terminate()
    POP_Setting = POP.GetSettings()
    pop_settings = CastTo(POP_Setting, "IAS_")

    cfg = r'C:\Users\pwfa-facet2\Documents\Zemax\Configs\POP.CFG'
    pop_settings.ModifySettings(cfg, "POP_START",2)
    pop_settings.ModifySettings(cfg, "POP_SAMPX", 5)
    pop_settings.ModifySettings(cfg, "POP_SAMPY", 5)
    pop_settings.ModifySettings(cfg, "POP_PARAM1", 1)
    pop_settings.ModifySettings(cfg, "POP_PARAM2", 1)
    pop_settings.ModifySettings(cfg, "POP_AUTO", 1)

    pop_settings.LoadFrom(cfg)

    for i in range(5,10):
        pop_settings.ModifySettings(cfg, "POP_END", i)
        POP.ApplyAndWaitForCompletion()
        pop_results = POP.GetResults()
        pop_results.GetTextFile(r'C:\Users\pwfa-facet2\Desktop\slacecodes\FACET_model_current\wavelength_runs\results_matlab\test_r'+str(i)+'.csv')


    # This will clean up the connection to OpticStudio.
    # Note that it closes down the server instance of OpticStudio, so you for maximum performance do not do
    # this until you need to.
del zosapi
zosapi = None