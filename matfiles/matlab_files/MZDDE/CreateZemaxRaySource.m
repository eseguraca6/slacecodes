function [RayHeader, RayList] = CreateZemaxRaySource(LaunchPlane, LandingPlane, Filename, Format)
% CreateZemaxRaySource: Create a ray source file for raytracing in Zemax
%
% This function creates a ray source file for use in a Zemax NSC model. The
% user must supply a plane in which the rays are launched and plane where
% the rays land. The probability of the ray be launched at a particular
% location on the source plane and of landing at a particular location on
% the landing plane is supplied. In this way the user can supply arbitrary
% apertures shapes for the source plane and landing plane.
%
% For details, see the Zemax manual in the section on NSC ray sources. This
% function generates either ASCII or binary ray source files. The binary
% format does not seem to work. Use the ASCII format.
%
% The Source File is a source whose ray coordinates, cosines, and intensity
% are defined in a user supplied file. The name of the file containing the 
% ray data must be placed in the comment column of the object. The file
% extension must be DAT and the file must be placed in the 
% 'Objects\Sources\Source Files' directory.
%
% Usage:
%  >> [RayHeader, RayList] = CreateZemaxRaySource(LaunchPlane, LandingPlane, Filename, Format);
%
% Inputs:
%  LaunchPlane is a structure containing data relevant to the launch plane
%  of the rays. it contains the following mandatory fields.
%    Prob : This a matrix of probabilities of a ray being launched
%      from a particular site on the source plane
%    Size : This is a 2-element vector giving the total x and y
%      size of the launch plane.
%    z : is the local z-axis location of the launch plane, where the local
%      z-axis is perpendicular to the launch plane
%    Wv : The default wavelength of the rayset in microns.
%  LaunchPlane may also contain the following optional fields.
%    Offset : is a 2-element vector giving the offset of the launch plane
%      in the x and y directions.
%    SizeUnit : This gives the units of the launch and landing plane sizes.
%      field. Use METERS = 0, IN = 1, CM = 2, FEET = 3, MM = 4. Default MM.
%    Priority : a flag that indicates whether the launch plane or landing
%      plane takes priority in determining the links between launch and
%      landing sites. If the flag is 1 or absent, the launch plane takes
%      priority and every ray generated in the launch plane is linked to a
%      randomly selected set of sites in the landing plane.
%      The converse will be true if the flag is any other value. Note that
%      with either of these options the exact number of rays is not
%      deterministic. See the nRays field to force generation of a specific
%      exact number of rays.
%    nRays : This is the number of rays to generate. If specified, the
%      Priority flag will be ignored, and a random set of launch and
%      landing sites will be matched up to get a deterministic total of
%      nRays rays. nRays must be scalar, integer and greater than 0.
%    TotalPower : If specified, the total power of the rays in the rayset
%      is normalised to this quantity. The total power (flux) is the sum of
%      the ray intensities.
%    Descr : is a character field of up to 100 characters giving a
%      description of the rayset. This field is stored in the binary file,
%      but apparently not used by Zemax.
%
%  LandingPlane is a structure containing data relevant to the landing plane
%  of the rays. The landing plane is the secondary source exported to the file.
%  That is, ray origin coordinates will lie in the landing plane.
%  It contains the following mandatory fields.
%    Prob : This a matrix of probabilities of a ray landing at
%      a particular site on the landing plane
%    Size : This is a 2-element vector giving the total x and y
%      size of the landing plane.
%    z : is the local z-axis location of the landing plane, where the local
%      z-axis is perpendicular to the landing plane
%  LandingPlane may also contain the following optional fields.
%    Offset : is a 2-element vector giving the offset of the landing plane
%      in the local x and y directions. The launch and landing planes
%      always lie in the local x-y plane.
%
%  Format is a character that must be either 'a' to specify an ASCII
%  database or 'b' to specify a binary database. The default is binary.
%
% Bugs : Binary format does not seem to work. Use ASCII format.
%
% See Also: roipoly, impoly (Image Processing Toolbox)

%% Copyright 2002-2009, DPSS, CSIR
% This file is subject to the terms and conditions of the BSD licence.
% For further details, see the file BSDlicence.txt
%

% $Id: CreateZemaxRaySource.m 222 2009-10-30 07:10:35Z DGriffith $

%% Set default outputs and check inputs.

if any(LaunchPlane.Prob(:)<0) || any(LaunchPlane.Prob(:)>1)
    error('CreateZemaxRaySource:ProbOutOfRange','Launch probabilities must be from 0 to 1.')
end
if isfield(LaunchPlane, 'Descr')
    if ~ischar(LaunchPlane.Descr)
        error('CreateZemaxRaySource:BadDescr','LaunchPlane.Descr must be char.');
    else
        if length(LaunchPlane.Descr) >= 100
            LaunchPlane.Descr = LaunchPlane.Descr(1:100);
        else
            LaunchPlane.Descr(end+1:100) = ' ';
        end
    end
else
    LaunchPlane.Descr = ['Created with CreateZemaxRaySource.m ' datestr(now)];
end
if isfield(LaunchPlane, 'SizeUnit')
    if ~isscalar(LaunchPlane.SizeUnit) || ~any(LaunchPlane.SizeUnit == [0 1 2 3 4])
        error('CreateZemaxRaySource:BadSizeUnit','Field SizeUnit must be scalar and from 0 to 4.');
    end
else
    LaunchPlane.SizeUnit = 4; % default mm
end
% Generate ray origins

LPSize1 = size(LaunchPlane.Prob);
Threshold1 = rand(LPSize1);
LaunchSites = LaunchPlane.Prob > Threshold1;
% Compute the x and y coordinates of the launch sites
PixelSize1 = LaunchPlane.Size ./ (LPSize1 - 1);

y1 = -LaunchPlane.Size(1)/2:PixelSize1(1):LaunchPlane.Size(1)/2;
x1 = -LaunchPlane.Size(2)/2:PixelSize1(2):LaunchPlane.Size(2)/2;

[xx1,yy1] = meshgrid(x1,y1);
iLaunchSites = find(LaunchSites);
xx1 = xx1(iLaunchSites);
yy1 = yy1(iLaunchSites);
%RayList = [xx1 yy1];
if isfield(LaunchPlane, 'Offset')
    xx1 = xx1+LaunchPlane.Offset(1);
    yy1 = yy1+LaunchPlane.Offset(2);
end

% Generate ray landings
LPSize2 = size(LandingPlane.Prob);
Threshold2 = rand(LPSize2);
LandingSites = LandingPlane.Prob > Threshold2;
% Compute the x and y coordinates of the landing sites
PixelSize2 = LandingPlane.Size ./ (LPSize2 - 1);

y2 = -LandingPlane.Size(1)/2:PixelSize2(1):LandingPlane.Size(1)/2;
x2 = -LandingPlane.Size(2)/2:PixelSize2(2):LandingPlane.Size(2)/2;

[xx2,yy2] = meshgrid(x2,y2);
iLandSites = find(LandingSites);
xx2 = xx2(iLandSites);
yy2 = yy2(iLandSites);

if isfield(LandingPlane, 'Offset')
    xx2 = xx2+LandingPlane.Offset(1);
    yy2 = yy2+LandingPlane.Offset(2);
end

%RayList = [xx2 yy2];

%% If the launch sites take priority, generate a list of random
%  landing sites that is the same length as the list of launch sites
if isfield(LaunchPlane, 'nRays') && round(LaunchPlane.nRays(1)) > 0
        nRays = round(LaunchPlane.nRays(1));
        iLaunchSitesSelect = ceil(rand(nRays,1)*size(xx1,1));
        xx1 = xx1(iLaunchSitesSelect);
        yy1 = yy1(iLaunchSitesSelect);

        iLandSitesSelect = ceil(rand(nRays,1)*size(xx2,1));
        xx2 = xx2(iLandSitesSelect);
        yy2 = yy2(iLandSitesSelect);

        zz2 = repmat(LandingPlane.z, nRays,1);
        zz1 = repmat(LaunchPlane.z, nRays,1);

else
    if ~isfield(LaunchPlane, 'Priority') || (isfield(LaunchPlane, 'Priority') && LaunchPlane.Priority == 1)
        iLandSitesSelect = ceil(rand(size(xx1,1),1)*size(xx2,1));
        xx2 = xx2(iLandSitesSelect);
        yy2 = yy2(iLandSitesSelect);
        zz2 = repmat(LandingPlane.z, size(xx2,1),1);
        zz1 = repmat(LaunchPlane.z, size(xx1,1),1);
        
    else % otherwise generate random list of launch sites
        iLaunchSitesSelect = ceil(rand(size(xx2,1),1)*size(xx1,1));
        xx1 = xx1(iLaunchSitesSelect);
        yy1 = yy1(iLaunchSitesSelect);
        zz1 = repmat(LaunchPlane.z, size(xx1,1),1);
        zz2 = repmat(LandingPlane.z, size(xx2,1),1);
    end
end
nRays = size(xx1,1);
RayIntensity = ones(nRays, 1);
% Normalise the ray intensities if requested
TotalPower = sum(RayIntensity, 1);

if isfield(LaunchPlane, 'TotalPower')
    TotalPower = sum(RayIntensity, 1);
    RayIntensity = RayIntensity * LaunchPlane.TotalPower/TotalPower;
    TotalPower = LaunchPlane.TotalPower;

end

% Compute the ray vectors
RayVec = [xx2-xx1 yy2-yy1 zz2-zz1];
% Normalize to get the direction cosines
RayVec = RayVec ./ repmat(sqrt(sum(RayVec.*RayVec,2)),1,3);


% Write the data to a file if a filename was given
if exist('Filename', 'var')
    fid = fopen(Filename, 'w', 'native');

    if ~exist('Format', 'var') || (exist('Format','var') && Format(1) == 'b')
        % Write binary format
        
        % int Identifier; // Will be set to 8675309 for quick check of proper format
        fwrite(fid, 8675309, 'int32');
        % int NbrRays; // The number of rays in the file
        fwrite(fid, size(RayVec,1),'int32');
        % char Description[100]; // A text description of the source
        if isfield(LaunchPlane, 'Descr')
            fwrite(fid, LaunchPlane.Descr, 'uchar');
        else
            fwrite(fid, repmat('CreateZemaxRaySource',1,5), 'uchar');
        end
        % float SourceFlux; // The total flux in watts of this source
        fwrite(fid, 1, 'float32');
        % float RaySetFlux; // The flux in watts represented by this Ray Set
        fwrite(fid, 1, 'float32');
        % float Wavelength; // The wavelength in micrometers, 0 if a composite
        fwrite(fid, LaunchPlane.Wv, 'float32');
        % float AzimuthBeg, AzimuthEnd; // Angular range for ray set (Degrees)
        fwrite(fid, [-1 1], 'float32');
        % float PolarBeg, PolarEnd;// Angular range for ray set (Degrees)
        fwrite(fid, [-1 1], 'float32');
        % long DimensionUnits; // METERS=0, IN=1, CM=2, FEET=3, MM=4
        if isfield(LaunchPlane, 'SizeUnit')
            fwrite(fid, LaunchPlane.SizeUnit, 'int64');
        else
            fwrite(fid, 4, 'int64');
        end
        % float LocX, LocY,LocZ; // Coordinate Translation of the source
        fwrite(fid, [0 0 0], 'float32');
        % float RotX,RotY,RotZ; // Source rotation (Radians)
        fwrite(fid, [0 0 0], 'float32');
        % float ScaleX, ScaleY, ScaleZ; // Scale factor to expand/contract source
        fwrite(fid, [1 1 1], 'float32');
        % float unused1, unused2, unused3, unused4;
        fwrite(fid, [0 0 0 0], 'float32');
        % int reserved1, reserved2, reserved3, reserved4;
        fwrite(fid, [0 0 0 0], 'float32');
        % Write all the ray data
        for iRay = 1:size(RayVec,1)
            % x y z l m n and intensity, all float32
            fwrite(fid, xx2(iRay), 'float32');
            fwrite(fid, yy2(iRay), 'float32');
            fwrite(fid, LandingPlane.z, 'float32');
            fwrite(fid, RayVec(iRay, :), 'float32');
            fwrite(fid, RayIntensity(iRay), 'float32');
        end
    else % write ascii format
        if isfield(LaunchPlane, 'SizeUnit')
            fprintf(fid, '%f %f\n', size(RayVec,1), LaunchPlane.SizeUnit);
        else
            fprintf(fid, '%f 4\n', size(RayVec,1));
        end
        for iRay = 1:size(RayVec,1)
            % x y z l m n and intensity, all float32
            fprintf(fid, '%g ', xx2(iRay));
            fprintf(fid, '%g ', yy2(iRay));
            fprintf(fid, '%g ', LandingPlane.z);
            fprintf(fid, '%g ', RayVec(iRay, :));
            fprintf(fid, '%g\n', RayIntensity(iRay));
        end
    end
    fclose(fid);
end
if nargout > 0
    % Generate the header data
    RayHeader.Description = LaunchPlane.Descr;
    RayHeader.NbrRays = nRays;
    RayHeader.DimensionUnits = LaunchPlane.SizeUnit;
    RayHeader.Wavelength = LaunchPlane.Wv;
    RayHeader.SourceFlux = TotalPower;
end
if nargout >= 2
  % Generate the ray list
  for iRay = 1:size(xx1,1)
    RayList.RayData(iRay).x = xx2(iRay);
    RayList.RayData(iRay).y = yy2(iRay);
    RayList.RayData(iRay).z = LandingPlane.z;
    RayList.RayData(iRay).l = RayVec(iRay,1);
    RayList.RayData(iRay).m = RayVec(iRay,2);
    RayList.RayData(iRay).n = RayVec(iRay,3);
  end
end

