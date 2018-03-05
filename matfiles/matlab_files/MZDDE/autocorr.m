function a=autocorr(r,x)
% Test function - autocorrelation of circular aperture radius e
ii=find(x>2*r);
x(ii)=2*r;
surd = sqrt(x.^2 - 4*r^2);
a = -(x .* surd - 4 * r^2 * log(surd + x))/2 - 2 * r^2 * log(2 * r);
a = abs(a);
