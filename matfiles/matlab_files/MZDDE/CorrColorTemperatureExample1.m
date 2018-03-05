% This script is an example of the usage of the function
% CorrColorTemperature which calculates correlated color temperature.
%
% The function is illustrated through testing against the Ohno spectra.
% These spectra are given by Ohno and Jergens of NIST
% for the purpose of intercomparison of various methods
% of computing the Correlated Colour Temperature.
% See :
% Ohno, Y. and Jergens, M., 'Results of the Intercomparison of Correlated Color Temperature Calculation',
% CORM Subcommitee CR3 Photometry, NIST, June 16 1999.
% The spectra are :
% 1) FEL type tungsten halogen lamp (~3200 K)
% 2) Integrating sphere source (~2850 K)
% 3) Triphosphor fluorescent lamp (~4000 K)
% 4) Metal halide lamp (~2900 K)
% 5) High pressure sodium lamp (~2000 K)
% 6) High pressure xenon lamp (~6500 K)
% 7) CRT white (~9300 K, white balance artificially set off from the Planckian locus)
%
% Read in the Ohno spectra using the script ReadOhnoCCTSpectra
ReadOhnoCCTSpectra;
% The mean color temperatures in the Ohno study are
OhnoMeanCCT = [3197.6 2856.1 4042.1 2903.2 2042.8 6415.6 9314.1]; % Table 1 in Ohno
% Compute the CCT using the Hernandez method. This is fast, but
% inaccurate for spectra that are not close to daylight/skylight spectra.
HernandezCCT = CorrColorTemperature(OhnoWaves, OhnoSpectra, 'Hernandez')
HernandezCCTError = HernandezCCT - OhnoMeanCCT

% The Hernandez errors are quite large for the Ohno spectra, which means
% that this method is not recommended for spectra sustantially deviant from
% daylight/skylight spectra (e.g. CIE D65). The error is particularly bad
% for spectrum 5 - high pressure sodium lamp

% Calculate Hernandez CCT for CIE D65 (6500 K daylight spectrum)
ReadCIE; % Read in CIE data

% the following gives 6498.4 which is very close to correct
D65CCT = CorrColorTemperature(CIEsLambda, CIEsid65, 'Hernandez');

% Compute a uv chromaticity diagram using ColorCoordsFromSpectrum function.
uMono = [];
vMono = [];
for MonoWv = 400:5:640 % Run through monochromatic wavelengths
   [u, v] = ColorCoordsFromSpectrum(MonoWv, 1, 'CIE2uv');
   uMono = [uMono; u];
   vMono = [vMono; v];
end
uMono(end+1) = uMono(1); % Close the curve
vMono(end+1) = vMono(1);
% Plot the chromaticity diagram
figure;
hold all;
plot(uMono, vMono);
axis([0 0.6 0 0.4]);
grid;
title('CIE 1960 uv Chromaticity Diagram with Ohno Spectra uv');
xlabel('u');
ylabel('v');

% Next compute and plot the uv coordinates of a bunch of blackbodies
% This is the "Planckian locus"
BBs = Planck(OhnoWaves/1000, 1000:500:32000); % temperatures 1000 to 32000 K
[uBBs, vBBs] = ColorCoordsFromSpectrum(OhnoWaves, BBs, 'CIE2uv');
plot(uBBs, vBBs);

% Plot the uv coordinates of the Ohno spectra
[uOhno, vOhno] = ColorCoordsFromSpectrum(OhnoWaves, OhnoSpectra, 'CIE2uv');
for iSpectrum = 1:length(uOhno)
    % Plot markers at the colour coordinates of the spectra
    plot(uOhno(iSpectrum), vOhno(iSpectrum), 'O');
    text(uOhno(iSpectrum), vOhno(iSpectrum), ['  ' num2str(iSpectrum)]);
end
hold off;

% Now compute the color temperaturs of the Ohno spectra using the
% uvOptimize method. The results are much closer to the Ohno mean values.
uvOptimizeCCT = CorrColorTemperature(OhnoWaves, OhnoSpectra, 'uvOptimize')
uvOptimizeCCTError = uvOptimizeCCT - OhnoMeanCCT

