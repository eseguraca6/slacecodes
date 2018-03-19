from win32com.client.gencache import EnsureDispatch, EnsureModule
from win32com.client import CastTo, constants
import os, time

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

    if not os.path.exists(zosapi.TheApplication.ZemaxDataDir + "\\Samples\\API\\Python\\e15_Seq_Optimization"):
        os.makedirs(zosapi.TheApplication.ZemaxDataDir + "\\Samples\\API\\Python\\e15_Seq_Optimization")

    TheSystem = zosapi.TheSystem

    # ! [e15s01_py]
    # Tests if file exists & loads the correct double gauss design sample file
    if os.path.isfile(zosapi.TheApplication.SamplesDir + '\\Short course\\sc_dbga1.zmx'):
        TheSystem.LoadFile(zosapi.TheApplication.SamplesDir + '\\Short course\\sc_dbga1.zmx', False)
    else:
        TheSystem.LoadFile(
            zosapi.TheApplication.SamplesDir + '\\Short course\\Optical System Design Using OpticStudio\\sc_dbga1.zmx',
            False)
    print('Double Gauss Design:')
    # ! [e15s01_py]

    # ! [e15s02_py]
    # Define path locations
    SamplesFolder = zosapi.TheApplication.SamplesDir
    SampleFile = zosapi.TheApplication.SamplesDir + '\\API\\Python\\e15_Seq_Optimization\\OptimizedFile.ZMX'
    TheSystem.SaveAs(SampleFile)
    # ! [e15s02_py]

    # ! [e15s03_py]
    # Define System Explorer
    # Define Aperture
    SystExplorer = TheSystem.SystemData
    SystExplorer.Aperture.ApertureType = constants.ZemaxApertureType_EntrancePupilDiameter
    SystExplorer.Aperture.ApertureValue = 20
    # ! [e15s03_py]

    # ! [e15s04_py]
    # Add 3 fields
    Field_1 = SystExplorer.Fields.GetField(1)
    NewField_2 = SystExplorer.Fields.AddField(0, 5.0, 1.0)
    SystExplorer.Fields.SetFieldType(constants.FieldType_ParaxialImageHeight)
    SystExplorer.Fields.MakeEqualAreaFields(3, 21.6)
    # ! [e15s04_py]

    # ! [e15s05_py]
    # Add 3 wavelengths: F,d,C
    slPreset = SystExplorer.Wavelengths.SelectWavelengthPreset(constants.WavelengthPreset_FdC_Visible)
    # ! [e15s05_py]

    # ! [e15s06_py]
    # Open a shaded model
    analysis = TheSystem.Analyses.New_Analysis(constants.AnalysisIDM_ShadedModel)
    analysis.Terminate()
    analysis.WaitForCompletion()
    analysisSettings = analysis.GetSettings()
    cfgFile = os.environ.get('Temp') + '\\sha.cfg'
    # Save the current settings to the temp file
    settings = CastTo(analysisSettings, 'IAS_')
    settings.SaveTo(cfgFile)
    # make your modifications to it
    # MODIFYSETTINGS are defined in the ZPL help files: The Programming Tab > About the ZPL > Keywords
    settings.ModifySettings(cfgFile, 'SHA_ROTX', '90')
    settings.ModifySettings(cfgFile, 'SHA_ROTY', '0')
    settings.ModifySettings(cfgFile, 'SHA_ROTZ', '0')
    # now load in the modified settings
    settings.LoadFrom(cfgFile)
    # If you want to overwrite your default CFG, copy it after you are done modifying the settings:
    # CFG_fullname = os.environ.get('USERPROFILE') + '\\Documents\\Zemax\\Configs\\POP.CFG'
    # copyfile(cfgFile, CFG_fullname)
    # We don't need the temp file any more, so delete it
    if os.path.exists(cfgFile):
        os.remove(cfgFile)
    # Run the analysis with the new settings
    baseTool = CastTo(analysis, 'IA_')
    baseTool.ApplyAndWaitForCompletion()
    # ! [e15s06_py]

    # ! [e15s07_py]
    # remove all variables and add a F# solve on last surface radius
    TheLDE = TheSystem.LDE
    # IOpticalSystemTools
    tools = TheSystem.Tools
    tools.RemoveAllVariables()
    Surface_Last = TheLDE.GetSurfaceAt(TheLDE.NumberOfSurfaces - 2)
    Solver = Surface_Last.RadiusCell.CreateSolveType(constants.SolveType_FNumber)
    Solver._S_FNumber.FNumber = 3.1415
    Surface_Last.RadiusCell.SetSolveData(Solver)
    SampleFile = zosapi.TheApplication.SamplesDir + '\\API\\Python\\e15_Seq_Optimization\\OptimizedFile1.ZMX'
    TheSystem.SaveAs(SampleFile)
    # ! [e15s07_py]

    # ! [e15s08_py]
    # change BFL & run quick focus
    Surface_Last.Thickness = 40.0
    QFocus = tools.OpenQuickFocus()
    QFocus.Criterion = constants.QuickAdjustCriterion_SpotSizeRadial
    QFocus.UseCentroid = True
    baseTool = CastTo(QFocus, 'ISystemTool')
    baseTool.RunAndWaitForCompletion()
    baseTool.Close()
    SampleFile = zosapi.TheApplication.SamplesDir + '\\API\\Python\\e15_Seq_Optimization\\OptimizedFile2.ZMX'
    TheSystem.SaveAs(SampleFile)
    # ! [e15s08_py]

    # ! [e15s09_py]
    # setup a few variables
    tools.SetAllRadiiVariable()
    Surface1 = TheLDE.GetSurfaceAt(1)
    Surface2 = TheLDE.GetSurfaceAt(2)
    Surface5 = TheLDE.GetSurfaceAt(5)
    Surface6 = TheLDE.GetSurfaceAt(6)
    Surface9 = TheLDE.GetSurfaceAt(9)
    Surface10 = TheLDE.GetSurfaceAt(10)
    Surface11 = TheLDE.GetSurfaceAt(11)
    # ! [e15s09_py]

    # ! [e15s10_py]
    # Thickness 2, 5, 6, 9, and 11 variable
    Surface2.ThicknessCell.MakeSolveVariable()
    Surface5.ThicknessCell.MakeSolveVariable()
    Surface6.ThicknessCell.MakeSolveVariable()
    Surface9.ThicknessCell.MakeSolveVariable()
    Surface11.ThicknessCell.MakeSolveVariable()
    # ! [e15s10_py]

    # ! [e15s11_py]
    # Thickness 10 pick up from 1
    Solver = Surface10.ThicknessCell.CreateSolveType(constants.SolveType_SurfacePickup)
    SolverPickup = Solver._S_SurfacePickup
    SolverPickup.Surface = 1
    SolverPickup.ScaleFactor = 1
    SolverPickup.Column = constants.SurfaceColumn_Thickness
    Surface10.ThicknessCell.SetSolveData(Solver)
    SampleFile = zosapi.TheApplication.SamplesDir + '\\API\\Python\\e15_Seq_Optimization\\OptimizedFile3.ZMX'
    TheSystem.SaveAs(SampleFile)
    # ! [e15s11_py]

    # ! [e15s12_py]
    # define merit function
    # load merit function
    # you need to have 64-bit pywin32 to use the SEQOptimizationWizard with an error
    TheMFE = TheSystem.MFE
    OptWizard = TheMFE.SEQOptimizationWizard

    # Optimize for smallest RMS Spot, which is "Data" = 1
    OptWizard.Data = 1
    OptWizard.OverallWeight = 1
    # Gaussian Quadrature with 3 rings (refers to index number = 2)
    OptWizard.Ring = 2
    # Set air & glass boundaries
    OptWizard.IsGlassUsed = True
    OptWizard.GlassMin = 3.0
    OptWizard.GlassMax = 15.0
    OptWizard.GlassEdge = 3.0
    OptWizard.IsAirUsed = True
    OptWizard.AirMin = 0.5
    OptWizard.AirMax = 1000.0
    OptWizard.AirEdge = 0.5
    # And click OK!
    baseTool = CastTo(OptWizard, 'IWizard')
    baseTool.Apply()
    mf_filename = zosapi.TheApplication.SamplesDir + '\\API\\Python\\e15_Seq_Optimization\\RMS_Spot_Radius.mf'
    TheMFE.SaveMeritFunction(mf_filename)
    TheMFE.LoadMeritFunction(mf_filename)
    SampleFile = zosapi.TheApplication.SamplesDir + '\\API\\Python\\e15_Seq_Optimization\\OptimizedFile4.ZMX'
    TheSystem.SaveAs(SampleFile)
    # ! [e15s12_py]

    # ! [e15s13_py]
    # Run local optimization and measure time
    # Local optimization until completion
    #t = time.time()

    '''
    # run global search
    GlobalOptimTimeInSeconds = 1
    GlobalOpt = TheSystem.Tools.OpenGlobalOptimization()
    if (GlobalOpt != None):
        print(GlobalOpt.Algorithm)
        print(GlobalOpt.NumberOfCores)
        print('Global Optimization for ' + str(GlobalOptimTimeInSeconds) + ' seconds...')
        print('Initial Merit Function ', GlobalOpt.InitialMeritFunction)
        GlobalOpt.NumberToSave = constants.OptimizationSaveCount_Save_10
        baseTool = CastTo(GlobalOpt, 'ISystemTool')
        baseTool.RunAndWaitWithTimeout(1 * GlobalOptimTimeInSeconds)
        for j in range(1, 11):
            print(str(int(j)) + ': ' + str(GlobalOpt.CurrentMeritFunction(j)))
        baseTool.Cancel()
        time.sleep(1)
        baseTool.Close()
    # ! [e15s14_py]
    '''
    # ! [e15s15_py]
    # run hammer optimization
    HammerOptimTimeInSeconds = 1
    HammerOpt = TheSystem.Tools.OpenHammerOptimization()
    if (HammerOpt != None):
        print(HammerOpt.Algorithm)
        print(HammerOpt.NumberOfCores)
        print('Hammer Optimization for ' + str(HammerOptimTimeInSeconds) + ' seconds...')
        print('Initial Merit Function ', HammerOpt.InitialMeritFunction)
        baseTool = CastTo(HammerOpt, 'ISystemTool')
        baseTool.RunAndWaitWithTimeout(1 * HammerOptimTimeInSeconds)
        print('Final Merit Function ', HammerOpt.CurrentMeritFunction)

        baseTool.Cancel()
        baseTool.Close()
    # ! [e15s15_py]

    TheSystem.Save()

    # This will clean up the connection to OpticStudio.
    # Note that it closes down the server instance of OpticStudio, so you for maximum performance do not do
    # this until you need to.
    del zosapi
    zosapi = None