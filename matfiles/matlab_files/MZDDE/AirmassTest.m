% Test and plot the various airmass formulae in Airmass.m
% Reference : http://en.wikipedia.org/wiki/Airmass

% This file is subject to the conditions of the BSD licence.
% See the file BSDlicence.txt for further details.

clear AM
ZenithAngle = (80:0.1:91)'; % Plot airmass for zenith angles 80 to 90 degrees
Elevation = 90 - ZenithAngle;

%     'secant'  : airmass is calculated as the secant of the zenith angle. This method is 
%                 acceptable up to zenith angles of 60 to 75 degrees, depending on the
%                 application. At these elevations, atmospheric refraction is not very
%                 large.
%     'young67' : Requires the true elevation angle, good up to 80 degrees zenith angle.
%     'hardie'  : Requires apparent elevation angle, good up to 85 degrees zenith angle.
%     'rozenbg' : Requires apparent elevation angle, good up to 90 degrees zenith angle.
%     'kasten'  : Requires apparent elevation angle, good up to 90 degrees zenith angle.
%     'young94' : Requires the true elevation angle, good up to 90 degrees zenith angle. 

Formulae = {'secant', 'young67', 'hardie', 'rozenbg', 'kasten', 'young94'};

for iFormula = 1:length(Formulae)
    AM(:,iFormula) = Airmass(Elevation, Formulae{iFormula});
end
% Clobber values outside the plot range
AM(AM < -100 | AM > 100) = NaN;
plot(ZenithAngle, AM);
axis([80 91 0 50]);
legend(Formulae, 'Location', 'Best');
grid;
title('Airmass Calculations using Various Formulae');
xlabel('Zenith Angle (degrees)');
ylabel('Airmass');

