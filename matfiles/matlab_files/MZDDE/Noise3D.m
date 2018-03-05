function NoiseParams = Noise3D(U, WantSpeed, WantStruct)
% Noise3D : Compute 3D noise parameters of a camera given a noise data cube
%
% This function is for analysis of 3D noise from imaging cameras, most
% significantly thermal IR cameras.
% The 3D noise parameters of the given input data cube U are computed
% according to the method given by D'Agostino and Webb.
%
% O'Shea and Sousk recommend sample sizes (U) of at least 100 by 100 by 100.
%
% Usage :
%   >> NoiseParams = Noise3D(U);
%  or
%   >> NoiseParams = Noise3D(U, WantSpeed);
%  or
%   >> NoiseParams = Noise3D(U, WantSpeed, WantStruct);
%
% Where :
%   U is a 3D matrix of samples with the third dimension being the time
%     dimension.
%   WantSpeed is a flag. If set non-zero, a faster algorithm is used.
%     Check your results against the slower, default algorithm. The results
%     should converge for large sample sizes.
%   WantStruct is a flag. If set non-zero, the output of the function
%     NoiseParams will be a structure having fields giving the
%     computed noise parameters. If WantStruct is zero or omitted, the
%     3D noise parameters are returned in a vector in the following order:
%     sigma_tvh, sigma_vh, sigma_tv, sigma_v, sigma_th, sigma_h, sigma_t and
%     Omega, being the standard deviations of the corresponding noise
%     components and the mean of the data cube (Omega). These are also
%     the names given to the fields of the structure returned if WantStruct
%     is set non-zero.
%
% References: 
%  1) D'Agostino, J. and Webb, C., "3-D Analysis Framework and
%     Methodology for Imaging System Noise", Proc. SPIE, Vol. 1488, 1991.
%  2) O'Shea, P. and Sousk, S., "Practical Issues with 3D-Noise
%     Measurements and Application to Modern Infrared Sensors", Proc. SPIE,
%     Vol. 5784, 2005.
%             
%
% Example:
% >> Noise = randn(50,50,50) + 1; % Gaussian noise with mean of 1 and
%                                 % standard deviation of 1.
% >> NoiseParams = Noise3D(Noise,1,1);
%
% The previous example generates random gaussian noise with a mean of 1
% and a standard deviation of 1. The 3D noise components are then
% calculated using the fast algorithm. The result is returned in a
% structure.

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

% $Date: 2009-10-30 09:07:07 +0200 (Fri, 30 Oct 2009) $
% $Revision: 221 $
% $Author: DGriffith $

%% Check inputs
if ~all(size(U) > [1 1 1])
    error('Noise3D:UtooSmall','Input U should be a noise cube with at least 2 samples in all three dimensions.');
end

if nargin < 3 % Default to not wanting struct output
    WantStruct = 0;
end
if nargin == 1 % Default to slower but more accurate algorithm
    WantSpeed = 0;
else
    if isempty(WantSpeed)
        WantSpeed = 0;
    end
end

%% Compute noise components and parameters.
% The noise cube should be large so be careful about making many full size intermediate results
% Avoid changing the input U so that Matlab does not make a copy.

iT = size(U,3);
iH = size(U,2);
iV = size(U,1);
% Initialise all outputs to NaN
[sigma_tvh, sigma_vh, sigma_tv, sigma_v, sigma_th, sigma_h, sigma_t, Omega] = deal(NaN, NaN, NaN, NaN, NaN, NaN, NaN, NaN);

%% Perform the noise computations using slow/sure or quick/dirty method
if WantSpeed % quick/dirty
    % Getting the order of computation optimal is a little tricky.
    % This method saves and reuses intermediate results to minimise memory
    % usage and increase speed. Use only one full size intermediate called
    % U3. Results may differ from slow method for smaller sample sizes.
    D_hU = mean(U,1); % = [D_h]{U}  1 by iH by iT
    D_vD_hU = mean(D_hU, 2); % [D_v*D_h]{U}   1 by 1 by iT
    
    % Omega = S is the firs and easiest target at this point
    Omega = mean(D_vD_hU, 3); % [D_t*D_v*D_h]{U}  scalar
    
    % Next (2nd)is N_t
    NotD_tD_vD_hU = D_vD_hU - repmat(mean(D_vD_hU, 3), [1 1 iT]); % [(1 - D_t)*D_v*D_h]{U} 1 by 1 by iT
    sigma_t = std(NotD_tD_vD_hU(:));
    
    % Next (3rd) is N_v
    NotD_vD_hU = D_hU - repmat(mean(D_hU, 2), [1 iH 1]); % = [(1 - D_v)*D_h]{U}   1 by iH by iT
    D_tNotD_vD_hU = mean(NotD_vD_hU, 3); % = N_v = [D_t)*(1 - D_v)*D_h]{U}  1 by iH by 1
    sigma_v = std(D_tNotD_vD_hU(:));
    
    % Next (4th) is N_tv
    NotD_tNotD_vD_hU = NotD_vD_hU - repmat(mean(NotD_vD_hU, 3), [1 1 iT]); % = N_tv = [(1 - D_t)*(1 - D_v)*D_h]{U}  1 by iH by iT
    sigma_tv = std(NotD_tNotD_vD_hU(:));
    
    % Next (5th) is N_h
    % But for this need NotD_hU, which is held temporarily in U3
    U3 = U  - repmat(D_hU, [iV 1  1]); % [(1 - D_h)]{U}  iV by iH by iT    
    D_vNotD_hU = mean(U3, 2); % = [D_v*(1 - D_h)]{U}  iV by 1 by iT
    D_tD_vNotD_hU = mean(D_vNotD_hU, 3); % = N_th = [D_t*D_v*(1 - D_h)]{U}  iV by 1 by 1
    sigma_h = std(D_tD_vNotD_hU(:));
    
    % Next (6th) is N_th
    NotD_tD_vNotD_hU = D_vNotD_hU - repmat(mean(D_vNotD_hU, 3), [1 1 iT]); % = N_th = [(1 - D_t)*D_v*(1 - D_h)]{U}   iV by 1 by iT
    sigma_th = std(NotD_tD_vNotD_hU(:));
    
    % Next (7th) is N_vh
    U3 = U3 - repmat(mean(U3,2), [1 iH  1]); % [(1 - D_v)*(1 - D_h)]{U}   iV by iH by iT
    U2 = mean(U3, 3); % = N_vh = [D_t*(1 - D_v)*(1 - D_h)]{U}   iV by iH by 1
    sigma_vh = std(U2(:));
    
    % Last (8th) is N_tvh
    U3 = U3 - repmat(mean(U3,3), [1  1 iT]); % = N_tvh = [(1 - D_t)*(1 - D_v)*(1 - D_h)]{U}  iV by iH by iT
    sigma_tvh = std(U3(:));
else % slow/sure method
    % Go the slow route using a less obscure method.
    % Calculate noise parameters in the order of D'Agostino without caring that some
    % things are recalculated several times and memory is seriously hogged for large sample sizes.
    N_x = notD_t(notD_v(notD_h(U)));
    sigma_tvh = std(N_x(:));
    N_x = D_t(notD_v(notD_h(U)));
    sigma_vh = std(N_x(:));
    N_x = notD_t(notD_v(D_h(U)));
    sigma_tv = std(N_x(:));
    N_x = D_t(notD_v(D_h(U)));
    sigma_v = std(N_x(:));
    N_x = notD_t(D_v(notD_h(U)));
    sigma_th = std(N_x(:));
    N_x = D_t(D_v(notD_h(U)));
    sigma_h = std(N_x(:));
    N_x = notD_t(D_v(D_h(U)));
    sigma_t = std(N_x(:));
    Omega = mean(U(:)); % Omega is the same as S in D'Agostino
end

if WantStruct
  NoiseParams.sigma_tvh = sigma_tvh;
  NoiseParams.sigma_vh = sigma_vh;
  NoiseParams.sigma_tv = sigma_tv; 
  NoiseParams.sigma_v = sigma_v;
  NoiseParams.sigma_th = sigma_th;
  NoiseParams.sigma_h = sigma_h;
  NoiseParams.sigma_t = sigma_t;
  NoiseParams.Omega = Omega;
  NoiseParams.S = Omega; % same thing
else
  NoiseParams = [sigma_tvh, sigma_vh, sigma_tv, sigma_v, sigma_th, sigma_h, sigma_t, Omega];
end

%% Here is the implementation of the averaging operators
function D_tU = D_t(U)
D_tU = repmat(mean(U,3), [1 1 size(U,3)]);
return

function notD_tU = notD_t(U)
notD_tU = U - repmat(mean(U,3), [1 1 size(U,3)]);
return

function D_vU = D_v(U)
D_vU = repmat(mean(U,2), [1 size(U,2) 1]);
return

function notD_vU = notD_v(U)
notD_vU = U - repmat(mean(U,2), [1 size(U,2) 1]);
return

function D_hU = D_h(U)
D_hU = repmat(mean(U,1), [size(U,1) 1 1]);
return

function notD_hU = notD_h(U)
notD_hU = U - repmat(mean(U,1), [size(U,1) 1 1]);
return
