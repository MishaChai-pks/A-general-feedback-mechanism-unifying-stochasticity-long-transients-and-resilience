
[x003, y003] = plot_a3();


%% FIG p3-detais for thesis (final version)

t = 13200:17000;

fig = figure('Position',[100 100 1120 840]);
set(fig,'Color','white');

applyStyle = @(ax) set(ax,'FontName','Times New Roman',...
    'FontSize',22,...
    'TickDir','out',...
    'LineWidth',1.5,...
    'Box','on');
setAxisLabelStyle = @(ax) set([ax.XLabel ax.YLabel],...
    'FontName','Times New Roman',...
    'FontSize',26);

addPanelLabel = @(ax, lab) set( ...
    text(ax,-0.19,1.07,lab,'Units','normalized',...
    'FontName','Times New Roman','FontSize',16,'FontWeight','bold'),...
    'Clipping','off');

%------------------
ax1 = subplot(2,2,2);
hold(ax1,'on');

plot(ax1, t, x003(t), '.', 'MarkerSize', 3);

xlabel(ax1,'t');
ylabel(ax1,'x');

applyStyle(ax1);
setAxisLabelStyle(ax1);
addPanelLabel(ax1,'(b)');

%------------------
ax2 = subplot(2,2,4);
hold(ax2,'on');

plot(ax2, t, y003(t), '.', 'MarkerSize', 3);

p1 = yline(ax2, 3.82842712474619 - 3, 'k--', 'LineWidth', 1.5);
yline(ax2, 3.857 - 3, 'k--', 'LineWidth', 1.5);

xlabel(ax2,'t');
ylabel(ax2,'y');

applyStyle(ax2);
setAxisLabelStyle(ax2);
addPanelLabel(ax2,'(d)');

lg = legend(ax2, p1, {'Boundary of the period-3 window'}, ...
    'Location','northwest');
set(lg,'Box','off');

%------------------
ax3 = subplot(2,2,3);
hold(ax3,'on');

plot(ax3, x003(t), 3 + y003(t), '.', 'MarkerSize', 3);

yline(ax3, 3.82842712474619, 'k--', 'LineWidth', 1.5);
yline(ax3, 3.857, 'k--', 'LineWidth', 1.5);

xlabel(ax3,'x');
ylabel(ax3,'r + y');

applyStyle(ax3);
setAxisLabelStyle(ax3);
addPanelLabel(ax3,'(c)');

%-----------------
% Logistic map bifurcation diagram - Period-3 window (optimized)
% x_{n+1} = r*x_n*(1-x_n)

% Period-3 window parameters
rMin = 3.82842712474619;   % 1 + sqrt(8), birth of period-3
rMax = 3.858;              % 3.857: end of period-3 window
nR = 6000;                 % Resolution in r
nIter = 2500;              % Total iterations
nTrans = 2000;             % Transient to discard
nKeep = nIter - nTrans;    % Points to plot per r per seed

% Use multiple initial conditions to capture full attractor
nSeeds = 10;
x0 = linspace(0.1, 0.9, nSeeds);

% r grid
r = linspace(rMin, rMax, nR);

fprintf('Computing bifurcation diagram...\n');

% --- Collect bifurcation points (store all seeds) ---
% Each r has nKeep*nSeeds x-values
Xplot = zeros(nKeep*nSeeds, nR);

for i = 1:nR
    ri = r(i);

    idx = 0;
    for seed = 1:nSeeds
        x = x0(seed);

        % Burn-in transient
        for k = 1:nTrans
            x = ri * x * (1 - x);
        end

        % Collect points
        for k = 1:nKeep
            x = ri * x * (1 - x);
            idx = idx + 1;
            Xplot(idx, i) = x;
        end
    end
end

% Build matching R array for plotting
Rplot = repmat(r, size(Xplot,1), 1);

% ---- Thesis style helpers ----
applyStyle = @(ax) set(ax,'FontName','Times New Roman',...
    'FontSize',15,...
    'TickDir','out',...
    'LineWidth',1.5,...
    'Box','on');

addPanelLabel = @(ax, lab) set( ...
    text(ax,-0.17,1.05,lab,'Units','normalized',...
        'FontName','Times New Roman','FontSize',15,'FontWeight','bold'),...
    'Clipping','off');

% ---- (a) Bifurcation panel ----
ax4 = subplot(2,2,1);
hold(ax4,'on');

plot(ax4, Xplot(:), Rplot(:), '.', 'MarkerSize', 1);

xlim(ax4,[0, 1]);
ylim(ax4,[3.84, 3.858]);

xlabel(ax4,'x');
ylabel(ax4,'r');

% Mark key bifurcation points (LineWidth unified to 1.5)
p2 = yline(ax4, 3.8495, 'r--', 'LineWidth', 1.5);  % r_{3,∞} (if that's what you mean)
p3 = yline(ax4, 3.857,  'k--', 'LineWidth', 1.5);  % end of window

% Legend (fixed: remove p1 since it doesn't exist)
lg = legend(ax4, p2, 'r_{3,\infty}', ...
    'Location','southeast');
set(lg,'Box','off');

applyStyle(ax4);
setAxisLabelStyle(ax4);
addPanelLabel(ax4,'(a)');


ax1.XAxis.TickLabelFormat = '%.1f';
ax1.YAxis.TickLabelFormat = '%.1f';

ax2.XAxis.TickLabelFormat = '%.1f';
ax2.YAxis.TickLabelFormat = '%.2f';


ax3.XAxis.TickLabelFormat = '%.1f';
ax3.YAxis.TickLabelFormat = '%.2f';

ax4.XAxis.TickLabelFormat = '%.1f';
ax4.YAxis.TickLabelFormat = '%.3f';
