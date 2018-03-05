function Abs = WaterAbsorpSegelstein81(Wavelengths, Thickness)
% WaterAbsorpSegelstein81 : Gives absorption coefficient of water per metre
%
% Reference : 
% D. J. Segelstein, "The complex refractive index of water," University of
%   Missouri-Kansas City, (1981). Data obtained from :
%   http://omlc.ogi.edu/spectra/water/index.html, Author Scott Prahl. 
%   Last Accessed 2008-12-26.
%
% Usage :
%    >> AbsorptionPerMetre = WaterAbsorpSegelstein81(Wavelengths)
%    >> AbsorptionPerMetre = WaterAbsorpSegelstein81
%    >> Transmission = WaterAbsorpSegelstein81(Wavelengths, Thickness)
%
% Where :
%   Wavelengths are the wavelengths at which to return the water absorption
%      per metre. If omitted or empty, the Wavelengths default to the 
%      wavelengths in the original data. Wavelengths are in nanometres.
%      The wavelength range is 10 nm to 1e10 nm.
%   Thickness is the thickness of the water layer for which to return the
%      internal transmission of the given water thickness in metres.
%      Transmission = exp(-Thickness * AbsorbCoeff).
%      If Thickness is not scalar, the returned data has an additional
%      column for each thickness.
%
% The absorption coefficient/transmission data is returned as a matrix.
% The first column is wavelength in nanometres and the following columns are 
% the absorption coefficients per metre or the tranmission for the given
% thicknesses.
%
% Example :
%   Compute the internal transmission of water, thicknesses of 1, 2 and 3 cm.
%   >> Trans = WaterAbsorpSegelstein81(400:1:1000, [0.01 0.02 0.03]);
%   >> plot(Trans(:,1), Trans(:,2:end));
%   >> title('Transmission of Water');
%   >> xlabel('Wavelength (nm)');
%   >> ylabel('Transmission');
%   >> grid;
%   >> legend('1 cm','2 cm','3 cm', 'location', 'best');
%      

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
% $Author: DGriffith $


persistent Segel81

if ~exist('Segel81', 'var') || isempty(Segel81)
    % Read in the data
    % disp('Reading')
    Directory = fileparts(which('WaterAbsorpSegelstein81'));
    Segel81 = dlmread([Directory '\Materials\WaterSegelstein81.dat'], '\t', 5, 0);
    % Convert from 1/cm to 1/m
    Segel81(:,2) = 100 * Segel81(:,2);
end

% if wavelengths are given, interpolate (linear);
if exist('Wavelengths', 'var') && ~isempty(Wavelengths)
    if min(Wavelengths(:)) < min(Segel81(:,1)) || max(Wavelengths(:)) > max(Segel81(:,1))
        error('WaterAbsorpSegelstein81:BadWavelengths', 'Wavelengths input out of range. Must be 10 nm to 1e10 nm.' );
    end
    
    Abs(:,1) = Wavelengths;
    Abs(:,2) = interp1(Segel81(:,1), Segel81(:,2), Wavelengths);
else
    Abs = Segel81;
end

% If thickness is given, compute the transmission
if exist('Thickness', 'var') && ~isempty(Thickness)
    % Compute the optical thickness
    Thickness = repmat(Thickness(:)', size(Abs,1), 1); % Make it a row vector and replicate over wavelenth
    Abscoeff = repmat(Abs(:,2), 1 ,size(Thickness, 2)); % Replicate abs over thicknesses
    Transmission = exp(-Thickness .* Abscoeff);
    Abs = [Abs(:,1) Transmission]; % Concatenate with the wavelengths
end
    


