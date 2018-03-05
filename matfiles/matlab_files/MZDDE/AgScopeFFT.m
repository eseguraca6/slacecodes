function ScopeDataOut = AgScopeFFT(ScopeDataIn)
% AgScopeFFT : Computes the Fast Fourier Transform of Agilent oscilloscope data.
% Usage : ScopeDataOut = AgScopeFFT(ScopeDataIn)
% Where:
%     ScopeDataIn is the structure returned by ReadAgScopeCSV
%     ScopeDataOut is the same structure, but with FFT of channels that are
%      present in the data.
% The following fields are added to the structure
% ScopeDataOut.f are the frequencies in Hertz.
% ScopeDataOut.fs are the frequencies folded to negative values as for shifted spectra.
% ScopeDataOut.ftv1 is the complex fourier transform of channel 1 data (if present).
% ScopeDataOut.ftv1s is the shifted complex fourier transform of channel 1 data.
% ScopeDataOut.ftv2 is the complex fourier transform of channel 2 data (if present).
% ScopeDataOut.ftv2s is the shifted complex fourier transform of channel 2 data.
% ScopeDataOut.aftv1 is the magnitude of the fourier transform of channel 1.
% ScopeDataOut.aftv1s is the magnitude of the shifted fourier transform of channel 1.
% ScopeDataOut.aftv2 is the magnitude of the fourier transform of channel 2.
% ScopeDataOut.aftv2s is the magnitude of the shifted fourier transform of channel 2.
% 
% Example :
% >> a = ReadAgScopeCSV('PRINT_00.CSV');
% >> b = AgScopeFFT(a);
% >> plot(b.fs, b.aftv1s);
%
% Notes : 
%     The frequency scale actually only goes to half the maximum in f.
%     Plot shifted spectra against the shifted frequencies (fs).
%
% See Also : ReadAgScopeCSV, PlotAgScope

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

% The timebase is in the field x

ScopeDataOut = ScopeDataIn;

for ii = 1:length(ScopeDataIn)

    if isfield(ScopeDataIn(ii), 'x')
      dt = mean(diff(ScopeDataIn(ii).x)); % Probably overkill, but get the time increment
      n = length(ScopeDataIn(ii).x); % Get the number of data points
      df = 1./(n*dt); % Get the frequency increment
      ScopeDataOut(ii).f = 0:df:((n-1)*df); % These are frequencies in hertz
      ScopeDataOut(ii).fs = fftshift(ScopeDataOut(ii).f);
      jj = find(ScopeDataOut(ii).fs == 0);
      ScopeDataOut(ii).fs(1:(jj-1)) = ScopeDataOut(ii).fs(1:(jj-1)) - ScopeDataOut(ii).fs(jj-1) - df; % Get the negative frequencies
    else
        error('AgScopeFFT::This input data has no timebase.');
    end

    % Now compute the ffts and the magnitudes
    if isfield(ScopeDataIn(ii), 'v1')
        ScopeDataOut(ii).ftv1 = fft(ScopeDataIn(ii).v1);
        ScopeDataOut(ii).ftv1s = fftshift(ScopeDataOut(ii).ftv1);
        ScopeDataOut(ii).aftv1 = abs(ScopeDataOut(ii).ftv1);
        ScopeDataOut(ii).aftv1s = fftshift(ScopeDataOut(ii).aftv1);    
    end

    if isfield(ScopeDataIn(ii), 'v2')
        ScopeDataOut(ii).ftv2 = fft(ScopeDataIn(ii).v2);
        ScopeDataOut(ii).ftv2s = fftshift(ScopeDataOut(ii).ftv2);
        ScopeDataOut(ii).aftv2 = abs(ScopeDataOut(ii).ftv2);
        ScopeDataOut(ii).aftv2s = fftshift(ScopeDataOut(ii).aftv2);        
    end
end
