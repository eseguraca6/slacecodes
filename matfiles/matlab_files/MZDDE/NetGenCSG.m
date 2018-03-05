function NetGenCSG = NetGenCSG(Filename, FirstSurface, LastSurface)
% NetGenCSG - Export Constructive Solid Geometry of Spherical Lenses to Netgen Format
% Usage : NetGenCSG(Filename, FirstSurface, LastSurface)
%
% Netgen is a mesh generator, useful for finite element or CFD work.
% Netgen has a native CSG (constructive solid geometry) format that can
% represent simple spherical lenses for efficient and accurate mesh generation.
% The exported lens diameter will be according to the semi-diameter on the
% lens data editor.
%
% Only lenses of non-zero thickness will be exported.
% Mirror surfaces are not exported.
%
% For lenses with non-spherical shape, export one of the BREP solid formats
% offered by ZEMAX
%
% Bugs : Annular flats around concave surfaces of less than about 0.6 mm on radius can cause 
%        meshing errors in NetGen.
%        Concave surfaces often do not display correctly in the NetGen geometry mode,
%        but meshing may still work.
%        Many lenses do not seem to reconstruct successfully in NetGen - more work is required.
%
% See: http://www.hpfem.jku.at/netgen/

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

% Copyright 2006, DPSS, CSIR
% $Revision: 221 $

zGetRefresh;

% Check that the system is in units of mm
systuff = zsGetSystem;
if systuff.unitcode ~= 0
    error('This routine only handles systems given in units of mm. Please convert to mm.');
end

flatshift = 0.2; % mm to move annular flats away from concave surface intersection with cylindrical edge
minannularflat = 0.6; % Annular flats should be at least 0.6 mm to help avoid meshing errors

for surf = FirstSurface:LastSurface
    % Get the surface data in a structure
    surfdata(surf-FirstSurface+1) = zsgetsurfacedata(surf);
    % Get the global coordintate transformation matrices
    [rotmat(:,:,surf-FirstSurface+1), colvec(:,:,surf-FirstSurface+1)] = zGetGlobalMatrix(surf);
end

% Integrity checks

for surf = 1:length(surfdata)
    
    surfdata(surf);
    rotmat(:,:,surf);
    colvec(:,:,surf);
    
    
end

fid = fopen(Filename, 'w');
fprintf(fid, '# NetGenCSG output from MZDDE, the ZEMAX toolbox for Matlab.\n');
fprintf(fid, '# Lens Title : %s', zGetName);
fprintf(fid, '# Filename   : %s', zGetFile);
fprintf(fid, 'algebraic3d\n');

% Run through the surfaces and see if there is glass

for surf = 1:length(surfdata)-1
 if (~isempty(surfdata(surf).glass))&&(~strcmp(surfdata(surf).glass, 'MIRROR')) % Only export non-air, non-mirror surfaces
     % Export the component at this surface if the surrounding surfaces are STANDARD and spherical
     if ~strcmp(surfdata(surf).type, 'STANDARD') || (surfdata(surf).conic ~= 0) && ...
        ~strcmp(surfdata(surf+1).type, 'STANDARD') || (surfdata(surf+1).conic ~= 0)   
        error('This routine only handles STANDARD spherical surfaces');
     end
     % Get the material thickness - indicates direction of light
     thickness = surfdata(surf).thickness;
     if thickness > 0
         direction = 1; % Light is moving from left to right
     else if thickness < 0
             direction = -1; % Light is moving from right to left 
         else
             error('Component has zero thickness at surface %i.',surf);
         end
     end
     
     % First deal with flat surfaces
     % Flat first surface
     if surfdata(surf).curvature == 0
         vertex = [0;0;0]; outwardvec = [0;0;-direction];
         % Tranform vertex to global coordinates
         % GlobalColVector = ColVector + RotationMatrix * LocalColVector
         vertex = colvec(:,:,surf) + rotmat(:,:,surf) * vertex;
         % Just rotate the outward vector
         outwardvec = rotmat(:,:,surf) * outwardvec;
         % Export the first surface
         % fprintf(fid, 'solid surf1st_%i = plane (%e, %e, %e; %e, %e, %e);\n', surf, vertex, outwardvec);
         fprintf(fid, 'solid z_%i_%i = plane (%e, %e, %e; %e, %e, %e)\n', surf, surf+1, vertex, outwardvec);
     end
     % Next deal with concave and convex surfaces
     % First surface
     if surfdata(surf).curvature ~= 0
         radofcurv = 1/surfdata(surf).curvature;
         vertex = colvec(:,:,surf) + [0;0;radofcurv];
         if direction * radofcurv < 0 % Surface is concave
           if abs(radofcurv) <= surfdata(surf).semidia
               error('Edge fault at concave surface %i. Semi-diameter is greater than radius of curvature', surf);
           else
             % Find the sag of the surface at the semi-diameter
             sag = abs(radofcurv) - sqrt(radofcurv^2 - surfdata(surf).semidia^2);
             if surfdata(surf).semidia >= surfdata(surf+1).semidia
                 sag = sag + flatshift; % Don't let the concave flat intersect with the edge cylinder at the sphere surface
             else
                 if abs(surfdata(surf).semidia - surfdata(surf+1).semidia) < minannularflat
                     warning('Annular flat size increased at surface %i to help avoid meshing errors.', surf);
                     semidia = surfdata(surf+1).semidia - minannularflat;
                     sag = abs(radofcurv) - sqrt(radofcurv^2 - semidia^2);
                 end
             end
             sag = sag * radofcurv / abs(radofcurv); % Give the sag the same sign as the radius of curvature
             flatvertex = [0;0;sag]; outwardvec = [0;0;-direction];
             % Transform to global coordinates
             flatvertex = colvec(:,:,surf) + rotmat(:,:,surf) * flatvertex;
             outwardvec = rotmat(:,:,surf) * outwardvec;
             % Export concave surface and centered flat
             fprintf(fid, 'solid z_%i_%i = plane (%e, %e, %e; %e, %e, %e)\n', surf, surf+1, flatvertex, outwardvec); 
             fprintf(fid, '                and not sphere (%e, %e, %e; %e)\n', vertex, abs(radofcurv));
           end  
         else                         % Surface is convex
           fprintf(fid, 'solid z_%i_%i = sphere (%e, %e, %e; %e)\n', surf, surf+1, vertex, abs(radofcurv));  
         end
         
     end
     % Flat second surface
     if surfdata(surf+1).curvature == 0
         vertex = [0;0;0]; outwardvec = [0;0;direction];
         % Tranform vertex to global coordinates
         % GlobalColVector = ColVector + RotationMatrix * LocalColVector
         vertex = colvec(:,:,surf+1) + rotmat(:,:,surf+1) * vertex;
         % Just rotate the outward vector
         outwardvec = rotmat(:,:,surf+1) * outwardvec;
         % Export the second surface
         fprintf(fid, '                and plane (%e, %e, %e; %e, %e, %e)\n', vertex, outwardvec);
     end
     
     % Concave or convex second surface
     if surfdata(surf+1).curvature ~= 0
         radofcurv = 1/surfdata(surf+1).curvature;
         vertex = colvec(:,:,surf+1) + [0;0;radofcurv];
         if direction * radofcurv < 0 % Surface is convex
           %fprintf(fid, 'solid surf2nd_%i = sphere (%e, %e, %e; %e);\n', surf+1, vertex, abs(radofcurv));  
           fprintf(fid, '                and sphere (%e, %e, %e; %e)\n', vertex, abs(radofcurv));
         else                         % Surface is concave
           % Find the sag of the second surface at the semi-diameter
             sag = abs(radofcurv) - sqrt(radofcurv^2 - surfdata(surf+1).semidia^2);
             if surfdata(surf+1).semidia >= surfdata(surf).semidia
                 sag = sag + flatshift; % Don't let the concave flat intersect with the edge cylinder at the sphere surface
             else
                 if abs(surfdata(surf).semidia - surfdata(surf+1).semidia) < minannularflat
                     warning('Annular flat size increased at surface %i to help avoid meshing errors.', surf+1);
                     semidia = surfdata(surf).semidia - minannularflat;
                     sag = abs(radofcurv) - sqrt(radofcurv^2 - semidia^2);
                 end
             end
             sag = sag * radofcurv / abs(radofcurv); % Give the sag the same sign as the radius of curvature
             flatvertex = [0;0;sag]; outwardvec = [0;0;direction];
             % Transform to global coordinates
             flatvertex = colvec(:,:,surf+1) + rotmat(:,:,surf+1) * flatvertex;
             outwardvec = rotmat(:,:,surf+1) * outwardvec;
             % Export concave surface and centered flat
             fprintf(fid, '                and plane (%e, %e, %e; %e, %e, %e)\n', flatvertex, outwardvec); 
             fprintf(fid, '                and not sphere (%e, %e, %e; %e)\n', vertex, abs(radofcurv)); 
         end
     end
     
     % Define the edge of the component as a cylinder
     edgeradius = max(surfdata(surf).semidia, surfdata(surf+1).semidia);
     vertex1 = colvec(:,:,surf);
     vertex2 = colvec(:,:,surf+1);
     % and write out the solid
     
     fprintf(fid, '                and cylinder (%e, %e, %e; %e, %e, %e; %e);\n',vertex1 , vertex2, edgeradius);
     fprintf(fid, 'tlo z_%i_%i;\n', surf, surf+1);
     
     % Move on to the next surface
     surf = surf+1;
 end    
end

fclose(fid);
