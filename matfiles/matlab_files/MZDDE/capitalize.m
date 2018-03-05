function result = capitalize(thestring)
% capitalize : Capitalizes the first letter of each word in a char array.

result = '';
[tok, rest] = strtok(thestring, ' ');
while ~isempty(tok)
    tok(1) = upper(tok(1)); % Capitalize the first letter
    if isempty(result)
        result = tok;
    else
        result = [result ' ' tok];
    end
    [tok, rest] = strtok(rest);
end

