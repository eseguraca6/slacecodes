function tokens = Tokenise(String, Delim)
% Tokenise - Splits a string into tokens at sepcified delimiters, returns tokens in cell array.
% Usage : tokens = Tokenise(String, Delim)
% String is the string to be tokenised and Delim is the string of delimiters.
% If the Delim is the empty string or a space, splitting occurs at any whitespace character.
% See the ISSPACE() function for a list of whitespace characters.
% Delimiter characters are stripped out of the tokens, and will therefore not occur
% in the returned cell array of tokens.
%
% If you want to split at whitespace and semicolon, the space must be specifically included
% in the delimiter string.


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


if ~strcmp(class(String), 'char') || ~strcmp(class(Delim), 'char')
    error('Inputs must be strings');
end
if isempty(Delim)
    Delim = ' ';
end

tokens = {};
while ~isempty(String)
  % Find next token
  [tok, String] = strtok(String, Delim);
  if ~isempty(tok)
    tokens{end+1} = tok;
  end
end

