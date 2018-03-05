function Sag = SagEvenAsphere(ProfileData, r)
% SagEvenAsphere - Computes the profile of a ZEMAX standard even aspheric surface.
%
% Usage : Sag = SagEvenAsphere(ProfileData, r)
%
% The Profile data consists of a vector having the paraxial radius of curvature,
% the conic constant and a series of coefficients for the even power of the radial
% distance.
%
% The sag of the surface is computed at the distances r from the axis.
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


% $Revision: 221 $

lenprof = length(ProfileData);
switch lenprof
    case 0
        c = 0; k = 0;
    case 1
        if ProfileData(1) ~= 0
            c=1/ProfileData(1);
        else
            c= 0;
        end
        k = 0;
    otherwise
        if ProfileData(1) ~= 0
            c=1/ProfileData(1);
        else
            c= 0;
        end
        k = ProfileData(2);
end
Sag = (c * r.^2)./(1 + sqrt(1 - (1+k) * c^2 .* r.^2));
if lenprof > 2
    for i = 3:lenprof
        Sag = Sag + ProfileData(i)*r.^(i-1);
    end
end
