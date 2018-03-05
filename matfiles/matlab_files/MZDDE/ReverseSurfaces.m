function Status = ReverseSurfaces(FirstSurface, LastSurface)
% ReverseSurfaces - Reverses a series of surfaces in a lens.
%
% Usage : Reply = ReverseSurfaces(FirstSurface, LastSurface)
% 
% The surfaces FirstSurface to LastSurface are reversed. This function is performed by first putting these surfaces into
% double pass using the DoublePass function, and then deleting the old surfaces. This approach has major limitations,
% including (but not limited to) the limitations of the DoublePass routine. In particular, all pickups, variables and
% solves are lost for the reversed surfaces.
%
% If called without parameters, the whole lens will be reversed. If the
% whole lens is reversed, the reversed lens will have the same number of
% surfaces of as the original. Also, in this case, if the field was set to paraxial or real image height,
% it is changed to object height, without changing the field values. Vignetting factors are not changed and may be incorrect.
%
% Ray aiming is switched off to avoid problems with updating the lens.
%
% Bugs:
% The stop may end up in the wrong position, and the entrance pupil or F-number may be wrong, so check these.
% Field heights must also be checked.
%
% See also : DoublePass
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
% $Author: DGriffith $


% Find the image surface
lensys = zsGetSystem;
ImSurface = lensys.numsurfs;

if nargin == 0;
    FirstSurface = 0;
    LastSurface = ImSurface;
end

% Find the stop surface
SystemAperture = zGetSystemAper;
StopSurface = SystemAperture(2);
NewStopSurface = LastSurface - StopSurface;
SystemAperture(2) = NewStopSurface;

% Switch off ray-aiming to avoid problems during the update
lensys.rayaimingtype = 0;
zsSetSystem(lensys);

% Firstly, sic the DoublePass routine on the surfaces and update the lens
Status = DoublePass(FirstSurface, LastSurface);
if (Status == 0) % Everything seems to be going right
  zGetUpdate;

  % Then make all lens data fixed for new surfaces and update again
  zFixAllSurfaceData(LastSurface:(2 * LastSurface - FirstSurface));
  zGetUpdate;

  % and delete the old surfaces
  
  % Zemax will not delete the object surface (surface 0), so special measures
  % are required
  if FirstSurface == 0
      for Surf = 1:(LastSurface-1)
          zDeleteSurface(1);
      end
      % Fix up surface 0 by copying the stuff from surface 1
      basicsurfdata = zsGetSurfaceData(1); surfparams = zGetSurfaceParamVector(1);
      zsSetSurfaceData(0,basicsurfdata); zSetSurfaceParamVector(0,surfparams);      
      % Delete surface 1
      zDeleteSurface(1);
  else % straightforward     
      for Surf = FirstSurface:(LastSurface-1)
          zDeleteSurface(FirstSurface);
      end
  end


    % Try to put the stop surface back in place.
    zSetSystemAper(SystemAperture(1), SystemAperture(2), SystemAperture(3));

    % If the field was set to image height, change it to the object height
    % but only if the whole lens was reversed
    if LastSurface == ImSurface
      FieldInfo = zGetField(0);
      if FieldInfo(1) == 2 || FieldInfo(1) == 3
          FieldInfo = zSetField(0, 1, FieldInfo(2));
      end
    end
end
