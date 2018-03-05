th=0;
gamma=1.282/0.511e-3;
dth=linspace(-0.01,0.01,1000);
psf=(th+dth).^2./(gamma^-2+(th+dth).^2).^2;
plot((th+dth).*0.5,psf)