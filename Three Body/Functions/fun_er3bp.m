function  dx = fun_er3bp(t,x,mu,e)
% t  : non-dimensional true anomaly
% x  : non-dimensional position and velocity, x = [x y z vx vy vz]'
% mu : mass ratio of the primaries
% e  : eccentricity

%the distances
  r1    = ((mu+x(1))^2+(x(2))^2+(x(3))^2)^0.5;
  r2    = ((1-mu-x(1))^2+(x(2))^2+(x(3))^2)^0.5;

 dUdx   = x(1) - (1-mu)*(x(1)+mu)/r1^3 - mu*(x(1)-1+mu)/r2^3;
 dUdy   = x(2) -      (1-mu)*x(2)/r1^3 -       mu*x(2)/r2^3;
 dUdz   = x(3) -      (1-mu)*x(3)/r1^3 -       mu*x(3)/r2^3; 

  dx    = [x(4);
           x(5);
           x(6);
          2*x(5) + dUdx/(1+e*cos(t)); 
         -2*x(4) + dUdy/(1+e*cos(t));
          - x(3) + dUdz/(1+e*cos(t))];
end