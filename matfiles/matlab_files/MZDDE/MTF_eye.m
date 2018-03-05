function MTF = MTF_eye(spfreq, lightlevel)
% Usage : MTF = MTF_eye(spfreq, lightlevel)
% returns the MTF of the eye at the spatial frequencies spfreq and lightlevel
% spatial frequencies are in cycles per milliradian
% lightlevel is in footlamberts !
%
% This computation is based on Overington (1976), as described by Vollmerhausen in 
% Biberman2000 (Chapter 12 Appendix II Page 12-44).

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

% First compute the pupil diameter
loglightlevel = round(log10(lightlevel)) + 5;
if loglightlevel < 1
    loglightlevel = 1
end

if loglightlevel > 8
    loglightlevel = 8
end

pupildiameters = [7.0;6.2;5.6;4.9;4.2;3.6;3.0;2.5];
pupildiameter = pupildiameters(loglightlevel);

% new set of pupil diameters for getting optics MTF
pupildiameters = [1.5;2.0;2.4;3.0;3.8;4.9;5.8;6.6;7.0];
f_0s = [36;39;35;32;25;15;11;8;8];
i_0s = [0.9;0.8;0.8;0.77;0.75;0.72;0.69;0.66;0.66];

f_0 = interp1(pupildiameters, f_0s, pupildiameter);
i_0 = interp1(pupildiameters, i_0s, pupildiameter);


MTF_optics = exp(-(43.69 * spfreq /f_0).^i_0);
MTF_retina = exp(-0.375 * spfreq.^1.21);
MTF_tremor = exp(-0.4441 * spfreq.^2);

MTF = MTF_optics .* MTF_retina .* MTF_tremor;
