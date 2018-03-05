% This script reads the Ohno spectra
% These spectra are given by Ohno and Jergens of NIST
% for the purpose of intercomparison of various methods
% of computing the Correlated Colour Temperature.
% See :
% Ohno, Y. and Jergens, M., 'Results of the Intercomparison of Correlated Color Temperature Calculation',
% CORM Subcommitee CR3 Photometry, NIST, June 16 1999.
% The spectra are :
% 1) FEL type tungsten halogen lamp (~3200 K)
% 2) Integrating sphere source (~2850 K)
% 3) Triphosphor fluorescent lamp (~4000 K)
% 4) Metal halide lamp (~2900 K)
% 5) High pressure sodium lamp (~2000 K)
% 6) High pressure xenon lamp (~6500 K)
% 7) CRT white (~9300 K, white balance artificially set off from the Planckian locus)
fullpath = which('ReadOhnoCCTSpectra'); % Find the data location
[pathstr,name,ext,versn] = fileparts(fullpath);
fid = fopen([pathstr '\OhnoCCTSpectra.txt'], 'r');
OhnoSpectra = textscan(fid, '%f %f %f %f %f %f %f %f', 'commentStyle', '//');
fclose(fid);
OhnoWaves = OhnoSpectra{1};
OhnoSpectra = [OhnoSpectra{2:8}];
