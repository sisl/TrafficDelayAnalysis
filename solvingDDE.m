% This function solves the delay differential equation (DDE) in (36)
% from "Analyzing Traffic Delay at Unmanaged Intersections".
% We solve it for n pieces.
% Note the computation can take a very long time.
%
% Inputs:
%   n: number of pieces in the DDE.
%   lambda: the traffic flow density. 
%   delta_d: the temporal gap
%
% Changliu Liu
% 2018.4


n = 5;
lambda = [0.4,0.4];
delta_d = 2;
%% Construct the n pieces of symbolic solutions of the DDE
Glist = cell(2,n);
syms g1 g2 %delta_d lambda1 lambda2
G2_so = @(t) g2*exp(lambda(1)*t);
G1_so = @(t) g1*exp(lambda(2)*t);
for i = 1:n
    syms G1(t) G2(t)
    eqn1 = diff(G1,t) == lambda(2)*G1 - lambda(1)*G2_so(t-delta_d);
    cond1 = G1(delta_d*i) == G1_so(delta_d*i);
    G1_new(t) = dsolve(eqn1,cond1);
    eqn2 = diff(G2,t) == lambda(1)*G2 - lambda(2)*G1_so(t-delta_d);
    cond2 = G2(delta_d*i) == G2_so(delta_d*i);
    G2_new(t) = dsolve(eqn2,cond2);
    Glist{1,i} = G1_so(delta_d*i);
    Glist{2,i} = G2_so(delta_d*i);
    G1_so = G1_new;
    G2_so = G2_new;
end

%% Enforcing the boundary constraint
eqns = [Glist{1,n} == lambda(1)/sum(lambda), Glist{2,n} == lambda(2)/sum(lambda)];
soln = solve(eqns, g1, g2);
double(soln.g1)
double(soln.g2)

%% Ploting the solution
Gval = zeros(2,n);
for i = 1:n
    Gval(1,i) = subs(Glist{1,i},{g1,g2},{soln.g1,soln.g2});
    Gval(2,i) = subs(Glist{2,i},{g1,g2},{soln.g1,soln.g2});
end
figure;hold on;
plot(delta_d:delta_d:delta_d*(n),Gval(1,:),'*')
plot(delta_d:delta_d:delta_d*(n),Gval(2,:),'o')
axis([0,40,0,1])
