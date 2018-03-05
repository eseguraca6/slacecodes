% ZEMAX DDE Server and Optronics Toolbox
%
% ZEMAX DDE Server and Optronics Toolbox Version 3
% ZEMAX DDE functions provide access to ZEMAX functionality from Matlab.
% NOTE : The ZEMAX DDE server maintains an independent copy of the lens from the Lens Data Editor (LDE).
%        See zPushLens and zGetRefresh for moving lens data between the DDE server and the LDE.
% For further details, see the chapter on "ZEMAX Extensions" in the ZEMAX manual.
%
% Before calling any functions that access the ZEMAX DDE server, it is imperative to initialise the DDE link
% using the zDDEInit function. Failure to do so will cause Matlab to CRASH immediately without useful 
% diagnostics the first time you call a DDE function.
%
% All rights reserved.
%
%% BSD Licence
% This toolbox is subject to the terms and conditions of the BSD licence,
% or the GPL Licence as stated in individual files.
% For further details, see the file BSDlicence.txt
%
% Report bugs and updates to dgriffith@csir.co.za
%
% List of Functions - Function names are case sensitive.
%
%% Atmosphere, Sun and Astronomy
%   Airmass - compute airmass at particular elevation using various formulae
%   AirmassTest - Script to illustrate and test the Airmass function
%   MoshierEphem - Compute ephemerides for sun, moon, planets and stars
%   MoshierEphemExample1 - Example script for MoshierEphem
%   MoshierMoon - Compute lunar ephemeris with additional data
%   MoshierMoonExample1 - Example script for MoshierMoon
%   ReadMODTRANfl7 - Read MODTRAN (3.7) output from a '.fl7' (tape7 format) file.
%   ReadSMARTSInput - Read an input file intended for SMARTS.
%   CheckSMARTSInput - Perform basic check on SMARTS input data.
%   DisplaySMARTSInput - Display the field data in a SMARTS input deck.
%   PlotSMARTSOutput - Plot output from the SMARTS model.
%   ReadSMARTSInputTest - This script reads all the SMARTS 2.9.5 example cases.
%   ReadSMARTSInputText - Read the input text file for SMARTS 2.9.5
%   ReadSMARTSOutput - Read .ext.txt data from SMARTS solar irradiance code.
%   ReadSMARTSSpectrum - Read a SMARTS extraterrestial solar spectrum.
%   RunSMARTS - Run the SMARTS solar irradiance code.
%   SMARTSTest - This script reads, tweaks, runs and displays results from the SMARTS example cases.
%   ScriptSMARTSInput - Write a Matlab script describing a SMARTS case.
%   SetSMARTSRoot - Set the location of the root directory of SMARTS.
%   TweakSMARTSInput - Alter a SMARTS case (requires case congruency)
%   LunarSMARTS - Compute moonlight spectral irradiance rather than sunlight.
%   LunarSMARTSExample1 - Example script for using LunarSMARTS.
%   ROLOLunarEquivReflect - Implementation of ROLO lunar equivalent spectral reflectance model.
%   ROLOLunarEquivReflectTest - Example and testing of ROLO model.
%
%% Radiometry, Photometry, Spectral Filtering, Signal Chain and Processing
%   AgScopeDiff - Differentiate (compute slope) data from Agilent 54622A Oscilloscope.
%   AgScopeFFT  - Compute Fourier Transform of Agilent 54622A Oscilloscope data.
%   AgScopeFFTNorm - Compute and normalise FFT of Agilent 54622A Oscilloscope data.
%   AlterSchottFilterThickness - Alter thickness of filter read with ReadSchottFilters.
%   ASRtoSQE - Converts detector absolute spectral response to spectral quantum efficiency.
%   SQEtoASR - Converts detector spectral quantum efficiency to absolute spectral response.
%   ColorCoordsFromSpectrum - Compute various color space coordinates from a spectrum.
%   ColorCoordsFromSpectrumExample1 - Example of using ColorCoordsFromSpectrum function.
%   datenumSpectraWin - Obtain serial date of SpectraWin files.
%   dPlanckdT - Partial derivative of planck black body radiance with respect to temperature.
%   GaussianCutOffFilter - Generate spectral cut-off filter with gaussian edge
%   GaussianCutOnFilter - Generate spectral cut-on filter with gaussian edge
%   GaussianFilter - Generate spectral bandpass filter with gaussian shape
%   IntSphere - Compute the spectral radiance of an integrating sphere given input spectral flux.
%   IntSphereExample1 - Example script for IntSphere.
%   Noise3D - Compute 3D noise parameters of a camera given a noise data cube
%   PhotometricFromRadiometric - Convert radiometric quantities to photometric quantities
%   PlotSpectraWin - Plot spectroradiometric data imported by ReadPR715txt.
%   Planck - Planck black body radiance function.
%   ReadCIE - Read CIE data into workspace variables (colour observers, daylight etc.)
%   ReadPR715txt - Read text data from a PhotoResearch PR-715 spectroradiometer.
%   SonyIllumCondIrrad - Compute faceplate irradiance for Sony Illumination Condition.
%
%% Transfer Functions OTF, MTF, Spatial Filtering etc.
%   ATF - MTF degradation due to wavefront error (Shannon formula).
%   LSF  - Diffraction-limited Monochromatic Line Spread Function. Computed with a Struve Function.
%   MTF - Diffraction-limited Monochromatic Modulation Transfer Function.
%   MTFobs - Diffraction-limited Monochromatic MTF of lens with central obscuration.
%   ESF -  Monochromatic diffraction-limited edge spread function.
%   PLSF - Diffraction-limited Polychromatic Line Spread Function.
%   PMTF - Diffraction-limited Polychromatic Modulation Transfer Function.
%   PMTFobs - Polychromatic MTF of a lens with a central obscuration.
%   PMTFobsWFE - Polychromatic MTF of centrally obscured lens with wavefront errors.
%   PSF - Diffraction-limited Monochromatic Point Spread Function (cross-section).
%   PPSF - Diffraction-limited Polychromatic Point Spread Function (cross section).
%   PSF2D - 2D Image of the Diffraction-limited Polychromatic Point Spread Function.
%   RevolveMTF - Rotates 1-dimensional MTF (or other 1D) data into a 2D image.
%   SIIF - The Slit Image Irradiance Function.
%
%% Image Processing and Exploitation
%   dcraw - Dave Coffins renowned raw digital camera image converter.
%   dcrawinfo - Converts image information (-i option) output from dcraw to .csv file
%   digitize - A script to digitize data from an image of a graph. Author J. Cogdell. Not MZDDE. 
%   GetImagePatchSignal - Threshold and retrieve signal from an image file
%   ImageROIMeanRatio - Select image ROI and compute ratio of mean pixel values in ROI
%   MeasureImageScale - Measure image scale in mm per pixel for images containing artifacts of known size.
%   NEFImPatchModulation - Compute modulation of two patches in a NEF (Nikon raw) image.
%   NEFReadIm - Read raw image data from Nikon Electronic Format (NEF) image file
%   uiGetImageFile - File open dialog for image formats known to Matlab.
%   uiGetImageFiles - Get multiple image file names using dialog.
%
%% Input and Output
% Functions designated (Z) require DDE access to Zemax and therefore must
% be proceeded to a call to zDDEInit.
%   BIMwrite - Write ZEMAX format binary greyscale image.
%   CreateZemaxRaySource - Generate a ray source file for non-sequential raytracing.
%   dcraw - Dave Coffins renowned raw digital camera image converter.
%   NEFReadIm - Read raw image data from Nikon Electronic Format (NEF) image file
%   NetGenCSG - Write spherical lenses to NetGen solids for meshing.
%   dcrawinfo - Converts image information (-i option) output from dcraw to .csv file
%   ReadASDtxt  - Read ASD radiometric data exported from ViewSpec
%   ReadAgLoggerCSV - Read data recorded with an Agilent Data Logger
%   ReadAgScopeCSV - Read data recorded with an Agilent Oscilloscope
%   ReadAllPR715txt - Read all PR715 spectra in a directory
%   ReadCIE - Script to read in CIE colorimetric data
%   ReadDavisMetData - Read data from a Davis weather station
%   ReadFisbaTxt - Read data from a Fisba interferometer
%   ReadFreeSnellNKFile - Read material refractive data from FreeSnell 
%   ReadMODTRANfl7 - Read output from MODTRAN
%   ReadOhnoCCTSpectra - Read the Ohno test spectra
%   ReadPR715txt - Read data from PhotoResearch PR715 Spectroradiometer
%   ReadSchottFilters - Read spectral data for Schott coloured glass
%   ReadSchottGlassData - Read data for Schott optical glasses
%   ReadSchottGlassXLS - Read Schott glass data from original Schott XLS file
%   ReadSMARTSInput - Read an input file intended for SMARTS.
%   ReadSMARTSInputTest - This script reads all the SMARTS 2.9.5 example cases.
%   ReadSMARTSInputText - Read the input text file for SMARTS 2.9.5
%   ReadSMARTSOutput - Read .ext.txt data from SMARTS solar irradiance code.
%   ReadSMARTSSpectrum - Read a SMARTS extraterrestial solar spectrum.
%   ReadSopraNKFile - Read refractive index spectrum in Sopra format.
%   ReadUSGSsplib05a - Read a USGS splib material reflectance spectrum.
%   ReadZemaxCoatData - Read Zemax coating analysis data exported as text.
%   ReadZemaxGImAnal - Read text file data from Zemax Geometric Image Analysis.
%   ReadZemaxGlassCat - (Z) Read Zemax glass catalogues.
%   ReadZemaxIllum - Read Zemax illumination analysis exported as text.
%   ReadZemaxOTF - Read Zemax MTF/OTF analysis data exported as text.
%   ReadZemaxPSF - Read Zemax PSF analysis data exported as text.
%   ReadZemaxRayDatabase - Read a Zemax ray (.ZRD) file for analysis.
%   ReadZemaxRMS - Read a Zemax RMS analysis exported as text.
%   ReadZemaxVignet - Read a Zemax vignetting analysis exported as text.
%   ReadZemaxWaveFile - Read a Zemax .wav wavelength definition file.
%   ReadZemaxWaveMap - Read a Zemax wavefront map exported as text.
%   ScanTextFile - Cherry-pick data out of text files
%   uiGetImageFile - File open dialog for image formats known to Matlab.
%   uiGetImageFiles - Get multiple image files.
%   WriteSMARTSInput - Write a SMARTS case to SMARTS-readable input file.
%   WriteSMARTSSpectrum - Read one of the SMARTS extraterrestrial solar spectra.
%   WriteZemaxRaySourceFile - Write a ray source definition file for non-sequential.
%   WriteZemaxWaveFile - Write a Zemax .wav wavelength definition file.
%
%% Miscellaneous
%   capitalize - Capitalizes the first letter of each word in a char array
%   deg2rad - convert degrees of arc to radians
%   FitBezierOrbit - Fit a closed set of cubic Bezier curves to a set of points in any number of dimensions.
%   GetPointOnBezierOrbit - Compute location of point along a cubic Bezier orbital curve
%   BezierExample1 - Example of using Bezier orbits.
%   rad2deg - convert radians to degrees of arc
%   HexBasePyramid - Computes a 2D hexagonal pyramid for image partitioning.
%   MakeEmptyStructFrom - Make empty struct function call from existing struct as template
%   POVRay - Call POVRay renderer with #define substitutions
%
%% Optical Modelling, Analysis and Testing
% Functions marked with (Z) need DDE access to Zemax and operate on a Zemax lens.
% Always call zDDEInit before calling any such function.
%   AlterSchottFilterThickness - Alter thickness of filter read with ReadSchottFilters.
%   Bayerize - Impose Bayer color filter on image data modeled with ModelFPAImage.
%   ContourPSPlot - Write PostScript plot of ContourPupil data.
%   ContourPupil - (Z) Return image coordinates of a ring of rays in the current Zemax lens pupil
%   findobs - (Z) Find the size of system central obscuration in relative pupil height y.
%   RayDevParPlate - Computes lateral deviation of a ray passing through a plane parallel plate.
%   NarcWiz - (Z) A wizard for performing basic narcissus analysis on staring infrared cameras.
%   RenderNarcissus - Render visual representation of narcissus artefact computed with IRNarcissus
%   IRNarcissus - (Z) A function for performing detailed narcissus analysis on staring infrared cameras.
%   ShowNarcissus - Plots narcissus results from IRNarcissus.
%   ReverseSurfaces - (Z) Reverses a series of surfaces in a Zemax lens.
%   SiemensStar - Generate image of a sector Siemens Star target.
%   ModelFPAImage  - (Z) Models formation and sampling of an image on a focal plane array.
%   TestModelFPAImage  - (Z) Use example of ModelFPAImage (script).
%   n_air - Refractive index of air over wavelength, temperature and pressure.
%   USAF1951 - Computes the fundamental spatial frequency of a USAF 1951 resolution target element.
%   LSF - Diffraction-limited Monochromatic Line Spread Function. Computed with a Struve Function.
%   PLSF - Diffraction-limited Polychromatic Line Spread Function.
%   ATF - MTF degradation due to wavefront error (Shannon formula).
%   MTF - Diffraction-limited Monochromatic Modulation Transfer Function.
%   MTFobs - Diffraction-limited Monochromatic MTF of lens with central obscuration.
%   PSF - Diffraction-limited Monochromatic Point Spread Function (cross-section).
%   PPSF - Diffraction-limited Polychromatic Point Spread Function (cross section).
%   PSF2D - 2D Image of the Diffraction-limited Polychromatic Point Spread Function.
%   Onion - (Z) Split lens into layers for analysis of axial temperature gradients.
%   SagEvenAsphere - Computes the sag of a standard ZEMAX even aspheric surface.
%   WaterAbsorpSegelstein81 - Model absorption of pure water.
%
%% Plotting
%   PlotAgScope - Plot data from Agilent 54622A Oscilloscope.
%   PlotSpectraWin - Plot spectroradiometric data imported by ReadPR715txt.
%   PlotSMARTSOutput - Plot output from the SMARTS model.
%   PlotZemaxCoatData - Plots coating data read with ReadZemaxCoatData
%   PlotZemaxOTF - Plot a thru-frequency MTF/OTF as returned by ReadZemaxOTF or zGetMTF.
%   ShowNarcissus - Plots narcissus results from IRNarcissus
%
%% Surveillance
%   CTF_eye - Contrast Threshold Function of the human eye (Barten).
%   ModelFPAImage  - Models formation and sampling of an image on a focal plane array.
%   TestModelFPAImage  - Example of using ModelFPAImage (script).
%   MTF_eye - MTF of the human eye.
%   airmass - compute airmass at particular elevation using various formulae
%   MoshierEphem - Compute ephemerides for sun, moon, planets and stars
%   MoshierEphemExample1 - Example script for MoshierEphem
%   MoshierMoon - Compute lunar ephemeris with additional data
%   MoshierMoonExample1 - Example script for MoshierMoon
%   Noise3D - Compute 3D noise parameters of a camera given a noise data cube
%   ReadMODTRANfl7 - Read MODTRAN (3.7) output from a '.fl7' (tape7 format) file.
%
%% Zemax Related
% Most of the functions listed below require DDE access to Zemax.
% Always call zDDEInit before calling any such function.
% See the chapter on Zemax Extensions in the Zemax manual.
%   BIMwrite                - Write ZEMAX format binary greyscale image.
%   DoublePass              - Put a Zemax lens system into double pass.
%   findobs                 - Find the size of system central obscuration in relative pupil height y.
%   genRayDataMode0         - Generate grid of ray data ready for zArrayTrace mode 0 (ordinary raytrace).
%   genRayDataMode2         - Generate grid of ray data ready for zArrayTrace mode 2 (polarization raytrace).
%   gridXYRayData           - Generate basic grid of ray data for zArrayTrace.
%   PlotZemaxCoatData       - Plots coating data read with ReadZemaxCoatData
%   PlotZemaxOTF            - Plot a thru-frequency MTF/OTF as returned by ReadZemaxOTF or zGetMTF.
%   ReadZemaxCoatData       - Reads data from a ZEMAX coating analysis.
%   ReadZemaxGImAnal        - Reads data from a ZEMAX Geometric Image Analysis text data file.
%   ReadZemaxIllum          - Reads data from a ZEMAX Uniformity of Illumination Analysis text file.
%   ReadZemaxOTF            - Reads data from a OTF/MTF text file from ZEMAX (thru-frequency, thru-focus or thru-field).
%   ReadZemaxRayDatabase    - Read a Zemax .ZRD ray database file.
%   ReadZemaxRMS            - Reads data from a ZEMAX RMS Analysis - Spot Size, Wavefront or Strehl Ratio.
%   ReadZemaxVignet         - Reads data from a ZEMAX Vignetting Analysis text file.
%   ReadZemaxWaveFile       - Reads wavelengths, weights and primary wavelength number from Zemax .wav file.
%   SpiralSpot              - Compute image plane trajectory of a ray scanned in a spiral over the pupil.
%   ReadZemaxWaveMap        - Reads data from a Wave Map text data file generated by ZEMAX.
%   WriteZemaxRaySourceFile - Write a Zemax ray source file for non-sequential raytracing.
%   WriteZemaxWaveFile      - Write a list of wavelengths and weights in ZEMAX .wav file format.
%   zArrayTrace             - Performs tracing of large numbers of rays in ZEMAX.
%       Take Note - zArrayTrace can cause instability of Matlab after a number of calls.
%   zDDEBusy                - Checks to see if the ZEMAX DDE server is busy.
%   zDDEClose               - Close DDE communications channel to ZEMAX.
%   zDDEInit                - Open communications channel to ZEMAX DDE server.
%   zDDEStart               - Attempt zDDEInit. If no ZEMAX running, attempt to start ZEMAX.
%   zCommand                - Send a command string directly to the ZEMAX DDE interface.
%   zDeleteSurface          - Delete a lens surface.
%   zExportCAD              - Export lens CAD data (IGES, STEP, SAT) to a file.  
%   zExportCheck            - Check if lens CAD export has completed.
%   zFindLabel              - Find integer label attached to a lens surface using zSetLabel.
%   zFixSurfaceData         - Set lens surface data to 'fixed' mode.
%   zFixAllSurfaceData      - Set all lens surface data to 'fixed' mode.
%   zGetAddress             - Get address line in Preferences/Address.
%   zGetAspect              - Get the aspect ratio of ZEMAX graphics or print windows.
%   zGetBuffer              - Get DDE client specific data from a ZEMAX window being updated.
%   zGetCoatings            - Get a list of available coatings from the ZEMAX COATINGS.DAT file.
%   zGetConfig              - Get current lens configuration, number of configurations and configuration operands.
%   zGetDate                - Get current date from ZEMAX DDE server.
%   zGetExtra               - Get single extra data value from ZEMAX DDE server.
%   zGetField               - Get data on lens field points.
%   zGetFile                - Get the filename of the currently loaded lens.
%   zGetFirst               - Get first order data about the lens.
%   zGetGlass               - Get data on a glass at a particular lens surface.
%   zGetGlassCats           - Get a list of available text glass catalogues from the ZEMAX Glasscat directory.
%   zGetGlobalMatrix        - Get transformation matrix from local surface coordinates to global lens coordinates.
%   zGetIndex               - Get index of refraction data at a lens surface.
%   zGetLabel               - Retrieve integer label associated with a surface.
%   zGetMetaFile            - Create Windows Metafile of a ZEMAX graphic analysis window.
%   zuiGetMetaFile          - As for zGetMetaFile, but with Save As dialog box.
%   zGetMulticon            - Get data from the ZEMAX multi-configuration editor.
%   zGetMTF                 - Get MTF computation from ZEMAX for current lens. Returns as for ReadZemaxOTF function.
%   zGetName                - Get the name of the lens in ZEMAX.
%   zGetNSCData             - Get number of NSC objects.
%   zGetNSCObjectData       - Get data describing NSC objects in ZEMAX.
%   zGetNSCPosition         - Get position data for an NSC object in ZEMAX.
%   zGetNSCParameter        - Get numeric parameters associated with an NSC object in ZEMAX.
%   zGetNSCSettings         - Get ZEMAX settings affecting raytracing in non-sequential components.
%   zGetOperand             - Get data from the ZEMAX Merit Function editor.
%   zGetOperandMatrix       - Get the entire merit function matrix from the Merit Function Editor.
%   zGetPath                - Get the path for the ZEMAX installation directory and lens directory.
%   zGetPolState            - Get the default polarization state from ZEMAX.
%   zGetPupil               - Get data on the aperture stop and pupils.
%   zGetPolTrace            - Perform a full polarization raytrace through the ZEMAX lens.
%   zGetPolTraceDirect      - Direct access full polarization raytrace.
%   zGetRefresh             - Copies the lens in the Lens Data Editor (LDE) into the ZEMAX DDE server.
%   zGetSag                 - Get the sag at particular x and y coordinates on a lens surface.
%   zGetSequence            - Get the sequence numbers of the lenses in the DDE server and LDE.
%   zGetSerial              - Get the ZEMAX hardware lock serial number.
%   zGetSolve               - Get data on solves and pickups on lens surfaces.
%   zGetSolveTable          - Get a table of solve information as in the Solves chapter in the Zemax manual.
%   zGetSurfaceData         - Get a data item describing a lens surface.
%   zsGetSurfaceData        - Get data for a lens surface in a Matlab structure.
%   zsGetSurfaceDataVector  - Get all basic surface data in a vector of Matlab structures.
%   zGetSurfaceDLL          - Get the name of a DLL for user-defined surface types.
%   zGetSurfaceParameter    - Get single surface parameter datum.
%   zGetSurfaceParamVector  - Get vector of all parameter values at a surface.
%   zGetSystem              - Get general information on the lens system in the ZEMAX DDE server.
%   zsGetSystem             - Get general lens information in a Matlab structure.
%   zGetSystemAper          - Get lens system aperture data.
%   zGetTextFile            - Save text from any ZEMAX analysis window which supports text.
%   zGetTimeout             - Get the timeout value in seconds for ZEMAX DDE calls.
%   zGetTol                 - Get data on a tolerance operand in the ZEMAX tolerance editor.
%   zGetTolCount            - Get the number of current lens tolerance operands from ZEMAX.
%   zGetTolMatrix           - Get a matrix of all current lens tolerances.
%   zGetTrace               - Trace a ray through the current lens in the ZEMAX DDE server.
%   zGetTraceDirect         - Direct access raytrace through the current lens in the ZEMAX DDE server.
%   zGetUpdate              - Perform update on the current lens in the ZEMAX DDE server.
%   zGetVersion             - Get the ZEMAX version which is running.
%   zGetWave                - Get data on a currently defined wavelength in ZEMAX.
%   zGetWaveMatrix          - Get all data on wavelengths and weights in a matrix.
%   zImportExtraData        - Import extra data to a ZEMAX surface which needs it e.g. Grid Sag.
%   zuiImportExtraData      - As for zImportExtraData, but with File Open dialog box.
%   zInsertSurface          - Insert a new surface in the lens.
%   zLoadFile               - Load a ZEMAX lens (.zmx) file into the ZEMAX DDE server.
%   zuiLoadFile             - As for zLoadFile, except with File Open dialog.
%   zLoadMerit              - Load a merit function file from a .MF or .ZMX file.
%   zuiLoadMerit            - As for zLOadMerit, except that an Open File dialog is presented.
%   zMakeGraphicWindow      - Request ZEMAX to generate a graphic display from data stored in client generated file.
%   zMakeTextWindow         - Request ZEMAX to display text stored in a client generated file.
%   zNewLens                - Erase the lens in the ZEMAX DDE server.
%   zNSCDetectorData        - Get a pixel value from an NSC detector object after zNSCTrace.
%   zNSCDetectorMatrix      - Gets all pixel values from an NSC detector object in an array.
%   zNSCTrace               - Performs non-sequential raytracing in a NSC Group.
%   zNumSurfs               - Returns the number of surfaces in the lens (actually the surface number of the last surface).
%   zOpenWindow             - Open a ZEMAX action/analysis window.
%   zOptimize               - Run the damped least squares on the lens in the ZEMAX DDE server.
%   zPushLens               - Copy the lens in the ZEMAX DDE server into the ZEMAX Lens Data Editor.
%   zPushLensPermission     - Checks if ZEMAX is set to allow pushing of lenses into the LDE.
%   zReleaseWindow          - Release a window locked during ZEMAX-client interaction.
%   zSaveFile               - Save a lens file from the ZEMAX DDE server.
%   zuiSaveFile             - As for zSaveLens, only a Save As dialog is used.
%   zSetAperture            - Set aperture details on a lens surface.
%   zSetBuffer              - Write text to a buffer for ZEMAX-client interactions.
%   zSetConfig              - Change selected lens configuration.
%   zSetExtra               - Set extra data associated with a lens surface in the ZEMAX DDE server.
%   zSetField               - Set details of a field point in the lens.
%   zSetFieldType           - Set the type of field points and the total number of points.
%   zSetFieldMatrix         - Set field type and all field point data from a Matlab matrix.
%   zSetFloat               - Set all surface without apertures to have floating apertures.
%   zSetLabel               - Attach an integer label to a lens surface for later reference.
%   zSetMEMState            - Set the micro-mirror state of a MEMS digital mirror device (DMD/DLP)
%   zSetMulticon            - Set multi-configuration data for lens surfaces in ZEMAX.
%   zSetMulticonOp          - Set up operand types in the ZEMAX multi-configuration editor.
%   zSetNSCNull             - Sets range of objects at a non-sequential surface to the 'Null Object'.
%   zSetNSCObjectData       - Set basic data for an non-sequential object in ZEMAX.
%   zsSetNSCObject          - Set data for an NSC object or objects through use of a Matlab structure array.
%   zSetNSCPosition         - Set position and tilt of a non-sequential object in ZEMAX.
%   zSetNSCParameter        - Set a parameter associated with an NSC object in ZEMAX.
%   zSetNSCSettings         - Set global settings in ZEMAX related to handling of NSC ray tracing.
%   zSetOperand             - Set lens optimization operand in ZEMAX.
%   zSetPolState            - Set default polarization state for polarization raytracing in ZEMAX.
%   zSetSolve               - Set solves and pickups on lens surfaces.
%   zSetSurfaceData         - Set basic lens surface data in ZEMAX.
%   zSetSurfaceParameter    - Set a parameter associated with a lens surface in ZEMAX.
%   zSetSurfaceParamVector  - Set all parameters associated with a lens surface from a vector.
%   zSetSurfaceParamMatrix  - Set all parameters associated with all lens surfaces from a matrix.
%   zSetSystem              - Set global operating conditions for a lens system in ZEMAX.
%   zSetSystemAper          - Set aperture type and size for a lens in ZEMAX.
%   zSetTimeout             - Set the timeout for all subsequent ZEMAX DDE function calls.
%   zSetVig                 - Set vignetting factors automatically in ZEMAX.
%   zSetWave                - Set a wavelength and weight for the lens in ZEMAX.
%   zSetWaveMatrix          - Set all wavelengths and weights from a Matlab matrix.
%   zWindowMaximize         - Maximize a ZEMAX window.
%   zWindowMinimize         - Minimize a ZEMAX window.
%   zWindowRestore          - Restore a ZEMAX window to before a Maximize or Minimize.
%   ZemaxButtons            - Get a list of 3-letter codes for ZEMAX analysis and action windows (see zOpenWindow).
%   ZemaxOperands           - Get a list of ZEMAX optimization operands.
%   ZemaxSurfTypes          - Get a list of ZEMAX surface type codes and descriptions.
%
%
%% $Id: Contents.m 221 2009-10-30 07:07:07Z DGriffith $

% $Revision: 221 $
% $Author: DGriffith $
