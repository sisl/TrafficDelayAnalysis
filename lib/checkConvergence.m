% This function is to check convergence of the delay distribution for a
% 2-lane scenario
%
% Inputs:
%   POLICY: 'FIFO' or 'FO';
%   lambda: 2d vector for the traffic density;
%   delta_d: temporal gap for vehicles from different lanes;
%   delta_s: temporal gap for vehicles in the same lane;
%
% Output:
%   b: 1 if converge; 0 if not.
%
% Note the condition for convergence is only a necessary condition.
%
% Changliu Liu
% 2018.4

function b = checkConvergence(POLICY,lambda,delta_d,delta_s)
b = 1;
switch POLICY
    case 'FIFO'
        if norm(lambda)^2*delta_s + 2*lambda(1)*lambda(2)*delta_d - sum(lambda)>0
            b = 0;
        end
    case 'FO'
        if (norm(lambda)^2+(2-exp(-lambda(1)*delta_d)-exp(-lambda(2)*delta_d))*lambda(1)*lambda(2))*delta_s + (exp(-lambda(1)*delta_d)+exp(-lambda(2)*delta_d))*lambda(1)*lambda(2)*delta_d - sum(lambda)>0
            b = 0;
        end
    otherwise
end
if b == 0
    disp([POLICY, ' do not converge!!']);
    disp(['Density: ',num2str(lambda)]);
    disp(['Temporal gap: ',num2str(delta_d),',',num2str(delta_s)])
end
end