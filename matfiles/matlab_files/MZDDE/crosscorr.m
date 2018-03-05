function a=crosscorr(r,R,zz)

% a1=int(sqrt((x-z)^2-r^2),z-r,(R^2-r^2+z^2)/(2*z))
% a2=int(sqrt(x^2-R^2),(R^2-r^2+z^2)/(2*z),R)
% A = 2*a1 + 2*a2;
% A=simplify(A);

ii=find(zz<R-r);
zz(ii)=R-r;
ii=find(zz>R+r);
zz(ii)=R+r;

for i = 1:length(zz)
  z=zz(i);
  a(i)=-1/2*((R^4-2*r^2*R^2-2*R^2*z^2+r^4-2*r^2*z^2+z^4)/z^2)^(1/2)*z+r^2*log(2)-r^2*log((-r^2-z^2+((z+r-R)*(r+z+R)*(-z+R+r)*(r-z-R)/z^2)^(1/2)*z+R^2)/z)+r^2*log(-r)-R^2*log(R)-R^2*log(2)+R^2*log(-(r^2-z^2-((z+r-R)*(r+z+R)*(-z+R+r)*(r-z-R)/z^2)^(1/2)*z-R^2)/z);
end
a=abs(a);
