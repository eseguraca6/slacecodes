from win32com.client.gencache import EnsureDispatch, EnsureModule
from win32com.client import CastTo, constants
import os, time, sys

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

    # written with ZOSAPI 16.5, 20161019, MRH

    # Set up primary optical system
    TheSystem = zosapi.TheSystem
    TheApplication = zosapi.TheApplication
    sampleDir = TheApplication.SamplesDir
    
    # creates a new API directory
    if not os.path.exists(zosapi.TheApplication.SamplesDir + "\\API\\Python"):
        os.makedirs(zosapi.TheApplication.SamplesDir + "\\API\\Python")
    
    #! [e03s01_py]
    # Open file
    testFile = sampleDir + '\\API\\Python\\e01_new_file_and_quickfocus.zmx'
    if not os.path.exists(testFile):
        # closes connection to ZOS; normally done at end of script
        del zosapi
        zosapi = None
        sys.exit('You need to run Example 01 before running this example')
    TheSystem.LoadFile(testFile, False)
    testFile2 = sampleDir + '\\API\\Python\\e03_open_file_and_optimise.zmx'
    TheSystem.SaveAs(testFile2)
    #! [e03s01_py]
    
    #! [e03s02_py]
    # Get Surfaces
    TheLDE = TheSystem.LDE
    Surface_1 = TheLDE.GetSurfaceAt(1)
    Surface_2 = TheLDE.GetSurfaceAt(2)
    Surface_3 = TheLDE.GetSurfaceAt(3)
    #! [e03s02_py]
    
    #! [e03s03_py]
    # Make thicknesses and radii variable
    Surface_1.ThicknessCell.MakeSolveVariable()
    Surface_2.ThicknessCell.MakeSolveVariable()
    Surface_2.RadiusCell.MakeSolveVariable()
    Surface_3.ThicknessCell.MakeSolveVariable()
    #! [e03s03_py]
    
    #! [e03s04_py]
    # Merit functions
    TheMFE = TheSystem.MFE
    Operand_1 = TheMFE.GetOperandAt(1)
    Operand_1.ChangeType(constants.MeritOperandType_ASTI)
    Operand_1.Target = 0.0
    Operand_1.Weight = 10.0
    #! [e03s04_py]
    
    Operand_2 = TheMFE.InsertNewOperandAt(2)
    Operand_2.ChangeType(constants.MeritOperandType_COMA)
    Operand_2.Target = 0.0
    Operand_2.Weight = 1.0
    
    #Air min / max
    Operand_3 = TheMFE.AddOperand()
    Operand_3.ChangeType(constants.MeritOperandType_MNCA)
    Operand_3.Target = 0.5
    Operand_3.Weight = 1.0
    Operand_3Cast = CastTo(Operand_3, 'IEditorRow')
    Operand_3Cast.GetCellAt(2).IntegerValue = 1
    Operand_3Cast.GetCellAt(3).IntegerValue = 3
    Operand_4 = TheMFE.AddOperand()
    Operand_4.ChangeType(constants.MeritOperandType_MXCA)
    Operand_4.Target = 1000
    Operand_4.Weight = 1.0
    Operand_4Cast = CastTo(Operand_4, 'IEditorRow')
    Operand_4Cast.GetCellAt(2).IntegerValue = 1
    Operand_4Cast.GetCellAt(3).IntegerValue = 3
    Operand_5 = TheMFE.AddOperand()
    Operand_5.ChangeType(constants.MeritOperandType_MNEA)
    Operand_5.Target = 0.5
    Operand_5.Weight = 1.0
    Operand_5Cast = CastTo(Operand_5,'IEditorRow')
    Operand_5Cast.GetCellAt(2).IntegerValue = 1
    Operand_5Cast.GetCellAt(3).IntegerValue = 3
    
    # Material min / max
    Operand_6 = TheMFE.AddOperand()
    Operand_6.ChangeType(constants.MeritOperandType_MNCG)
    Operand_6.Target = 3.0
    Operand_6.Weight = 1.0
    Operand_6Cast = CastTo(Operand_6, 'IEditorRow')
    Operand_6Cast.GetCellAt(2).IntegerValue = 1
    Operand_6Cast.GetCellAt(3).IntegerValue = 3
    Operand_7 = TheMFE.AddOperand()
    Operand_7.ChangeType(constants.MeritOperandType_MXCG)
    Operand_7.Target = 15.0
    Operand_7.Weight = 1.0
    Operand_7Cast = CastTo(Operand_7,'IEditorRow')
    Operand_7Cast.GetCellAt(2).IntegerValue = 1
    Operand_7Cast.GetCellAt(3).IntegerValue = 3
    Operand_8 = TheMFE.AddOperand()
    Operand_8.ChangeType(constants.MeritOperandType_MNEG)
    Operand_8.Target = 3.0
    Operand_8.Weight = 1.0
    Operand_8Cast = CastTo(Operand_8,'IEditorRow')
    Operand_8Cast.GetCellAt(2).IntegerValue = 1
    Operand_8Cast.GetCellAt(3).IntegerValue = 3
    
    #! [e03s05_py]
    # Local optimisation till completion
    print('Running Local Optimization')
    LocalOpt = TheSystem.Tools.OpenLocalOptimization()
    LocalOpt.Algorithm = constants.OptimizationAlgorithm_DampedLeastSquares
    LocalOpt.Cycles = constants.OptimizationCycles_Automatic
    LocalOpt.NumberOfCores = 8
    LocalOptCast = CastTo(LocalOpt,'ISystemTool')
    LocalOptCast.RunAndWaitForCompletion()
    LocalOptCast.Close()
    #! [e03s05_py]
    
    #! [e03s06_py]
    # Hammer for 10 seconds
    # need to 'import time' at the top of the file to use the pause function
    print('Running Hammer Optimization')
    HammerOpt = TheSystem.Tools.OpenHammerOptimization()
    HammerOptCast = CastTo(HammerOpt,'ISystemTool')
    HammerOptCast.Run()
    time.sleep(10)
    HammerOptCast.Cancel()
    HammerOptCast.Close()
    #! [e03s06_py]
    
    #Save and close
    TheSystem.Save()

    # This will clean up the connection to OpticStudio.
    # Note that it closes down the server instance of OpticStudio, so you for maximum performance do not do
    # this until you need to.
    del zosapi
    zosapi = None



