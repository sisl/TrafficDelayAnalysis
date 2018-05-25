% This function initializes the particles for event-driven simulation
%
% Inputs:
%   Nparticles: number of particles
%   nlane: number of lanes
%   delta_d: temporal gap
%   Mode: mode of initialization. 'Zero' or 'Random'
%
% Output:
%   part: the particles
%
% Changliu Liu
% 2018.5

function part = initParticles(Nparticles,nlane,delta_d,Mode)

part = zeros(Nparticles,nlane);
for i = 1:Nparticles
    lane = ceil(i/Nparticles*nlane);
    switch Mode
        case 'Zero'
            part(i,lane) = 0;
            for k = 1:nlane
                if k ~= lane
                    part(i,k) = -delta_d;
                end
            end
        case 'Random'
            part(i,lane) = exprnd(1)-delta_d;
            s = part(i,lane);
            for k = 1:nlane
                if k ~= lane
                    part(i,k) = s+exprnd(1)+delta_d;
                    s = part(i,k);
                end
            end
        otherwise
            error('Unrecognized Mode.')
    end
end

end