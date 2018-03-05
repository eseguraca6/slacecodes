function PlotAgScope(AgScopeData, varargin)
% PlotAgScope: Plots data from an Agilent 54622A Oscilloscope
%
% Usage : PlotAgScope(AgScopeData)
%         PlotAgScope(AgScopeData, PlotTitle);
%         PlotAgScope(AgScopeData, PlotTitle, PlotList);
%         PlotAgScope(AgScopeData, PlotTitle, PlotList, ScopeSampFreq);
% Where :
% AgScopeData is the structure returned by ReadAgScopeCSV.
% If fourier transform data is also present, as provided by AgScopeFFT,
% then the fourier transforms are also plotted by default.
% Optional PlotTitle is the title you would like to give the plot.
% Optional PlotList is the list of plots you would like in a vector.
%    Plot 1 is the channel 1 data.
%    Plot 2 is the channel 2 data.
%    Plot 3 is the math data.
%    Plot 4 is the complex fourier transform of channel 1 data (if present)
%    Plot 5 is the shifted complex fourier transform of channel 1 data.
%    Plot 6 the complex fourier transform of channel 2 data (if present).
%    Plot 7 is the shifted complex fourier transform of channel 2 data.
%    Plot 8 is the magnitude of the fourier transform of channel 1.
%    Plot 9 is the magnitude of the shifted fourier transform of channel 1.
%    Plot 10 is the magnitude of the fourier transform of channel 2.
%    Plot 11 is the magnitude of the shifted fourier transform of channel 2.
% Optional Argument ScopeSampFreq is the sampling frequency of the scope in samples per second.
% Specifying the sampling frequency will result in frequency scales in the
% FFT plots being limited to the sampling frequency.
%
%  If AgScopeData has the field 'title' then that is used for the plot,
%  otherwise a title is created from the filename.
%  If a fourier transform plot is explicitly requested but the fourier data
%  is not present in the input structure, AgScopeFFT is called to compute
%  the FFT data.
%
% See also : ReadAgScopeCSV, AgScopeFFT

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

if ~isfield(AgScopeData, 'x')
    error('AgScopeFFT::This input data has no timebase.');
end

if ~isfield(AgScopeData, 'title')    
    for ip = 1:numel(AgScopeData)
        AgScopeData(ip).title = ['Oscilloscope Data from file : ' strrep(AgScopeData(ip).filename, '_', '\_')];
    end
end

if nargin >= 2 % plot title given
    PlotTitle = varargin{1};
    if ~ischar(PlotTitle)
            error('PlotAgScope::Second argument must be char (plot title).')
    end    
    if ~isempty(PlotTitle)
        for ip=1:numel(AgScopeData)
          if size(PlotTitle,1) == numel(AgScopeData)
             AgScopeData(ip).title = PlotTitle(ip,:);
          else
             AgScopeData(ip).title = PlotTitle(1,:); 
          end
        end
    end
end    



if nargin >=3 && ~isempty(varargin{2}) % The plot types are given
    PlotList = varargin{2};
else % Plot everything available
    PlotList = [];
    if isfield(AgScopeData, 'v1');
        PlotList = [1];
    end
    if isfield(AgScopeData, 'v2');
        PlotList = cat(2, PlotList, 2);
    end
    if isfield(AgScopeData, 'math');
        PlotList = cat(2, PlotList, 3);
    end
    if isfield(AgScopeData, 'f');
        PlotList = cat(2, PlotList, [4 5 6 7 8 9 10 11]);
    end
    
end


FreqLimit = [];
if nargin >= 4 % The scope sampling rate is given
    FreqLimit = varargin{3};
    if ~isscalar(FreqLimit) || ~isfloat(FreqLimit)
        error('PlotAgScope::Scope sampling frequency must be scalar floating point number.');
    end

end
% Make various plots

for ip = 1:numel(AgScopeData)

    
% Here are the plots    
    if ~isempty(find(PlotList==1))
        % Plot the v1 data versus x
        if ~isfield(AgScopeData, 'v1')
            disp(['PlotAgScope::No Data for scan ' num2str(ip) ' channel 1 (plot 1).'])
        else
            figure;
            plot(AgScopeData(ip).x, AgScopeData(ip).v1);
            title(AgScopeData(ip).title);
            xlabel('Time (s)');
            ylab = 'Channel 1';
            if exist('AgScopeData(ip).units1', 'var')
                ylab = [ylab ' (' AgScopeData(ip).units1 ')']
            end
            ylabel(ylab);
            grid;
        end
    end

    if ~isempty(find(PlotList==2))
        % Plot the v2 data versus x
        if ~isfield(AgScopeData, 'v2')
            disp(['PlotAgScope::No Data for scan ' num2str(ip) ' channel 2 (plot 2).'])
        else
            figure;
            plot(AgScopeData(ip).x, AgScopeData(ip).v2);
            title(AgScopeData(ip).title);
            xlabel('Time (s)');
            ylab = 'Channel 2';

            if exist('AgScopeData(ip).units2', 'var')
                  ylab = [ylab ' (' AgScopeData(ip).units2 ')']
            end
            ylabel(ylab);
              
            end
            grid;
        end
    end

    if ~isempty(find(PlotList==3))
        % Plot the math data versus x
        if ~isfield(AgScopeData, 'math')
            disp(['PlotAgScope::No Data for scan ' num2str(ip) '  math channel (plot 3).']);
        else
            figure;
            plot(AgScopeData(ip).x, AgScopeData(ip).v2);
            title(AgScopeData(ip).title);
            ylabel('Math Data');
            grid;
        end
    end

    if ~isempty(find(PlotList==4))
        % Plot the ftv1 data versus f
        if ~isfield(AgScopeData, 'f')
            AgScopeData = AgScopeFFT(AgScopeData); % Get the FFT stuff
        end
        if ~isfield(AgScopeData, 'ftv1')
            disp(['PlotAgScope::No Data for scan ' num2str(ip) ' plot 4 (ftv1).']);
        else
            figure;
            subplot(2,1,1);
            plot(AgScopeData(ip).f(1:round(end/2)), real(AgScopeData(ip).ftv1(1:round(end/2))));
            title(AgScopeData(ip).title);
            ylabel('FFT Real Part');
            if ~isempty(FreqLimit)
              ymin = min(real(AgScopeData(ip).ftv1));
              ymax = max(real(AgScopeData(ip).ftv1));
              axis([0 FreqLimit ymin ymax]);
            else
              axis tight;
            end
            grid;
            subplot(2,1,2);
            plot(AgScopeData(ip).f(1:round(end/2)), imag(AgScopeData(ip).ftv1(1:round(end/2))));
            xlabel('Frequency (Hz)');
            ylabel('FFT Imaginary Part');
            if ~isempty(FreqLimit)
              ymin = min(imag(AgScopeData(ip).ftv1));
              ymax = max(imag(AgScopeData(ip).ftv1));
              axis([0 FreqLimit ymin ymax]);
            else
              axis tight;
            end
            grid;
        end
    end

    if ~isempty(find(PlotList==5))
        % Plot the ftv1s data versus fs
        if ~isfield(AgScopeData, 'fs')
            AgScopeData = AgScopeFFT(AgScopeData); % Get the FFT stuff
        end
        if ~isfield(AgScopeData, 'ftv1s')
            disp(['PlotAgScope::No Data for scan ' num2str(ip) ' plot 5 (ftv1s).']);
        else
            figure;
            subplot(2,1,1);
            plot(AgScopeData(ip).fs, real(AgScopeData(ip).ftv1s));
            title(AgScopeData(ip).title);
            ylabel('FFT Real Part');
            if ~isempty(FreqLimit)
              ymin = min(real(AgScopeData(ip).ftv1s));
              ymax = max(real(AgScopeData(ip).ftv1s));
              axis([-FreqLimit FreqLimit ymin ymax]);
            else
              axis tight;
            end
            grid;
            subplot(2,1,2);
            plot(AgScopeData(ip).fs, imag(AgScopeData(ip).ftv1s));
            xlabel('Frequency (Hz)');
            ylabel('FFT Imaginary Part');
            if ~isempty(FreqLimit)
              ymin = min(imag(AgScopeData(ip).ftv1s));
              ymax = max(imag(AgScopeData(ip).ftv1s));
              axis([-FreqLimit FreqLimit ymin ymax]);
            else
              axis tight;
            end

            grid;
        end
    end

    if ~isempty(find(PlotList==6))
        % Plot the ftv2 data versus f
        if ~isfield(AgScopeData, 'f')
            AgScopeData = AgScopeFFT(AgScopeData); % Get the FFT stuff
        end
        if ~isfield(AgScopeData, 'ftv2')
            disp(['PlotAgScope::No Data for scan ' num2str(ip) ' plot 5 (ftv2).']);
        else
            figure;
            subplot(2,1,1);
            plot(AgScopeData(ip).f(1:round(end/2)), real(AgScopeData(ip).ftv2(1:round(end/2))));
            title(AgScopeData(ip).title);
            ylabel('FFT Real Part');
            if ~isempty(FreqLimit)
              ymin = min(real(AgScopeData(ip).ftv2));
              ymax = max(real(AgScopeData(ip).ftv2));
              axis([0 FreqLimit ymin ymax]);
            else
              axis tight;
            end
            grid;
            subplot(2,1,2);
            plot(AgScopeData(ip).f(1:round(end/2)), imag(AgScopeData(ip).ftv2(1:round(end/2))));
            xlabel('Frequency (Hz)');
            ylabel('FFT Imaginary Part');
            if ~isempty(FreqLimit)
              ymin = min(imag(AgScopeData(ip).ftv2));
              ymax = max(imag(AgScopeData(ip).ftv2));
              axis([0 FreqLimit ymin ymax]);
            else
              axis tight;
            end
            grid;

        end
    end

    if ~isempty(find(PlotList==7))
        % Plot the ftv2s data versus fs
        if ~isfield(AgScopeData, 'fs')
            AgScopeData = AgScopeFFT(AgScopeData); % Get the FFT stuff
        end
        if ~isfield(AgScopeData, 'ftv2s')
            disp(['PlotAgScope::No Data for scan ' num2str(ip) ' plot 6 (ftv2s).']);
        else
            figure;
            subplot(2,1,1);
            plot(AgScopeData(ip).fs, real(AgScopeData(ip).ftv2s));
            title(AgScopeData(ip).title);
            ylabel('FFT Real Part');
            if ~isempty(FreqLimit)
              ymin = min(real(AgScopeData(ip).ftv2s));
              ymax = max(real(AgScopeData(ip).ftv2s));
              axis([-FreqLimit FreqLimit ymin ymax]);
            else
              axis tight;
            end
            grid;
            subplot(2,1,2);
            plot(AgScopeData(ip).fs, imag(AgScopeData(ip).ftv2s));
            xlabel('Frequency (Hz)');
            ylabel('FFT Imaginary Part');
            if ~isempty(FreqLimit)
              ymin = min(imag(AgScopeData(ip).ftv2s));
              ymax = max(imag(AgScopeData(ip).ftv2s));
              axis([-FreqLimit FreqLimit ymin ymax]);
            else
              axis tight;
            end
            grid;

        end
    end

    % Magnitude plots

    if ~isempty(find(PlotList==8))
        % Plot the aftv1 data versus f
        if ~isfield(AgScopeData, 'f')
            AgScopeData = AgScopeFFT(AgScopeData); % Get the FFT stuff
        end
        if ~isfield(AgScopeData, 'aftv1')
            disp(['PlotAgScope::No Data for scan ' num2str(ip) ' plot 8 (aftv1).']);
        else
            figure;
            plot(AgScopeData(ip).f(1:round(end/2)), AgScopeData(ip).aftv1(1:round(end/2)));
            title(AgScopeData(ip).title);
            ylabel('FFT Magnitude');
            xlabel('Frequency (Hz)');
            if ~isempty(FreqLimit)
              ymin = min(AgScopeData(ip).aftv1);
              ymax = max(AgScopeData(ip).aftv1);
              axis([0 FreqLimit ymin ymax]);
            else
              axis tight;
            end
            grid;
        end
    end

    if ~isempty(find(PlotList==9))
        % Plot the aftv1s data versus fs
        if ~isfield(AgScopeData, 'fs')
            AgScopeData = AgScopeFFT(AgScopeData); % Get the FFT Stuff
        end
        if ~isfield(AgScopeData, 'aftv1s')
            disp(['PlotAgScope::No Data for scan ' num2str(ip) ' plot 9 (aftv1s).']);
        else
            figure;
            plot(AgScopeData(ip).fs, AgScopeData(ip).aftv1s);
            title(AgScopeData(ip).title);
            ylabel('FFT Magnitude');
            xlabel('Frequency (Hz)');
            if ~isempty(FreqLimit)
              ymin = min(AgScopeData(ip).aftv1s);
              ymax = max(AgScopeData(ip).aftv1s);
              axis([-FreqLimit FreqLimit ymin ymax]);
            else
              axis tight;
            end
            grid;
        end
    end

    if ~isempty(find(PlotList==10))
        % Plot the aftv2 data versus f
        if ~isfield(AgScopeData, 'f')
            AgScopeData = AgScopeFFT(AgScopeData); % Get the FFT stuff
        end
        if ~isfield(AgScopeData, 'aftv2')
            disp(['PlotAgScope::No Data for scan ' num2str(ip) ' plot 10 (aftv2).']);
        else
            figure;
            plot(AgScopeData(ip).f(1:round(end/2)), AgScopeData(ip).aftv2(1:round(end/2)));
            title(AgScopeData(ip).title);
            ylabel('FFT Magnitude');
            xlabel('Frequency (Hz)');
            if ~isempty(FreqLimit)
              ymin = min(AgScopeData(ip).aftv2);
              ymax = max(AgScopeData(ip).aftv2);
              axis([0 FreqLimit ymin ymax]);
            else
              axis tight;
            end
            grid;        
        end
    end

    if ~isempty(find(PlotList==11))
        % Plot the aftv2s data versus fs
        if ~isfield(AgScopeData, 'fs')
            AgScopeData = AgScopeFFT(AgScopeData); % Get the FFT stuff
        end
        if ~isfield(AgScopeData, 'aftv2s')
            disp(['PlotAgScope::No Data for scan ' num2str(ip) ' plot 11 (aftv2s).']);
        else
            figure;
            plot(AgScopeData(ip).fs, AgScopeData(ip).aftv2s);
            title(AgScopeData(ip).title);
            ylabel('FFT Magnitude');
            xlabel('Frequency (Hz)');
            if ~isempty(FreqLimit)
              ymin = min(AgScopeData(ip).aftv2s);
              ymax = max(AgScopeData(ip).aftv2s);
              axis([-FreqLimit FreqLimit ymin ymax]);
            else
              axis tight;
            end
            grid;
        end
    end

end
