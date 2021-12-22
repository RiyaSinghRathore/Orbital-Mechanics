function dx = fun_stm_cr3bp(t,x,mu)
% t  : non-dimensional time
% x  : non-dimensional position and velocity, x = [x y z vx vy vz]'
% mu : mass ratio of the primaries

	%% equations of motion
	r1 = sqrt((mu+x(1))^2+(x(2))^2+(x(3))^2);
	r2 = sqrt((1-mu-x(1))^2+(x(2))^2+(x(3))^2);
	dx(1:6,1) = [x(4);
							 x(5);
	 						 x(6);
							 2*x(5) + x(1) - (1-mu)*(x(1)+mu)/r1^3 - mu*(x(1)-1+mu)/r2^3; 
							-2*x(4) + x(2) -      (1-mu)*x(2)/r1^3 -       mu*x(2)/r2^3;
										         -      (1-mu)*x(3)/r1^3 -       mu*x(3)/r2^3];                                                             
	                                                             
	%% stm
	A = fun_A_cr3bp(x(1:6),mu);
	phi = reshape(x(7:end),6,6);
	dphi = A*phi;
	dx(7:42,1) = dphi(:);
end 