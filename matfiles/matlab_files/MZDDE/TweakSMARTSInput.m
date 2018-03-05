function S = TweakSMARTSInput(S, Tweaks)
% TweakSMARTSInput : Alters tweakable variables in a SMARTS input deck
% 
% SMARTS is the Simple Model of the Atmospheric Radiative Transfer of
% Sunshine, available at http://www.nrel.gov/rredc/smarts/
% SMARTS Author : Christian A. Gueymard
% This function is written for SMARTS 2.9.5
%
% Two SMARTS cases are congruent if they have the same input card structure.
% That is there is a one to one mapping between the two input files.
% TweakSMARTSInput allows the user to move around within a set of congruent
% SMARTS cases by individually changing (tweaking) the variables that define
% the case.
%
% Usage :
% >> Tweakables = TweakSMARTSInput
% >> TweakedSMARTSStruct = TweakSMARTSInput(SMARTStruct, Tweaks)
%
% Where :
%   SMARTStruct is a structure representing a SMARTS input case.
%     This structure can be obtained by reading a SMARTS input file
%     (smarts295.inp.txt), or by compiling a deck manually according to
%     the structure and constraints given in the SMARTS manual.
%     SMARTS input files (card decks) can be read using ReadSMARTSInput.
%   Tweakables is a cell array containing the names of all SMARTS variables
%     and a logical flag which indicates if the variable is tweakable or not.
%     The names of the variables are given in the first column of the cell
%     array, and the logical flags in the third column. The variable names
%     are given in alphabetical order. The card number appears in the
%     second column. The fourth column contains the class of the variable.
%   Tweaks is a cell array containing the names of the variables to be
%     tweaked, and the new value to be given to the variable. The first
%     column in the cell array must contain the variable names, and the
%     second column must contain the new values.
%
% An error is thrown if an attempt is made to tweak a non-tweakable
% variable.
%
% With a number of exceptions, the main cards (variables beginning with I,
% usually representing option selection) cannot be tweaked. Most of the
% other variables are tweakable. See the cell array returned by calling
% TweakSMARTSInput without any parameters.
% 
% ISPCTR, the extraterrestrial spectrum option is tweakable.
% AEROS, the aerosol selection option is tweakable, but cannot be tweaked
% to or from the 'USER' setting, since that introduces or removes a card.
%
% IPRT is not directly tweakable, but the variable list IOUT is
% tweakable, and IPRT will automatically be changed accordingly.
%
% Bugs : Setting of the LATIT variable is currently an unresolved problem.
%        LATIT is used as a variable in two places (Cards 2a and 17a). This
%        causes an error if a tweak to LATIT is attempted.
%
% Example : See script SMARTSTest
%
% See Also : WriteSMARTSInput, DisplaySMARTSInput, CheckSMARTSInput,
%   ReadSMARTSInput, RunSMARTS, ReadSMARTSOutput, PlotSMARTSOutput

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


persistent SMARTSVar

% Read in cell array data about the SMARTS variables
% See page 27 in the SMARTS 2.9.5 for Windows User's Manual
if isempty(SMARTSVar)
    Directory  = fileparts(which('TweakSMARTSInput')); % Get the MZDDE Directory
    fid = fopen([Directory '\SMARTSVariables.txt'], 'r');
    SV = textscan(fid, '%s %s %s %s');
    [s, is] = sortrows(upper(SV{1})); % Sort by variable name
    SMARTSVar = [SV{1}(is) SV{2}(is) SV{3}(is) SV{4}(is)];
    fclose(fid);
end

if nargin == 0
    S = SMARTSVar;
    return;
end

if isempty(S) || ~isstruct(S)
    error('First input parameter SMARTStruct must be a structure representing a SMARTS input deck.');
end
if ~exist('Tweaks', 'var') || ~iscell(Tweaks) || size(Tweaks, 2) ~= 2
    error('TweakSMARTSInput:badTweaks',['Input parameter Tweaks must be a 2 column cell array with SMARTS' ... 
          ' variable names in the first column and the new value of the variable in the second column.']);
end

for iTweak = 1:size(Tweaks,1)
    VarName = Tweaks{iTweak,1};
    if ~ischar(VarName)
      error('TweakSMARTSInput:badTweaks',['Input parameter Tweaks must be a 2 column cell array with SMARTS' ... 
            ' variable names in the first column and the new value of the variable in the second column.']);
    end
    % Check the name and type of the variable
    iMatch = strmatch(VarName, SMARTSVar(:,1), 'exact');
    if isempty(iMatch) % Variable does not exist
        warning('TweakSMARTSInput:badVariable', [VarName ...
            ' is not a valid SMARTS variable. Tweak ignored.']);
    else
      if SMARTSVar{iMatch, 3} == '0' % This is not a tweakable variable
        warning('TweakSMARTSInput:notTweakable', [VarName ...
            ' is not a tweakable SMARTS variable. Tweak ignored.'])
      else % Go ahead and tweak the variable if the other conditions are met
        % First check the class
        NewVal = Tweaks{iTweak,2};
        TheCorrectClass = SMARTSVar{iMatch, 4};
        if ~strcmp(class(NewVal), TheCorrectClass)
            warning('TweakSMARTSInput:wrongClass', ['SMARTS variable ' VarName ' is class '  TheCorrectClass ...
                ' but a tweak value of class ' class(Tweaks{iTweak,2}) ' was given. Tweak ignored.'])
        else
            % The variable must actually exist in the deck
            Card = ['C' SMARTSVar{iMatch, 2}];
            if ~isfield(S, Card) || ~isfield(S.(Card), VarName)
              warning('TweakSMARTSInput:notThere', ['SMARTS variable ' VarName ...
                       ' does not exist in this deck. Tweak Ignored']);
            else % Only a few special cases need checking now
                % Variable AEROS cannot be tweaked to or from 'USER' setting
                if strcmp(VarName, 'AEROS') && (strcmp(S.(Card).AEROS, 'USER') || strcmp(NewVal, 'USER'))
                    warning('TweakSMARTSInput:AEROS', ...
                        'Variable AEROS cannot be tweaked to or from USER setting. Tweak ignored.')
                    continue;
                end
                if strcmp(VarName, 'IOUT')
                    NewVal = NewVal(:)'; % Straighten into a row vector
                    S.(Card).IOTOT = length(NewVal); % Change IOTOT accordingly
                end
                
                % Finally the change is actually made
                S.(Card).(VarName) = NewVal;
                % And the resulting deck is checked for range violations and various other things
                CheckSMARTSInput(S);
            end
        end
      end
    end
end

