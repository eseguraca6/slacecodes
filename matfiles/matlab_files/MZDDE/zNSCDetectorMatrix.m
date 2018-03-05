function DetData = zNSCDetectorMatrix(Surface, Object, Data)
% zNSCDetectorMatrix : Returns incoherent intensity data from a ZEMAX NSC detector object in a matrix.
%
% Usage :
%        DetectorData = zNSCDetectorData(Surface, Object, Data);
%
% where Surface defines the surface number of the NSC group (always 1 in pure NSC systems). 
% Object refers to the object number of the desired detector. 
% Data is 0 for flux, 1 for flux/area, and 2 for flux/solid angle pixel. Only values 0 and 1 
% (for flux and flux/area) are supported for faceted detectors.
%
% A matrix of values for all pixels is returned. This function is slow for
% large numbers of pixels, since a call to zNSCDetectorData is made for
% each pixel.
%
% Note that you must call zNSCTrace before there will be valid current data
% for this function to fetch.
%
% Limitations : Only Rectangular detector objects are currently supported.
%
% See also : zNSCTrace, zNSCDetectorData, zGetNSCObjectData, zGetNSCParameter

%% BSD Licence
% This file is subject to the terms and conditions of the BSD licence.
% For further details, see the file BSDlicence.txt
%%
% Contact : dgriffith@csir.co.za
% 


% $Revision: 221 $
% $Author: DGriffith $
% $Date: 2009-10-30 09:07:07 +0200 (Fri, 30 Oct 2009) $


global ZemaxDDEChannel ZemaxDDETimeout

% Get some information on this object - it must be a detector
ObjType = zGetNSCObjectData(Surface, Object, 0);
if ~strcmp(ObjType, 'NSC_DETE')
    error(['Object ' num2str(Object) ' at surface ' num2str(Surface) ' is not a detector.']);
end
% Next get the size of the detector

numxpix = zGetNSCParameter(Surface, Object, 3); % number of x pixels
numypix = zGetNSCParameter(Surface, Object, 4); % y pixels

DetData = zeros(numypix, numxpix); % Create the output matrix

for ix = 1:numxpix
    for iy = 1:numypix
        ipix = ix + (iy - 1) * numxpix;
        DetData(iy,ix) = zNSCDetectorData(Surface, Object, ipix, Data);
    end
end

DetData = flipud(DetData); % Give the data the same orientation as in Zemax detector viewer
