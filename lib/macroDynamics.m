% This file returns the value of the following function
%   newT = F(T,x,s)
% which is the change of new lane delays when new vehicles are added.
% 
% Inputs:
%   s: the lane number of the new vehicle
%   x: the temporal gap between two vehicles
%   T: the existing lane delay
%   G: conflict graph
%   delta_s: the required temporal gap between vehicles in the same lane
%   delta_d: the required temporal gap between vehicles in different lanes
%   POLICY: 'FIFO' or 'FO' or a number in [0,1]
%
% Outputs:
%   newT: the new lane delay
%   delay: the vehicle delay (scalar)
%
% Changliu Liu
% 2018.5

function [newT,delay] = macroDynamics(s,x,T,G,delta_d,delta_s,POLICY)
nlane = length(T);
delay = 0;
newT = T;
switch POLICY
    case 'FIFO'
        D = -Inf; % the earlist passing time considering vehicles from other lanes
        for k = 1:nlane
            if k~=s
                newT(k)=T(k)-x;
                if G(k,s)
                    D = max([D,newT(k)]);
                end
            end
        end
        newT(s) = max([0,D+delta_d,T(s)-x+delta_s]);
        delay = newT(s);
    case 'FO'
        S = max([0,T(s)-x+delta_s]);
        D = -Inf; % the earlist passing time considering vehicles from other lanes
        for k = 1:nlane
            if k~=s
                if G(k,s) && T(k)-x-S>0
                    newT(k) = Inf;
                else
                    newT(k)=T(k)-x;
                    D = max([D,newT(k)]);
                end
            end
        end
        newT(s) = max([0,D+delta_d,S]);
        delay = newT(s);
        % Determine the time for delayed vehicles
        D = 0;
        for k = 1:nlane
            if k~=s && newT(k) == Inf
                D = min([D,T(k)-x-newT(s)-delta_d]);
            end
        end
        for k = 1:nlane
            if k~=s && newT(k) == Inf
                newT(k) = T(k)-x-min([0,D]);
                delay = delay - min([0,D]);
            end
        end
    otherwise
        if isnumeric(POLICY) && POLICY<=1 && POLICY>=0
            S = max([0,T(s)-x+delta_s]);
            D = -Inf; % the earlist passing time considering vehicles from other lanes
            for k = 1:nlane
                if k~=s
                    if G(k,s) && T(k)-x-S+(1-1/POLICY)*delta_d>0
                        newT(k) = Inf;
                    else
                        newT(k)=T(k)-x;
                        D = max([D,newT(k)]);
                    end
                end
            end
            newT(s) = max([0,D+delta_d,S]);
            delay = newT(s);
            % Determine the time for delayed vehicles
            D = 0;
            for k = 1:nlane
                if k~=s && newT(k) == Inf
                    D = min([D,T(k)-x-newT(s)-delta_d]);
                end
            end
            for k = 1:nlane
                if k~=s && newT(k) == Inf
                    newT(k) = T(k)-x-min([0,D]);
                    delay = delay - min([0,D]);
                end
            end
        else
            error('Unknown Policy');
        end
end
% add lower bounds
for k = 1:nlane
    newT(k) = max([newT(k),-delta_d]);
end
end