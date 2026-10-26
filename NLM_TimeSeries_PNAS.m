%--FIG.--    ******(x,t) (y,t)****

%%
% -- load data --
[x001, y001] = plot_a1();
[x002, y002] = plot_a2();
[x003, y003] = plot_a3();
[x004, y004] = plot_a4();
[x005, y005] = plot_a5();


data = { ...
    x001, y001, 1000,   'a = 0.05'; ...
    x002, y002, 3500,  'a = 0.02'; ...
    x003, y003, 25000, 'a = 0.01'; ...
    x004, y004, 250000,'a = 0.006'; ...
    x005, y005, 8e7,   'a = 0.005'};


%% FIG (5 rows × 1 column)

cx = [0, 0.45, 0.74];      
cy = [0.85, 0.33, 0.1];    

fig = figure('Position',[320, 278, 560, 840]);
%set(fig,'Color','white');
applyStyle = @(ax) set(ax,...
    'FontName','Times New Roman',...
    'FontSize',22,...
    'TickDir','out',...
    'LineWidth',2,...
    'Box','on');

setAxisLabelStyle = @(ax) set([ax.XLabel ax.YLabel],...
    'FontName','Times New Roman',...
    'FontSize',30);

addPanelLabel = @(ax, lab) set( ...
    text(ax,-0.14,1.07,lab,'Units','normalized',...
        'FontName','Times New Roman','FontSize',23,'FontWeight','bold'), ...
    'Clipping','off');

panelLabels = {'(a)','(b)','(c)','(d)','(e)'};
axList = gobjects(5,1); 

for i = 1:5

    x     = data{i,1};
    y     = data{i,2};
    Tmax  = data{i,3};
    label = data{i,4};

    ax = subplot(5,1,i);
    axList(i) = ax;
    hold(ax,'on');

    t = 1:numel(x);

    plot(ax, t, x, '.', 'Color', cx, 'MarkerSize', 5);
    plot(ax, t, y, '.', 'Color', cy, 'MarkerSize', 5);

    ylim(ax,[0 1]);
    yticks(ax,[0 1]);

    xlim(ax,[0 Tmax]);
    xticks(ax,[0 Tmax]);

    % Disable MATLAB's automatic exponent
    ax.XAxis.Exponent = 0;

    % Put scientific notation directly in the right tick label
    if Tmax >= 1e4
        exponent = floor(log10(Tmax));
        mantissa = Tmax / 10^exponent;

        ax.XTickLabel = {'0', ...
            sprintf('%.3g\\times10^{%d}', mantissa, exponent)};
    else
        ax.XTickLabel = {'0', num2str(Tmax)};
    end

    ax.TickLabelInterpreter = 'tex';

    % ---- Title (lift upward slightly) ----
    tobj = title(ax, label, ...
        'FontName','Times New Roman', ...
        'FontWeight','bold', ...
        'FontSize',18, ...
        'Units','normalized');

    tpos = get(tobj,'Position');
    tpos(2) = 1.08;
    set(tobj,'Position',tpos);


    % ---- Only show legend once (top panel) ----
   if i == 1

    % Create dummy objects for legend (larger markers)
    h1 = plot(ax, nan, nan, '.', 'Color', cx, 'MarkerSize', 30);
    h2 = plot(ax, nan, nan, '.', 'Color', cy, 'MarkerSize', 30);

    lg = legend(ax, [h1 h2], {'x','y'}, 'Location','northeast');
    set(lg,'Box','off');

   end

   if i == 5
    xlabel(ax,'Time');
   end

    applyStyle(ax);
    setAxisLabelStyle(ax);

end


% %Adjust positions to move left
% 
% shift_amount = 0.08;
% 
% for i = 1:5
% 
%     ax = axList(i);
% 
%     pos = get(ax,'Position');
% 
%     set(ax,'Position', ...
%         [pos(1)-shift_amount, pos(2), pos(3), pos(4)]);
% 
% end


