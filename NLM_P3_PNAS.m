[x003, y003] = plot_a3();

t = 13200:17000;

%% ==================================================
% Figure settings
% ===================================================

% Style helpers
applyStyle = @(ax) set(ax, ...
    'FontName', 'Times New Roman', ...
    'FontSize', 22, ...
    'TickDir', 'out', ...
    'LineWidth', 1.5, ...
    'Box', 'on');

setAxisLabelStyle = @(ax) set([ax.XLabel ax.YLabel], ...
    'FontName', 'Times New Roman', ...
    'FontSize', 30);

addPanelLabel = @(ax, lab) set( ...
    text(ax, -0.14, 1.07, lab, ...
    'Units', 'normalized', ...
    'FontName', 'Times New Roman', ...
    'FontSize', 23, ...
    'FontWeight', 'bold'), ...
    'Clipping', 'off');


%% ==================================================
% Logistic map bifurcation diagram - Period-3 window
% x_{n+1} = r*x_n*(1-x_n)
% ===================================================

% Period-3 window parameters
rMin = 3.82842712474619;
rMax = 3.858;
nR = 6000;
nIter = 2500;
nTrans = 2000;
nKeep = nIter - nTrans;

% Use multiple initial conditions to capture full attractor
nSeeds = 10;
x0 = linspace(0.1, 0.9, nSeeds);

% r grid
r = linspace(rMin, rMax, nR);

fprintf('Computing bifurcation diagram...\n');

% Collect bifurcation points
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



%% ==================================================
% Layout: three columns
% (c) is wider than (a) and (b)
% y(t) has the same height as (a) and (b)
% ===================================================

% Widths in normalized units
widthAB = 0.208;
widthC  = 0.290;

panelHeight = 0.57;

% (a) Bifurcation diagram
posA = [0.075 0.36 widthAB panelHeight];

% (b) Phase space
posB = [0.355 0.36 widthAB panelHeight];

% (c) Upper: y(t), wider
posC2 = [0.650 0.36 widthC panelHeight];

% (c) Lower: x(t), wider but shorter
posC1 = [0.650 0.13 widthC 0.16];
%%
%%========================FIG=======================

fig = figure('Units', 'pixels', ...
    'Position', [440 278 1900 650]);

set(fig, 'Color', 'white');
% ==================================================
% (a) Bifurcation diagram - LEFT
% ===================================================

ax4 = axes('Position', posA);
hold(ax4, 'on');

plot(ax4, Xplot(:), Rplot(:), '.', 'MarkerSize', 1);

xlim(ax4, [0 1]);
ylim(ax4, [3.84 3.858]);

xlabel(ax4, 'x');
ylabel(ax4, 'r');

% Mark bifurcation points
p2 = yline(ax4, 3.8495, 'r--', 'LineWidth', 3);
p3 = yline(ax4, 3.857, '--', 'LineWidth', 3);

% Legend
lg = legend(ax4, [p2;p3], {'r_{3,\infty}';'Boundary of the period-3 window'}, ...
    'Location', 'southoutside');

set(lg, 'Box', 'off');

applyStyle(ax4);
setAxisLabelStyle(ax4);
addPanelLabel(ax4, 'A');

ax4.XAxis.TickLabelFormat = '%.1f';
ax4.YAxis.TickLabelFormat = '%.3f';


% ==================================================
% (b) Phase-space plot - MIDDLE
% ===================================================

ax3 = axes('Position', posB);
hold(ax3, 'on');

plot(ax3, x003(t), y003(t), '.', 'MarkerSize', 5);

p3=yline(ax3, 0.82842712474619, ...
    'k--', 'LineWidth', 3);

yline(ax3, 0.857, ...
    'k--', 'LineWidth', 3);

xlabel(ax3, 'x');
ylabel(ax3, 'y');


applyStyle(ax3);
setAxisLabelStyle(ax3);
addPanelLabel(ax3, 'B');

ax3.XAxis.TickLabelFormat = '%.1f';
ax3.YAxis.TickLabelFormat = '%.2f';

% Keep panel (b) aligned
ax3.Position = posB;


% ==================================================
% (c) Time series x(t) and y(t)
% Two independent axes, vertically stacked
% ===================================================

% ---------------- Upper: x(t) ----------------

ax1 = axes('Position', posC1);
hold(ax1, 'on');

px = plot(ax1, t, x003(t), '.', ...
    'MarkerSize', 5, ...
    'Color', [0 0.4470 0.7410]);

ylabel(ax1, 'x');

applyStyle(ax1);
setAxisLabelStyle(ax1);
xlabel(ax1, 't');

ax1.YAxis.TickLabelFormat = '%.1f';


% ---------------- Lower: y(t) ----------------

ax2 = axes('Position', posC2);
hold(ax2, 'on');

py = plot(ax2, t, y003(t), '.', ...
    'MarkerSize', 5, ...
    'Color', [0 0.4470 0.7410]);

% Original period-3 boundaries
p1 = yline(ax2, 3.82842712474619 - 3, ...
    'k--', 'LineWidth', 3);

yline(ax2, 3.857 - 3, ...
    'k--', 'LineWidth', 3);


ylabel(ax2, 'y');
ax2.XTickLabel = [];

applyStyle(ax2);
setAxisLabelStyle(ax2);
addPanelLabel(ax2, 'C');


ax2.XAxis.TickLabelFormat = '%.0f';
ax2.YAxis.TickLabelFormat = '%.2f';

% Keep the same time range
linkaxes([ax1 ax2], 'x');


% ==================================================
% Final layout alignment
% ===================================================

ax4.Position = posA;
ax3.Position = posB;
ax1.Position = posC1;
ax2.Position = posC2;