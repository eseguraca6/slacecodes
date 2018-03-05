function CCT = CorrColorTemperature(Wv, Spectrum, Method)
% CorrColorTemperature : Calculate CCT from radiometric spectrum
%
% Usage :
%    >> CCT = CorrColorTemperature(Wavelengths, Spectrum)
%    >> CCT = CorrColorTemperature(Wavelengths, Spectrum, Method)
%
% Where :
%  Wavelengths is a vector of wavelengths at which the relative spectrum
%    is given. Units must be nanometres.
%  Spectrum is the relative radiometric spectrum given at the Wavelengths.
%    Spectrum must be a column vector, or multiple columns of spectra. The
%    CCT is retured as a row vector, one CCT for each column in Spectrum.
%  Method is the method by which to calculate the color temperature.
%    The default method is that by Hernandez-Andres, Lee and Romero. 
%    This method is unsuitable for spectra not close to daylight or skylight
%    spectra. This method is called 'Hernandez'.
%
%    Method 'uvOptimize' uses an optimization method to minimize the
%    distance in CIE 1960 uv (UCS) chromaticity coordinates to a Planckian
%    radiator. The CCT is then taken as the absolute temperature of the
%    Planckian radiator. This method is much slower and requires the
%    Optimization Toolbox. This method works well on the Ohno spectra.
%
% Example :
%  See the script CorrColorTemperatureExample1.m
%
%  Notes :
%    Correlated color temperature is not a good concept with which to
%    characterize a spectrum if the spectrum lies very far from the
%    "Planckian locus" on the CIE chromaticity diagram. This includes
%    most monochromatic spectra.
%
%  See also : ColorCoordsFromSpectrum, PhotometricFromRadiometric
%
% References :
%  1) Hernandez-Andres, J. and Lee, R.L. and Romero, J. 'Calculating
%  correlated color temperatures acros the entire gamut of daylight and
%  skylight chromaticities', Applied Optics, 38, 27, 5703-5709.
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

% $Date: 2009-10-30 09:07:07 +0200 (Fri, 30 Oct 2009) $
% $Revision: 221 $
% $Author: DGriffith $

% Do some parameter checking
if ~exist('Wv', 'var') || ~isfloat(Wv) || ~isvector(Wv)
    error('CorrColorTemperature:BadWaves', ['Wavelengths input parameter must be floating point vector\n' ...
          ' which overlaps the photometric range of 380 nm to 780 nm']);
end
Wv = Wv(:); % Force to column vector

if ~exist('Spectrum', 'var') || ~isfloat(Spectrum) || size(Spectrum,1) ~= length(Wv)
    error('CorrColorTemperature:BadSpectrum', ['Spectrum input quantity must be a floating point matrix\n' ...
          ' in which the number of rows is equal to the length of the Wavelengths input vector.']);
end

if ~exist('Method', 'var')
    Method = 'Hernandez';
elseif ~ischar(Method)
    error('CorrColorTemperature:BadType', 'Method input parameter must be char naming the CCT calculation method.')
    
end

        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % Set up a nested function for the uvOptimize method
        % The function must return the distance in uv space from a given uv
        % coordinate to the uv coordinate of a planckian radiator of a specific
        % temperature.        
        function Distance = uvDistance(BBTemperature)
        % First compute the uv coordinates of the Planck black body
        [BBu, BBv] = ColorCoordsFromSpectrum(Wv, Planck(Wv/1000, BBTemperature), 'CIE2uv');
        % Compute the distance from (Su, Sv) to (BBu, BBv)
        Vector = [Su Sv] - [BBu BBv];
        Distance = sqrt(Vector(1).^2 + Vector(2).^2);
        end

switch Method
    case 'Hernandez' % This fast method is suitable for daylight and skylight spectra
        % Calculate the xyY chromaticity coordinates
        [x, y] = ColorCoordsFromSpectrum(Wv, Spectrum, 'CIE2xyY'); % 2 degree CIE observer
        % The following comes from Table 2 in Hernandez
        x_e = [0.3366 0.3356]; % chromatic epicentre for CCT
        y_e = [0.1735 0.1691];
        A_0 = [-949.86315 36284.48953];
        A_1 = [6253.80338 0.002288];
        t_1 = [0.92159 0.07861];
        A_2 = [28.70599 5.4535e-36];
        t_2 = [0.20039 0.01543];
        A_3 = [0.00004 NaN];
        t_3 = [0.07125 NaN];
        % Do prelim. calculation to see if CCT lies in range above 50 000 K
        n = (x - x_e(1)) ./ (y - y_e(1)); % Eq. 2 in Hernandez
        CCT = A_0(1) + A_1(1) * exp(-n ./ t_1(1)) + A_2(1) * exp(-n./t_2(1)) + A_3(1) * exp(-n ./ t_3(1)); % Eq 3 in Hernandez
        if CCT >= 50000 % Redo calculation with the shifted epicentre and alternative constants
            n = (x - x_e(2)) ./ (y - y_e(2)); % Eq. 2 in Hernandez
            CCT = A_0(2) + A_1(2) * exp(-n ./ t_1(2)) + A_2(2) * exp(-n./t_2(2)); % Eq 3 in Hernandez            
        end
    case 'uvOptimize'
        if isempty(which('fminsearch'))
            error('CorrColorTemperature:OptToolMissing', 'The uvOptimize method requires the Optimization Toolbox.');
        end
        % This method uses an unconstrained minimisation of the distance
        % from the uv coordinates of the given spectrum to the uv
        % coordinates of a black body at a particular temperature. The
        % optimisation is done with respect to temperature.
        % Find an initial guess using the fast Hernandez method
        StartCCT = CorrColorTemperature(Wv, Spectrum, 'Hernandez');           
        % Perform optimisation 1 spectrum at a time.
        for iSpectrum = 1:size(Spectrum, 2)
          % Compute the uv coordinates of the input spectrum
          [Su, Sv] = ColorCoordsFromSpectrum(Wv, Spectrum(:, iSpectrum), 'CIE2uv');
          % Optimize the distance to black body uv [x,fval,exitflag]
          [CCT(iSpectrum), D, exitflag] = fminsearch(@uvDistance, StartCCT(iSpectrum));
        end
    otherwise
        error('CorrColorTemperature:BadMethod', ['Unknown CCT calculation Method = ' Method '.']);
end % switch

end % CorrColorTemperature Function



