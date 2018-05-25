% This file is for event-driven simulation (EDS)
%
% Parameters:
%   Nparticles: number of particles, default 10000;
%   POLICY: 'FIFO' or 'FO';
%   delta_d: temporal gap for vehicles from different lanes;
%   delta_s: temporal gap for vehicles in the same lane;
%   lambda: a vector for the density of each lane;
%
% Changliu Liu
% 2018.4

%% Initialize Parameters
Nparticles = 10000;
nlane = 2;
Graph = [0 1;1 0];
r = 0.5;
lambda_total = 1;
lambda = lambda_total*[r/(1+r),1/(1+r)];
delta_d = 2;
delta_s = 0;
POLICY = 'FO';
iter = 100;

PlotMode = 2; % 0: no plot; 1: particles; 2: histogram;

%% Check convergence
checkConvergence(POLICY,lambda,delta_d,delta_s);

%% Initialize Particles
part = zeros(Nparticles,nlane,iter);
part(:,:,1) = initParticles(Nparticles,nlane,delta_d,'Random');
plotParticles(part(:,:,1),PlotMode)
legend(['Iter ',num2str(1)]);
pause;

%% Iteration
meandelay = zeros(1,iter);
for k = 2:iter
    for i = 1:Nparticles
        lane = ceil(rand(1)*nlane);
        x = exprnd(1/sum(lambda));
        [part(i,:,k), delay] = macroDynamics(lane,x,part(i,:,k-1),Graph,delta_d,delta_s,POLICY);
        meandelay(k) = meandelay(k) + delay;
    end
    plotParticles(part(:,:,k),PlotMode);
    legend(['Iter ',num2str(k)]);
    meandelay(k) = meandelay(k)/Nparticles;
    if abs(meandelay(k)-meandelay(k-1))<0.0001
        break;
    end
    pause(0.5);
end
