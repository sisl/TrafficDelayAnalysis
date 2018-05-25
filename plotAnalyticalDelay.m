% This function plots zero-delay or expected delay from analysis
% The figures correspond to Fig. 7 and Fig. 8 in the paper "Analyzing Traffic Delay at Unmanaged Intersections"
%
% Inputs:
%   POLICY: 'FIFO' or 'FO';
%   VARIABLE: 'Delta', 'Ratio', 'Lambda';
%   VALUE: 'Exp' or 'Zero';
%
% Changliu Liu
% 2018.5

POLICY = 'FIFO';
VARIABLE = 'Ratio';
VALUE = 'Exp';

switch VALUE
    case 'Exp'
        load(['Data/',POLICY,'-Ed.mat'])
        value = Ed;
    case 'Zero'
        load(['Data/',POLICY,'_PT.mat'])
        value = soln.g1+soln.g2;
end


switch VARIABLE
    case 'Delta'
        ratio = 0.5;
        delta = 0.1:0.1:4;
        r = [0.1,0.5,1,2,4];
        delay = Inf*ones(length(ratio),length(r));
        
        figure(1); hold on;
        for k = 1:length(delta)
            for i = 1:length(r)
                lambda_data = [r(i)*ratio/(1+ratio),r(i)/(1+ratio)];
                if ~checkConvergence(POLICY,lambda_data,delta(k),0)
                    break;
                end
                delay(k,i) = evaluate(value,lambda_data,delta(k));
                if delay(k,i)< 1e-6
                    break;
                end
            end
        end
        plot(delta,delay)
    case 'Ratio'
        ratio = 1:-0.02:0.02;
        delta = [0.2,1,2,4,8];
        r = 1;
        delay = Inf*ones(length(ratio),length(delta));
        
        figure(1); hold on;
        for k = 1:length(ratio)
            for i = 1:length(delta)
                lambda_data = [r*ratio(k)/(1+ratio(k)),r/(1+ratio(k))];
                if ~checkConvergence(POLICY,lambda_data,delta(i),0)
                    break;
                end
                delay(k,i) = evaluate(value,lambda_data,delta(i));
                if delay(k,i)< 1e-6
                    break;
                end
            end
        end
        plot(ratio,delay)
        axis([0,1,0,5])
    case 'Lambda'
        ratio = 1:-0.1:0.1;
        delta = 2;
        r = 0.1:0.1:4.5;
        delay = Inf*ones(length(ratio),length(r));
        
        figure(1); hold on;
        for k = 1:length(ratio)
            for i = 1:length(r)
                lambda_data = [r(i)*ratio(k)/(1+ratio(k)),r(i)/(1+ratio(k))];
                if ~checkConvergence(POLICY,lambda_data,delta,0)
                    break;
                end
                delay(k,i) = evaluate(value,lambda_data,delta);
                if delay(k,i)< 1e-6
                    break;
                end
            end
            plot(r,delay(k,:))
        end
end