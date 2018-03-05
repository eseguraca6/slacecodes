function ZemaxButtons = ZemaxButtons()
% ZEMAX 3-Letter Analysis/Action Window Codes (ZEMAX Version September 19, 2002)
% These codes are case-sensitive.
%
%  Off: None                          Mfl: Merit Function List
%  ABg: ABg Data Catalog              Mfo: Make Focal
%  Bfv: Beam File Viewer              Mgm: Geometric MTF Map
%  Caa: Coating, Abs. vs. Angle       Mtf: Modulation TF
%  Car: Cardinal Points               Mth: MTF vs. Field
%  Cas: Coat All Surfaces             NCE: Non-Sequential Editor
%  Caw: Coating, Abs. vs. Wavelength  New: New File
%  Cca: Convert to Circular Apertures Nxc: Next Configuration
%  Cda: Coating, Dia. vs. Angle       Off: Huygens Through Focus MTF
%  Cdw: Coating, DIa. vs. Angle       Opd: Opd Fan
%  Cfa: Convert to Floating Apertures Ope: Open File
%  Cfs: Chromatic Focal Shift         Opt: Optimization
%  Cls: Coating List                  Pab: Pupil Aberration Fan
%  Cna: Coating, Ret. vs. Angle       Pcs: PSF Cross Section
%  Cng: Convert to NSC Group          Per: Performance Test
%  Cnw: Coating, Ret. vs. Wavelength  Pha: Pol. Phase Aberration
%  Cpa: Coating, Phase vs. Angle      Pmp: Pol. Pupil Map
%  Cpw: Coating, Phase vs. Wavelength Pol: Pol. Ray Trace
%  Cra: Coating, Refl vs. Angle       Pop: Physical Optics Propagation
%  Crw: Coating, Refl. vs. Wavelength Pre: Prescription Data
%  Cta: Coating, Tran. vs. Angle      Prf: Preferences
%  Ctw: Coating, Tran. vs. Wavelength Ptf: Pol. Transmission Fan
%  Dcl: Detector Control              Qfo: Quick Focus
%  Dim: Diffraction Image Analysis    Raa: Remove All Apertures
%  Dip: Biocular Dipvergence/Converge Ray: Ray Fan
%  Dis: Dispersion Plot               Rcf: Reload Coating File
%  Dvi: Detector Viewer               Rdb: Ray Database
%  EDE: Extra Data Editor             Red: Redo
%  Ect: Edit Coating                  Rel: Relative Illumination
%  Ele: ZEMAX Element Drawing         Rev: Reverse Elements
%  Enc: Diff Encircled Energy         Rg4: New Report Graphic 4
%  Ext: Exit                          Rg6: New Report Graphic 6
%  Fcd: Field Curv/Distorion          Rmf: RMS vs. Focus
%  Fcl: Fiber Coupling                Rml: Refresh Macro List
%  Fie: Field Data                    Rms: RMS vs. Field
%  Fld: Add Fold Mirror               Rmw: RMS vs. Wavelength
%  Flx: Delete Fold Mirror            Rtr: Ray Trace
%  Foa: Foucault Analysis             Rva: Remove Variables
%  Foo: Footprint Analysis            Rxl: Refresh Extensions List
%  Fov: Biocular Field of View Analys Sag: Sag Table
%  Fps: FFT PSF                       Sas: Save As
%  Gbp: Parax Gaussian Beam           Sav: Save File
%  Gbs: Skew Gaussian Beam            Sca: Scale Lens
%  Gen: General Lens Data             Sei: Seidel Coefficients
%  Geo: Geom Encircled Energy         Sff: Full Field Spot
%  Gho: Ghost Focus                   Sld: Slider
%  Gla: Glass Catalog                 Sma: Spot Matrix
%  Glb: Global Optimization           Smc: Spot Matrix Config
%  Gmp: Glass Map                     Smf: Surface MTF
%  Gpr: Gradium Profile               Spt: Spot Diagram
%  Grd: Grid Distortion               Srp: Surface Phase
%  Gst: Glass Substitution Template   Srs: Surface Sag
%  Gtf: Geometric MTF                 Ssg: System Summary Graphic
%  Gvf: Geometric MTF vs. Field       Stf: Though Focus Spot
%  Ham: Hammer Optimization           Sur: Surface Data
%  Hlp: Help                          Sys: System Data
%  Hmf: Huygens MTF                   TDE: Tolerance Data Editor
%  Hps: Huygens PSF                   Tde: Tilt/Decenter Elements
%  Hsm: Huygens SUrface MTF           Tfg: Through Focus GTF
%  ISO: ISO Element Drawing           Tfm: Through Focus MTF
%  Ibm: Geometric Bitmap Image Analys Tls: Tolerance List
%  Igs: Export IGES File              Tol: Tolerancing
%  Ilf: Illumination Surface          Tpf: Test Plate Fit
%  Ils: Illumination Scan             Tpl: Test Plate Lists
%  Ima: Geometric Image Analysis      Tra: Pol. Transmission
%  Imv: IMA/BIM File Viewer           Trw: Transmission vs. Wavelength
%  Ins: Insert Lens                   Tsm: Tolerance Summary
%  Int: Interferogram                 Und: Undo
%  L3d: 3D Layout                     Uni: Universal Plot
%  L3n: NSC 3D Layout                 Upa: Update All
%  LDE: Lens Data Editor              Upd: Update
%  LSn: NSC Shaded Model Layout       Vig: Vignetting Plot
%  Lac: Last Configuration            Wav: Wavelength Data
%  Lat: Lateral Color                 Wfm: Wavefront Map
%  Lay: 2D Layout                     Xdi: Extended Diffraction Image Analysis
%  Len: Lens Search                   Xis: Export IGES/STEP/SAT FIle
%  Lin: Line/Edge Response            Xse: Extended Source Encircled
%  Lon: Longitudinal Aberration       Yni: YNI Contributions
%  Lsh: Shaded Model Layout           Yyb: Y-Ybar
%  Lsm: Solid Model Layout            Zat: Zernike Annular Terms
%  Lwf: Wireframe Layout              Zex: ZEMAX Extensions
%  MCE: Multi-Config Editor           Zfr: Zernike Fringe Terms
%  MFE: Merit Function Editor         Zpl: Edit/Run ZPL Macros
%  Mdm: FFT MTF Map                   Zst: Zernike Standard Terms
%
%  There are 168 Buttons in this list. The latest version of ZEMAX may have more.

%% Copyright 2002-2009, DPSS, CSIR
% This file is subject to the terms and conditions of the BSD Licence.
% For further details, see the file BSDlicence.txt
%
% Contact : dgriffith@csir.co.za
% 
% 
%
%
%


% $Revision: 221 $

ZemaxButtons = [
'Off',':None                          ';
'ABg',':ABg Data Catalog              ';
'Bfv',':Beam File Viewer              ';
'Caa',':Coating, Abs. vs. Angle       ';
'Car',':Cardinal Points               ';
'Cas',':Coat All Surfaces             ';
'Caw',':Coating, Abs. vs. Wavelength  ';
'Cca',':Convert to Circular Apertures ';
'Cda',':Coating, Dia. vs. Angle       ';
'Cdw',':Coating, DIa. vs. Angle       ';
'Cfa',':Convert to Floating Apertures ';
'Cfs',':Chromatic Focal Shift         ';
'Cls',':Coating List                  ';
'Cna',':Coating, Ret. vs. Angle       ';
'Cng',':Convert to NSC Group          ';
'Cnw',':Coating, Ret. vs. Wavelength  ';
'Cpa',':Coating, Phase vs. Angle      ';
'Cpw',':Coating, Phase vs. Wavelength ';
'Cra',':Coating, Refl vs. Angle       ';
'Crw',':Coating, Refl. vs. Wavelength ';
'Cta',':Coating, Tran. vs. Angle      ';
'Ctw',':Coating, Tran. vs. Wavelength ';
'Dcl',':Detector Control              ';
'Dim',':Diffraction Image Analysis    ';
'Dip',':Biocular Dipvergence/Convergen';
'Dis',':Dispersion Plot               ';
'Dvi',':Detector Viewer               ';
'EDE',':Extra Data Editor             ';
'Ect',':Edit Coating                  ';
'Ele',':ZEMAX Element Drawing         ';
'Enc',':Diff Encircled Energy         ';
'Ext',':Exit                          ';
'Fcd',':Field Curv/Distorion          ';
'Fcl',':Fiber Coupling                ';
'Fie',':Field Data                    ';
'Fld',':Add Fold Mirror               ';
'Flx',':Delete Fold Mirror            ';
'Foa',':Foucault Analysis             ';
'Foo',':Footprint Analysis            ';
'Fov',':Biocular Field of View Analysi';
'Fps',':FFT PSF                       ';
'Gbp',':Parax Gaussian Beam           ';
'Gbs',':Skew Gaussian Beam            ';
'Gen',':General Lens Data             ';
'Geo',':Geom Encircled Energy         ';
'Gho',':Ghost Focus                   ';
'Gla',':Glass Catalog                 ';
'Glb',':Global Optimization           ';
'Gmp',':Glass Map                     ';
'Gpr',':Gradium Profile               ';
'Grd',':Grid Distortion               ';
'Gst',':Glass Substitution Template   ';
'Gtf',':Geometric MTF                 ';
'Gvf',':Geometric MTF vs. Field       ';
'Ham',':Hammer Optimization           ';
'Hlp',':Help                          ';
'Hmf',':Huygens MTF                   ';
'Hps',':Huygens PSF                   ';
'Hsm',':Huygens SUrface MTF           ';
'ISO',':ISO Element Drawing           ';
'Ibm',':Geometric Bitmap Image Analysi';
'Igs',':Export IGES File              ';
'Ilf',':Illumination Surface          ';
'Ils',':Illumination Scan             ';
'Ima',':Geometric Image Analysis      ';
'Imv',':IMA/BIM File Viewer           ';
'Ins',':INsert Lens                   ';
'Int',':Interferogram                 ';
'L3d',':3D Layout                     ';
'L3n',':NSC 3D Layout                 ';
'LDE',':Lens Data Editor              ';
'LSn',':NSC Shaded Model Layout       ';
'Lac',':Last Configuration            ';
'Lat',':Lateral Color                 ';
'Lay',':2D Layout                     ';
'Len',':Lens Search                   ';
'Lin',':Line/Edge Response            ';
'Lon',':Longitudinal Aberration       ';
'Lsh',':Shaded Model Layout           ';
'Lsm',':Solid Model Layout            ';
'Lwf',':Wireframe Layout              ';
'MCE',':Multi-Config Editor           ';
'MFE',':Merit Function Editor         ';
'Mdm',':FFT MTF Map                   ';
'Mfl',':Merit Function List           ';
'Mfo',':Make FOcal                    ';
'Mgm',':Geometric MTF Map             ';
'Mtf',':Modulation TF                 ';
'Mth',':MTF vs. Field                 ';
'NCE',':Non-Sequential Editor         ';
'New',':New File                      ';
'Nxc',':Next Configuration            ';
'Off',':Huygens Through Focus MTF     ';
'Opd',':Opd Fan                       ';
'Ope',':Open File                     ';
'Opt',':Optimization                  ';
'Pab',':Pupil Aberration Fan          ';
'Pcs',':PSF Cross Section             ';
'Per',':Performance Test              ';
'Pha',':Pol. Phase Aberration         ';
'Pmp',':Pol. Pupil Map                ';
'Pol',':Pol. Ray Trace                ';
'Pop',':Physical Optics Propagation   ';
'Pre',':Prescription Data             ';
'Prf',':Preferences                   ';
'Ptf',':Pol. Transmission Fan         ';
'Qfo',':Quick Focus                   ';
'Raa',':Remove All Apertures          ';
'Ray',':Ray Fan                       ';
'Rcf',':Reload Coating File           ';
'Rdb',':Ray Database                  ';
'Red',':Redo                          ';
'Rel',':Relative Illumination         ';
'Rev',':Reverse Elements              ';
'Rg4',':New Report Graphic 4          ';
'Rg6',':New Report Graphic 6          ';
'Rmf',':RMS vs. Focus                 ';
'Rml',':Refresh Macro List            ';
'Rms',':RMS vs. Field                 ';
'Rmw',':RMS vs. Wavelength            ';
'Rtr',':Ray Trace                     ';
'Rva',':Remove Variables              ';
'Rxl',':Refresh Extensions List       ';
'Sag',':Sag Table                     ';
'Sas',':Save As                       ';
'Sav',':Save File                     ';
'Sca',':Scale Lens                    ';
'Sei',':Seidel Coefficients           ';
'Sff',':Full Field Spot               ';
'Sld',':Slider                        ';
'Sma',':Spot Matrix                   ';
'Smc',':Spot Matrix Config            ';
'Smf',':Surface MTF                   ';
'Spt',':Spot Diagram                  ';
'Srp',':Surface Phase                 ';
'Srs',':SUrface Sag                   ';
'Ssg',':System Summary Graphic        ';
'Stf',':Though Focus Spot             ';
'Sur',':Surface Data                  ';
'Sys',':System Data                   ';
'TDE',':Tolerance Data Editor         ';
'Tde',':Tilt/Decenter Elements        ';
'Tfg',':Through Focus GTF             ';
'Tfm',':Through Focus MTF             ';
'Tls',':Tolerance List                ';
'Tol',':Tolerancing                   ';
'Tpf',':Test Plate Fit                ';
'Tpl',':Test Plate Lists              ';
'Tra',':Pol. Transmission             ';
'Trw',':Transmission vs. Wavelength   ';
'Tsm',':Tolerance Summary             ';
'Und',':Undo                          ';
'Uni',':Universal Plot                ';
'Upa',':Update All                    ';
'Upd',':Update                        ';
'Vig',':Vignetting Plot               ';
'Wav',':Wavelength Data               ';
'Wfm',':Wavefront Map                 ';
'Xdi',':Extended Diffraction Image Ana';
'Xis',':Export IGES/STEP/SAT FIle     ';
'Xse',':Extended Source Encircled     ';
'Yni',':YNI Contributions             ';
'Yyb',':Y-Ybar                        ';
'Zat',':Zernike Annular Terms         ';
'Zex',':ZEMAX Extensions              ';
'Zfr',':Zernike Fringe Terms          ';
'Zpl',':Edit/Run ZPL Macros           ';
'Zst',':Zernike Standard Terms        '];
