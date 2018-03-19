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

    # This code build a chain of prisms based on the KB article:
    # http://zemax.com/os/resources/learn/knowledgebase/how-to-work-in-global-coordinates-in-a-sequential
    TheSystem = zosapi.TheSystem
    TheSystem.New(False)

    #! [e19s01_py]
    # ISystemData represents the System Explorer in GUI.
    # We access options in System Explorer through ISystemData in ZOS-API
    TheSystemData = TheSystem.SystemData
    TheSystemData.Aperture.ApertureValue = 10
    TheSystemData.Aperture.AFocalImageSpace = True
    TheSystemData.Wavelengths.GetWavelength(1).Wavelength = 0.55
    #! [e19s01_py]

    #! [e19s02_py]
    # Get interface of Lens Data Editor and add 3 surfaces.
    TheLDE = TheSystem.LDE
    TheLDE.InsertNewSurfaceAt(2)
    TheLDE.InsertNewSurfaceAt(2)
    TheLDE.InsertNewSurfaceAt(2)

    # Set thickness and material for each surface.
    TheLDE.GetSurfaceAt(1).Thickness = 30
    TheLDE.GetSurfaceAt(2).Thickness = 20
    TheLDE.GetSurfaceAt(4).Thickness = 30
    TheLDE.GetSurfaceAt(2).Material = 'N-BK7'
    #! [e19s02_py]
    
    #! [e19s03_py]
    # GetSurfaceAt(surface number shown in LDE) will return an interface ILDERow
    # Through property TiltDecenterData of each interface ILDERow, we can modify data in Surface Properties > Tilt/Decenter section
    TheLDE.GetSurfaceAt(2).TiltDecenterData.BeforeSurfaceOrder = constants.TiltDecenterOrderType_Decenter_Tilt
    TheLDE.GetSurfaceAt(2).TiltDecenterData.BeforeSurfaceTiltX = 15
    TheLDE.GetSurfaceAt(2).TiltDecenterData.AfterSurfaceTiltX = -15
    TheLDE.GetSurfaceAt(3).TiltDecenterData.BeforeSurfaceTiltX = -15
    TheLDE.GetSurfaceAt(3).TiltDecenterData.AfterSurfaceTiltX = 15
    #! [e19s03_py]

    #! [e19s04_py]
    # To specify an aperture to a surface, we need to first create an ISurfaceApertureType and then assign it.
    Rect_Aper = TheLDE.GetSurfaceAt(2).ApertureData.CreateApertureTypeSettings(constants.SurfaceApertureTypes_RectangularAperture)
    Rect_Aper._S_RectangularAperture.XHalfWidth = 10
    Rect_Aper._S_RectangularAperture.YHalfWidth = 10
    TheLDE.GetSurfaceAt(2).ApertureData.ChangeApertureTypeSettings(Rect_Aper)
    TheLDE.GetSurfaceAt(3).ApertureData.PickupFrom = 2
    #! [e19s04_py]
    
    #! [e19s05_py]
    # To change surface type, we need to first get an ISurfaceTypesettings and then assign it.
    SurfaceType_CB = TheLDE.GetSurfaceAt(4).GetSurfaceTypeSettings(constants.SurfaceType_CoordinateBreak)
    TheLDE.GetSurfaceAt(4).ChangeType(SurfaceType_CB)
    #! [e19s05_py]

    #! [e19s06_py]
    # Set Chief Ray solves to surface 4, which is Coordinate Break
    # To set a solve to a cell in editor, we need to first create a ISolveData and then assign it.
    Solve_ChiefNormal = TheLDE.GetSurfaceAt(4).GetSurfaceCell(constants.SurfaceColumn_Par1).CreateSolveType(constants.SolveType_PickupChiefRay)
    TheLDE.GetSurfaceAt(4).GetSurfaceCell(constants.SurfaceColumn_Par1).SetSolveData(Solve_ChiefNormal)
    TheLDE.GetSurfaceAt(4).GetSurfaceCell(constants.SurfaceColumn_Par2).SetSolveData(Solve_ChiefNormal)
    TheLDE.GetSurfaceAt(4).GetSurfaceCell(constants.SurfaceColumn_Par3).SetSolveData(Solve_ChiefNormal)
    TheLDE.GetSurfaceAt(4).GetSurfaceCell(constants.SurfaceColumn_Par4).SetSolveData(Solve_ChiefNormal)
    TheLDE.GetSurfaceAt(4).GetSurfaceCell(constants.SurfaceColumn_Par5).SetSolveData(Solve_ChiefNormal)
    #! [e19s06_py]

    #! [e19s07_py]
    # Copy 3 surfaces starting from surface number 2 in LDE and paste to surface number 5, which will become surface number 8 after pasting.
    for i in range(10):
        TheLDE.CopySurfaces(2, 3, 5)
    # Save file
    TheSystem.SaveAs(zosapi.TheApplication.SamplesDir + '\\API\\Python\\e19_Sample_Prism_Chain.ZMX')
    #! [e19s07_py]

    #! [e19s08_py]
    # Run tool Convert Local To Global Coordinates to convert surface #2 to surface #35 to be globally referenced to surface #1
    TheLDE.RunTool_ConvertLocalToGlobalCoordinates(2, 35, 1)
    TheSystem.SaveAs(zosapi.TheApplication.SamplesDir + '\\API\\Python\\e19_Sample_Prism_Chain_GlobalCoordinate.ZMX')
    #! [e19s08_py]

    #! [e19s09_py]
    # Run tool Conver Global To Local Coordinates to convert surface #1 to surface #57 back to local coordinate.
    TheLDE.RunTool_ConvertGlobalToLocalCoordinates(1, 57, constants.ConversionOrder_Forward)
    TheSystem.SaveAs(zosapi.TheApplication.SamplesDir + '\\API\\Python\\e19_Sample_Prism_Chain_BackTo_LocalCoordinate.ZMX')
    #! [e19s09_py]

    # This will clean up the connection to OpticStudio.
    # Note that it closes down the server instance of OpticStudio, so you for maximum performance do not do
    # this until you need to.
    del zosapi
    zosapi = None