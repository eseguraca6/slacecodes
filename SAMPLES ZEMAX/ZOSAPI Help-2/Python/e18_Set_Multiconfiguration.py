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

    # Setup
    TheSystem = zosapi.TheSystem
    TheSystem.LoadFile(zosapi.TheApplication.SamplesDir + "\Sequential\Objectives\Double Gauss 28 degree field.zmx", False)
    TheMCE = TheSystem.MCE

    #! [e18s01_py]
    # Add 2 configurations (totally 3)
    TheMCE.AddConfiguration(False)
    TheMCE.AddConfiguration(False)
    #! [e18s01_py]

    #! [e18s02_py]
    # Add one operand (totally 2)
    TheMCE.AddOperand()
    #! [e18s02_py]

    #! [e18s03_py]
    # Get interface of each operand
    MCOperand1 = TheMCE.GetOperandAt(1)
    MCOperand2 = TheMCE.GetOperandAt(2)
    # Change both operands' type to THIC
    MCOperand1.ChangeType(constants.MultiConfigOperandType_THIC)
    MCOperand2.ChangeType(constants.MultiConfigOperandType_THIC)
    #! [e18s03_py]

    #! [e18s04_py]
    # Set parameters of operands
    # If the type of operand is THIC, the first parameter here means surface number
    MCOperand1.Param1 = 0
    MCOperand2.Param1 = 11
    #! [e18s04_py]

    #! [e18s05_py]
    # Set values of operand for each configuration
    MCOperand1.GetOperandCell(1).DoubleValue = 10000.0
    MCOperand1.GetOperandCell(2).DoubleValue = 5000.0
    MCOperand1.GetOperandCell(3).DoubleValue = 1000.0
    #! [e18s05_py]

    #! [e18s06_py]
    # Refocus for each configuration
    quickfocus = TheSystem.Tools.OpenQuickFocus()
    QFtool = CastTo(quickfocus, "ISystemTool")  # Gain access to ISystemTool methods
    TheMCE.SetCurrentConfiguration(1)  # Set system to config 1
    QFtool.RunAndWaitForCompletion()  # Quick focus for config 1
    TheMCE.SetCurrentConfiguration(2)
    QFtool.RunAndWaitForCompletion()
    TheMCE.SetCurrentConfiguration(3)
    QFtool.RunAndWaitForCompletion()
    #! [e18s06_py]

    TheSystem.SaveAs(zosapi.TheApplication.SamplesDir + "\\API\\Python\\e18_Double_Gauss_28_degree_field_MultiConfig.zmx")

    #! [e18s07_py]
    # An example of manually "Make Thermal"
    TheSystem.LoadFile(zosapi.TheApplication.SamplesDir + "\Sequential\Objectives\Doublet.zmx", False)
    # Add 1 configuration (totally 2)
    TheMCE.AddConfiguration(False)
    # Add 12 operands (totally 13)
    for i in range(0, 12):
        TheMCE.AddOperand()
    # Create an operand type array and later we will input the array into MCE with a for loop
    operandType = [constants.MultiConfigOperandType_TEMP, constants.MultiConfigOperandType_PRES,
                   constants.MultiConfigOperandType_CRVT, constants.MultiConfigOperandType_THIC,
                   constants.MultiConfigOperandType_GLSS, constants.MultiConfigOperandType_SDIA,
                   constants.MultiConfigOperandType_CRVT, constants.MultiConfigOperandType_THIC,
                   constants.MultiConfigOperandType_GLSS, constants.MultiConfigOperandType_SDIA,
                   constants.MultiConfigOperandType_CRVT, constants.MultiConfigOperandType_THIC,
                   constants.MultiConfigOperandType_SDIA]
    # Set parameter 1 for each config operand
    param1value = [1, 1, 1, 1, 2, 2, 2, 2, 3, 3, 3]
    for i in range(0, 11):
        TheMCE.GetOperandAt(i+3).Param1 = param1value[i]

    # Set type for each config operand
    for i in range(13):
        TheMCE.GetOperandAt(i+1).ChangeType(operandType[i])

    # Set thermal pickup solves
    ThermalPickupSolve = TheMCE.GetOperandAt(1).GetOperandCell(1).CreateSolveType(constants.SolveType_ThermalPickup)
    ThermalPickupSolve._S_ThermalPickup.Configuration = 1
    ThermalPickup_num = [3, 4, 6, 7, 8, 10, 11, 12, 13]
    for i in ThermalPickup_num:
        TheMCE.GetOperandAt(i).GetOperandCell(2).SetSolveData(ThermalPickupSolve)

    # Set Pickup Solve
    ConfigPickupSolve = TheMCE.GetOperandAt(1).GetOperandCell(1).CreateSolveType(constants.SolveType_ConfigPickup)
    ConfigPickupSolve._S_ConfigPickup.Configuration = 1
    GLSSops = [5, 9]  # Operands 5 and 9 are GLSS operands
    for i in GLSSops:
        ConfigPickupSolve._S_ConfigPickup.Operand = i  # Set pickup solve's "operand" value to pickup from correct place
        TheMCE.GetOperandAt(i).GetOperandCell(2).SetSolveData(ConfigPickupSolve)  # apply solve for operands 5 and 9

    # Set temperature of configuration 2 to 100 degrees
    TheMCE.GetOperandAt(1).GetOperandCell(2).DoubleValue = 100
    TheSystemData = TheSystem.SystemData
    TheSystemData.Environment.AdjustIndexToEnvironment = True

    TheSystem.SaveAs(zosapi.TheApplication.SamplesDir + "\\API\\Python\\e18_Doublet_MakeTermal.zmx")
    #! [e18s07_py]


    # This will clean up the connection to OpticStudio.
    # Note that it closes down the server instance of OpticStudio, so you for maximum performance do not do
    # this until you need to.
    del zosapi
    zosapi = None



