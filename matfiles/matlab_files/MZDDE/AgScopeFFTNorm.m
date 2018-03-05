function ScopeDataOut = AgScopeFFTNorm(ScopeDataIn)
% AgScopeFFTNorm : As for AgScopeFFT, except that spectra are normalised to
% unity at frequency of 0.
% Usage : ScopeDataOut = AgScopeFFTNorm(ScopeDataIn)
% Where:
%     ScopeDataIn is the structure returned by ReadAgScopeCSV
%     ScopeDataOut is the same structure, but with FFT of channels that are
%      present in the data.
% The following fields are added to the structure
% ScopeDataOut.f are the frequencies in Hertz.
% ScopeDataOut.fs are the frequencies folded to negative values as for shifted spectra (see fftshift).
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
% >> b = AgScopeFFTNorm(a);
% >> PlotAgScope(b);
%
% Notes : 
%     The frequency scale actually only goes to half the maximum in f.
%     Plot shifted spectra against the shifted frequencies (fs).
%
% See Also : ReadAgScopeCSV, PlotAgScope, AgScopeFFT

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



ScopeDataOut = AgScopeFFT(ScopeDataIn);

% Normalise all spectra to unity

if isfield(ScopeDataOut, 'v1')
    for ip = 1:numel(ScopeDataOut)
        ScopeDataOut(ip).ftv1 = ScopeDataOut(ip).ftv1 ./ ScopeDataOut(ip).ftv1(1);
        ScopeDataOut(ip).aftv1 = ScopeDataOut(ip).aftv1 ./ ScopeDataOut(ip).aftv1(1);
        izero = find(ScopeDataOut(ip).fs == 0);
        ScopeDataOut(ip).ftv1s = ScopeDataOut(ip).ftv1s ./ ScopeDataOut(ip).ftv1s(izero);
        ScopeDataOut(ip).aftv1s = ScopeDataOut(ip).aftv1s ./ ScopeDataOut(ip).aftv1s(izero);
    end
end


if isfield(ScopeDataOut, 'v2')
    for ip = 1:numel(ScopeDataOut)
        ScopeDataOut(ip).ftv2 = ScopeDataOut(ip).ftv2 ./ ScopeDataOut(ip).ftv2(1);
        ScopeDataOut(ip).aftv2 = ScopeDataOut(ip).aftv2 ./ ScopeDataOut(ip).aftv2(1);
        izero = find(ScopeDataOut(ip).fs == 0);
        ScopeDataOut(ip).ftv2s = ScopeDataOut(ip).ftv2s ./ ScopeDataOut(ip).ftv2s(izero);
        ScopeDataOut(ip).aftv2s = ScopeDataOut(ip).aftv2s ./ ScopeDataOut(ip).aftv2s(izero);
    end
end

