function [returncode, returntext] = dcraw(filespec, varargin)
% dcraw : Dave Coffins renowned raw digital camera image convertor.
% Converts a large range of raw digital camera images to .ppm or .tiff
% The default is to convert to an 8-bit per channel .ppm (24 bit total) with
% gamma correction. If you need linear conversion, the -4 option must be
% used. Use the -T option to write a .tiff file instead of a .ppm file.
%
% For more information, search for dcraw on the internet.
%
% Linear conversion is required for photometric use. To create a linear
% 16-bit tiff for reading into Matlab with imread, use Options -4 and -T.
%
% Usage :
%       [successcode, output] = dcraw(FileSpecification); % Converts using defaults
%                                                    to .ppm
%       [successcode, output] = dcraw(FileSpecification, Options); % Converts using
%                                                          the given
%                                                          options.
%       successcode = dcraw(FileSpecification, Options, OutFile); % Converts using
%                                                          the given
%                                                          options and
%                                                          writes to an
%                                                          output file.
%                                                      
% Where FileSpecification is the list of files (separated by spaces), and
% Options are any other options you wish to specify as given below.
% Wildcards (e.g. *.NEF) are permissable.
% The output from the command is returned in output as a single string
% (with line breaks). A successcode of 0 is returned if the execution was
% successful.
%
% Example :
% >> [successcode, output] = dcraw('DSC_0045.nef', '-4 -T'); % Converts Nikon format to
%                                           % linear 16-bit (per colour channel) tiff file
% >> image = imread('DSC_0045.tiff'); % Read the image into Matlab
% >> greenchan = image(:,:,2); % Extract the green channel
%
% Other options are as follows :
% Raw photo decoder "dcraw" v8.68
% by Dave Coffin, dcoffin a cybercom o net
% 
% Usage:  f:/projects/mzdde/dcraw.exe [OPTION]... [FILE]...
% 
% -v        Print verbose messages
% -c        Write image data to standard output
% -e        Extract embedded thumbnail image
% -i        Identify files without decoding them
% -i -v     Identify files and show metadata
% -z        Change file dates to camera timestamp
% -a        Use automatic white balance
% -w        Use camera white balance, if possible
% -r <4 numbers> Set custom white balance
% -b <num>  Adjust brightness (default = 1.0)
% -n <num>  Set threshold for wavelet denoising
% -k <num>  Set black point
% -K <file> Subtract dark frame (16-bit raw PGM)
% -H [0-9]  Highlight mode (0=clip, 1=no clip, 2+=recover)
% -t [0-7]  Flip image (0=none, 3=180, 5=90CCW, 6=90CW)
% -o [0-5]  Output colorspace (raw,sRGB,Adobe,Wide,ProPhoto,XYZ)
% -d        Document mode (no color, no interpolation)
% -D        Document mode without scaling (totally raw)
% -j        Don't stretch or rotate raw pixels
% -q [0-3]  Set the interpolation quality
% -h        Half-size color image (twice as fast as "-q 0")
% -f        Interpolate RGGB as four colors
% -s [0-99] Select a different raw image from the same file
% -4        Write 16-bit linear instead of 8-bit with gamma
% -T        Write TIFF instead of PPM
%
% If you want to preview and manipulate your raw digital images, consider
% using The GIMP and the UFRaw plugin.
%
% See also : dcrawinfo

if nargin > 1
    Options = varargin{1};
else
    Options = '';
end

if nargin > 2
    OutFile = varargin{2};
else
    OutFile = '';
end

% Just call dcraw with the arguments
% First establish the directory in which the executable lies

dcrawdir = fileparts(which('dcraw'));

% Check to see if there is a wildcard in the filespec
if ~isempty(findstr('*', filespec))
    % Get a directory listing
    InFiles = dir(filespec);
    if ~isempty(InFiles)
        FilePath = fileparts(filespec);
        if ~isempty(FilePath)
          FilePath = [FilePath '\'];
        end
        filespec = [FilePath InFiles(1).name];

        if isempty(OutFile)
         [returncode, returntext] = system([dcrawdir '\dcraw.exe ' Options ' ' filespec]);
        else
         [returncode, returntext] = system([dcrawdir '\dcraw.exe ' Options ' ' filespec ' > ' OutFile]);
        end    
        if returncode ~= 0
            error(['dcraw error : ' returntext]);
        end
        % do the rest of the files, concatenating any output to OutFile
        for iFile = 2:length(InFiles)
            filespec = [FilePath InFiles(iFile).name];
            if isempty(OutFile)
             [returncode, returntext] = system([dcrawdir '\dcraw.exe ' Options ' ' filespec]);
            else
             [returncode, returntext] = system([dcrawdir '\dcraw.exe ' Options ' ' filespec ' >> ' OutFile]);
            end
            if returncode ~= 0
                error(['dcraw error : ' returntext]);
            end            
        end
    end
else
    if isempty(OutFile)
     [returncode, returntext] = system([dcrawdir '\dcraw.exe ' Options ' ' filespec]);
    else
     [returncode, returntext] = system([dcrawdir '\dcraw.exe ' Options ' ' filespec ' > ' OutFile]);
    end    
end

