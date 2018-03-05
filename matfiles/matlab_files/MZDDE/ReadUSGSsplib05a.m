function SpectralData = ReadUSGSsplib05a(Filename)
% ReadUSGSsplib05a : Read spectral reflectance data from the USGS splib% database
% Usage : SpectralData = ReadUSGSsplib05a(Filename)
%  where Filename is the splib data file name in .asc format.
%  If no filename is given, a file open dialog will be presented.
%
% Reference : http://speclab.cr.usgs.gov/spectral-lib.html

%% $Id: ReadUSGSsplib05a.m 221 2009-10-30 07:07:07Z DGriffith $
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

% Check for existence of the file.

if exist('Filename', 'var') && ~isempty(Filename)
else
    [Filename, Pathname] = uigetfile('*.asc','Open USGS splib05a ASCII File');
    if Filename == 0
        SpectralData = [];
        return;
    else
        Filename = [Pathname Filename];
    end
end

if ~exist(Filename, 'file')
    error(['ReadUSGSsplib05a:Filename ' Filename ' not found.']);
end

fid = fopen(Filename, 'r');

ilin = 1;
lin = fgetl(fid);
[A, count] = sscanf(lin, 'USGS Digital Spectral Library %s');
if count == 1
  SpectralData.Version = A;
end

historyline = 0;
titleline = 0;
startline = 0;

while ~feof(fid)
    ilin = ilin + 1;
    lin = fgetl(fid);
    switch ilin
        case 2
            [A, count] = sscanf(lin, 'Clark et. al. %i');
            if count == 1
                SpectralData.Year = A;
            end 
        case 3
        case 4
        case 5
            [A, count] = sscanf(lin, 'line %i title');
            if count == 1
                titleline = A;
            end
        case 6
            [A, count] = sscanf(lin, 'line %i history');
            if count == 1
                historyline = A;
            end

        case 7
            [A, count] = sscanf(lin, 'line %i to end:  3-columns of data:');
            if count == 1
                startline = A;
            end
        case 8
        case 9
        case 10
        case 11
        case 12
        case 13
            if titleline ~= 13
                warning('Title not in line 13. Format not as expected.');
            end
            SpectralData.title = lin;
        case 14
            if historyline ~= 14
                warning('History not in line 14. Format not as expected.');
            end
            SpectralData.history = lin;            
        otherwise
            if ilin >= startline
                wv = str2num(lin(1:15));
                reflectance = str2num(lin(16:30));
                if isempty(reflectance), reflectance = NaN; end
                stddev = str2num(lin(31:end));
                if isempty(stddev) || stddev == 0
                    stddev = NaN;
                end
                SpectralData.wv(ilin-startline+1) = wv;
                SpectralData.refl(ilin-startline+1) = reflectance;
                SpectralData.stddev(ilin-startline+1) = stddev;
            end
    end
end

fclose(fid);
