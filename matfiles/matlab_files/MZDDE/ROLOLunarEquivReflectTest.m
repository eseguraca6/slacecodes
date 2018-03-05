% Runs test for ROLOLunarEquivReflect given in
% Hugh H. Kieffer and Thomas C. Stone, "The Spectral Irradiance of the Moon",
% The Astronomical Journal, 129:2887–2901, 2005 June.

[Wv0, Reflect0] = ROLOLunarEquivReflect(0,0,0,0,[],1e-6);
[Wv1, Reflect1] = ROLOLunarEquivReflect([0 pi*40/180],0,0,[0 pi*40/180]);
Zirkind = LunarSpectralAlbedo(.360:.010:1.100);
plot(Wv0,Reflect0,Wv1,Reflect1, 360:10:1100, Zirkind);
title('ROLO Lunar Equivalent Spectral Reflectance');
xlabel('Wavelength (nm)');
ylabel('Reflectance');
legend('Full Moon, Smoothed', 'Full Moon, Unsmoothed', '40 deg Phase, Unsmoothed', 'Zirkind');
axis([350 2300 0.0 0.5])
grid;

iPhase = 1;
Phaser = -180:0.5:180;
r555 = [];
% Calculate equivalent reflectance at 550 nm over lunar phase from -180 to 180 degrees 
for Phase = Phaser
   [Wv, Reflect] = ROLOLunarEquivReflect(abs(pi*Phase/180),0,0,pi*Phase/180,555);
   r555(iPhase) = Reflect;
   iPhase = iPhase + 1;
end
figure;
semilogy(Phaser, r555);
title('Lunar Reflectance over Phase Cycle');
xlabel('Phase Angle (degrees) Negative Phase before Full');
ylabel('Equivalent Reflectance at 555 nm');
axis([-100 100 0.008 0.2])
grid;
