function [] = tunefig(style, figs, custom_style)
%RESHAPE_FIGURE
%
%   tunefig(style, figs, custom_style)
%       style:          select style of figure ('document', 'ppt', %/'custom'/%)
%       figs:           figure object
%       custom_style:   custom_style = {fig_st, ax_st, ln_st}
%
%   See also FIGURE, AXES, LINE

% Copyright (c) 2019 larking95(https://qiita.com/larking95)
% Released under the MIT Licence 
% https://opensource.org/licenses/mit-license.php

%% initialization
style_list = {'document', 'ppt', 'qiita', 'thin_document', 'thin_ppt'};
style_num = 1;
fig_st = struct([]);
ax_st  = struct([]);
ln_st  = struct([]);

%% settings
% ======= document =======
% Type: figure
fig_st(1).Color = 'w';  % background color = white 'w'

% Type: axis
ax_st(1).Color = 'w';
ax_st(1).Box = 'on';
ax_st(1).GridLineStyle = '-'; % '-' or 'none'
ax_st(1).GridColor = [0.15, 0.15,0.15].*1.05;
ax_st(1).MinorGridLineStyle = '-'; %
ax_st(1).MinorGridAlpha = 0.1;
ax_st(1).LineWidth = 1.5;
ax_st(1).XColor = 'k';
ax_st(1).YColor = 'k';
ax_st(1).ZColor = 'k';
% ax_st(1).GridAlpha = 0.0;
ax_st(1).FontSize= 20;
ax_st(1).FontName = 'Times New Roman';
ax_st(1).XLabel.Interpreter = 'latex';
ax_st(1).YLabel.Interpreter = 'latex';
ax_st(1).ZLabel.Interpreter = 'latex';

% Type: line
ln_st(1).LineWidth = 1.8;

% ======= ppt =======
% Type: figure
fig_st(2).Color = 'w';%'none';  % background color = transparent 'none'
% Type: axes
ax_st(2) = ax_st(1);    % the same to 'document'
% Type: line
ln_st(2) = ln_st(1);    % the same to 'document'

% ======= qiita =======
% Type: figure
fig_st(3).Color = 'w';%'none';  % background color = transparent 'none'/ white 'w'
% Type: axes
ax_st(3) = ax_st(1);    % the same to 'document'
ax_st(3).LineWidth = 2;   % change some settings
ax_st(3).FontSize= 15;
% Type: line
ln_st(3) = ln_st(1);    % the same to 'document'
ln_st(3).LineWidth = 2;   % change some settings

% ======= thin_document =======
% Type: figure
fig_st(4).Color = 'w';%'none';  % background color = transparent 'none'
% Type: axes
ax_st(4) = ax_st(1);    % the same to 'document'
% Type: line
ln_st(4) = ln_st(1);    % the same to 'document'
ln_st(4).LineWidth = 1.0;

% ======= thin_ppt =======
% Type: figure
fig_st(5).Color = 'w';%'none';  % 背景色Color = transparent 'none'
% Type: axes
ax_st(5) = ax_st(1);    % the same to 'document'
ax_st(5).FontSize = 20;
% Type: line
ln_st(5) = ln_st(1);    % the same to 'document'
ln_st(5).LineWidth = 1.0;

%% confirm variables
style_name = validatestring(style, style_list, 1);
style_num = find(strcmpi(style_name, style_list));
if nargin <= 2 && style_num > length(style_list)
    error('custom_style is not defined');
end
switch nargin
    case 1
        figs = gcf;
        custom_style = gobjects;
    case 2
        custom_style = gobjects;
    case 3
        fig_st(end+1) = custom_style{1};
        ax_st(end+1)  = custom_style{2};
        ln_st(end+1)  = custom_style{3};
end
validateattributes(figs, {'matlab.ui.Figure'}, {'vector'});

%% reshape
ff = fieldnames(fig_st(style_num));
af = fieldnames(ax_st(style_num));
lf = fieldnames(ln_st(style_num));

for f = 1:length(figs)
    for ffidx = 1:length(ff)
        figs(f).(cell2mat(ff(ffidx))) = fig_st(style_num).(cell2mat(ff(ffidx)));
    end
    ax = findobj(figs(f),'Type','axes');
    for a = 1:length(ax)
        for afidx = 1:length(af)
            if isempty(ax_st(style_num).(cell2mat(af(afidx))))
                continue;
            end
            if isstruct(ax_st(style_num).(cell2mat(af(afidx))))
                field1 = cell2mat(af(afidx));
                field2 = cell2mat(fieldnames(ax_st(style_num).(cell2mat(af(afidx)))));
            else
                ax(a).(cell2mat(af(afidx))) = ax_st(style_num).(cell2mat(af(afidx)));
            end
        end
        ln = findobj(ax(a),'Type','Line');
        for l = 1:length(ln)
            for lfidx = 1:length(lf)
                ln(l).(cell2mat(lf(lfidx))) = ln_st(style_num).(cell2mat(lf(lfidx)));
            end
        end
    end
end