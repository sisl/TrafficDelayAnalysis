% This script computes the steady state vehicle delay under FO
% This corresponds to Corollary 8 in the paper "Analyzing Traffic Delay at Unmanaged Intersections"
%
% Changliu Liu
% 2018.5

syms c1 c2 lambda_1 lambda_2 lambda y1 y2 y s0 s1 s2 s3 s4 s5 s6 p0 p1 delta_d

eqn = {};
eqn{1} = c1 == lambda_1*lambda_2*(lambda_1*y^2+lambda_1*y2+lambda_2*y-lambda_1*y^2*y2)/lambda^2/(1+y*(y1+y2)-y*(y+1));
eqn{2} = c2 == lambda_1*lambda_2*(lambda_2*y^2+lambda_2*y1+lambda_1*y-lambda_2*y^2*y1)/lambda^2/(1+y*(y1+y2)-y*(y+1));

eqn{3} = lambda == lambda_1+lambda_2;
eqn{4} = y == y1*y2;

eqn{10} = s0 == 2*lambda_1*lambda_2/lambda^2;
eqn{11} = s1 == (lambda_1^2+lambda_2^2)/lambda^2*y+2*lambda_1*lambda_2/lambda^2*y^2+c1/lambda_1*y*(1-y1)+c2/lambda_2*y*(1-y2)-c1*y1/lambda_2-c2*y2/lambda_1;
eqn{12} = s2 == c2/lambda_1;
eqn{13} = s3 == c1/lambda_2;
eqn{14} = s4 == -(2*lambda_1*lambda_2)/lambda^2+c2/lambda_2/y1+c1/lambda_1/y2;
eqn{15} = s5 == -c2/lambda_2/y1;
eqn{16} = s6 == -c1/lambda_1/y2;

eqn{20} = p0 == s0+s1+s2+s3+s4+s5+s6;
eqn{21} = p1 == s0+s1/y+s2/y1+s3/y2+s4*y+s5*y1+s6*y2;

coeresult = solve([eqn{1},eqn{2},eqn{3},eqn{4},eqn{10},eqn{11},eqn{12},eqn{13},eqn{14},eqn{15},eqn{16},eqn{20},eqn{21}],...
    [c1,c2,lambda_2,y2,s0,s1,s2,s3,s4,s5,s6,p0,p1]);

%%
simplify(subs(coeresult.s1, [lambda_1,y], [lambda/2,y1^2]))
simplify(subs(coeresult.c1, [lambda_1,y], [lambda/2,y1^2]))
simplify(subs(coeresult.p0, [lambda_1,y], [lambda/2,y1^2]))
simplify(subs(coeresult.p1, [lambda_1,y], [lambda/2,y1^2]))

%% Verify that p0 = g1+g2
GI1 = c1*(1-y1)/(lambda_1*lambda_2)+lambda_1^2*y/lambda^2;
GI2 = c2*(1-y2)/(lambda_1*lambda_2)+lambda_2^2*y/lambda^2;
equality = coeresult.p0-coeresult.c1/(lambda-lambda_1)-coeresult.c2/(lambda_1);
simplify(subs(equality,[lambda_2,y2],[lambda-lambda_1,y/y1]))

%%
syms t
Pd = coeresult.s0+coeresult.s1*exp(lambda*t)+coeresult.s2*exp(lambda_1*t)+coeresult.s3*exp(lambda_2*t)+coeresult.s4*exp(-lambda*t)+coeresult.s5*exp(-lambda_1*t)+coeresult.s6*exp(-lambda_2*t);
lambda_data = [0.1,0.7];
delta = 2;
Pd = simplify(subs(Pd,[lambda,lambda_1,lambda_2,y,y1],[sum(lambda_data),lambda_data(1),lambda_data(2),exp(-delta*sum(lambda_data)),exp(-delta*lambda_data(1))]));
r = 0:0.1:delta;
delay = zeros(size(r));
for i = 1:length(r)
    delay(i) = double(subs(Pd,t,r(i)));
end
plot(r,delay,'k','LineWidth',2)
box on
axis equal
axis([0,delta,0,1])
%%
S0 = evaluate(coeresult.s0,lambda_data,delta)
S1 = evaluate(coeresult.s1,lambda_data,delta)
S2 = evaluate(coeresult.s2,lambda_data,delta)
S3 = evaluate(coeresult.s3,lambda_data,delta)
S4 = evaluate(coeresult.s4,lambda_data,delta)
S5 = evaluate(coeresult.s5,lambda_data,delta)
S6 = evaluate(coeresult.s6,lambda_data,delta)
%%
pd = s2*lambda_1*exp(lambda_1*t)+s3*lambda_2*exp(lambda_2*t)+s4*(-lambda)*exp(-lambda*t)+s5*(-lambda_1)*exp(-lambda_1*t)+s6*(-lambda_2)*exp(-lambda_2*t);
syms v
intexp = (1+exp(delta_d*v)*(delta_d*v-1))/v;
Ed = s2*subs(intexp,v,lambda_1)+s3*subs(intexp,v,lambda_2)+s4*subs(intexp,v,-lambda)+s5*subs(intexp,v,-lambda_1)+s6*subs(intexp,v,-lambda_2);
Ed = simplify(subs(Ed,[s0,s2,s3,s4,s5,s6],[coeresult.s0,coeresult.s2,coeresult.s3,coeresult.s4,coeresult.s5,coeresult.s6]))