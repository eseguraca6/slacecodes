function fundamental = USAF1951(Group, Element)
% USAF1951 : Computes the fundamental spatial frequency of a USAF 1951 resolution target element.
% Usage :
% >> spf = USAF1951(Group, Element);
% Where Group and Element are target group and element on the USAF 1951
% three-bar resolution target.
% The spatial frequency is returned in cycles per mm at the target itself.
% The spatial frequency must be multiplied by the system magnification to obtain the
% spatial frequency in the final system image.
%
% Both Group and Element may be vectors, in which case data is returned as for
% a meshgrid of Group and Element in a matrix of numel(Element) by numel(Group).
% Groups will change from column to column, Elements from row to row.
%
% Example :
% >> spf = USAF1951(3, [1:6]);
% Computes fundamental spatial frequency of group 3 elements 1 to 6.
% A column vector is returned.
% 
% Reference : MZDDE\Documents\USAF 1951 Resolution Test Target.pdf

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

% Group and Element must be vectors

if (numel(Group) ~= length(Group)) || ~isnumeric(Group)
    error('USAF1951:Group must be numeric scalar or vector');
end

if (numel(Element) ~= length(Element)) || ~isnumeric(Element)
    error('USAF1951:Element must be numeric scalar or vector');    
end

[Group, Element] = meshgrid(Group, Element);

fundamental = 2.^(Group + (Element-1)/6);
