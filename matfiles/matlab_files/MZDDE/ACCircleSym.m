% Computes autocorrelation of a circle of radius e
% w is the separation of the circle centres
clear all
syms A x e w


A = 4 * int(sqrt(e^2-x^2),x,w/2,e);

%A=simple(A);
