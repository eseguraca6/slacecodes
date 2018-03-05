function zmxPSF = ReadZemaxPSF(File)
% ReadZemaxPSF : Read a text file containing a Zemax Point Spread Function
%
% Usage :
%   zmxPSF = ReadZemaxPSF(Filename)
%
% Reads text written from a Zemax FFT or Huygens Point Spread Function computation.
% The text can be written from the PSF analysis window, or generated using the zGetTextFile function.
% (see help ZemaxButtons).
% The button codes for FFT and Huygens PSF computations are respectively 'Fps' and 'Hps'.
% The results are returned in a struct in which the following fields are defined :
%      datatype: Type of data in the data field e.g. 'Polychromatic Diffraction MTF'
%          file: Name of the ZEMAX file from which the data was computed e.g. 'C:\Projects\test.ZMX'
%         title: Title of the ZEMAX lens from which the data was computed e.g. 'mak U.S.Patent 2701983 Variant a'
%          date: Date on which the data was computed e.g. 'THU NOV 6 2003'
%           wav: Wavelength range for the computation e.g. [0.4500 0.5150]
%        fieldx: The x values of the field positions e.g. [0 0 0 0 0]
%        fieldy: The y values of the field positions e.g. [0 0 20 40 40]
%    fieldunits: The units of the field positions e.g. 'mm'
%   dataspacing: Spacing (pitch) of data points in the PSF.
%  spacingunits: Units of dataspacing.
%     dataareax: Total dimension of PSF in x
%     dataareay: Total dimension of PSF in y
%     areaunits: Units of total area dimensions.
%        strehl: Strehl ratio (Huygens PSF)
%     pupilgrid: Pupil sampling grid size.
%     imagegrid: Image sampling grid size.
%        center: Indices of center pixel.
%  centercoords: Image space coodinates of center pixel.
%       surface: Surface at which PSF was computed (FFT PSF).
%     valuesare: Information about PSF data values.
%           psf: The PSF data (dimensions are given in imagegrid field).

% See also zGetTextFile

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


% $Author: DGriffith $
% $Revision: 221 $

[fid, err] = fopen(File, 'r');
if fid==-1
    disp(['Unable to open specified file ' File ' - ' err]);
    return;
end
lin = fgetl(fid);

zmxPSF.datatype = sscanf(lin, 'Listing of %s');
if strcmp(zmxPSF.datatype, 'FFT')
    zmxPSF.datatype = 'FFT PSF Data';
else
    if strcmp(zmxPSF.datatype, 'Huygens')
        zmxPSF.datatype = 'Huygens PSF Data';
    else
        fclose(fid);
        error('This file does not seem to contain PSF data.');
    end
end
while ~feof(fid)
    lin = fgetl(fid);
    % Scan for various fields and extract the data
    [A, count] = sscanf(lin, 'File : %s');
    if count == 1
        zmxPSF.file = lin(8:end);
    end
    [A, count] = sscanf(lin, 'Title: %s');
    if count == 1
        zmxPSF.title = lin(8:end);
    end
    [A, count] = sscanf(lin, 'Date : %s');
    if count == 1
        zmxPSF.date = lin(8:end);
    end
    [A, count] = sscanf(lin, '%f to %f µm at %f, %f');
    if count == 4
        zmxPSF.wav = [A(1) A(2)];
        zmxPSF.fieldx = A(3);
        zmxPSF.fieldy = A(4);
        zmxPSF.fieldunits = sscanf(lin, '%*f to %*f µm at %*f, %*f %s');
        zmxPSF.fieldunits = zmxPSF.fieldunits(1:(end-1));
    end
    if count == 3
        zmxPSF.wav = [A(1) A(2)];
        zmxPSF.fieldx = A(3);
        zmxPSF.fieldy = 0;
        zmxPSF.fieldunits = sscanf(lin, '%*f to %*f µm at %*f %s');
        zmxPSF.fieldunits = zmxPSF.fieldunits(1:(end-1));
    end
    [A, count] = sscanf(lin, 'Data spacing is %f');
    if count
        zmxPSF.dataspacing = A(1);
        zmxPSF.spacingunits = sscanf(lin, 'Data spacing is %*f %s');
        zmxPSF.spacingunits = zmxPSF.spacingunits(1:(end-1));

    end
    [A, count] = sscanf(lin, 'Data area is %f µm wide.');
    if count
        zmxPSF.dataareax = A(1);
        zmxPSF.dataareay = A(1);
        zmxPSF.areaunits = sscanf(lin, 'Data area is %*f %s %*s');
    end

    [A, count] = sscanf(lin, 'Data area is %f by %f');
    if count == 2
        zmxPSF.dataareax = A(1);
        zmxPSF.dataareay = A(2);
        zmxPSF.areaunits = sscanf(lin, 'Data area is %*f by %*f %s');
        zmxPSF.areaunits = zmxPSF.areaunits(1:(end-1));

    end

    [A, count] = sscanf(lin, 'Strehl ratio: %f');
    if count
        zmxPSF.strehl = A;
    end
    [A, count] = sscanf(lin, 'Pupil grid size: %i by %i');
    if count
        zmxPSF.pupilgrid = [A(1) A(2)];
    end
    [A, count] = sscanf(lin, 'Image grid size: %i by %i');
    if count
        zmxPSF.imagegrid = [A(1) A(2)];
    end
    [A, count] = sscanf(lin, 'Center point is: %i, %i');
    if count
        zmxPSF.center = [A(1) A(2)];
    end
    [A, count] = sscanf(lin, 'Center point is: row %i, column %i');
    if count
        zmxPSF.center = [A(1) A(2)];
    end
    [A, count] = sscanf(lin, 'Center coordinates: %f, %f');
    if count
        zmxPSF.centercoords = [A(1) A(2)];
    end
    [A, count] = sscanf(lin, 'Reference Coordinates: %f, %f');
    if count
        zmxPSF.centercoords = [A(1) A(2)];
    end
    [A, count] = sscanf(lin, 'Surface: %s');
    if count
        zmxPSF.surface = A;
    end
    [A, count] = sscanf(lin, 'Values are %s');
    if count
        zmxPSF.valuesare = lin;
        % take this as the cue to read the rest of the data
        lin = fgetl(fid); % blank line
        data = textscan(fid, '%f');
        zmxPSF.psf = reshape(data{1}, zmxPSF.imagegrid(1), zmxPSF.imagegrid(2));
        fclose(fid);
        return;
    end
end
fclose(fid);
