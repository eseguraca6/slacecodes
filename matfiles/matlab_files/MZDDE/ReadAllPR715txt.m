function data = ReadAllPR715txt(Directory, FileList)
% ReadAllPR715txt : Read multiple spectral files using ReadPR715txt
%
% Usage :
% >> data = ReadAllPR715txt(Directory, FileList)
%
% Where data is a vector structure containing one set of spectral data per element,
% each read from the one of the files given in the FileList input parameter.
% Files must occur on the relative or absolute directory given in the
% input parameter Directory.
%
% FileList is a structure obtained from the dir function, and must have
% the field 'name', being the name of the file.
%
% Example:
% >> specfiles = dir('SpecDir\*.txt'); % Get all text file names in a directory
% >> specdata = ReadAllPR715txt('SpecDir', specfiles);
%
% To specify the current directory, use '' or '.' for Directory.
%
% See Also : ReadPR715txt

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

%% Parameter checking
if ~isfield(FileList, 'name')
    error('Input parameter FileList must at least have the field "name", being a valid filename.')
end

if isempty(Directory)
    Directory = '.';
end

%% Read all the files given
for ifile = 1:numel(FileList)
    if ~isempty(Directory)
      fullname = [Directory '\' FileList(ifile).name];
    else
      fullname = FileList(ifile).name;
    end
    if exist(fullname, 'file');
        data(ifile) = ReadPR715txt(fullname);
    end
end
