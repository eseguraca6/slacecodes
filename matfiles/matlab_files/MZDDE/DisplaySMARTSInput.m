function DisplaySMARTSInput(S)
% DisplaySMARTSInput : Displays a SMARTS input card deck
%
% SMARTS is the Simple Model of the Atmospheric Radiative Transfer of
% Sunshine, available at http://www.nrel.gov/rredc/smarts/
% SMARTS Author : Christian A. Gueymard
% This function is written for SMARTS 2.9.5
%
% Usage :
%  >> DisplaySMARTSInput(SMARTStruct);
%
% Where :
%  SMARTSStruct is a structure containing a SMARTS input card deck. This
%    structure can be obtained by reading a SMARTS input file created 
%    manually or with the SMARTS Excel GUI and read in with the function
%    ReadSMARTSInput.
%
% Example :
% >> S = ReadSMARTSInput('D:\SMARTS\Examples\Example9-NREL_summer_scan\smarts295.inp.txt');
% >> DisplaySMARTSInput(S);  % Display one of the SMARTS test case input
% card decks
%
% See Also : WriteSMARTSInput, TweakSMARTSInput, CheckSMARTSInput,
%   ReadSMARTSInput, RunSMARTS, ReadSMARTSOutput, PlotSMARTSOutput
%
% Notes : This display routine is very basic. A better format is desired.

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

% $Date: 2009-10-30 09:07:07 +0200 (Fri, 30 Oct 2009) $
% $Revision: 221 $
% $Author: DGriffith $

switch class(S)
    case 'struct'
        for iStruct = 1:prod(size(S))
            DisplaySMARTS(S(iStruct));
        end
    case 'cell'
        for iCell = 1:prod(size(S))
            for iStruct = 1:prod(size(S{iCell}))
                DisplaySMARTS(S{iCell}(iStruct));
            end
        end
    otherwise
        error('DisplaySMARTSInput:badarg', 'Input to DisplaySMARTSInput must be a struct or cell array of structs.')
end

function DisplaySMARTS(S)
FieldNames = fieldnames(S);
for iField = 1:length(FieldNames)
    disp(['Card ' FieldNames{iField}]);
    disp(S.(FieldNames{iField}));
end
 
