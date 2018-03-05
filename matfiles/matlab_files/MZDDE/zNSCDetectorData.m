function DetData = zNSCDetectorData(Surface, Object, Pixel, Data)
% zNSCDetectorData : Returns incoherent intensity data from a ZEMAX NSC detector object.
%
% Usage :
%        DetectorData = zNSCDetectorData(Surface, Object, Pixel, Data);
%
% where Surface defines the surface number of the NSC group (always 1 in pure NSC systems). 
% Object refers to the object number of the desired detector. If Object is zero, then all 
% detectors are cleared. If Pixel is a positive integer, then the data from the specified pixel 
% is returned. If Pixel is zero, then the sum of the flux or average flux/area for all pixels 
% for that detector object is returned. If Pixel is -1, then the maximum flux or flux/area 
% is returned. If Pixel is -2, then the minimum flux or flux/area is returned. If Pixel is -3, 
% the number of rays striking the detector is returned. If Pixel is -4, the standard deviation 
% (RMS from the mean) of all the pixel data is returned.
% Data is 0 for flux, 1 for flux/area, and 2 for flux/solid angle pixel. Only values 0 and 1 
% (for flux and flux/area) are supported for faceted detectors. See “Optimizing with sources 
% and detectors in nonsequential mode” for complete details. For detector volumes, Pixel is 
% interpreted as the voxel number. For Data values of 0, 1, or 2, the returned value is incident 
% flux, absorbed flux, or absorbed flux per unit volume, respectively. If Pixel is zero, the 
% value returned is the sum for all pixels.
%
% The output DetectorData is a single value for the incoherent data as
% requested. Multiple calls are required to get data for all pixels.
%
% Note that in the interest of speed, this function does no checking of any
% kind. Nonsensical inputs will generally produce 0 or NaN as output.
% Calls to zGetNSCObjectData and zGetNSCParameter are advisable for
% checking that the object is a detector and how many pixels it has.
%
% See also : zNSCTrace, zNSCDetectorMatrix, zGetNSCObjectData, zGetNSCParameter

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
% $Author: DGriffith $
% $Date: 2009-10-30 09:07:07 +0200 (Fri, 30 Oct 2009) $


global ZemaxDDEChannel ZemaxDDETimeout
DDECommand = sprintf('NSCDetectorData,%i,%i,%i,%i',Surface, Object, Pixel, Data);
Reply = ddereq(ZemaxDDEChannel, DDECommand, [1 1], ZemaxDDETimeout);
DetData = str2num(Reply);
