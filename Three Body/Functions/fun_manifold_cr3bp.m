% calculate initial conditions for stable and unstable manifolds of a periodic orbit
function [XS_left, XS_right, XU_left, XU_right, Y] = fun_manifold_cr3bp(mu, x0, t0, N, xpert, options)
% mu      : mass ratio of the primaries
% x0      : initial state of a periodic orbit
% t0      : the period of a periodic orbit
% N       : the number of points on a periodic orbit
% xpert   : weight for a position of the eigenvector
% options : options for ode

  %% calculate eigenvalues of the monodromy matrix
  % Propogate orbit for one period and gather data at N points
  tspan = linspace(0, t0, N);
  X0 = [x0; reshape(eye(6), 36, 1)];
  [~,Y] = ode113(@(t,x) fun_stm_cr3bp(t,x,mu),tspan,X0,options);

  % Monodromy matrix
  M = reshape(Y(end, 7:42), 6, 6);

  % Eigenvector and eigenvalue analysis
  [vec, val] = eig(M);
  val = diag(val);

  [~, index_s] = min(abs(val)); % stable
  [~, index_u] = max(abs(val)); % unstable

  if (imag(val(index_s)) ~= 0) || (imag(val(index_u)) ~= 0)
    error('Imag eigenvalues are dominant');
  end

  % Stable and unstable eigenvectors
  vector_stable = vec(:,index_s);
  if vector_stable(1) < 0
    vector_stable = - vector_stable;
  end
  vector_unstable = vec(:,index_u);
  if vector_unstable(1) < 0
    vector_unstable = - vector_unstable;
  end


  %% calculate manifolds
  XS_left = zeros(6, N); 
  XS_right = zeros(6, N);
  XU_left = zeros(6, N);
  XU_right = zeros(6, N);

  % Apply perturbations to each of N points of a periodic orbit
  for iteration = 1:N
    % Grab state transition matrix at the fixed point
    Phi = reshape(Y(iteration, 7:42), 6, 6);
    
    % Grab state at the fixed point
    x_star = Y(iteration, 1:6)';
    
    % Map stable and unstable vectors forward
    S = Phi*vector_stable;
    S = S/norm(S);
    U = Phi*vector_unstable;
    U = U/norm(U);
    
    % Create perturbation vector
    vpert = xpert*norm(x_star(4:6))/norm(x_star(1:3));
    pert = [ones(3,1).*xpert; ones(3,1).*vpert];
    
    % Perturb conditions
    XS_left(:,iteration)  = x_star - S.*pert;
    XS_right(:,iteration) = x_star + S.*pert;
    
    XU_left(:,iteration)  = x_star - U.*pert;
    XU_right(:,iteration) = x_star + U.*pert;   
  end
end