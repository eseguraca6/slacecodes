% This script shows a few examples of the use of the function ColorCoordsFromSpectrum
%
% Compute a CIE chromaticity curve
x = [];
y = [];
for Wv = 386:2:700
    [xTemp, yTemp] = ColorCoordsFromSpectrum(Wv, 1, 'CIE2xyY');
    x = [x; xTemp];
    y = [y; yTemp];
end
x = [x; x(1)]; % close the curve
y = [y; y(1)];
% Plot the xy chromaticity curve
figure;
hold all
plot(x,y);
axis([0 0.8 0 0.9]);
title('CIE 1931 xy Chromaticity Diagram with Ohno Spectra xy');
xlabel('x');
ylabel('y');
grid;

% For next example, compute the xy color coordinates of the Ohno spectra
ReadOhnoCCTSpectra; % Read in the Ohno spectra

[x,y] = ColorCoordsFromSpectrum(OhnoWaves, OhnoSpectra, 'CIE2xyY');
for iSpectrum = 1:length(x)
    % Plot markers at the colour coordinates of the spectra
    plot(x(iSpectrum), y(iSpectrum), 'O');
    text(x(iSpectrum), y(iSpectrum), ['  ' num2str(iSpectrum)]);
end

% Next compute and plot the uv coordinates of a bunch of blackbodies
% This is the "Planckian locus"
BBs = Planck(OhnoWaves/1000, 1000:500:32000); % temperatures 1000 to 32000 K
[xBBs, yBBs] = ColorCoordsFromSpectrum(OhnoWaves, BBs, 'CIE2xyY');
plot(xBBs, yBBs);

hold off
% Also plot the Ohno spectra
figure;
plot(OhnoWaves, OhnoSpectra);
title('Ohno Spectra for Intercomparison of CCT Computation');
xlabel('Wavelength (nm)');
ylabel('Relative Intensity');
grid;
axis([380 780 0 1]);
legend('1','2','3','4','5','6','7', 'Location', 'BestOutside');
