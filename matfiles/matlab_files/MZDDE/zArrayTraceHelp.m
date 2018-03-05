% zArrayTrace - Performs tracing of large numbers of rays in ZEMAX.
%
% RayDataOut = zArrayTrace(RayDataIn);
% or
% RayDataOut = zArrayTrace(RayDataIn, Timeout);
%
% Timeout is the amount of time in milliseconds to give ZEMAX to finish raytracing before the command times out.
% RayDataIn and RayDataOut are structures with the following fields : x, y, z, l, m, n, Exr, Exi,
% Eyr, Eyi, Ezr, Ezi, wave, error, vigcode, want_opd.
%
% Only non-zero fields of RayDataIn need be set. RayDataOut will be returned with all fields.
% If the command times out, an error message is generated.
%
% There are 5 modes of raytracing documented in the "Tracing Large numbers of rays" section of the
% chapter on "ZEMAX Extensions" in the ZEMAX manual. Usage of zArrayTrace is exactly as documented
% there with the following exception. Matlab uses arrays starting at index 1 whereas C starts at
% index 0. Any references to RayData[0] in C will therefore apply to RayDataIn(1) in Matlab.
%
% The first element of the RayDataIn structure determines which mode of raytracing is selected. The
% modes can be summarised as follows.
%
% Mode 0 : Trace ray from fractional field coordinates hx, hy to fractional pupil coordinates px, py.
% The fields of the first element are set as follows :
%   RayDataIn(1).opd = 0;  % Sets mode 0 - actually no need to set any fields that are zero.
%   RayDataIn(1).wave = raytracingmode; % Set to 0 for real rays, set to 1 for paraxial rays. 
%   RayDataIn(1).error = numberofrays;  % This MUST be set to the number of rays to be traced.
%   RayDataIn(1).want_opd = finalsurface; % Last surface to which rays must be traced. Use -1 for image.
% Then for ray number i, fill in the following data :
%   RayDataIn(i+1).x = hx; % Fractional field coordinates
%   RayDataIn(i+1).y = hy;
%   RayDataIn(i+1).z = px; % Fractional pupil coordinates
%   RayDataIn(i+1).l = py;
%   RayDataIn(i+1).intensity = 1.0;  % Initial intensity of the ray
%   RayDataIn(i+1).wave = wavenumer; % The wavelength number to use for raytracing
%   RayDataIn(i+1).want_opd = opdrequest; % Set to 0 for no OPD calculations, set to 1 for OPD calculations.
% Consult the ZEMAX manual for further details.
%
% Mode 1 : Trace a ray from a given point in a given direction.
% The fields of the first element are set as follows :
%   RayDataIn(1).opd = 1;  % Sets mode 1.
%   RayDataIn(1).wave = raytracingmode; % Set to 0 for real rays, set to 1 for paraxial rays. 
%   RayDataIn(1).error = numberofrays;  % This MUST be set to the number of rays to be traced.
%   RayDataIn(1).vigcode = startsurface % First surface, and surface on which the given coordinates start.
%   RayDataIn(1).want_opd = finalsurface; % Last surface to which rays must be traced. Use -1 for image.
% Then for ray number i, fill in the following data :
%   RayDataIn(i+1).x = x; % Local coordinates from which the ray is launched at given surface.
%   RayDataIn(i+1).y = y;
%   RayDataIn(i+1).z = z.
%   RayDataIn(i+1).l = l; % Direction cosines of the ray launch.
%   RayDataIn(i+1).m = m;
%   RayDataIn(i+1).n = n;
%   RayDataIn(i+1).intensity = 1.0;  % Initial intensity of the ray
%   RayDataIn(i+1).wave = wavenumer; % The wavelength number to use for raytracing
%   RayDataIn(i+1).want_opd = opdrequest; % Set to 0 for no OPD calculations, set to 1 for OPD calculations.
% Consult the ZEMAX manual for further details.
% 
% Mode 2 : Trace a ray from fractional field coordinates hx, hy to fractional pupil coordinates px, py, and compute
% state of polarisation.
% The fields of the first element are set as follows :
%   RayDataIn(1).x = Ex;   % Electric field amplitude in x
%   RayDataIn(1).y = Ey;   % Electric field amplitude in y 
%   RayDataIn(1).z = Phax; % Phase in degrees for Ex 
%   RayDataIn(1).l = Phay; % Phase in degrees for Ey 
%   RayDataIn(1).opd = 2;  % sets mode 2 
%   RayDataIn(1).wave = raytracingmode; % 0 for real rays, 1 for paraxial rays 
%   RayDataIn(1).error = numrays;       % This MUST be set to the number of rays to be traced.
%   RayDataIn(1).want_opd = lastsurf;   % -1 for image, or any valid surface number 
% Then for ray number i, fill in the following data :
%   RayDataIn(i+1).x = hx; % Fractional Field coordinates
%   RayDataIn(i+1).y = hy; 
%   RayDataIn(i+1).z = px; % Fractional Pupil coordinates
%   RayDataIn(i+1).l = py;
%   RayDataIn(i+1).intensity = 1.0; % Initial intensity 
%   RayDataIn(i+1).Exr = Exr % Electric field X real 
%   RayDataIn(i+1).Exi = Exi % Electric field X imaginary 
%   RayDataIn(i+1).Eyr = Eyr % Electric field Y real 
%   RayDataIn(i+1).Eyi = Eyi % Electric field Y imaginary 
%   RayDataIn(i+1).Ezr = Ezr % Electric field Z real 
%   RayDataIn(i+1).Ezi = Ezi % Electric field Z imaginary 
%   RayDataIn(i+1).wave = wavenumber;
% See the ZEMAX Manual for further details.
%
% Mode 3 : Trace a ray from a given point in a given direction and compute state of polarisation.
% The fields of the first element are set as follows :
%   RayDataIn(1).x = Ex; % Electric field amplitude in x  
%   RayDataIn(1).y = Ey; % Electric field amplitude in y  
%   RayDataIn(1).z = Phax; % Phase in degrees for Ex  
%   RayDataIn(1).l = Phay; % Phase in degrees for Ey  
%   RayDataIn(1).opd = 3; % sets mode 3  
%   RayDataIn(1).wave = mode; % 0 for real rays, 1 for paraxial rays  
%   RayDataIn(1).error = numrays; % This MUST be set to the number of rays to be traced.
%   RayDataIn(1).vigcode = startsurf; % the surface on which the coordinates start  
%   RayDataIn(1).want_opd = lastsurf; % -1 for image, or any valid surface number
% Then for ray number i, fill in the following data :
%   RayDataIn(i+1).x = x; % Ray starting point coordinates
%   RayDataIn(i+1).y = y;
%   RayDataIn(i+1).z = z;
%   RayDataIn(i+1).l = l; % Ray starting direction
%   RayDataIn(i+1).m = m;
%   RayDataIn(i+1).n = n;
%   RayDataIn(i+1).intensity = 1.0; % initial intensity  
%   RayDataIn(i+1).Exr = Exr % Electric field X real  
%   RayDataIn(i+1).Exi = Exi % Electric field X imaginary  
%   RayDataIn(i+1).Eyr = Eyr % Electric field Y real  
%   RayDataIn(i+1).Eyi = Eyi % Electric field Y imaginary  
%   RayDataIn(i+1).Ezr = Ezr % Electric field Z real  
%   RayDataIn(i+1).Ezi = Ezi % Electric field Z imaginary  
%   RayDataIn(i+1).wave = wavenumber;
% See the ZEMAX Manual for further details.
%
% Currently there is no mode 4.
%
% Mode 5 : Tracing of a single ray in a non-sequential group of objects.
% The fields of the first element are set as follows :
%   RayDataIn(1).x = x; % Starting x coordinate  
%   RayDataIn(1).y = y; % Starting y coordinate  
%   RayDataIn(1).z = z; % Starting z coordinate  
%   RayDataIn(1).l = l; % Starting x direction cosine  
%   RayDataIn(1).m = m; % Starting y direction cosine  
%   RayDataIn(1).n = n; % Starting z direction cosine  
%   RayDataIn(1).opd = 5+nMaxSegments; % sets mode 5, see ZEMAX Manual for further details.
%   RayDataIn(1).intensity = 1.0; % initial intensity  
%   RayDataIn(1).Exr = Exr; % initial E field if doing pol ray tracing, otherwise 0.0
%   RayDataIn(1).Exi = Exi;
%   RayDataIn(1).Eyr = Eyr;
%   RayDataIn(1).Eyi = Eyi;
%   RayDataIn(1).Ezr = Ezr;
%   RayDataIn(1).Ezi = Ezi;
%   RayDataIn(1).wave = wavenumber; % wavelength number, use 0 for randomly selected by weight  
%   RayDataIn(1).error = NSCGroup; % NSC group surface, 1 if the program mode is NSC  
%   RayDataIn(1).vigcode = PolSplitScatter; % controls polarization, split, and scatter  
%   RayDataIn(1).want_opd = Object; % The inside of flag, use 0 if ray is not inside anything  
% The integer vigcode value determines if polarization ray tracing, splitting, and scattering are to be used. To
% determine the vigcode value, use 0 for no polarization, 1 for polarization, plus 2 if splitting is used, plus 4 if
% scattering is used. The resulting integer will be between 0 and 7 inclusive. Note if ray splitting is to be used,
% polarization must be used as well.
%
% Note : For all modes, be sure to fill in the "error" field correctly (number of rays) for the first element. 
% Although zArrayTrace provides some protection, failure to do so can cause Matlab to report a 
% Segmentation Violation or to crash.
%
% See also zGetTrace, zGetTraceDirect, zGetPolTrace, zGetPolTraceDirect.

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


% Written by D J Griffith
% $Revision: 221 $

% Modification History
% Bug reported as follows and code fixed 2006-03-29
% There is an error in the function zArrayTrace included in the MZDDE Toolbox. 
% When calling the function with polarisation switched on, setting Ezr = 1 results in Exr = 1 but Ezr = 0. 
% Setting Exr to any non-zero value always results in Exr being set to the value chosen for Ezr, while Ezr is always zero. 
% I've tracked down the error in the source file zArrayTrace.cpp - 
% from line 325 onwards in the CASE statements, all the case 13's should refer to Ezr, but in fact refer to Exr. 
% Exr is already covered by the case 9's and so the value gets overwritten, while Ezr is never set.
