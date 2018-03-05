function TraceResult = zNSCTrace(surf, source, split, scatter, usepolar, ignore_errors, random_seed, save, savefilename, filter)
% zNSCTrace : Performs non-sequential raytrace in a non-sequential group.
% 
% Usage :
%  TraceResult = zNSCTrace(Surf, Source, Split, Scatter, Usepolar, ignore_errors)
%  TraceResult = zNSCTrace(Surf, Source, Split, Scatter, Usepolar,
%                          ignore_errors, random_seed)
%  TraceResult = zNSCTrace(Surf, Source, Split, Scatter, Usepolar,
%                          ignore_errors, random_seed, save, savefilename, filter)
%  
% Where ...
% Surf is an integer value that indicates the number of the Non-Sequential surface. 
% If the program mode is set to Non-Sequential, use 1. 
% Source refers to the object number of the desired source. 
% If Source is zero, all sources will be traced. 
% If Split is non-zero, then splitting is on, otherwise, ray splitting is off. 
% If Scatter is non-zero, then scattering is on, otherwise scattering is off. 
% If Usepolar is non-zero then polarization will be used, otherwise
% polarization is off. If splitting is on polarization is automatically selected. 
% If ignore_errors is non-zero, then errors will be ignored, otherwise ray errors
% will terminate the non-sequential trace and macro execution and an error will
% be reported.
% If random_seed is omitted or zero, then the random number generator will be 
% seeded with a random value, and every call to zNSCTrace will produce 
% different random rays. 
% If random_seed is any integer other than zero, then the random number generator 
% will be seeded with the specified value, and every call to zNSCTrace using the 
% same seed will produce identical rays. 
% If save is omitted or is zero, the parameters savefilename and filter need not
% be supplied. If save is not zero, the rays will be saved in a ZRD file. The 
% ZRD file will have the name specified by the savefilename, and will be placed 
% in the same directory as the lens file. The extension of savefilename should 
% be ZRD, and no path should be specified. If save is not zero, then the optional 
% filter can also be given (string).
% 
% zNSCTrace always updates the lens before tracing rays to make certain all 
% objects are correctly loaded and updated.
%
% Examples :
% >> zNSCTrace(1, 2, 1, 0, 1, 1)
% The above command traces rays in NSC group 1, from source 2, with ray
% splitting, no ray scattering, using polarization and ignoring errors.
%
% >> zNSCTrace(1, 2, 1, 0, 1, 1, 33, 1, 'myrays.ZRD', 'h2');
% Same as above, only a random seed of 33 is given and the data is saved to
% the file myrays.ZRD after filtering as per h2.
%
% The string 'OK' is returned on success. Numeric 0 is returned if the
% command timed out. Since NSC raytracing can be very time-consuming,
% this is quite likely to happen. Increase the timeout period using
% zSetTimeout.

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
% $Date: 2009-10-30 09:07:07 +0200 (Fri, 30 Oct 2009) $

global ZemaxDDEChannel ZemaxDDETimeout


DDECommand = sprintf('NSCTrace,%i,%i,%i,%i,%i,%i',surf, source, split, scatter, usepolar, ignore_errors);

if ~exist('random_seed','var')
    random_seed = 0;
end
DDECommand = [DDECommand sprintf(',%i', random_seed)];

if exist('save','var') && save ~= 0 % user has requested that ray data be saved
    if ~ischar(savefilename)
        error('Parameter savefilename must be char');
    end
    DDECommand = [DDECommand sprintf(',%i,"%s"', save, savefilename)];
    if exist('filter','var')
      if ~ischar(savefilename)
        error('parameter filter must be char.');
      end
      DDECommand = [DDECommand sprintf(',"%s"', filter)];      
    end
end

TraceResult = ddereq(ZemaxDDEChannel, DDECommand, [1 1], ZemaxDDETimeout);
if ischar(TraceResult)
    TraceResult = strtrim(TraceResult);
end

% TraceResults is 0 if the command timed out
