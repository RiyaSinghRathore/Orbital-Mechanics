% differential correction for Lyapunov and halo orbits in CR3BP
function [x_n,t_n,C]     = fun_differential_correction_cr3bp(x0,t0,mu,options)
% x0      : initial guess of x
% t0      : initial guess of period
% mu      : mass ratio of the primaries
% options : options for ode

  X0 = [x0(1),x0(2),x0(3),x0(4),x0(5),x0(6),reshape(eye(6),1,[])];
  tspan = [0,t0];
  [~,Y] = ode113(@(t,x) fun_stm_cr3bp(t,x,mu),tspan,X0,options);

  X = Y(end,1:6);   
  Phi = reshape(Y(end,7:end),6,6);
  f_x = fun_cr3bp([],X,mu);
  DF = [Phi(2,3), Phi(2,5), f_x(2);
        Phi(4,3), Phi(4,5), f_x(4);
        Phi(6,3), Phi(6,5), f_x(6)];
  x_ast = [X0(3); X0(5); t0]-DF\[X(end,2); X(end,4); X(end,6)];

  x_n = [x0(1);0;x_ast(1);0;x_ast(2);0];
  t_n = x_ast(3);
  C = Jacobi_const(x_n,mu);       
end











