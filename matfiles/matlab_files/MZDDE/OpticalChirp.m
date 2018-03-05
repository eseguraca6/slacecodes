% Script to generate a spatial chirp
% Requires Signal Processing Toolbox

x = 0.1:0.0003:1;
z = chirp(x,0.1,1,300,'quadratic');
%z = chirp(x,0.1,1,200,'logarithmic');

y = (1:-0.0003:0)';

z = repmat(z, size(y,1), 1);

y = repmat(y, 1, size(z,2));

Chirp = z.*y;


imagesc(Chirp)
colormap('gray')

