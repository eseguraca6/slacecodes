function SolveTable = zGetSolveTable
% zGetSolvaTable - Reads in a solve table from a .csv file.
% This is the solve table given in the Solves chapter of the Zemax manual.
% The data is returned in a cell array.
%
% Example:
% >> SolveTable = zGetSolveTable;

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

fid = fopen('SolveTable.csv', 'r');
if fid == -1
    error('zGetSolveTable:Unable to find solve table file SolveTable.csv. Ensure that MZDDE directory is on your Matlab path.');
end

SolveTable = textscan(fid, '%s%s%s%s%s%s%s%f', 100, 'delimiter', ',');

% Compile into a single table

SolveTable = cat(2, SolveTable{1}, SolveTable{2},SolveTable{3},SolveTable{4},SolveTable{5},SolveTable{6},SolveTable{7},num2cell(SolveTable{8}));

fclose(fid);

