function dx = fun_cr3bp_IF(t,x,mu)
% t  : non-dimensional time
% x  : non-dimensional position and velocity, x = [x y z vx vy vz]'
% mu : mass ratio of the primaries

% Primaly body position
          r1        = [x(1)+mu*cos(t);x(2)+mu*sin(t);x(3)];
          r2        = [x(1)-(1-mu)*cos(t);x(2)-(1-mu)*sin(t);x(3)];
          R1        = norm(r1);
          R2        = norm(r2);

%           Ux        = -(1-mu)*(x(1)+mu*cos(t))/R1^3 - mu*(x(1)-(1-mu)*cos(t))/R2^3;
%           Uy        = -(1-mu)*(x(2)+mu*sin(t))/R1^3 - mu*(x(2)-(1-mu)*sin(t))/R2^3;
%           Uz        = -(1-mu)*x(3)/R1^3             - mu*x(3)/R2^3;

          Ux        = -(1-mu)*r1(1)/R1^3 - mu*r2(1)/R2^3;
          Uy        = -(1-mu)*r1(2)/R1^3 - mu*r2(2)/R2^3;
          Uz        = -(1-mu)*r1(3)/R1^3 - mu*r2(3)/R2^3;
          dx        = [x(4);x(5);x(6);Ux;Uy;Uz];

%%
% % Primaly body position
%     x1        = (-mu)*cos(t);
%     y1        = (-mu)*sin(t); 
%     z1        = 0; 
% 
% 
% % Secondary body position
%     x2        = (1-mu)*cos(t);
%     y2        = (1-mu)*sin(t); 
%     z2        = 0; 
%     
% % S/C state vector    
%     x3        = x(1);
%     y3        = x(2);
%     z3        = x(3);
%     vx3       = x(4);
%     vy3       = x(5);
%     vz3       = x(6);
%     
%     
%     
%     
%     r13       = norm([x3 - x1, y3 - y1, z3 - z1])^3;
%     r23       = norm([x3 - x2, y3 - y2, z3 - z2])^3;
% 
%     ax3       = -(1-mu)*(x3 - x1)./r13 - mu*(x3 - x2)./r23;
%     ay3       = -(1-mu)*(y3 - y1)./r13 - mu*(y3 - y2)./r23;
%     az3       = -(1-mu)*(z3 - z1)./r13 - mu*(z3 - z2)./r23;
% 
% 
%     dx        = [vx3;vy3;vz3;ax3;ay3;az3];

end