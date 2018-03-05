function WriteSMARTSSpectrum(Spectrum, Filename)
% WriteSMARTSSpectrum : Write an extraterrestrial spectrum in SMARTS format
%
% SMARTS is the Simple Model of the Atmospheric Radiative Transfer of
% Sunshine, available at http://www.nrel.gov/rredc/smarts/
% SMARTS Author : Christian A. Gueymard
% This function is written for SMARTS 2.9.5
%
% Usage :
%  >> WriteSMARTSSpectrum(Spectrum)
%  >> WriteSMARTSSpectrum(Spectrum, Filename)
%
% Where :
%  Spectrum is a structure containing the following fields
%   Spectrum.Name is the name of the spectrum, appearing in the first line of the file.
%   Spectrum.Integral is the integral of the spectrum over all wavelengths, representing
%     the "solar constant". This is in W/m^2.
%   Spectrum.Wv are the wavelengths. In the file that gets written by this function, 
%     the wavelength are given in Angstroms, but this field must have the standard
%     SMARTS wavelength in units of nanometres. The spectral irradiance is given in 
%     W/m^2/nm both in the file and in the following field. Get the wavelengths by 
%     reading one of the SMARTS standard spectra using ReadSMARTSSpectrum.
%   Spectrum.Irrad must be the extraterrestrial solar irradiance in W/m^2/nm.
%
% Filename is the file to which the spectrum must be written. If the Filename is
%   not given, a file save dialog will be presented. If a file path is not given, 
%   the file will be written to the Solar subfolder in the SMARTS root directory.
%
% See Also : WriteSMARTSInput, DisplaySMARTSInput, CheckSMARTSInput,
%   TweakSMARTSInput, RunSMARTS, ReadSMARTSOutput, ReadSMARTSInput

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

% $Date: 2009-10-30 09:07:07 +0200 (Fri, 30 Oct 2009) $
% $Revision: 221 $
% $Author: DGriffith $

persistent SMARTSRoot

% Check some inputs
if ~exist('Spectrum', 'var') || ~isstruct(Spectrum) || ~all(isfield(Spectrum, {'Name','Integral','Wv','Irrad'}))
    error('WriteSMARTSPectrum:badSpectrum', ['Input Spectrum must be a structure with fields ' ...
          '"Name", "Integral", "Wv" and "Irrad" - see help.']);
end
if ~ischar(Spectrum.Name) || ~isfloat(Spectrum.Integral) || ~isfloat(Spectrum.Wv) || ~isfloat(Spectrum.Irrad)
    error('WriteSMARTSPectrum:badSpectrum', 'Check classes of input structure Spectrum fields.');
end

if isempty(SMARTSRoot)
  SMARTSRootFile = [fileparts(which('RunSMARTS')) '\SMARTSRoot.mat'];
  if exist(SMARTSRootFile, 'file')
      load(SMARTSRootFile)
  else
      SMARTSRoot = SetSMARTSRoot;
  end
end

%% Check input filename and open
if ~exist('Filename', 'var') || isempty(Filename)
    % Use dialog
    [Filename, Pathname] = uiputfile({'Spctrm_*.dat';'*.dat';'*.*'},'SMARTS Spectrum File Selector', ...
        [SMARTSRoot 'Solar\Spctrm_U.dat']);
    if Filename
      Filename = [Pathname Filename];
    else
        return;
    end
else
    if isempty(fileparts(Filename))
      Filename = [SMARTSRoot 'Solar\' Filename];    
    end
end

fid = fopen(Filename, 'wt');
fprintf(fid, '%s\n', Spectrum.Name);
fprintf(fid, '%g\n', Spectrum.Integral);
Spectrum.Wv = 10 * Spectrum.Wv; % Convert to angstroms
Data = [Spectrum.Wv(:)'; Spectrum.Irrad(:)'];
fprintf(fid, '%g %g\n', Data);
fclose(fid);
