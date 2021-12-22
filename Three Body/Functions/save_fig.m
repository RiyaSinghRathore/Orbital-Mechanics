% reshape figure and save fig for paper and ppt
function [] = save_fig(fig,filename,view_angle)
% fig        : figure object
% filename   : filename excluding .eps
% view_angle : = [azimuth, elevation]

	% change the view point
	ax = findobj(fig,'Type','axes');
	view(ax,view_angle(1),view_angle(2));

	% save: eps for paper and ppt
	ppt_name = strcat(filename,'.png');
	tunefig('ppt',fig);
	exportgraphics(fig,ppt_name,'Resolution',600);
	doc_name = strcat(filename,'.pdf');
	tunefig('document',fig);
	exportgraphics(fig,doc_name);
end