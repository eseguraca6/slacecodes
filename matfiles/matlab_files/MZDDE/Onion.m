function Status = Onion(Surface, Layers, T1, T2)
% Onion - Splits a lens into a number of layers for the purpose of analysing the effect of an axial
% temperature gradient.
%
% Usage : Status = Onion(Surface, Layers, T1, T2)
%
% Where Surface is the surface to split up, Layers is the number of layers to use, T1 is the temperature at
% the given surface and T2 is the temperature at the following surface. Currently, only standard surfaces are
% handled correctly. There must be sufficient MOFF operands in the multi-configuration editor to accommodate
% the new TEMP and GLSS operands i.e. there must be at least (Layers + 1) * 2 operands of type MOFF. These 
% MOFF operands must appear at the start of the list. The reason for this is that there is currently no way 
% to insert multicon operands from the DDE interface.
%
% Note : To correcly evaluate the thermal effect, the "Use Temperature and Pressure" box on the general
% settings dialog must be checked.
%
% Status is the return status.
%  0 indicates success.
% -1 indicates that ZEMAX is not running.
% -2 indicates that the lens could not be updated.
% -3 indicates an invalid surface number.
% -4 indicates the surface is too thick (INFINITY).
% -5 indicates the surface has zero thickness.
% -6 indicates that there are insufficient MOFF operands at the start of the multicon editor.

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


%
% $Revision: 221 $
%

Status = zDDEInit;
if Status ~= 0
    return;
end

% Get an update of the lens
Status = zGetRefresh;
if Status ~= 0
    Status = -2;
    return;
end

Sys = zsGetSystem;

if (Surface > Sys.numsurfs - 1) | (Surface < 0)
    Status = -3;
    return;
end

Surf = zsGetSurfaceData(Surface); 
if Surf.thickness > 9e9
    Status = -4;
    return;
end

if Surf.thickness == 0
    Status = -5;
    return;
end

Thick = Surf.thickness/Layers;
Curv = Surf.curvature;
Glass = Surf.glass;
Conic = Surf.conic;
% Insert the right number of surfaces and assign curvatures and conic constants which are stepwise between 
% the curvatures and conic constants of the existing surfaces

Surf2 = zsGetSurfaceData(Surface+1);
Curv2 = Surf2.curvature;
Conic2 = Surf2.conic;

ConStep = (Conic - Conic2)/Layers;
CurvStep = (Curv - Curv2)/Layers;
Curvature = Curv2;
ConicConstant = Conic2;
for i = 1:(Layers-1)
    Curvature = Curvature + CurvStep;
    ConicConstant = ConicConstant + ConStep;
    zInsertSurface(Surface+1);
    % zSetSurfaceData(Surface+1, 1, ['Onion ' num2str(i)]);
    zSetSurfaceData(Surface+1, 2, Curvature);
    zSetSurfaceData(Surface+1, 3, Thick);
    zSetSurfaceData(Surface+1, 4, Glass);
    zSetSurfaceData(Surface+1, 6, ConicConstant);
end
zSetSurfaceData(Surface, 3, Thick);

% Now insert the TEMP operands into the multi-config editor.
% First get the number of configs and number of operands
[Type,NumConfigs, NumOpers]=zgetmulticon(1,1);

% If too few or not MOFF, return status -6
if NumOpers < (Layers+1)*2
    Status = -6;
    return;
end

for i= 1:((Layers+1)*2)
    Type=zgetmulticon(0,i);
    if strcmp(Type,'MOFF') == 0 % not MOFF
        Status = -6;
        return;
    end
end

% Now set the TEMP and GLSS operands in config 1
TempInc = (T2-T1)/Layers; % Increment in temperature from layer to layer
OperNum = 0;
Temperature = T1;
for Surf = Surface:(Surface+Layers)
    OperNum = OperNum + 1;
    zSetMultiConOp(OperNum, 'TEMP', 0,0,0);
    zSetMultiCon(1, OperNum, Temperature);
    OperNum = OperNum + 1;
    zSetMultiConOp(OperNum,'GLSS', Surf, 0, 0);
    zSetMulticon(1, OperNum, Glass);
    Temperature = Temperature + TempInc;
end
zSetMulticon(1,OperNum, Surf2.glass);
zPushLens(90);
Status = 0;
