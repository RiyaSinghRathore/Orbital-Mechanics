function A = fun_A_cr3bp(X, mu)
% X  : non-dimensional position and velocity, X = [x y z vx vy vz]'
% mu : mass ratio of the primaries

  %% Generate A Matrix
  r1 = sqrt((mu+X(1))^2+(X(2))^2+(X(3))^2);
  r2 = sqrt((1-mu-X(1))^2+(X(2))^2+(X(3))^2);

  Uxx       = 1 - (1-mu)/r1^3 - mu/r2^3 + 3*(1-mu)*(X(1)+mu)^2/r1^5 + 3*mu*(X(1)-1+mu)^2/r2^5;
  Uyy       = 1 - (1-mu)/r1^3 - mu/r2^3 + 3*(1-mu)*X(2)^2/r1^5 + 3*mu*X(2)^2/r2^5;
  Uzz       =   - (1-mu)/r1^3 - mu/r2^3 + 3*(1-mu)*X(3)^2/r1^5 + 3*mu*X(3)^2/r2^5;
  Uxy       = 3*(1-mu)*(X(1)+mu)*X(2)/r1^5 + 3*mu*(X(1)-1+mu)*X(2)/r2^5;
  Uxz       = 3*(1-mu)*(X(1)+mu)*X(3)/r1^5 + 3*mu*(X(1)-1+mu)*X(3)/r2^5;
  Uyz       = 3*(1-mu)*X(2)*X(3)/r1^5 + 3*mu*X(2)*X(3)/r2^5;
  B         = [Uxx,Uxy,Uxz;
               Uxy,Uyy,Uyz;
               Uxz,Uyz,Uzz];

  C         = [0 2 0; -2 0 0; 0 0 0];

  A         = [zeros(3), eye(3); B, C];
end 