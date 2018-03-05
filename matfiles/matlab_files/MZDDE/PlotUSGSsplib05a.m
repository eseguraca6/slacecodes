function h = PlotUSGSsplib05a(SData)
% PlotUSGSsplib05a : Plot spectral data read with ReadUSGSsplib05a
% Example :
% >> SData = ReadUSGSsplib05a('C:\USGS\C\des_varnish_anp90-14.8923.asc');
% >> PlotUSGSsplib05a(SData);

if nargout == 1
  h = errorbar(SData.wv, SData.refl, SData.stddev);
else
    errorbar(SData.wv, SData.refl, SData.stddev);
end
grid;
title(strrep(SData.title, '_', '-'));
xlabel('Wavelength (\mum)');
ylabel('Reflectance');
