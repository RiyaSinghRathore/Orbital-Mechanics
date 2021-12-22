function [OE] = TLE2OrbitalElements(TLE)
%% *purpose*
% convert TLE to Orbital Elements
%% *reference*
% https://en.wikipedia.org/wiki/Two-line_element_set
% http://www.castor2.ca/03_Mechanics/03_TLE/index.html
%% *inputs*
%  TLE - the two line element set corresponding to either Skylab itself or
%        the Apollo capsule that will dock with it for a manned mission
%% *outputs*
%  OE - structure with the orbital elements
%% *notes*
% Skylab 1 was the actual station, while Skylabs 2-4 were the
% Apollo capsules carrying the manned missions to it. 
% According to the informal post on celestia, these
% TLEs are from GSFC, and should be correct for the Epoch. 
%% *history*
%  When       Who    What
%  ---------- ------ --------------------------------------------------
%  2019/07/17 mnoah  original code

mu = 398618.0;  % [km3/s2] Mass of the Earth times the constant of gravitation
                %          geocentric gravitational constant
line1 = TLE{2};

% NORAD Catalogue Number is a 5-digit satellite identification 
% number that has been used since the first satellite (Sputnik = 1)
% was launched in 1957.
OE.satelliteID = str2num(line1(3:7));

% [string] classification of the satellite
% U - unclassified
% C - classified
% S - secret
OE.classification = line1(8:8);

% year launched
OE.launch_year = str2num(line1(10:11));
if (OE.launch_year < 50)
    OE.launch_year = OE.launch_year + 2000;
else
    OE.launch_year = OE.launch_year + 1900;
end

% day of year launched
OE.launch_dayOfYear = str2num(line1(12:14));

% piece of the satellite 
% A              = primary payload
% (B, C, D, ...) = secondary payloads in sequence of when first separated
%                  or detected
% There can be many pieces, fragments and debris associated with launch and
% deployment of space assets.
OE.launch_piece = strtrim(line1(15:17));

% the international designator is another catalog way to identiyf a
% satellite
OE.InternationalDesignator = [num2str(OE.launch_year) '-' num2str(OE.launch_dayOfYear) OE.launch_piece];

% The TLE's Epoch indicates the UTC time when its orbit elements were true.
OE.epoch_year = str2double(line1(19:20));     % Epoch year
if (OE.epoch_year < 50)
    OE.epoch_year = OE.epoch_year + 2000;
else
    OE.epoch_year = OE.epoch_year + 1900;
end
OE.epoch_dayOfYear = str2double(line1(21:32));         % Epoch day
OE.epoch = datenum([OE.epoch_year,1,OE.epoch_dayOfYear,0,0,0]);% (datenum) Epoch

% [orbits/day^2] Mean Motion Dot is defined as half of the first time 
% derivative of the Mean Motion.  The value can be negative or positive.
OE.Mdot_orbit_per_day2 = str2double(line1(34:43));

% [orbits/day^3] Mean Motion Double Dot is defined as one sixth the second 
% time derivative of the Mean Motion.  This value is typically zero unless
% the satellite is maneuvering or experiencing orbit decay
OE.Mdoubledot_orbit_per_day3 = str2double([line1(45) '0.' line1(46:50) 'e' line1(51:52)]);

% [1/EarthRadii] The BStar Drag Term is used by orbit propagators  
% to estimate the effects of atmospheric drag on the satellite's motion. 
%    BStar = CD*Rho*A/2*m
% where
%    CD = coeffiecient of drag
%    Rho = atmosphere density
%    A = cross-sectional area of the satellite (wrt orbit)
%    m = satellite mass
OE.BStar_per_Re = str2double([line1(54) '0.' line1(55:59) 'e' line1(60:61)]);

% This field houses an internal Air Force Space Command flag identifying
% the model used to generate the TLE.  It is usually set to 0 for public
% release TLE.
OE.ephemeris_type = str2double(line1(63));

% This field identifies the specific TLE for this satellite, and it
% typically is incremented when new TLE are generated
OE.element_set_number = str2double(line1(65:68));

OE.checksum1 = str2num(line1(69));
str = strrep(line1,'+','0');
str = strrep(str,'-','1');
str = regexprep(str,'[^1-9]','');
num = 0;
for i = 1:length(str)
    num = num + str2num(str(i));
end
expectedChecksum1 = mod(num,10);

% Line 2 of the TLE
line2 = TLE{3};

% [deg] Orbit Inclination (i) is the angle the satellite's orbit 
% plane makes with the Earth's equatorial plane.  Allowed values are
% [0,180].  Between 0 and 90 degrees, the satellite has prograde motion,
% viewd from a point north of the equator; the satellite moves
% counterclockwise around the Earth.  Between 90 and 180 degrees, the
% satellite has retrograde motion; the satellite moves clockwise
% around the Earth.  
OE.i_deg = str2double(line2(9:16));

% [deg] Right Ascension of Ascending Node is the geocentric Right Ascension
% of the satellite as it intersects the Earth's equatorial plane traveling 
% northward (ascending). Allowed values are [0,360].
OE.Omega_deg = str2double(line2(18:25));    

% [unitless] Eccentricity is the ratio of the orbits focus distance to the
% semi-major axis.  For a circle, the ratio is 0.  As the ellipse becomes
% more elliptical, the eccentricity increases.  Allowed values [0,1).
OE.e = str2double(['0.' line2(27:33)]);     

% [deg] Argument of Perigee (omega or w) is the angle that lies in the
% satellite orbit plane from the Ascending Node (Omega or W) to the perigee
% point (p) along the satellite's direction of travel.
OE.omega_deg = str2double(line2(35:42));    

% [deg] Mean Anomaly parameterizes the location of the satellite on its
% orbit at the time of the TLE epoch. Allowed values [0 360].
%        M(t) = M0 + n(t-t0)
% where
%    M(t) - the Mean Anomaly at time t
%    M0   - a reference Mean Anomaly at time t=0
%    n    - the satellites Mean Motion (orbits/day)
%    t    - time
%    t0   - time of the reference Mean Anomaly
OE.M_deg = str2double(line2(44:51));        

% [km] semi major axis
OE.a_km = ( mu/(str2double(line2(53:63))*2*pi/86400)^2 )^(1/3);  

% [orbits/day] Mean Motion is the number of times the satellite orbits the
% Earth in exactly 24 hours (one solar day).  The theoretical limits are
% between 0 and 17 orbits per day.
%        a = G*Me/(2*pi*n)^2
% where
%        n  - Mean Motion
%        a  - semi-major axis
%        G  - universal gravitational constant
%        Me - mass of the Earth
OE.n_orbits_per_day = line2(53:63);         

% [orbits] Orbit Number at Epoch is the number of orbits completed from the
% launch to the epoch of the TLE
OE.orbit_number_at_epoch = str2double(line2(64:68));  

OE.checksum2 = line2(69);
str = strrep(line2,'+','0');
str = strrep(str,'-','1');
str = regexprep(str,'[^1-9]','');
num = 0;
for i = 1:length(str)
    num = num + str2num(str(i));
end
expectedChecksum2 = mod(num,10);

end
