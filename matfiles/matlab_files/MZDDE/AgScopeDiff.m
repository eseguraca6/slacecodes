function AgScopeOut = AgScopeDiff(AgScopeIn)
% AgScopeDiff : Differentiate channel 1 and channel 2 data from Agilent 54622A Oscilloscope
% Usage : AgScopeOut = AgScopeDiff(AgScopeIn)
% Where :
%    AgScopeIn is data read with ReadAgScopeCSV
%    The channel 1 (v1) and channel 2 (v2) data are differentiated
%       with respect to time.
% See also : ReadAgScopeCSV, AgScopeFFT, AgScopePlot


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

AgScopeOut = AgScopeIn;

% Compute Approximate derivatives
if isfield(AgScopeIn, 'v1')
    for ip = 1:numel(AgScopeOut)
        AgScopeOut(ip).v1 = diff(AgScopeIn(ip).v1) ./ diff(AgScopeIn(ip).x);
        AgScopeOut(ip).x = AgScopeIn(ip).x(1:end-1);
    end
end

if isfield(AgScopeIn, 'v2')
    for ip = 1:numel(AgScopeOut)
        AgScopeOut(ip).v2 = diff(AgScopeIn(ip).v2) ./ diff(AgScopeIn(ip).x);
        AgScopeOut(ip).x = AgScopeIn(ip).x(1:end-1);
        
    end
end

if isfield(AgScopeIn, 'units1')
    for ip = 1:numel(AgScopeOut)
        AgScopeOut(ip).units1 = [AgScopeOut(ip).units1 '/s'];
    end    
end

if isfield(AgScopeIn, 'units2')
    for ip = 1:numel(AgScopeOut)
        AgScopeOut(ip).units2 = [AgScopeOut(ip).units2 '/s'];
    end    
end
