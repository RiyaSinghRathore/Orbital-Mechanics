% stable and unstable of Li 

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




%% main
[mu,~,~,~] = parameter(2); % Earth-Moon
[L1,L2,L3,L4,L5] = librationPoints(mu);

options_ODE = odeset('RelTol',1e-14, 'AbsTol',1e-14);

% zero velocity curve
[xc,yc] = meshgrid(-1.5:1e-3:1.5);
[a,b] = size(xc);
zc = zeros(a,b);

xc = reshape(xc, [a*b,1]);
yc = reshape(yc, [a*b,1]);
zc = reshape(zc, [a*b,1]);

r1 = sqrt((xc+mu).^2+yc.^2+zc.^2);
r2 = sqrt((xc-(1-mu)).^2+yc.^2+zc.^2);
U = 1/2.*(xc.^2+yc.^2) + (1-mu)./r1 + mu./r2;
C = 2.*U;

xc = reshape(xc, [a,b]);
yc = reshape(yc, [a,b]);
C = reshape(C, [a,b]);


% L1
tf1 = 15;
C1 = Jacobi_const([L1;zeros(3,1)],mu);

sigma = (1-mu)/(abs(L1(1)+mu)^3) + mu/(abs(L1(1)-1+mu)^3);
A = [        0       0      0  1 0 0;
             0       0      0  0 1 0;
             0       0      0  0 0 1;
     2*sigma+1       0      0  0 2 0;
             0 1-sigma      0 -2 0 0;
             0       0 -sigma  0 0 0];
[V,D] = eig(A);
for i = 1:6
	if imag(D(i,i)) ~= 0
		continue;
	end

	if D(i,i) < 0
		Vs = V(:,i);
	end

	if D(i,i) > 0
		Vu = V(:,i);
	end
end

tspan_s = [tf1 0];
x0_sp = [L1;zeros(3,1)] + 1e-10.*Vs/norm(Vs);
[~, xsp_L1] = ode113(@(t,x) fun_cr3bp(t,x,mu), tspan_s, x0_sp, options_ODE);
xsp_L1 = flipud(xsp_L1);

x0_sm = [L1;zeros(3,1)] - 1e-10.*Vs/norm(Vs);
[~, xsm_L1] = ode113(@(t,x) fun_cr3bp(t,x,mu), tspan_s, x0_sm, options_ODE);
xsm_L1 = flipud(xsm_L1);

tspan_u = [0 tf1];
x0_up = [L1;zeros(3,1)] + 1e-10.*Vu/norm(Vu);
[~, xup_L1] = ode113(@(t,x) fun_cr3bp(t,x,mu), tspan_u, x0_up, options_ODE);

x0_um = [L1;zeros(3,1)] - 1e-10.*Vu/norm(Vu);
[~, xum_L1] = ode113(@(t,x) fun_cr3bp(t,x,mu), tspan_u, x0_um, options_ODE);

f1 = figure;
hold on;
contour(xc, yc, C, [C1 C1],'k','LineWidth',1);
plot(-mu,0,'o','MarkerFaceColor','k','MarkerEdgeColor','k','MarkerSize',10);
plot(1-mu,0,'o','MarkerFaceColor','k','MarkerEdgeColor','k','MarkerSize',10);
stable1 = plot(xsp_L1(:,1), xsp_L1(:,2), 'r');
plot(xsm_L1(:,1), xsm_L1(:,2), 'r');
unstable1 = plot(xup_L1(:,1), xup_L1(:,2), 'b');
plot(xum_L1(:,1), xum_L1(:,2), 'b');
plot(L1(1),L1(2),'*','MarkerFaceColor','#D95319','MarkerEdgeColor','#D95319','MarkerSize',10);
plot(L2(1),L2(2),'*','MarkerFaceColor','k','MarkerEdgeColor','k','MarkerSize',10);
plot(L3(1),L3(2),'*','MarkerFaceColor','k','MarkerEdgeColor','k','MarkerSize',10);
plot(L4(1),L4(2),'*','MarkerFaceColor','k','MarkerEdgeColor','k','MarkerSize',10);
plot(L5(1),L5(2),'*','MarkerFaceColor','k','MarkerEdgeColor','k','MarkerSize',10);
axis equal
xlabel('$x$[-]');
ylabel('$y$[-]');
grid on;
legend([stable1, unstable1], {'Stable manifold', 'Unstable manifold'});
hold off;


% L2
tf2 = 25;
C2 = Jacobi_const([L2;zeros(3,1)],mu);

sigma = (1-mu)/(abs(L2(1)+mu)^3) + mu/(abs(L2(1)-1+mu)^3);
A = [        0       0      0  1 0 0;
             0       0      0  0 1 0;
             0       0      0  0 0 1;
     2*sigma+1       0      0  0 2 0;
             0 1-sigma      0 -2 0 0;
             0       0 -sigma  0 0 0];
[V,D] = eig(A);
for i = 1:6
	if imag(D(i,i)) ~= 0
		continue;
	end

	if D(i,i) < 0
		Vs = V(:,i);
	end

	if D(i,i) > 0
		Vu = V(:,i);
	end
end

tspan_s = [tf2 0];
x0_sp = [L2;zeros(3,1)] + 1e-10.*Vs/norm(Vs);
[~, xsp_L2] = ode113(@(t,x) fun_cr3bp(t,x,mu), tspan_s, x0_sp, options_ODE);
xsp_L2 = flipud(xsp_L2);

x0_sm = [L2;zeros(3,1)] - 1e-10.*Vs/norm(Vs);
[~, xsm_L2] = ode113(@(t,x) fun_cr3bp(t,x,mu), tspan_s, x0_sm, options_ODE);
xsm_L2 = flipud(xsm_L2);

tspan_u = [0 tf2];
x0_up = [L2;zeros(3,1)] + 1e-10.*Vu/norm(Vu);
[~, xup_L2] = ode113(@(t,x) fun_cr3bp(t,x,mu), tspan_u, x0_up, options_ODE);

x0_um = [L2;zeros(3,1)] - 1e-10.*Vu/norm(Vu);
[~, xum_L2] = ode113(@(t,x) fun_cr3bp(t,x,mu), tspan_u, x0_um, options_ODE);

f2 = figure;
hold on;
contour(xc, yc, C, [C2 C2],'k','LineWidth',1);
plot(-mu,0,'o','MarkerFaceColor','k','MarkerEdgeColor','k','MarkerSize',10);
plot(1-mu,0,'o','MarkerFaceColor','k','MarkerEdgeColor','k','MarkerSize',10);
stable2 = plot(xsp_L2(:,1), xsp_L2(:,2), 'r');
plot(xsm_L2(:,1), xsm_L2(:,2), 'r');
unstable2 = plot(xup_L2(:,1), xup_L2(:,2), 'b');
plot(xum_L2(:,1), xum_L2(:,2), 'b');
plot(L2(1),L2(2),'*','MarkerFaceColor','#D95319','MarkerEdgeColor','#D95319','MarkerSize',10);
plot(L1(1),L1(2),'*','MarkerFaceColor','k','MarkerEdgeColor','k','MarkerSize',10);
plot(L3(1),L3(2),'*','MarkerFaceColor','k','MarkerEdgeColor','k','MarkerSize',10);
plot(L4(1),L4(2),'*','MarkerFaceColor','k','MarkerEdgeColor','k','MarkerSize',10);
plot(L5(1),L5(2),'*','MarkerFaceColor','k','MarkerEdgeColor','k','MarkerSize',10);
axis equal
xlabel('$x$[-]');
ylabel('$y$[-]');
grid on;
xlim([-2.5 2.5]);
ylim([-2.5 2.5]);
legend([stable2, unstable2], {'Stable manifold', 'Unstable manifold'});
hold off;

% L3
tf3 = 145;
C3 = Jacobi_const([L3;zeros(3,1)],mu);

sigma = (1-mu)/(abs(L3(1)+mu)^3) + mu/(abs(L3(1)-1+mu)^3);
A = [        0       0      0  1 0 0;
             0       0      0  0 1 0;
             0       0      0  0 0 1;
     2*sigma+1       0      0  0 2 0;
             0 1-sigma      0 -2 0 0;
             0       0 -sigma  0 0 0];
[V,D] = eig(A);
for i = 1:6
	if imag(D(i,i)) ~= 0
		continue;
	end

	if D(i,i) < 0
		Vs = V(:,i);
	end

	if D(i,i) > 0
		Vu = V(:,i);
	end
end

tspan_s = [tf3 0];
x0_sp = [L3;zeros(3,1)] + 1e-10.*Vs/norm(Vs);
[~, xsp_L3] = ode113(@(t,x) fun_cr3bp(t,x,mu), tspan_s, x0_sp, options_ODE);
xsp_L3 = flipud(xsp_L3);

x0_sm = [L3;zeros(3,1)] - 1e-10.*Vs/norm(Vs);
[~, xsm_L3] = ode113(@(t,x) fun_cr3bp(t,x,mu), tspan_s, x0_sm, options_ODE);
xsm_L3 = flipud(xsm_L3);

tspan_u = [0 tf3];
x0_up = [L3;zeros(3,1)] + 1e-10.*Vu/norm(Vu);
[~, xup_L3] = ode113(@(t,x) fun_cr3bp(t,x,mu), tspan_u, x0_up, options_ODE);

x0_um = [L3;zeros(3,1)] - 1e-10.*Vu/norm(Vu);
[~, xum_L3] = ode113(@(t,x) fun_cr3bp(t,x,mu), tspan_u, x0_um, options_ODE);

f3 = figure;
hold on;
contour(xc, yc, C, [C3 C3],'k','LineWidth',1);
plot(-mu,0,'o','MarkerFaceColor','k','MarkerEdgeColor','k','MarkerSize',10);
plot(1-mu,0,'o','MarkerFaceColor','k','MarkerEdgeColor','k','MarkerSize',10);
stable3 = plot(xsp_L3(:,1), xsp_L3(:,2), 'r');
plot(xsm_L3(:,1), xsm_L3(:,2), 'r');
unstable3 = plot(xup_L3(:,1), xup_L3(:,2), 'b');
plot(xum_L3(:,1), xum_L3(:,2), 'b');
plot(L3(1),L3(2),'*','MarkerFaceColor','#D95319','MarkerEdgeColor','#D95319','MarkerSize',10);
plot(L1(1),L1(2),'*','MarkerFaceColor','k','MarkerEdgeColor','k','MarkerSize',10);
plot(L2(1),L2(2),'*','MarkerFaceColor','k','MarkerEdgeColor','k','MarkerSize',10);
plot(L4(1),L4(2),'*','MarkerFaceColor','k','MarkerEdgeColor','k','MarkerSize',10);
plot(L5(1),L5(2),'*','MarkerFaceColor','k','MarkerEdgeColor','k','MarkerSize',10);
axis equal
xlabel('$x$[-]');
ylabel('$y$[-]');
grid on;
legend([stable3, unstable3], {'Stable manifold', 'Unstable manifold'});
hold off;


%% End of script