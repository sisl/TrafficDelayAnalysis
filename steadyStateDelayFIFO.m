% This function computes the mean delay under FIFO
%
% Changliu Liu
% 2018.5
%% Integration
syms g1 g2 a lambda_1 lambda_2 t delta_d
d1 = lambda_2*g1*exp(lambda_2*t)+lambda_1*g2*exp(lambda_1*t);
sec1 = int(d1*t,t);
d2 = a*(g1*exp(lambda_2*delta_d)+g2*exp(lambda_1*delta_d)-1)*exp(a*(t-delta_d));
sec2 = int(d2*t,t);
mean = subs(sec1,t,delta_d)-subs(sec1,t,0)+subs(sec2,t,Inf)-subs(sec2,t,delta_d);
mean = simplify(mean)
%%
mean = (g1*lambda_2)/lambda_2^2 - ((a*delta_d - 1)*(g1*exp(delta_d*lambda_2) + g2*exp(delta_d*lambda_1) - 1))/a + (g2*lambda_1)/lambda_1^2  + (g2*lambda_1*exp(delta_d*lambda_1)*(delta_d*lambda_1 - 1))/lambda_1^2 + (g1*lambda_2*exp(delta_d*lambda_2)*(delta_d*lambda_2 - 1))/lambda_2^2;
lambda_data = [0.3,0.5];
delta = 2;
aa = getRoot(lambda_data,delta);
g1_data = subs(soln.g1,{lambda_1,lambda_2,delta_d,a,lambda},{lambda_data(1),lambda_data(2),delta,aa,sum(lambda_data)});
g2_data = subs(soln.g2,{lambda_1,lambda_2,delta_d,a,lambda},{lambda_data(1),lambda_data(2),delta,aa,sum(lambda_data)});
meanvalue = subs(mean,{lambda_1,lambda_2,delta_d,a,g1,g2},{lambda_data(1),lambda_data(2),delta,aa,g1_data,g2_data});