% This file visualizes the mapping F
%   T_{i+1} = F(T_i,x_i,s_{i+1})
% which is the change of the lane delays when new vehicles are added.
% 
% Note that this function only works in a 2-lane case.
% 
% Inputs:
%   s: the lane number of the new vehicle
%   x: the temporal gap between two vehicles
%   T: the existing lane delay
%   delta_s: the required temporal gap between vehicles in the same lane
%   delta_d: the required temporal gap between vehicles in different lanes
%   STRATEGY: 'FIFO' or 'FO'
%   PLOT: 0: no plot; 1: 2D plot; 2: 3D plot;
%
% Outputs:
%   F: the mapping in matrix form
%

function newT = mapping(s,x,Tlist,G,delta_d,delta_s,STRATEGY,PLOT)
npoints = size(Tlist,2);
newT.F1 = zeros(npoints);
newT.F2 = zeros(npoints);

for i =1:npoints
    for j = 1:npoints
        if abs(Tlist(1,i)-Tlist(2,j))<=delta_d
            newT.F1(i,j) = Inf;
            newT.F2(i,j) = Inf;
        else
            delay = macroDynamics(s,x,[Tlist(1,i),Tlist(2,j)],G,delta_d,delta_s,STRATEGY);
            newT.F1(i,j) = delay(1);
            newT.F2(i,j) = delay(2);
        end
    end
end

switch PLOT
    case 1
        subplot(121)
        imagesc(Tlist(1,:),Tlist(2,:),newT.F1)
        title('Delay in lane 1.')
        subplot(122)
        imagesc(Tlist(1,:),Tlist(2,:),newT.F2)
    case 2
        subplot(121)
        surf(Tlist(1,:),Tlist(2,:),newT.F1','EdgeColor','none')
        grid off;box on;
        axis equal
        subplot(122)
        surf(Tlist(1,:),Tlist(2,:),newT.F2','EdgeColor','none')
        grid off;box on;
        axis equal
end
end