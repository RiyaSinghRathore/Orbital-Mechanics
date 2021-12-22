% differential correction for Lyapunov and halo orbits in Sun-Earth CR3BP

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



%% initial settings
[mu,~,~,~] = parameter(1); % Sun-Earth
[L1,L2,L3,L4,L5] = librationPoints(mu);

options_ODE = odeset('RelTol',3e-14, 'AbsTol',1e-14);

iteration_max = 100;
threshold = 1e-12;

% for Lyapunov orbit
%x0 = [0.9889 0 0 0 0.008375 0]';
%t0 = 2;

% for halo orbit
x0 = [0.9919 0 0.002223 0 -0.01014 0]';
t0 = pi/2;

if x0(3) == 0
	Lyapunov = true;
else
	Lyapunov = false;
end


%% differential correction
% initial guess
tspan = [0 2*t0];
[t_initial, x_initial] = ode113(@(t,x) fun_cr3bp(t,x,mu), tspan, x0, options_ODE);

f1 = figure;
hold on
f1_pL = plot3(L1(1),L1(2),L1(3),'*','MarkerFaceColor','k','MarkerEdgeColor','k','MarkerSize',10);
f1_p1 = plot3(x_initial(:,1), x_initial(:,2),x_initial(:,3),'r');
plot3(x_initial(1,1), x_initial(1,2),x_initial(1,3),'o','MarkerFaceColor','r','MarkerEdgeColor','r','MarkerSize',4);
hold off

% correction
for iteration = 1:iteration_max
	[x_n,t_n,~] = fun_differential_correction_cr3bp(x0,t0,mu,options_ODE);

	tspan = [0 2*t_n];
	[t_corrected, x_corrected] = ode113(@(t,x) fun_cr3bp(t,x,mu), tspan, x_n, options_ODE);

	x_error = norm(x_corrected(end,:) - x_corrected(1,:));
	disp( strcat('x_error = ',num2str(x_error)) );
	if x_error < threshold
		break;
	end

	if x_error > 1e+3
		disp('calculation diverged');
		return;
	end

  if iteration == iteration_max
    disp('do not finish');
    return;
  end

  x0 = x_n;
  t0 = t_n;
end


figure(f1);
hold on
f1_p2 = plot3(x_corrected(:,1), x_corrected(:,2),x_corrected(:,3),'b');
plot3(x_corrected(1,1), x_corrected(1,2),x_corrected(1,3),'o','MarkerFaceColor','b','MarkerEdgeColor','b','MarkerSize',4);
if Lyapunov == true
  view_angle = [0 90];
else
  view_angle = [40 30];
end
view(gca,view_angle(1),view_angle(2));
axis image
xlabel('$x$[-]');
ylabel('$y$[-]');
zlabel('$z$[-]');
grid on
legend([f1_pL, f1_p1, f1_p2], {'$L_1$', 'initial', 'corrected'});
hold off


%% monodromy matrix
X0 = [x_n',reshape(eye(6),1,[])];
tspan = [0,2*t_n];
[~,Y] = ode113(@(t,x) fun_stm_cr3bp(t,x,mu),tspan,X0,options_ODE);
  
monodromy = reshape(Y(end,7:end),6,6);
[V,D] = eig(monodromy);
disp(diag(D));

theta = linspace(0, 2*pi, 1001)';
x_circle = cos(theta);
y_circle = sin(theta);

f2 = figure;
hold on
plot(x_circle,y_circle,'k');
f2_p1 = plot(diag(D),'o','MarkerFaceColor','none','MarkerEdgeColor','b','MarkerSize',10);
axis equal
xlabel('real part');
ylabel('imaginary part');
grid on
legend([f2_p1], {'eigenvalue'});
hold off

figure(f2);
hold on
xlim([-1.5 1.5]);
ylim([-1.5 1.5]);
hold off


%% End of script