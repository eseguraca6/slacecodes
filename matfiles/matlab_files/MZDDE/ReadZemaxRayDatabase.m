function [Rays, FileID]  = ReadZemaxRayDatabase(Filename, MaxRaysToRead)
% ReadZemaxRayDatabase : Read a Zemax .ZRD Ray Database file
%
% Usage :
%   >> [Rays, FileID] = ReadZemaxRayDatabase(Filename, MaxRaysToRead)
%     Or
%   >> Rays = ReadZemaxRayDatabase(FileID, MaxRaysToRead)
%
% Where the inputs are:
%  Filename is the full path and filename of the file .ZRD file to read.
%    If Filename is not given or is given as the empty string (''), a file
%    open dialog is presented for selection of the file.
%  MaxRaysToRead is the maximum number of rays to read from the file. This
%    option is provided in order to deal with very large databases. If a
%    limited number of rays is to be read, the FileID output should be
%    saved and with the subsequent calls to the function, the FileID is
%    given instead of the Filename. In this way, the rays can be read in
%    batches of size MaxRaysToRead. Fewer rays may be returned if the
%    end-of-file is reached. If end-of-file is reached, the FileID is
%    returned empty.
%
% The returned data is as follows:
% Rays is a structure containing one element per ray. Each ray comprises a
% number of segments. Note that segments are numbered from 0, not from 1, although 
% segment 0 has length zero and exists to indicate the ray source origin.
% Each ray has a field called seg that contains the ray segment details.
% The sub-fields in the seg field are as follows:
%  iseg : the number of the ray segment. 
%  status: bitwise flags indicating the status of the ray.
%  statusbits: gives the status flags in bitwise form. The meaning of the
%          bits is as follows:
%            bit 1 : ray terminated
%            bit 2 : ray reflected
%            bit 3 : ray refracted
%            bit 4 : ray scattered
%            bit 5 : ray diffracted
%            bit 6 : ray ghost
%            bit 7 : ray diffracted from previous object
%            bit 8 : ray scattered from previous object
%            bit 9 : ray segment had fatal error
%            bit 10: ray bulk scattered
%  level: The number of ray segments between the ray segment and the original source. This is the number of
%         ray-object intercepts the ray has accumulated.
%  hit_object: The object number the ray intercepted. If zero, the ray did not hit anything. For the zero segment,
%         this value will be the source segment object number.
%  hit_face: The face number the ray intercepted. Valid only if hit_object is not zero.
%  in_object: The object number the ray is propagating inside of. This generally determines the index of refraction
%         the ray is traveling through. A value of zero means inside the "background media".
%  parent: The (prior) ray segment from which the ray originated. If zero, the ray came from the original source
%         point. Note more than 1 child ray may have the same parent; but each ray has only one parent. The parent
%         segment number will always be less than the child rays segment number.
%  storage: A temporary buffer used by ZEMAX for indexing. For segment 0 only, this integer is the ray wavelength
%         number. Other segments may contain meaningless data.
%  xybin, lmbin: The pixel number on a detector object which the ray struck. The xybin is for spatial data, the lmbin
%         is for angular (intensity) data.
%  index: the index of refraction of the media. Not an adequate description for gradient index media.
%  starting_phase: the initial optical path length the ray starts with. This is usually the contribution from diffraction
%         gratings when rays are split off.
%  x, y, z: the global coordinates of the ray intercept.
%  l, m, n: the global direction cosines of the ray. Not an adequate description for gradient index media.
%  nx, ny, nz: the global normal vector of the object at the intercept point.
%  path_to: the physical (not optical) path length of the ray segment.
%  intensity: the intensity of the ray segment.
%  phase_of: the phase of the object. This is the optical phase path length equivalent in lens units added by
%         gratings, holograms, and other phase modifying surfaces.
%  phase_at: the accumulated total phase of the ray. This value is only computed at detector surfaces.
%  exr, exi, eyr, eyi, ezr, ezi: the electric field in the global x, y, and z coordinates, real and imaginary parts. These
%         values will all be zero if the ray trace did not use polarization.
%
% Examples:
%   >> Rays = ReadZemaxRayDatabase;
%  The above example presents a file open dialog to select the .ZRD file
%  and reads all rays from the file.
%
%   >> [Rays, FileID] = ReadZemaxRayDatabase('', 20);
%   >> [Rays, FileID] = ReadZemaxRaydatabase(FileID, Inf);
%  The above example presents a file open dialog to select the .ZRD file
%  and 20 rays are read and returned. The FileID is also returned. The
%  second call then reads the remainder of the rays in the file. Any number
%  of rays can be specified. If the end-of-file is reached, FileID will be
%  empty.
%
% Bugs and Caveats:
%  This function is written for version 1011 of the ZRD database. Other
%  versions may return incorrect data. A warning is issued if the 
%  database is not version 1011.
%

% $Id: ReadZemaxRayDatabase.m 221 2009-10-30 07:07:07Z DGriffith $

persistent fid ZRDVersion MaxSegs

CurrentZRDVersion = 1011;
Rays = [];

if ~exist('MaxRaysToRead','var')
    MaxRaysToRead = Inf;
end

if ~exist('Filename', 'var') || isempty(Filename)
    [Filename, Pathname] = uigetfile('*.zrd', 'Select the Zemax Ray Database File');
    if ~Filename
        return
    end
    Filename = [Pathname Filename];
end

if fid == Filename(1) % Reading more data from previously opened file
else
    if ~isempty(fid) % a file is already open
        fclose(fid); % close it and open the new file
    end
    if ~exist(Filename, 'file')
      error('ReadZemaxRayDatabase:FileDoesNotExist','Given file does not exist.')
    end

    fid = fopen(Filename, 'r', 'n');
    FileID = fid;
    if ~fid
        FileID = [];
        return
    end
    ZRDVersion = fread(fid, 1, 'int32');
    if ZRDVersion ~= CurrentZRDVersion
        warning('ReadZemaxRayDatabase:VersionWarning', ...
            ['The ZRD database is not version ' num2str(CurrentZRDVersion) ' and results may be incorrect.']);
    end
    MaxSegs = fread(fid, 1, 'int32');
end
% Read next batch of rays or to end of file
iRay = 0;
while ~feof(fid) && (iRay < MaxRaysToRead)
    NumSegs = fread(fid, 1, 'int32');
    if NumSegs > MaxSegs
        warning('ReadZemaxRayDatabase:MaxSegsExceeded',...
            ['A ray in the database has more segments than the indicated maximum of ' num2str(MaxSegs) '. Check the data.']);
    end
    if ~isempty(NumSegs)
      iRay = iRay + 1; 
      Rays(iRay).numsegs = NumSegs;
      for iSeg = 1:NumSegs
        Rays(iRay).seg(iSeg).iseg = iSeg-1; % Segments are labelled from 0
        % unsigned int status;
        Rays(iRay).seg(iSeg).status = fread(fid, 1, 'uint32');
        % Convert the status flags to bits for convenience
        Rays(iRay).seg(iSeg).statusbits = bitget(Rays(iRay).seg(iSeg).status, 1:1:10);
        % int level;
        Rays(iRay).seg(iSeg).level = fread(fid, 1, 'int32');
        % int hit_object;
        Rays(iRay).seg(iSeg).hit_object = fread(fid, 1, 'int32');
        % int hit_face;
        Rays(iRay).seg(iSeg).hit_face = fread(fid, 1, 'int32');
        % int in_object;
        Rays(iRay).seg(iSeg).in_object = fread(fid, 1, 'int32');
        % int parent;
        Rays(iRay).seg(iSeg).parent = fread(fid, 1, 'int32');
        % int storage;
        Rays(iRay).seg(iSeg).storage = fread(fid, 1, 'int32');
        % int xybin, lmbin;
        Rays(iRay).seg(iSeg).xybin = fread(fid, 1, 'int32');
        Rays(iRay).seg(iSeg).lmbin = fread(fid, 1, 'int32');
        % Read 4 padding bytes (see Zemax manual why)
        padding = fread(fid, 4, 'uint8');
        % double index, starting_phase;
        Rays(iRay).seg(iSeg).index = fread(fid, 1, 'double');
        Rays(iRay).seg(iSeg).starting_phase = fread(fid, 1, 'double');
        % double x, y, z;
        Rays(iRay).seg(iSeg).x = fread(fid, 1, 'double');
        Rays(iRay).seg(iSeg).y = fread(fid, 1, 'double');
        Rays(iRay).seg(iSeg).z = fread(fid, 1, 'double');
        % double l, m, n;
        Rays(iRay).seg(iSeg).l = fread(fid, 1, 'double');
        Rays(iRay).seg(iSeg).m = fread(fid, 1, 'double');
        Rays(iRay).seg(iSeg).n = fread(fid, 1, 'double');
        % double nx, ny, nz;
        Rays(iRay).seg(iSeg).nx = fread(fid, 1, 'double');
        Rays(iRay).seg(iSeg).ny = fread(fid, 1, 'double');
        Rays(iRay).seg(iSeg).nz = fread(fid, 1, 'double');
        % double path_to, intensity;
        Rays(iRay).seg(iSeg).path_to = fread(fid, 1, 'double');
        Rays(iRay).seg(iSeg).intensity = fread(fid, 1, 'double');
        % double phase_of, phase_at;
        Rays(iRay).seg(iSeg).phase_of = fread(fid, 1, 'double');
        Rays(iRay).seg(iSeg).phase_at = fread(fid, 1, 'double');
        % double exr, exi, eyr, eyi, ezr, ezi;
        Rays(iRay).seg(iSeg).exr = fread(fid, 1, 'double');
        Rays(iRay).seg(iSeg).exi = fread(fid, 1, 'double');
        Rays(iRay).seg(iSeg).eyr = fread(fid, 1, 'double');
        Rays(iRay).seg(iSeg).eyi = fread(fid, 1, 'double');
        Rays(iRay).seg(iSeg).ezr = fread(fid, 1, 'double');
        Rays(iRay).seg(iSeg).ezi = fread(fid, 1, 'double');
      end
    end
end
if feof(fid)
  % disp('File closed');
  fclose(fid);
  fid = [];
  FileID = [];
else
    FileID = fid;
end
