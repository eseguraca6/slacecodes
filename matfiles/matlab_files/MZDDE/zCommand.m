function Answer = zCommand(Command)
% zCommand - Send a direct string command to the Zemax DDE interface.
%
% Example :
% >> TheZemaxDate = zCommand('GetDate'); % Get the date from Zemax
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

Answer = ddereq(ZemaxDDEChannel, Command, [1 1], ZemaxDDETimeout);
