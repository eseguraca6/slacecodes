function r = findobs(wave,err)
% findobs - Establish the size of the axial central obscuration of a system (relative pupil height y), using bisection.
% 
% Usage : r = findobs(Wavelength, error);
% Returns the relative height in y of the obscuration in pupil coordinates at wavelength number "Wavelength".
% Iterates until successive bisections have reduced the error level to "error".

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

if (err < 1e-15)
    err = 1e-15;
end

py = 0.5;
inner = 0.0; outer = 1.0;
sysdata = zgetsystem;
imsurf = sysdata(1);

% Trace a ray at half pupil through to the image
rtdata = zGetTrace(wave, 1, imsurf, 0, 0, 0, py);

while (outer-inner)>err % iterate until the error criterion is met
	% Check if ray error
	if (rtdata(1) ~=0)
        error('Ray missed or encountered TIR. Fix lens and try again')
	end
	
	% Check if ray vignetted
	if (rtdata(2) ~= 0)
        % If vignetted, move outwards
        inner = py;
        py = (py+outer)/2;
        
	else
        % If not vignetted, move inwards
        outer = py;
        py = (py+inner)/2;
        
	end
    rtdata = zGetTrace(wave, 1, imsurf, 0, 0, 0, py);
    if outer <= err
        error('No central obscuration found within the error margin.');
    end
    if (1-inner) <= err
        error('Pupil fully obscured within the margin of error.');
    end
end

r = py;
