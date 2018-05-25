% This function evaluates a symbolic representation

function xval = evaluate(x,lambda_data,delta)
syms lambda_1 lambda_2 lambda y1 y2 y delta_d a
aa = getRoot(lambda_data,delta);
xval = double(subs(x,[lambda,lambda_1,lambda_2,y,y1,y2,delta_d,a],[sum(lambda_data),lambda_data(1),lambda_data(2),exp(-delta*sum(lambda_data)),exp(-delta*lambda_data(1)),exp(-delta*lambda_data(2)),delta,aa]));
end