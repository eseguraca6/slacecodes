function fullfilename = uiGetImageFile(StartDirectory, DialogTitle)
% uiGetImageFilename : Uses uigetfile to get a filename of file for imread.
%
% Usage :
%  fullfilename = uiGetImageFile(StartDirectory, DialogTitle)
%  fullfilename = uiGetImageFile
%
% Returns the complete filename of the image file selected by the user with
% the file selection dialog. If the optional StartDirectory is given the dialog will
% open initially in that directory. The Nikon Electronic File Format (NEF)
% has been added to the list. You will need the Stanford NEF reader to read
% NEF files directly (see NEFReadIm.m and rawCamFileRead.dll). If not
% included with your distribution, look at
% http://scien.stanford.edu/class/psych221/projects/05/joanmoh/appendixI.html
%
% Returns 0 if the user cancelled the dialog.
%
% See also : uigetfile, imread, imformats, imfinfo


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

% $Revision:$
% $Author:$
if ~exist('DialogTitle', 'var') || isempty(DialogTitle)
    DialogTitle = 'Select an Image File';
end

fmts = imformats; % Get the available image formats that will be read by imread
% Cook up a string to give to uigetfile
allimagefmts = '';
for i = 1:length(fmts)
    if length(fmts(i).ext) == 1
      extensions = ['*.' char(fmts(i).ext)];
    else 
      extensions = ['*.' char(fmts(i).ext(1)) ';*.' char(fmts(i).ext(2))];
    end
    uigetstring{i,1} = extensions;
    uigetstring{i,2} = fmts(i).description;
    allimagefmts = [allimagefmts ';' extensions];
end
uigetstring{end+1,1} = ['*.nef;*.NEF' allimagefmts];
uigetstring{end,2} = 'All Known Image File Formats';
uigetstring{end+1,1} = '*.nef;*.NEF'; % need the NEF file reader from stanford 
uigetstring{end,2} = 'Nikon Electronic Format (NEF)';
uigetstring = circshift(uigetstring, 2); % Put all formats at top of list
uigetstring{end+1,1} = '*.*';
uigetstring{end,2} = 'All Files (*.*)';

if exist('StartDirectory', 'var')
    if exist(StartDirectory, 'dir')
      if StartDirectory(end) ~= '\' && StartDirectory(end) ~= '/'
          StartDirectory = [StartDirectory '/'];
      end
      [ImageFile, PathName] = uigetfile(uigetstring, DialogTitle, StartDirectory);
  
    else
        error(['Directory ' StartDirectory ' does not exist.']);
    end
else % starts in the current directory
   [ImageFile, PathName] = uigetfile(uigetstring, DialogTitle);    
end
if ImageFile ~= 0
  fullfilename = [PathName ImageFile];
else
    fullfilename = 0;
end
 
