% stable and unstable manifolds of a periodic orbit in Sun-Earth CR3BP

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
x0 = [0.9889 0 0 0 0.008375 0]';
t0 = 2;

if x0(3) == 0
	Lyapunov = true;
else
	Lyapunov = false;
end


%% differential correction
% initial guess
tspan1 = [0 2*t0];
[t_initial, x_initial] = ode113(@(t,x) fun_cr3bp(t,x,mu), tspan1, x0, options_ODE);

% correction
for iteration = 1:iteration_max
	[x_n,t_n,C_xn] = fun_differential_correction_cr3bp(x0,t0,mu,options_ODE);

	tspan = [0 2*t_n];
	[t_corrected, x_corrected] = ode113(@(t,x) fun_cr3bp(t,x,mu), tspan, x_n, options_ODE);

	x_error = norm(x_corrected(end,:) - x_corrected(1,:));
	%disp( strcat('x_error = ',num2str(x_error)) );
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


%% zero velocity curve
[x_curve,y_curve] = meshgrid(0.9:1e-4:1.1,-0.1:1e-4:0.1);
[a,b] = size(x_curve);
z_curve = zeros(a,b);

x_curve = reshape(x_curve, [a*b,1]);
y_curve = reshape(y_curve, [a*b,1]);
z_curve = reshape(z_curve, [a*b,1]);

r1 = sqrt((x_curve+mu).^2+y_curve.^2+z_curve.^2);
r2 = sqrt((x_curve-(1-mu)).^2+y_curve.^2+z_curve.^2);
U = 1/2.*(x_curve.^2+y_curve.^2) + (1-mu)./r1 + mu./r2;
C = 2.*U;

x_curve = reshape(x_curve, [a,b]);
y_curve = reshape(y_curve, [a,b]);
C = reshape(C, [a,b]);


%% stable and unstable manifolds
xpert = 1e-6;
N = 40;
[XS_left, XS_right, XU_left, XU_right, Y] = fun_manifold_cr3bp(mu, x_n, 2*t_n, N, xpert, options_ODE);

tf = 4.8;
tspan_s = [tf 0];
tspan_u = [0 tf];

f1 = figure;
hold on
contourf(x_curve, y_curve, -C, [-C_xn -C_xn],'k');
colormap gray
plot3(x_corrected(:,1), x_corrected(:,2),x_corrected(:,3),'y');
for i = 1:N
	[~,ys_left] = ode113(@(t,x) fun_cr3bp(t,x,mu), tspan_s, XS_left(:,i), options_ODE);
	ys_left = flipud(ys_left);
	[~,ys_right] = ode113(@(t,x) fun_cr3bp(t,x,mu), tspan_s, XS_right(:,i), options_ODE);
	ys_right = flipud(ys_right);
	[~,yu_left] = ode113(@(t,x) fun_cr3bp(t,x,mu), tspan_u, XU_left(:,i), options_ODE);
	[~,yu_right] = ode113(@(t,x) fun_cr3bp(t,x,mu), tspan_u, XU_right(:,i), options_ODE);

	f1_p1 = plot3(ys_left(:,1),ys_left(:,2),ys_left(:,3),'m');
	f1_p2 = plot3(ys_right(:,1),ys_right(:,2),ys_right(:,3),'r');
	f1_p3 = plot3(yu_left(:,1),yu_left(:,2),yu_left(:,3),'c');
	f1_p4 = plot3(yu_right(:,1),yu_right(:,2),yu_right(:,3),'b');
end
plot3(L1(1),L1(2),L1(3),'*','MarkerFaceColor','k','MarkerEdgeColor','k','MarkerSize',10);
if Lyapunov == true
  view_angle = [0 90];
else
  view_angle = [40 30];
end
view(gca,view_angle(1),view_angle(2));
axis image
xlim([0.96 1.02]);
ylim([-0.02 0.02]);
xlabel('$x$[-]');
ylabel('$y$[-]');
zlabel('$z$[-]');
grid on
legend([f1_p1, f1_p2, f1_p3, f1_p4], {'left half of stable manifold','right half of stable manifold','left half of unstable manifold','right half of unstable manifold'});
hold off



%% End of script
