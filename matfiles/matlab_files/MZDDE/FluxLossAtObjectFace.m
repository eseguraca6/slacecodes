function [InboundFlux, OutboundFlux, FluxLoss, FluxLossPercent, InboundSegs, OutboundSegs] = FluxLossAtObjectFace(Rays, Object, Face)
% FluxLossAtObjectFace : Compute loss of flux at NSC object in Zemax Ray Database
%
% This function computes the difference in flux between all the inbound and
% all the outbound ray segments at a glass/air interface.
%
% Usage:
%  >> [InboundFlux, OuboundFlux, FluxLoss, FluxLossPercent] = FluxLossAtObjectFace(Rays, Object, Face);
% 
%
% Where:
%  Rays is a structure containing rays from a Zemax .ZRD ray database,
%     read using the function ReadZemaxRayDatabase.
%  Object and Face give the non-sequential object and face at which to
%     compute the flux loss.
%  Face can be a vector of faces, in which case the returned values are also
%  vectors of the same length as Face.
%
%  InboundFlux is the sum of the intensities of all ray segments striking
%     the interface from the background medium (usually air).
%  OutboundFlux is the sum of the intensities of all ray segments passing
%     away from the interface in the background medium (usually air).
%  FluxLoss is the difference between the inbound and outbound flux.
%  FluxLossPercent is the FluxLoss expressed as a percentage of the
%     InboundFlux.
%
% See Also: ReadZemaxRayDatabase

% $Id: FluxLossAtObjectFace.m 221 2009-10-30 07:07:07Z DGriffith $

NextIndex = 1;
Index = zeros(1,max(Face(:))+1);
for iFace = 0:max(Face(:))
    iIndex = iFace+1;
    if iFace == Face(NextIndex)
        Index(iIndex) = NextIndex;
        NextIndex = NextIndex + 1;
    end
end
InboundFlux = zeros(1,length(Face));
OutboundFlux = zeros(1,length(Face));
InboundSegs = zeros(1,length(Face));
OutboundSegs = zeros(1,length(Face));
% InSegInObj = [];
for iRay = 1:length(Rays)
    %disp(['Processing Ray ' num2str(iRay)])
    for iSeg = 1:length(Rays(iRay).seg)
        % Incident ray segments are those travelling in air that strike the front surface 
        if (Rays(iRay).seg(iSeg).hit_object == Object) && any(Rays(iRay).seg(iSeg).hit_face == Face) ...
                && (Rays(iRay).seg(iSeg).in_object == 0)
            % InSegInObj = [InSegInObj Rays(iRay).seg(iSeg).in_object];
            iIndex = Index(Rays(iRay).seg(iSeg).hit_face+1);
            InboundFlux(iIndex) = InboundFlux(iIndex) + Rays(iRay).seg(iSeg).intensity;
            InboundSegs(iIndex) = InboundSegs(iIndex)+1;
        end
        % Now if the parent ray segment hit the front face and the ray
        % segment itself is in air
        % then the segment power is leaving the facet
        ParentSegment = Rays(iRay).seg(iSeg).parent+1;
        if  (Rays(iRay).seg(ParentSegment).hit_object == Object) && any(Rays(iRay).seg(ParentSegment).hit_face == Face) ...
                && (Rays(iRay).seg(iSeg).in_object == 0)
            %disp([ParentSegment-1 Rays(iRay).seg(ParentSegment).iseg])
%             disp(Rays(iRay).seg(iSeg))
%             disp(Rays(iRay).seg(ParentSegment))
%             disp('------------------------------------');
            if (Rays(iRay).seg(ParentSegment).intensity - Rays(iRay).seg(iSeg).intensity < 0)
                warning('Ray segment found with more energy in child than in parent');
            end
            iIndex = Index(Rays(iRay).seg(ParentSegment).hit_face+1);
            OutboundFlux(iIndex) = OutboundFlux(iIndex) + Rays(iRay).seg(iSeg).intensity;
            OutboundSegs(iIndex) = OutboundSegs(iIndex) + 1;
        end
    end
end


FluxLoss = InboundFlux - OutboundFlux;
FluxLossPercent = 100 * FluxLoss ./ InboundFlux;
