function AgScopeOut = AgScopePadTrim(AgScopeIn, NewSize, Percentage, LeftRight)
% AgScopePadTrim : Pads or trims an oscilloscope trace to the given size
% Usage : 
%     AgScopeOut = AgScopePadTrim(AgScopeIn, NewSize)
%     AgScopeOut = AgScopePadTrim(AgScopeIn, NewSize, Percentage)
%     AgScopeOut = AgScopePadTrim(AgScopeIn, NewSize, Percentage, LeftRight)

% Where :
%    AgScopeIn is data read with ReadAgScopeCSV
%    The channel 1 (v1) and channel 2 (v2) data are padded or trimmed.
%       to the NewSize. Pad values are computed from the average of the 10%
%       of samples on either end. If Percentage is given as an input parameter
%       then this percentage is used instead.
%    If the input LeftRight is given as 0, padding or trimming is performed on the left
%       only. If given as 1, padding or trimming is performed only on the right.
% See also : ReadAgScopeCSV, AgScopeFFT, AgScopePlot, AgScopeDiff


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

if ~exist('Percentage', 'var')
    Percentage = 0.1;
else
    Percentage = Percentage/100;
end

x1 = AgScopeIn.x(1);
xend = AgScopeIn.x(end);
dt = AgScopeIn.x(2) - x1 ; % Oscilloscope time delta
len = length(AgScopeIn.x);

if NewSize > len % pad
   leftpart = 1:round(Percentage * len);
   rightpart = (len - round(Percentage * len)):len;    
   if exist('LeftRight', 'var') % pad on the right or left only
       if LeftRight % pad right only
          padleft = [];
          padright = 1:(NewSize-len);
       else % pad left only
          padleft = 1:(NewSize-len);
          padright = [];           
       end
   else % pad both ends
       padleft = 1:(ceil((NewSize-len)/2));
       padright = 1:(floor((NewSize-len)/2));
   end
   xleft = fliplr(-dt * padleft) + x1;
   xright = xend + dt * padright;
   AgScopeIn.x = [xleft AgScopeIn.x xright];

elseif NewSize < len % trim
   if exist('LeftRight', 'var') % trim on the right or left only
       if LeftRight % trim right only
           AgScopeIn.x  = AgScopeIn.x(1:NewSize);    
       else % trim left only
           AgScopeIn.x  = AgScopeIn.x((len-NewSize+1):len);
       end
   else 
       AgScopeIn.x  = AgScopeIn.x(round((len-NewSize)/2)+1:round(len-(len-NewSize)/2));    
   end
end

if isfield(AgScopeIn, 'v1') % pad/trim channel 1 data
    if NewSize > len % pad
          leftave  = mean(AgScopeIn.v1(leftpart));
          rightave = mean(AgScopeIn.v1(rightpart));
          vleft = ones(1, length(padleft)) * leftave;
          vright = ones(1, length(padright)) * rightave;
          AgScopeIn.v1 = [vleft AgScopeIn.v1 vright];
    else
        if NewSize < len % trim
            if exist('LeftRight', 'var') % trim one end
                if LeftRIght % trim right
                    AgScopeIn.v1 = AgScopeIn.v1(1:NewSize);
                else % trim left
                    AgScopeIn.v1  = AgScopeIn.v1((len-NewSize+1):len);
                end    
            else  % trim both ends
              AgScopeIn.v1 = AgScopeIn.v1(round((len-NewSize)/2)+1:round(len-(len-NewSize)/2));
            end
        end
    end
end

if isfield(AgScopeIn, 'v2') % pad/trim channel 2 data
    
    if NewSize > len % pad
          leftave  = mean(AgScopeIn.v2(leftpart));
          rightave = mean(AgScopeIn.v2(rightpart));
          vleft = ones(1, length(padleft)) * leftave;
          vright = ones(1, length(padright)) * rightave;
          AgScopeIn.v2 = [vleft AgScopeIn.v2 vright];
        
    else
        if NewSize < len % trim
            if exist('LeftRight', 'var') % trim one end
                if LeftRIght % trim right
                    AgScopeIn.v2 = AgScopeIn.v2(1:NewSize);
                else % trim left
                    AgScopeIn.v2  = AgScopeIn.v2((len-NewSize+1):len);
                end    
            else  % trim both ends            
              AgScopeIn.v2 = AgScopeIn.v2(round((len-NewSize)/2)+1:round(len-(len-NewSize)/2));
            end
        end
    end
    
end

if isfield(AgScopeIn, 'math') % pad/trim math data
    if NewSize > len % pad
          leftave  = mean(AgScopeIn.math(leftpart));
          rightave = mean(AgScopeIn.math(rightpart));
          vleft = ones(1, length(padleft)) * leftave;
          vright = ones(1, length(padright)) * rightave;
          AgScopeIn.math = [vleft AgScopeIn.math vright];
        
    else
        if NewSize < len % trim
            if exist('LeftRight', 'var') % trim one end
                if LeftRIght % trim right
                    AgScopeIn.math = AgScopeIn.math(1:NewSize);
                else % trim left
                    AgScopeIn.math  = AgScopeIn.math((len-NewSize+1):len);
                end    
            else  % trim both ends
              AgScopeIn.math = AgScopeIn.math(round((len-NewSize)/2)+1:round(len-(len-NewSize)/2));
            end
        end
    end
    
end
AgScopeOut = AgScopeIn;
