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


# make sure the Python wrappers are available for the COM client and
# interfaces
EnsureModule('ZOSAPI_Interfaces', 0, 16, 0)
EnsureModule('ZOSAPI', 0, 16, 0)
# Note - the above can also be accomplished using 'makepy.py' in the
# following directory:
#      {PythonEnv}\Lib\site-packages\wind32com\client\
# Also note that the generate wrappers do not get refreshed when the
# COM library changes.
# To refresh the wrappers, you can manually delete everything in the
# cache directory:
#	   {PythonEnv}\Lib\site-packages\win32com\gen_py\*.*

TheConnection = EnsureDispatch("ZOSAPI.ZOSAPI_Connection")
if TheConnection is None:
    raise Exception("Unable to intialize COM connection to ZOSAPI")

TheApplication = TheConnection.ConnectAsExtension(0)
if TheApplication is None:
    raise Exception("Unable to acquire ZOSAPI application")

if TheApplication.IsValidLicenseForAPI == False:
    raise Exception("License is not valid for ZOSAPI use")

TheSystem = TheApplication.PrimarySystem
if TheSystem is None:
    raise Exception("Unable to acquire Primary system")

print('Connected to OpticStudio')

# The connection should now be ready to use.  For example:
print('Serial #: ', TheApplication.SerialCode)

# Insert Code Here

TheSystem.New(False)
file = '/mnt/c/Users/pwfa-facet2/Desktop/slacecodes/FACET_model_current/wavelength_runs/dtransport.zmx'
TheSystem.LoadFile(file, False)


TheAnalyses = TheSystem.Analyses
TheLDE = TheSystem.LDE



POP = TheAnalyses.New_Analysis(constants.AnalysisIDM_PhysicalOpticsPropagation)
POP.Terminate()
POP_Setting = POP.GetSettings()
pop_settings = CastTo(POP_Setting, "IAS_")



cfg = POP.GetSettings().LoadFrom(r'C:\Users\pwfa-facet2\Documents\Zemax\Configs\POP.CFG')
pop_settings.ModifySettings(cfg, 'POP_BEAMTYPE', 0)
pop_settings.ModifySettings(cfg, 'POP_SAMPX', 3)
pop_settings.ModifySettings(cfg, 'POP_SAMPY', 3)

pop_settings.ModifySettings(cfg, 'POP_PARAM1', 1)
pop_settings.ModifySettings(cfg, 'POP_PARAM1', 1)
pop_settings.ModifySettings(cfg, 'POP_AUTO', 1)



for i in range(2, 5):
        print(i)
        pop_settings.ModifySettings(cfg, 'POP_START', 2)
        pop_settings.ModifySettings(cfg, 'POP_END', i)


        out_file = (r'C:\Users\pwfa-facet2\Desktop\slacecodes\FACET_model_current\wavelength_runs\results_matlab\test_POP'+str(i)+'.TXT')

        POP.ApplyAndWaitForCompletion()
        POP_results = POP.GetResults()
        POP_results.GetTextFile(out_file)

