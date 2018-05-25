% This function computes the root of the characteristic equation of the DDE
%   (a-lambda(1))*(a-lambda(2)) = lambda(1)*lambda(2)*exp(-2*a*delta_d)
%
% Inputs:
%   lambda: traffic flow density
%   delta_d: temperal gap
%
% Changliu Liu
% 2018.4

function a = getRoot(lambda, delta_d)
a = -100;
while true
anew = log((a-lambda(1))*(a-lambda(2))/(lambda(1)*lambda(2)))/(-2*delta_d);
if abs(anew-a)<0.000001
    break;
end
a = anew;
end