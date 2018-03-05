function CoatingData = ReadZemaxCoatData(Filename)
% ReadZemaxCoatData - Read results from a ZEMAX Coating Data text file
%
% Usage : CoatingData = ReadZemaxCoatData(Filename)
%
% Reads data written from a Zemax coating analysis.
% Will read data as a function of incidence angle or as a function of wavelength.
% The associated zemax buttons are Caa, Caw, Cda, Cdw, Cna, Cnw, Cra, Crw etc.
%
% See also : zGetTextFile, ZemaxButtons, PlotZemaxCoatData

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

if ~exist('Filename', 'var')
    [Filename, Pathname] = uigetfile('*.txt', 'Open Coating Data Text File');
    Filename = [Pathname Filename];
end

[fid, err] = fopen(Filename, 'r');
if fid==-1
    error(['Unable to open specified file ' Filename ' - ' err]);
end

% Read some of the header information
lin = fgetl(fid);
[vs, count] = sscanf(lin, 'Reflection, Transmission, Absorption, Diattenuation, and Phase vs. %s');
CoatingData.xVariable = vs;

lin = fgetl(fid); % blank line
lin = fgetl(fid);
[RefWave, count] = sscanf(lin, 'Reference wavelength for coating thickness: %f µm.');
CoatingData.CoatRefWave = RefWave;

lin = fgetl(fid);

[PhaseUnits, count] = sscanf(lin, 'Phase and Retardance values are in %[a-z].');

lin = fgetl(fid); % blank line
lin = fgetl(fid);

[CoatName, count] = sscanf(lin, 'Coating %s on Surface %*s has %*s layer(s).');
[SurfLayers, count] = sscanf(lin, 'Coating %*s on Surface %f has %f layer(s).');   

if count > 1 % Only read coating data if found
    CoatingData.CoatName = CoatName;
    CoatingData.Surface = SurfLayers(1);
    CoatingData.NumLayers = SurfLayers(2);

    lin = fgetl(fid); % header line

    for ilayer = 1:CoatingData.NumLayers % Read the layer data of the coating
      lin = fgetl(fid);
      [LayerMaterial, count] = sscanf(lin, '%s %*f %*f %*f %*s');
      CoatingData.LayerMaterial{ilayer} = char(LayerMaterial');
      [LayerData, count] = sscanf(lin, '%*s %f %f %f %*s');
      CoatingData.LayerThickness(ilayer) = LayerData(1);
      CoatingData.LayerAbsolute(ilayer) = LayerData(2);
      CoatingData.LayerLoop(ilayer) = LayerData(3);
      [LayerTaper, count] = sscanf(lin, '%*s %*f %*f %*f %s');
      CoatingData.LayerTaper{ilayer} = char(LayerTaper');
    end
end
lin = fgetl(fid); % blank line
lin = fgetl(fid);

[CoatingData.IncidentMedium, count] = sscanf(lin, 'Incident media: %s');

lin = fgetl(fid);

[CoatingData.Substrate, count] = sscanf(lin, 'Substrate     : %s');


lin = fgetl(fid);
if strcmp(lower(vs), 'wavelength')
[CoatingData.AngleOfIncidence, count] = sscanf(lin, 'Angle of Incidence: %f');

else 
    if strcmp(lower(vs), 'angle')
        [CoatingData.EvalWave, count] = sscanf(lin, 'Wavelength: %f');
    end
end

lin = fgetl(fid); % blank line
lin = fgetl(fid); % Data column headers

% Split into headers
[tok, rest] = strtok(lin);
iheader = 1;
while ~isempty(tok)
    h1{iheader} = strtrim(tok);
    [tok, rest] = strtok(rest);
    iheader = iheader + 1;
end

% Now kill bad characters
% for ii = 1:length(h1)
%     if ~isempty(h1{ii})
%         alphachars = isletter(h1{ii});
%         alphachars = alphachars .* (1:length(alphachars));
%         h1{ii} = h1{ii}(alphachars(find(alphachars)));
%     end
% end
CoatingData.Headers = h1;
format = '%f';

for iheader = 2:length(h1)
    format = [format ' %f'];
end

Data = textscan(fid, format);
CoatingData.Data = Data;
fclose(fid);



