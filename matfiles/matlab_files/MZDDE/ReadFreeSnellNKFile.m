function nkdata = ReadFreeSnellNKFile(Filename, PlotFlag, ZemaxCoatOut, MicronRange)
% ReadFreeSnellNKFile : Read material optical constant data from a FreeSnell .nk file
%
% The FreeSnell data for numerous materials can be obtained at :
%  http://people.csail.mit.edu/jaffer/FreeSnell/nk.html
%   (Last Accessed 2009-08-21).
%
% Usage :
%
%  >> nkdata = ReadFreeSnellNKFile(Filename);
%    Or
%  >> nkdata = ReadFreeSnellNKFile(Filename, PlotFlag);
%    Or
%  >> nkdata = ReadFreeSnellNKFile(Filename, PlotFlag, ZemaxCoatFileOut);
%    Or
%  >> nkdata = ReadFreeSnellNKFile(Filename, PlotFlag, ZemaxCoatFileOut, MicronRange);
%
% Where :
%   Filename is the name of the FreeSnell .nk refractive index data file.
%     If omitted or empty a file open dialog is presented.
%   If PlotFlag is given as non-zero, then the n and k data are plotted.
%     PlotFlag also determines the wavelength-related scale of the plot as
%     follows:
%     PlotFlag = 1 : n and k plotted against photon energy in eV
%     PlotFlag = 2 : n and k plotted against wavelength in microns
%     PlotFlag = 3 : n and k plotted against wavenumber in 1/cm
%     PlotFlag = 4 : n and k plotted against wavelength in nm
%   If ZemaxCoatOut is given as a filename, then the n and k data are
%     written to the file in a suitable format for insertion into the Zemax
%     coating data file 'COATING.DAT' as a MATE (material) entry.
%   If MicronRange is given, both the plot x-axis range and the range of
%     wavelength data writen to the ZemaxCoatOut file will be limited to the
%     given range. If MicronRange has more than 2 elements, the data is
%     first interpolated onto the MicronRange values before being written
%     to the output file.
%
% The returned structure nkdata contains the following fields:
%
%   Filename: The filename (without .nk extension)
%   Filepath: The full path of the file
%     Header: The data in the first line of the file
%          n: The real part of the refractive index
%          k: The imaginary part of the refractive index
%       Unit: The unit of the wavelength-related data in the file, could
%             be eV, nm, 1/cm or micron
%         eV: Photon energy in electron volts
%         nm: Wavelength in nm
%      percm: Wavenumber per cm
%     micron: Wavelength in microns
%
% Example:
%  >> Silver = ReadFreeSnellNKFile('Ag.nk', 2, 'Ag.txt', [0.3 1.8]);
%
%  The above example reads optical constant data from the FreeSnell file Ag.nk
%  in the current directory, plots the data with respect to wavelength in
%  microns over the range of 0.3 micron to 1.8 micron and saves the data in
%  the same range to the file Ag.txt in the Zemax COATING.DAT material
%  definition format.

%% $Id: ReadFreeSnellNKFile.m 221 2009-10-30 07:07:07Z DGriffith $
% All rights reserved.
%
% Redistribution and use in source and binary forms, with or without 
% modification, are permitted provided that the following conditions are 
% met:
%
%    * Redistributions of source code must retain the above copyright 
%      notice, this list of conditions and the following disclaimer.
%    * Redistributions in binary form must reproduce the above copyright 
%      notice, this list of conditions and the following disclaimer in 
%      the documentation and/or other materials provided with the distribution
%      
% THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" 
% AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE 
% IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE 
% ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE 
% LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR 
% CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF 
% SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS 
% INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN 
% CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) 
% ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE 
% POSSIBILITY OF SUCH DAMAGE.

%% Some checking
nkdata = [];

if exist('MicronRange', 'var') && isnumeric(MicronRange)
  MicronRange = sort(MicronRange(:));
else
  MicronRange = [];
end
if ~exist('Filename', 'var') || isempty(Filename)
    [Filename, Pathname] = uigetfile('*.nk', 'Select the FreeSnell .nk Database File');
    if ~Filename
        return
    end
    Filename = [Pathname Filename];
end
[pathstr, name] = fileparts(Filename);

%% Open and read the file
fid = fopen(Filename,'r');
% Read the header data
Header = fgetl(fid);
if Header(1) == ';' % Drop comment at start of file
  nkdata.Comment = Header(2:end);
  Header = fgetl(fid);
end
nkdata.Header = Header;
% Scan the header line for strings
HeaderStrings = textscan(Header, '%s');
HeaderStrings = HeaderStrings{1};
nkdata.HeaderStr = HeaderStrings';
for iStr = 1:length(HeaderStrings) % strip off comments
  if HeaderStrings{iStr}(1) == ';'
    break;
  else
    ColHeads{iStr} = HeaderStrings{iStr};
  end
end
nkdata.ColHeads = ColHeads;
nkdata.Filename = name;
nkdata.FilePath = pathstr;
% nkdata.Header = Header';
% x = (Header(2):((Header(3)-Header(2))/Header(4)):Header(3))';
TheFormat = repmat('%f', 1, length(ColHeads))
data = textscan(fid, TheFormat, 'Delimiter', ', \t', 'MultipleDelimsAsOne',1, 'CommentStyle', ';');
nkdata.data = [data];
x = data{1};
nkdata.n = data{2};
nkdata.k = data{3};
fclose(fid);

%% Compute the x values for various units and populate the output structure
c = 299792458; % m/s 
switch ColHeads{1}
  case 'eV' % eV
    nkdata.Unit = 'eV';
    nkdata.eV = x;
    nkdata.nm = 4.13566733e-15 * c * 1e9 ./ nkdata.eV;
    nkdata.percm = 1e7 ./ nkdata.nm;
    nkdata.micron = nkdata.nm / 1000;
  
  case 'um' % micron
    nkdata.Unit = [char(181) 'm'];
    nkdata.micron = x;
    nkdata.nm = 1000 * x;
    nkdata.percm = 1e7 ./ nkdata.nm;
    nkdata.eV = 4.13566733e-15 * c * 1e9 ./ nkdata.nm;

  case '1/cm' % 1/cm
    nkdata.Unit = '1/cm';
    nkdata.percm = x;
    nkdata.nm = 1e7 ./ percm;
    nkdata.micron = nkdata.nm / 1000;
    nkdata.eV = 4.13566733e-15 * c * 1e9 ./ nkdata.nm;
    
  case 'nm' % nm
    nkdata.Unit = 'nm';
    nkdata.nm = x;
    nkdata.percm = 1e7 ./ nkdata.nm;
    nkdata.micron = nkdata.nm / 1000;
    nkdata.eV = 4.13566733e-15 * c * 1e9 ./ nkdata.nm;

  otherwise
    error('ReadFreeSnellNKFile:UnknownUnit','The unit code in this FreeSnell file is unknown.')
end


%% Do the plotting if requested
if exist('PlotFlag', 'var') && PlotFlag % Plot the data
  figure;
  switch PlotFlag
    case 1
      subplot(2,1,1), plot(nkdata.eV, nkdata.n); grid;
      title(['FreeSnell Optical Constants - ' nkdata.Filename]);      
      ylabel('n');
      subplot(2,1,2), plot(nkdata.eV, nkdata.k); grid;
      xlabel('Photon Energy (eV)');
      ylabel('k');
    case 2
      subplot(2,1,1), plot(nkdata.micron, nkdata.n); grid;
      title(['FreeSnell Optical Constants - ' nkdata.Filename]);      
      ylabel('n');
      if exist('MicronRange', 'var')
        if isnumeric(MicronRange) && length(MicronRange) >= 2
          axis([min(MicronRange) max(MicronRange) min(nkdata.k) max(nkdata.k)])
          axis 'auto y'
          
        else
          warning('ReadFreeSnellNKFile:BadMicronRange','MicronRange input must a 2  (or more) element numeric vector.')
        end
      end
      subplot(2,1,2), plot(nkdata.micron, nkdata.k); grid;
      xlabel('Wavelength (\mum)');
      ylabel('k');
      if exist('MicronRange', 'var')
        if isnumeric(MicronRange) && length(MicronRange) >= 2
          axis([min(MicronRange) max(MicronRange) min(nkdata.k) max(nkdata.k)])
          axis 'auto y'
          
        else
          warning('ReadFreeSnellNKFile:BadMicronRange','MicronRange input must a 2 (or more) element numeric vector.')
        end
        
      end
      
    case 3
      subplot(2,1,1), plot(nkdata.percm, nkdata.n); grid;
      title(['FreeSnell Optical Constants - ' nkdata.Filename]);      
      ylabel('n');
      subplot(2,1,2), plot(nkdata.percm, nkdata.k); grid;
      xlabel('Wavenumber (1/cm)');
      ylabel('k');    
    case 4
      subplot(2,1,1), plot(nkdata.nm, nkdata.n); grid;
      title(['FreeSnell Optical Constants - ' nkdata.Filename]);      
      ylabel('n');
      subplot(2,1,2), plot(nkdata.nm, nkdata.k); grid;
      xlabel('Wavelength (nm)');
      ylabel('k');
    otherwise
      error('ReadFreeSnellNKFile:BadPlotFlag', 'PlotFlag input must be 1 to 4.');
  end
end

%% Write the Zemax COATING.DAT compatible MATL definition if requested
if exist('ZemaxCoatOut','var') && ischar(ZemaxCoatOut) && ~isempty(ZemaxCoatOut)
  microndata = [nkdata.micron nkdata.n -nkdata.k./nkdata.n]; % Zemax wants the imaginary part negative, expressed as extinction coefficient
  % First sort the data on wavelength
  microndata = sortrows(microndata);
  if exist('MicronRange', 'var')
    if isnumeric(MicronRange) && length(MicronRange) >= 2
      if length(MicronRange) > 2
        microndata = [MicronRange interp1(microndata(:,1), microndata(:,2), MicronRange) interp1(microndata(:,1), microndata(:,3), MicronRange)];
      else
        % Select given subrange of data
        iselect = microndata(:,1)>=min(MicronRange) & microndata(:,1)<=max(MicronRange);
        microndata = microndata(iselect,:);
      end
    else
      warning('ReadFreeSnellNKFile:BadMicronRange','MicronRange input must a 2 element numeric vector.')
    end
  end
  fid = fopen(ZemaxCoatOut, 'w');
  fprintf(fid, 'MATE %s\n', upper(nkdata.Filename));
  fprintf(fid, '%7.5f %11.7f %12.7f\n', microndata');
  fclose(fid);
end
