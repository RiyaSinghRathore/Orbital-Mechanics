% calculate trajectories 

%% Start of script
close all;  %close all figures
clear;      %clear all variables
clc;        %clear the command terminal
format long
%warning off

% line width 
set(0,'DefaultLineLineWidth',1.5) % default 0.5pt
set(0,'DefaultAxesLineWidth',1.5)
set(0,'DefaultTextLineWidth',1.5)

% font size
set(0,'DefaultTextFontSize',20)
set(0,'DefaultAxesFontSize',20)

% font name
set(0,'DefaultTextFontName','Times New Roman')
set(0,'DefaultAxesFontName','Times New Roman')
set(0,'DefaultTextInterpreter','Latex')
set(0,'DefaultLegendInterpreter','Latex')

% figure color
set(0,'DefaultFigureWindowStyle','docked');
set(gcf,'Color','none');
set(gca,'Color','none');
set(gcf,'InvertHardCopy', 'off');

close

current_pass = pwd;
addpath(strcat(current_pass, '/Functions'));

%% initial conditions
Ms = 1.9885e+30; %[kg], mass of Sun, from https://nssdc.gsfc.nasa.gov/planetary/factsheet/sunfact.html
M1 = 5.9724e+24; %[kg], mass of Earth, from https://nssdc.gsfc.nasa.gov/planetary/factsheet/
M2 = 7.346e+22; %[kg], mass of Moon, from https://nssdc.gsfc.nasa.gov/planetary/factsheet/
G = 6.673e-11; %[m^3/(kg*s^2)], gravitational constant

% Earth-Moon CR3BP
chara_length_CR3BP = 3.8440e+8; %[m]
chara_mass_CR3BP = M1 + M2; %[kg]
chara_time_CR3BP = sqrt( chara_length_CR3BP^3 / (G * chara_mass_CR3BP) ); % == period / (2*pi)
mu_EM = M2 / (M1 + M2);
N_CR3BP = sqrt( G*chara_mass_CR3BP / chara_length_CR3BP^3 );

% Earth-Moon ER3BP
a = 3.8440e+8; %[m], semimajor axis, from https://nssdc.gsfc.nasa.gov/planetary/factsheet/
N_ER3BP = sqrt( G*(M1+M2)/(a^3) ); %[1/s], mean motion
e = 0.0549; % eccentricity, from https://nssdc.gsfc.nasa.gov/planetary/factsheet/


% calculations
options_ODE = odeset('RelTol',1e-14, 'AbsTol',1e-14);


%% L2 Lyapunov orbit in Earth-Moon CR3BP
t_CR3BP = 3.467622949281189;
x0_CR3BP = [   1.102866098413080
                   0
                   0
                   0
                0.259155907029058
                   0];
tspan1 = [0 t_CR3BP];
[~, x_CR3BP] = ode113(@(t,x) fun_cr3bp(t,x,mu_EM), tspan1, x0_CR3BP, options_ODE);

f1 = figure;
hold on
p_moon = plot(1-mu_EM, 0, 'o', 'MarkerFaceColor', '#EDB120', 'MarkerEdgeColor', '#EDB120', 'MarkerSize', 20);
plot(x_CR3BP(1,1), x_CR3BP(1,2),'o', 'MarkerFaceColor', '#0072BD', 'MarkerEdgeColor', '#0072BD', 'MarkerSize', 4);
plot(x_CR3BP(:,1), x_CR3BP(:,2), 'Color', '#0072BD');
axis equal
xlabel('$x$[-]');
ylabel('$y$[-]');
legend([p_moon], {'Moon'});
hold off



%% trajectory in Earth-Moon ER3BP
t_ER3BP = t_CR3BP * chara_time_CR3BP * N_ER3BP;

% transfomation from CR3BP reference frame to the inertial frame
X0_CR3BP = [x0_CR3BP(1:3).*chara_length_CR3BP; x0_CR3BP(4:6).*chara_length_CR3BP./chara_time_CR3BP];
C_CR3BP = [cos(0) -sin(0) 0;
           sin(0)  cos(0) 0;
                0       0 1];
dtheta_dt_CR3BP = N_CR3BP;
rotating_matrix_CR3BP = fun_rotating_to_inertial_matrix(C_CR3BP, dtheta_dt_CR3BP);
X0_inertial = rotating_matrix_CR3BP * X0_CR3BP;

% transformation from the inertial frame to ER3BP reference frame
C_ER3BP = [cos(0) -sin(0) 0;
           sin(0)  cos(0) 0;
                0       0 1];
dtheta_dt_ER3BP = sqrt( G*(M1+M2) * (1+e*cos(0))^4 / (a*(1-e^2))^3 );
rotating_matrix_ER3BP = fun_rotating_to_inertial_matrix(C_ER3BP, dtheta_dt_ER3BP);
X0_ER3BP = rotating_matrix_ER3BP \ X0_inertial;
x0_ER3BP = [X0_ER3BP(1:3)./(a*(1-e)); X0_ER3BP(4:6)./(a*(1-e))./N_ER3BP];

tspan2 = [0 t_ER3BP];
[~, x_ER3BP] = ode113(@(t,x) fun_er3bp(t,x,mu_EM,e), tspan2, x0_ER3BP, options_ODE);

f2 = figure;
hold on
p_moon = plot(1-mu_EM, 0, 'o', 'MarkerFaceColor', '#EDB120', 'MarkerEdgeColor', '#EDB120', 'MarkerSize', 20);
plot(x_ER3BP(1,1), x_ER3BP(1,2),'o', 'MarkerFaceColor', '#0072BD', 'MarkerEdgeColor', '#0072BD', 'MarkerSize', 4);
plot(x_ER3BP(:,1), x_ER3BP(:,2), 'Color', '#0072BD');
axis equal
xlabel('$x$[-]');
ylabel('$y$[-]');
legend([p_moon], {'Moon'});
hold off


%% End of script
