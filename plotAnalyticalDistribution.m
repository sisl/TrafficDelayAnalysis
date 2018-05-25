% This file plots the theoretical distributions PT
% This corresponds to Fig. 9 in the paper "Analyzing Traffic Delay at Unmanaged Intersections"
%
% Inputs:
%   POLICY: 'FIFO' or 'FO'
%   COMPUTE: 0: load existing distribution; 1: compute distribution
%
% Changliu Liu
% 2018.5

POLICY = 'FO';
COMPUTE = 0;

if COMPUTE
    % find distribution
    switch POLICY
        case 'FIFO'
            syms c1 c2 a g1 g2 I1 I2 delta_d y y1 y2 lambda lambda_1 lambda_2 gd1 gd2
            eqn1 = c1*(a-lambda_2) + c2*lambda_1*exp(-a*delta_d) == 0;
            eqn2 = c2*(a-lambda_1) + c1*lambda_2*exp(-a*delta_d) == 0;
            eqn3 = lambda_1/lambda == g1/y2+gd1/(-a);
            eqn4 = lambda_2/lambda == g2/y1+gd2/(-a);
            eqn5 = lambda*g1 == lambda_1*(I1+y*I2);
            eqn6 = lambda*g2 == lambda_2*(I2+y*I1);
            eqn7 = I1 == g1*(1+lambda_2/lambda_1*(1-y1))+gd1/(lambda-a)*y;
            eqn8 = I2 == g2*(1+lambda_1/lambda_2*(1-y2))+gd2/(lambda-a)*y;
            
            eqn9 = y == exp(-(lambda_1+lambda_2)*delta_d);
            eqn10 = y1 == exp(-(lambda_1)*delta_d);
            eqn11 = y2 == exp(-(lambda_2)*delta_d);
            
            eqn12 = gd1 == lambda_2*g1/y2-lambda_1*g2;
            eqn13 = gd2 == lambda_1*g2/y1-lambda_2*g1;
            % Relax the local condition
            soln = solve([eqn3, eqn4, eqn5,eqn6,eqn7, eqn8, eqn9, eqn10, eqn11], [I1,I2,g1,g2,gd1,gd2,y,y1,y2]);
        case 'FO'
            syms c1 c2 g1 g2 I1 I2 delta_d y y1 y2 lambda lambda_1 lambda_2 gd1 gd2 M1 M2
            eqn1 = g1+c1/lambda_2*(1/y2-1)+gd1 == M1;
            eqn2 = g2+c2/lambda_1*(1/y1-1)+gd2 == M2;
            
            eqn3 = I1 == g1+c1/lambda_1*(1-y1)+gd1*y;
            eqn4 = I2 == g2+c2/lambda_2*(1-y2)+gd2*y;
            
            eqn5 = lambda*g1 == lambda_1*(I1+y*I2);
            eqn6 = lambda*g2 == lambda_2*(I2+y*I1);
            
            eqn7 = lambda*gd1 == lambda_1*(lambda_2/lambda-I2);
            eqn8 = lambda*gd2 == lambda_2*(lambda_1/lambda-I1);
            
            eqn9 = y == exp(-(lambda_1+lambda_2)*delta_d);
            eqn10 = y1 == exp(-(lambda_1)*delta_d);
            eqn11 = y2 == exp(-(lambda_2)*delta_d);
            
            eqn12 = lambda == lambda_1+lambda_2;
            eqn13 = 1 == M1+M2;
            
            eqn14 = c1 == lambda_2*g1;
            eqn15 = c2 == lambda_1*g2;
            
            soln = solve([eqn1, eqn2, eqn3, eqn4, eqn5,eqn6,eqn7, eqn8, eqn9, eqn10, eqn11, eqn12, eqn13, eqn14, eqn15], [c1,c2,I1,I2,g1,g2,gd1,gd2,y,y1,y2,lambda_2,M1,M2]);
            %soln = solve([eqn1, eqn2, eqn3, eqn4, eqn5,eqn6,eqn7, eqn8, eqn13], [c1,c2,I1,I2,g1,g2,gd1,gd2,y2]);
    end
else
    load(['data/',POLICY,'_PT.mat'])
end

%% Plot
PLOTMODE = 1; %1: scalar delay; 2: lane delay;
VARIABLE = 'Ratio';

switch VARIABLE
    case 'Ratio'
        r = 1;
        delta = 2;
        ratio = [0.1,0.2,0.4,0.6,1];
    case 'Lambda'
        ratio = 0.5;
        r = [0.1,0.5,1,2,4];
        delta = 2;
    case 'Delta'
        r = 1;
        ratio = 0.5;
        lambda_data = [r*ratio/(1+ratio),r/(1+ratio)];
        delta_list = [0.2,1,2,4,8];
end

figure(1);hold on;

for k = 1:5
    switch VARIABLE
        case 'Ratio'
            lambda_data = [r*ratio(k)/(1+ratio(k)),r/(1+ratio(k))];
        case 'Lambda'
            lambda_data = [r(k)*ratio/(1+ratio),r(k)/(1+ratio)];
        case 'Delta'
            delta = delta_list(k);
    end
    if ~checkConvergence(POLICY,lambda_data,delta,0)
        break;
    end
switch POLICY
    case 'FIFO'
        aa = getRoot(lambda_data,delta);
        g1 = evaluate(soln.g1,lambda_data,delta);%subs(soln.g1,{lambda_1,lambda_2,delta_d,a,lambda},{lambda_data(1),lambda_data(2),delta,aa,sum(lambda_data)});
        g2 = evaluate(soln.g2,lambda_data,delta);%subs(soln.g2,{lambda_1,lambda_2,delta_d,a,lambda},{lambda_data(1),lambda_data(2),delta,aa,sum(lambda_data)});
        gd1 = evaluate(soln.gd1,lambda_data,delta);%subs(soln.gd1,{lambda_1,lambda_2,delta_d,a,lambda},{lambda_data(1),lambda_data(2),delta,aa,sum(lambda_data)});
        gd2 = evaluate(soln.gd2,lambda_data,delta);%subs(soln.gd2,{lambda_1,lambda_2,delta_d,a,lambda},{lambda_data(1),lambda_data(2),delta,aa,sum(lambda_data)});
        switch PLOTMODE
            case 1
                t=0:0.1:delta;
                plot(t,g1.*exp(lambda_data(2).*t)+g2.*exp(lambda_data(1).*t))
                t=delta:0.1:30;
                plot(t,lambda_data(1)/sum(lambda_data)-gd1/(-aa).*exp(aa.*(t-delta))+lambda_data(2)/sum(lambda_data)-gd2/(-aa).*exp(aa.*(t-delta)))
            case 2
                t=0:0.1:delta;
                plot(t,g1.*exp(lambda_data(2).*t))
                plot(t,g2.*exp(lambda_data(1).*t))
                t=delta:0.1:30;
                plot(t,lambda_data(1)/sum(lambda_data)-gd1/(-aa).*exp(aa.*(t-delta)))
                plot(t,lambda_data(2)/sum(lambda_data)-gd2/(-aa).*exp(aa.*(t-delta)))
        end
    case 'FO'
        switch PLOTMODE
            case 1
                tt = 0:0.1:delta;
                %lambda = sum(lambda_data);
                %lambda_1 = lambda_data(1);
                %lambda_2 = lambda_data(2);
                delay = zeros(size(tt));
                for i = 1:length(tt)
                    %t = tt(i);
                    delay(i) = evaluate(subs(Pd,t,tt(i)),lambda_data,delta);
                    %delay(i) = evaluate(coeresult.s0,lambda_data,delta)+evaluate(coeresult.s2,lambda_data,delta)*exp(lambda_1*t)+evaluate(coeresult.s3,lambda_data,delta)*exp(lambda_2*t)+evaluate(coeresult.s4,lambda_data,delta)*exp(-lambda*t)+evaluate(coeresult.s5,lambda_data,delta)*exp(-lambda_1*t)+evaluate(coeresult.s6,lambda_data,delta)*exp(-lambda_2*t);
                end
                plot(tt,delay,'k','LineWidth',2)
                tt=[delta,delta*2];
                plot(tt,ones(1,length(tt)))
            case 2
                g1 = subs(soln.g1,{lambda_1,lambda_2,delta_d,lambda},{lambda_data(1),lambda_data(2),delta,sum(lambda_data)});
                g2 = subs(soln.g2,{lambda_1,lambda_2,delta_d,lambda},{lambda_data(1),lambda_data(2),delta,sum(lambda_data)});
                t=0:0.1:delta;
                plot(t,g1.*exp(lambda_data(2).*t))
                plot(t,g2.*exp(lambda_data(1).*t))
                t=[delta,delta*2];
                plot(t,lambda_data(1)/sum(lambda_data)*ones(1,length(t)))
                plot(t,lambda_data(2)/sum(lambda_data)*ones(1,length(t)))
        end
end
end