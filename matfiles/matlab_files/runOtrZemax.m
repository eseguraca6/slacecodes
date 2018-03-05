clear; close all
%% OTR PSF data
nray=1000;
obsang=0; %0.3491; % 20 deg = 0.3491 rad
thran=0.0035;
th=0;
gamma=1.282/0.511e-3;
dth=linspace(-thran,thran,1e6);
psf=(th+dth).^2./(gamma^-2+(th+dth).^2).^2;
psf=psf./max(abs(psf));
figure
plot(th+dth,psf)
% Wavelengths from optical filter central wavelength = 500nm, FWHM= 40nm
sigOF=0.04/(2*sqrt(2*log(2)));
[wvI,lam]=histcounts(randn(1,1000000).*sigOF); lam=lam+0.5; wvI=wvI./max(wvI);
OF_lam=linspace(lam(1),lam(end-1),23);
%% Load into Zemax
% zDDEInit;
zSetWave(0, 0.5, 23);
for iwf=1:23
  zSetWave(iwf, OF_lam(iwf), interp1(lam(1:end-1),wvI,OF_lam(iwf)));
end
zPushLens(1)
RayDataIn(1).opd = 1;  % Sets mode 1.
RayDataIn(1).wave = 0; % Set to 0 for real rays, set to 1 for paraxial rays.
RayDataIn(1).error = nray;  % This MUST be set to the number of rays to be traced.
RayDataIn(1).vigcode = 1; % First surface, and surface on which the given coordinates start.
RayDataIn(1).want_opd = -1; % Last surface to which rays must be traced. Use -1 for image.
xth=0;
yth=(rand(1,nray)-0.5).*thran.*2;
I=interp1(dth,psf,xth).*interp1(dth,psf,yth);
for iray=1:nray
  x=0; y=0.1; z=0;
  l=0;
  m=sin((yth(iray)+obsang));
  n=sqrt(1-l^2-m^2);
  RayDataIn(iray+1).x = x; % Local coordinates from which the ray is launched at given surface.
  RayDataIn(iray+1).y = y;
  RayDataIn(iray+1).z = z;
  RayDataIn(iray+1).l = l; % Direction cosines of the ray launch.
  RayDataIn(iray+1).m = m;
  RayDataIn(iray+1).n = n;
  RayDataIn(iray+1).intensity = I(iray);  % Initial intensity of the ray
  RayDataIn(iray+1).wave = iray; % The wavelength number to use for raytracing
  RayDataIn(iray+1).want_opd = 1; % Set to 0 for no OPD calculations, set to 1 for OPD calculations.
end
RayDataOut = zArrayTrace(RayDataIn);
ydat=[RayDataOut.y];
I=[RayDataOut.intensity];
figure
[mag,x,bin]=histcounts(ydat);
A=accumarray(bin',I);
plot(x(1:end-1)+diff(x(1:2))/2,A)
fprintf('STDY: %g\n',sqrt(var(x(1:end-1)+diff(x(1:2))/2,A)))