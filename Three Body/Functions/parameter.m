function [mu, a_1, a_s, w_1] = parameter(y)
switchplanets = y; % 1:Earth, 2:Moon, 3:Mars, 4:Phobos, 5:Deimos


% selection of axis
switch switchplanets
	case 1
		% Sun-Earth
		mu = 3.00245E-06; % mass ratio
		a_1= 1.49598E+08; % primary-secondary distance[km]
		a_s= 4.25874E-05; % secondary radius[nonD]
		w_1= 1.99097E-07; % ang vel[rad/s]

	case 2
		% Earth-Moon
		mu = 1.21536E-02; % mass ratio
		a_1= 3.84400E+05; % primary-secondary distance[km]
		a_s= 4.52003E-03; % secondary radius[nonD]
		w_1= 2.66167E-06; % ang vel[rad/s] 

	case 3
		% Sun-Mars
		mu = 3.22605E-07; % mass ratio
		a_1= 2.27943824E+08; % primary-secondary distance[km]
		a_s= 1.48699E-05; % secondary radius[nonD]
		w_1= 1.0585760E-07; % ang vel[rad/s]

	case 4
		% Mars-Phobos
		mu = 1.66100E-08; % mass ratio
		a_1= 9.37600E+03; % primary-secondary distance[km]
		a_s= 1.18387E-03; % secondary radius[nonD]
		w_1= 2.28040E-04; % ang vel[rad/s]

	case 5
		% Mars-Deimos
		mu = 2.30046E-09; % mass ratio
		a_1= 2.34580E+04; % primary-secondary distance[km]
		a_s= 2.34580E+04; % secondary radius[nonD]
		w_1= 2.34580E+04; % ang vel[rad/s]

	case 6
		% Sun-Jupitar
		mu = 9.5479E-04; % mass ratio
		a_1= 7.7841E+08; % primary-secondary distance[km]
		a_s= 9.1844E-04; % secondary radius[nonD]
		w_1= 1.6800E-08; % ang vel[rad/s]
end