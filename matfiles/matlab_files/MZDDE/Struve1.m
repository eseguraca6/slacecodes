function sh1 = Struve1(x)
% Struve Function of First Order
% Usage : H1 = Struve1(x)

% This program is adapted from a direct conversion of the corresponding Fortran program in
% S. Zhang & J. Jin "Computation of Special Functions" (Wiley, 1996).
% online: http://iris-lee3.ece.uiuc.edu/~jjin/routines/routines.html
%
% Converted by f2matlab open source project:
% online: https://sourceforge.net/projects/f2matlab/
% Written by Ben Barrowes (barrowes@alum.mit.edu)
% Adapted and vectorized for MZDDE by D J Griffith

% $Revision: 221 $

% This routine used to fail if x is a vector/matrix containing a zero
% Remove zeros from the vector
i=find(x==0);
% Replace with a harmless value
x(i) = 1;

% The computation uses a different algorithm for different domains (x<=Blendpos and x>Blendpos)
% With the blend at 34, this Struve function may not be suitable for purposes other than computing the LSF.
Blendpos = 34;

% Find values of x that are <= Blendpos and > Blendpos
ileblend = find(x<=Blendpos)';
igtblend = find(x >Blendpos)';

% Populate the result matrix with zeroes
sh1 = zeros(size(x));

% Implement first algorithm on x<= Blendpos domain
if length(ileblend) > 0 
    r = ones(1, length(ileblend));
	s = zeros(1,length(ileblend));
	a0 = -2.0 / pi;
	for  k=1:60
		r = -r .* x(ileblend) .* x(ileblend) / (4 * k * k - 1);
		s = s + r;
		if (abs(r) < (1e-12 * abs(s))) break; end
	end
	sh1(ileblend) = a0 * s;
end

% Implement second algorithm on x > Blendpos domain
if length(igtblend) > 0
    r = ones(1, length(igtblend));
	s = ones(1, length(igtblend));
	km = fix(0.5 * max(x(igtblend)));
	%if (x > 50) km=25; end
	for  k=1:km
		r = -r .*(4 * k * k - 1)./(x(igtblend) .* x(igtblend));
		s = s + r;
		if (abs(r) < 1e-12 * abs(s)) break; end
	end
	t = 4 ./ x(igtblend);
	t2 = t .* t;
	p1=((((.42414d-5.*t2-.20092d-4).*t2+.580759d-4).*t2-.223203d-3).*t2+.29218256d-2).*t2+.3989422819d0;
	q1=t.*(((((-.36594d-5.*t2+.1622d-4).*t2-.398708d-4).*t2+.1064741d-3).*t2-.63904d-3).*t2+.0374008364d0);
	ta1 = x(igtblend) - 0.75 * pi;
	by1 = 2.0 ./ sqrt(x(igtblend)) .* (p1 .* sin(ta1) + q1 .* cos(ta1));
	sh1(igtblend) = 2.0 ./ pi .* (1.0 + s ./ (x(igtblend) .* x(igtblend))) + by1;
end

% Put back zeroes where x was zero
sh1(i) = 0;
