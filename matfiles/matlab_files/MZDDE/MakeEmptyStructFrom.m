function S = MakeEmptyStructFrom(TemplateStruct, NewName)
% MakeEmptyStructFrom : Make empty struct function call from existing struct as template
%
% Generates .m code for an empty struct with the same fields as TemplateStruct.
%
% Usage :
%   >> S = MakeEmptyStructFrom(TemplateStruct, NewName)
%
% Where : 
%   TemplateStruct is the structure to use as a template
%   NewName is the name to use in the code.
%

% $Author:$
% $Id:$
% $Revision:$


Fields = fieldnames(TemplateStruct)'; % Creates cell array of fieldnames
S = sprintf('%s = struct( ... \n', NewName);
for iField = 1:(size(Fields,2)-1)
    S = [S sprintf('\t''%s'', {}, ...\n', Fields{iField})];
end
S = [S sprintf('\t''%s'', {});', Fields{end})];
