function PleaseCancel
% This is a callback to allow user to stop the computation
global Cancelled
disp('User cancelled computation.');
Cancelled = 1;
