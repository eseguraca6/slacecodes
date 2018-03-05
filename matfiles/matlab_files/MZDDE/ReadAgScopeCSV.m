function Data = ReadAgScopeCSV(filename)
% ReadAgScopeCSV : Read data from an Agilent 54622A (or similar) Oscilloscope .csv file
%
% The Agilent 54622A is a dual channel 100MHz (200 Megasamples per second)
% oscilloscope. The CSV data is saved to a stiffy using the "Quick Print" key.
%
% Data saved to a memory stick by the Agilent MSO6104A can also be read, but the
% channel labels have to be 1 and 2 (channels 3 and 4 are not currently read).
%
% The Agilent MSO6104A is a 4 Gs/s (Gigsamples per second) 4-channel scope.
%
% Simple data saved with Agilent IntuiLink software should also read fine with 
% this routine in most cases.
%
% Data must be in comma-separated values (.CSV) format.
% 
% Usage : Data = ReadAgScopeCSV(filename)
% Returns a structure with the timebase in the field x,
% and the y-axis in the field v1 for channel 1 and v2 for channel 2.
% If present, the MATH data is stored in the field math.
% Other fields in the structure are
%     channels - 1 is for channel 1, 2 is for channel 2 and 77 for the math
%     units1 to units3 are the units for each of the recorded channels
%     many others, according to the setup of the scope.
%     Consult the documentation for the scope.
%     Manual may be found at http://cp.literature.agilent.com/litweb/pdf/54622-97036.pdf
%     The filename from which the data was read is put in the field
%     "filename".
%
% Bugs :
% This code only tested against a few scopes and scope configurations. 
% The priority was to read PAL TV signal scans for video system MTF calculations.

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
% $Author: DGriffith $


[fid, message] = fopen(filename, 'r');
if fid == -1
    error(['ReadAgScopeCSV::' message]);
end
Data.filename = filename;
Data.channels = [];
dataline = 0;
% Get first dataline
lin = fgetl(fid);
% Get the headers to see if this is simple data written from Agilent Untuilink software
[tok, rest] = strtok(lin, ',');
if ~strcmp(tok, 'x-axis')
    error('ReadAgScopeCSV::Data must include x-axis. This file is not useable.');
end

[head{1}, rest] = strtok(rest, ',');
[head{2}, rest] = strtok(rest, ',');
head{3} = strtok(rest, ',');
head = lower(head); % switch to lower case
if strcmp(head{1}, 'ch1') || strcmp(head{1}, 'ch2') || strcmp(head{1}, 'math') || strcmp(head{1}, 'ch77') % Intuilink data
    % disp('This appears to be IntuiLink data.');
    for ihead = 1:3
        if strcmp(head{ihead}, 'math')
                Data.channels = [Data.channels 77];
        else    
            [A, count] = sscanf(head{ihead}, 'ch%i');
            if count > 0
                channel(ihead) = A;
                Data.channels = [Data.channels channel(ihead)];
            end
        end
    end

    switch length(channel)
        case 0,
             error('ReadAgScopeCSV::There is no scope data available in this file.');
        case 1, theformat = '%f,%f';
        case 2, theformat = '%f,%f,%f';
        case 3, theformat = '%f,%f,%f,%f,';
    end

    % Read the rest of the data
    thebeef = textscan(fid, theformat);
    Data.x = thebeef{1}'; % x axis data
    for ichan = 1:length(channel)
        switch channel(ichan)
            case 1, Data.v1 = thebeef{channel(ichan)+1}';
            case 2, Data.v2 = thebeef{channel(ichan)+1}';
            case 77, Data.math = thebeef{channel(ichan)+1}';               
        end
    end
    fclose(fid);
    return; % All done with Intuilink data
end

% This is hopefully QUICK PRINT data
flag = 0;
while ~feof(fid)
    if flag
      lin = fgetl(fid); % Don't read next line on first pass, already read.
    else
      flag = 1;
    end
    % Check for which data is stored in the file
    [A,count] = sscanf(lin, 'x-axis,%i,%i,%s');
    switch count
        case 1
            col2 = A(1); Data.channels = [col2]; continue;
        case 2
            col2 = A(1); col3 = A(2); Data.channels = [col2 col3]; continue;
        case 3
            col2 = A(1); col3 = A(2); col4 = A(3); Data.channels = [col2 col3 col4]; continue;
    end
    
    % Get the units for each of the columns
    if (length(lin)>6) && (strcmp(lin(1:6), 'second'))
        units = lin(8:end);
        switch length(Data.channels)
            case 1
                [Data.units1, units] = strtok(units,',');
            case 2
                [Data.units1, units] = strtok(units,',');
                [Data.units2, units] = strtok(units,',');
            case 3
                [Data.units1, units] = strtok(units,',');
                [Data.units2, units] = strtok(units,',');
                [Data.units3, units] = strtok(units,',');
        end
    end
    
    % scan for data with up to 4 columns
    [A,count] = sscanf(lin, '%f,%f,%f,%f');
    switch count
      case 2 % There are a total of 2 columns
        dataline = dataline+1;
        Data.x(dataline) = A(1);
        switch col2
            case 1
                Data.v1(dataline) = A(2);
            case 2
                Data.v2(dataline) = A(2);
            case 77
                Data.math(dataline) = A(2);
        end
        continue;
       
      case 3 % There are three columns
        dataline = dataline+1;
        Data.x(dataline) = A(1); % time-base is in column 1
        switch col2
            case 1
                Data.v1(dataline) = A(2);
            case 2
                Data.v2(dataline) = A(2);
            case 77 % Math
                Data.math(dataline) = A(2)
        end
        switch col3
            case 1
                Data.v1(dataline) = A(3);
            case 2
                Data.v2(dataline) = A(3);
            case 77
                Data.math(dataline) = A(3);
        end
      case 4 % There are four columns
        dataline = dataline+1;
        Data.x(dataline) = A(1); % time-base is in column 1
        switch col2
            case 1
                Data.v1(dataline) = A(2);
            case 2
                Data.v2(dataline) = A(2);
            case 77 % Math
                Data.math(dataline) = A(2)
        end
        switch col3
            case 1
                Data.v1(dataline) = A(3);
            case 2
                Data.v2(dataline) = A(3);
            case 77
                Data.math(dataline) = A(3);
        end
        switch col4
            case 1
                Data.v1(dataline) = A(4);
            case 2
                Data.v2(dataline) = A(4);
            case 77
                Data.math(dataline) = A(4);
        end

        continue;
    end

    % Read Setup of the scope channels
    [A,count] = sscanf(lin, 'Anlg Ch State  Units/Div  Position  Coupling  BW Limit %s');
    if count==1 && strcmp(deblank(A), 'Invert')
        lin = fgetl(fid); % Read setup of first channel and split up the data
        lin = lin(4:end); % chop off the Ch bit
        [ch, lin] = strtok(lin, ' :'); ch = str2num(ch);
        switch ch
            case 1
                [Data.state1, lin] = strtok(lin, ' :');
                [Data.unitsperdiv1, lin] = strtok(lin, ' ');
                [Data.position1, lin] = strtok(lin, ' ');
                [Data.coupling1, lin] = strtok(lin, ' ');
                [Data.bwlimit1, lin] = strtok(lin, ' ');
                [Data.invert1, lin] = strtok(lin, ' ');
            case 2
                [Data.state2, lin] = strtok(lin, ' :');
                [Data.unitsperdiv2, lin] = strtok(lin, ' ');
                [Data.position2, lin] = strtok(lin, ' ');
                [Data.coupling2, lin] = strtok(lin, ' ');
                [Data.bwlimit2, lin] = strtok(lin, ' ');
                [Data.invert2, lin] = strtok(lin, ' ');
        end
        % Check for another channel setup line
        lin = fgetl(fid);
        if ~isempty(lin)  % Read setup of next channel
            lin = lin(4:end); % chop off the Ch bit
            [ch, lin] = strtok(lin, ' :'); ch = str2num(ch);
            switch ch
                case 1
                    [Data.state1, lin] = strtok(lin, ' :');
                    [Data.unitsperdiv1, lin] = strtok(lin, ' ');
                    [Data.position1, lin] = strtok(lin, ' ');
                    [Data.coupling1, lin] = strtok(lin, ' ');
                    [Data.bwlimit1, lin] = strtok(lin, ' ');
                    [Data.invert1, lin] = strtok(lin, ' ');
                case 2
                    [Data.state2, lin] = strtok(lin, ' :');
                    [Data.unitsperdiv2, lin] = strtok(lin, ' ');
                    [Data.position2, lin] = strtok(lin, ' ');
                    [Data.coupling2, lin] = strtok(lin, ' ');
                    [Data.bwlimit2, lin] = strtok(lin, ' ');
                    [Data.invert2, lin] = strtok(lin, ' ');
            end
        end
        continue;
    end
    
    [A,count] = sscanf(lin, 'Anlg Ch Impedance  %s');
    if count==1 && strcmp(deblank(A), 'Probe')
        lin = fgetl(fid); % Read probe setup of first channel and split up the data
        lin = lin(4:end); % chop off the Ch bit
        [ch, lin] = strtok(lin, ' :'); ch = str2num(ch);
        switch ch
            case 1
                [Data.impedance1, lin] = strtok(lin, ' :');
                [Data.impedanceunits1, lin] = strtok(lin, ' ');
                [Data.probe1, lin] = strtok(lin, ': ');
            case 2
                [Data.impedance2, lin] = strtok(lin, ' :');
                [Data.impedanceunits2, lin] = strtok(lin, ' ');
                [Data.probe2, lin] = strtok(lin, ': ');
        end
        % Check for another channel probe setup line
        lin = fgetl(fid);
        if ~isempty(lin)  % Read setup of next channel
            lin = lin(4:end); % chop off the Ch bit
            [ch, lin] = strtok(lin, ' :'); ch = str2num(ch);
            switch ch
                case 1
                    [Data.impedance1, lin] = strtok(lin, ' :');
                    [Data.impedanceunits1, lin] = strtok(lin, ' ');
                    [Data.probe1, lin] = strtok(lin, ': ');
                case 2
                    [Data.impedance2, lin] = strtok(lin, ' :');
                    [Data.impedanceunits2, lin] = strtok(lin, ' ');
                    [Data.probe2, lin] = strtok(lin, ': ');
            end
        end
        continue;
        
    end
    % Get the trigger fields
    [A,count] = sscanf(lin, 'Trigger Mode  Coupling  %s');
    if count==1 && strcmp(deblank(A), 'Holdoff')
        lin = fgetl(fid); 
        [Data.trigger,lin] = strtok(lin, ' ');
        [Data.triggermode,lin] = strtok(lin, ' ');
        [Data.triggercoupling,lin] = strtok(lin, ' ');
        [Data.triggerholdoff,lin] = strtok(lin, ' ');
    end
    
    % More trigger data for TV stuff - don't know what happens if not TV
    % trigger
    [A,count] = sscanf(lin, 'Trigger Source  Polarity  Standard      Mode     %s');
    if count==1 && strcmp(deblank(A), 'Line')
        lin = fgetl(fid);
        [trash,lin] = strtok(lin, ' ');
        [Data.triggersource,lin] = strtok(lin, ' ');
        Data.triggersource = ['Ch' Data.triggersource];
        [Data.triggerpolarity,lin] = strtok(lin, ' ');
        [Data.triggerstandard,lin] = strtok(lin, ' ');
        [Data.triggerlinemode,lin] = strtok(lin, ' ');
        [Data.triggerlinenumber,lin] = strtok(lin, ' ');
        Data.triggerlinenumber = str2num(Data.triggerlinenumber); 
    end
    
    % Get the time axis setup
    [A,count] = sscanf(lin, 'Time Time Ref  Main S/div   %s');
    if count==1 && strcmp(deblank(A), 'Delay')
        lin = fgetl(fid); 
        [Data.timesource,lin] = strtok(lin, ' ');
        [Data.timereference,lin] = strtok(lin, ' ');
        [Data.timescale,lin] = strtok(lin, ' ');
        [Data.timedelay,lin] = strtok(lin, ' ');
    end
    
    % Get the averaging acquisition stuff
    [A,count] = sscanf(lin, 'Acquisition  # Avgs  Realtime  Vectors  Infinite %s');
    if count==1 && strcmp(deblank(A), 'Persistence')
        lin = fgetl(fid); 
        [Data.acqmode,lin] = strtok(lin, ' ');
        [averages,lin] = strtok(lin, ' ');
        % Convert averages to a number
        if averages(end) == 'k'
            averages = str2num(averages(1:(end-1)))*1000;
        else
            averages = str2num(averages);
        end
        Data.acqaverages = averages;
        [Data.acqrealtime,lin] = strtok(lin, ' ');
        [Data.acqvectors,lin] = strtok(lin, ' ');
        [Data.acqinfpersistence,lin] = strtok(lin, ' ');
    end
    
    % Get the normal acquisition stuff
    [A,count] = sscanf(lin, 'Acquisition  Realtime  Vectors  Infinite %s');
    if count==1 && strcmp(deblank(A), 'Persistence')
        lin = fgetl(fid); 
        [Data.acqmode,lin] = strtok(lin, ' ');
        Data.acqaverages = 1;
        [Data.acqrealtime,lin] = strtok(lin, ' ');
        [Data.acqvectors,lin] = strtok(lin, ' ');
        [Data.acqinfpersistence,lin] = strtok(lin, ' ');
    end
    
    % Get the math stuff
    [A,count] = sscanf(lin, ' Math Scale   %s');
    if count==1 && strcmp(deblank(A), 'Offset')
        lin = fgetl(fid); 
        [Data.mathandscale,lin] = strtok(lin, '/');
        Data.mathandscale = [Data.mathandscale '/'];
        [Data.mathoffset,lin] = strtok(lin, ' /');
    end

    % Other setups would go here - one candidate is more formats for the
    % trigger source and trigger mode setups.
end

fclose(fid);

