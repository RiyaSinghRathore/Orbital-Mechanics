% Zero velocity curve in CR3BP 

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


%% zero velocity curve
[mu,~,~,~] = parameter(2); % Earth-Moon
[L1,L2,L3,L4,L5] = librationPoints(mu);

% co-rotating flame (x,y,z)
[x,y] = meshgrid(-1.5:1e-3:1.5);
[a,b] = size(x);
z = zeros(a,b);

x = reshape(x, [a*b,1]);
y = reshape(y, [a*b,1]);
z = reshape(z, [a*b,1]);

r1 = sqrt((x+mu).^2+y.^2+z.^2);
r2 = sqrt((x-(1-mu)).^2+y.^2+z.^2);
U = 1/2.*(x.^2+y.^2) + (1-mu)./r1 + mu./r2;
C = 2.*U;

x = reshape(x, [a,b]);
y = reshape(y, [a,b]);
C = reshape(C, [a,b]);


%% show result
Clevel = [3.000 3.020 3.040 3.060 3.080 3.100 3.120 3.140 3.160 3.180 3.200 3.220 3.240 3.260 3.280 3.300];

f1 = figure;
hold on;
contour(x, y, C, Clevel,'LineWidth',1);
colormap jet
colorbar('Ticks',[3.0 3.1 3.2 3.3],'Ticksmode','manual','Limits',[3.0 3.3],'Limitsmode','manual')
plot(-mu,0,'o','MarkerFaceColor','k','MarkerEdgeColor','k','MarkerSize',10);
plot(1-mu,0,'o','MarkerFaceColor','k','MarkerEdgeColor','k','MarkerSize',10);
plot(L1(1),L1(2),'*','MarkerFaceColor','k','MarkerEdgeColor','k','MarkerSize',10);
plot(L2(1),L2(2),'*','MarkerFaceColor','k','MarkerEdgeColor','k','MarkerSize',10);
plot(L3(1),L3(2),'*','MarkerFaceColor','k','MarkerEdgeColor','k','MarkerSize',10);
plot(L4(1),L4(2),'*','MarkerFaceColor','k','MarkerEdgeColor','k','MarkerSize',10);
plot(L5(1),L5(2),'*','MarkerFaceColor','k','MarkerEdgeColor','k','MarkerSize',10);
axis equal
xlabel('$x$[-]');
ylabel('$y$[-]');
grid on;
hold off;


%% End of script