function Merit = zOptimize(Cycles)
% zOptimize - Optimize the lens in the ZEMAX DDE server.
%
% Usage : Merit = zOptimize(Cycles)
% zOptimize calls the ZEMAX Damped Least Squares optimizer
% where Cycles is the number of cycles to run. The return value is the final merit function. If the merit function value
% returned is 9.0E+009, the optimization failed, usually because the lens or merit function could not be evaluated.
% If n is zero, the optimization runs in automatic mode. If n is less than zero, Optimize returns the current merit
% function, and no optimization is performed.
%
% Returns -1 if the optimisation did not complete within the timeout period.
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

global ZemaxDDEChannel ZemaxDDETimeout
DDECommand = sprintf('Optimize,%i',Cycles);
Reply = ddereq(ZemaxDDEChannel, DDECommand, [1 1], ZemaxDDETimeout);
if (Reply)
    Merit = str2double(Reply);
else
    Merit = -1;
end

