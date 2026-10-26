%% Cleaner and more efficient version
clear; clc; close all;

% Parameters
iteration = 100000;
numPoints = 1000;
a = 0.01;
r = 3;

% Preallocate arrays
x0 = zeros(iteration + 1, numPoints);
y0 = zeros(iteration + 1, numPoints);
lifetime = zeros(1, numPoints);

% Initialize - using vectorized initialization
x0(1, :) = linspace(0, 1, numPoints);
y0(1, :) = -0.5;  % All columns same initial y

% Main simulation loop - vectorized where possible
for j = 1:numPoints
    isign = 1;
    for i = 1:iteration   
        if x0(i, j) >= 0 && x0(i, j) < 1
            x0(i+1, j) = (r + y0(i, j)) * x0(i, j) * (1 - x0(i, j));
            y0(i+1, j) = y0(i, j) + a * isign * (x0(i, j) - 0.5);
            isign = -isign;
        else
            lifetime(j) = i - 1;
            break;
        end
    end
    % If no break occurred
    if lifetime(j) == 0
        lifetime(j) = iteration;
    end
end

%% 
% Find trajectories with long lifetimes
threshold = 20730;
longIndices = find(lifetime >= threshold);

fprintf('Found %d trajectories with lifetime >= %d\n', length(longIndices), threshold);

% Plot a specific trajectory (j=801 as in your code)
j = 801;
startIdx = 20;
endIdx = lifetime(j);

% Extract trajectory data
x_traj = x0(startIdx:endIdx, j);
y_traj = y0(startIdx:endIdx, j);
timeVec = 1:length(x_traj);


% % Plot x vs time
% figure;
% scatter(timeVec, x_traj, 1, 'filled');
% xlabel('Time (t)');
% ylabel('x');
% title(sprintf('x(t) for trajectory %d', j));
% grid on;
% 
% % Plot y vs time
% figure;
% scatter(timeVec, y_traj, 1, 'filled');
% xlabel('Time (t)');
% ylabel('y');
% title(sprintf('y(t) for trajectory %d', j));
% grid on;
% axis([76386 87525 -0.5 1])
% 
% % Plot phase space: x vs r+y
% figure;
% scatter(x_traj, r + y_traj, 1, 'filled');
% xlabel('x');
% ylabel('r + y');
% title('Phase space: x vs r+y');
% grid on;

%% FIG: Two rows, one column, with inset zoom

% Colors
cup     = [237/255, 196/255, 152/255];
cdown   = [0.58, 0.40, 0.74];
crandom = [0.53, 0.58, 0.18];

cx = [0, 0.45, 0.74];
cy = [0.85, 0.33, 0.10];

% Figure
fig = figure('Position', [100 100 560 840], ...
    'Color', 'white');

% Style
applyStyle = @(ax) set(ax, ...
    'FontName', 'Times New Roman', ...
    'FontSize', 22, ...
    'TickDir', 'out', ...
    'LineWidth', 1.2, ...
    'Box', 'on');

setAxisLabelStyle = @(ax) set( ...
    [ax.XLabel ax.YLabel], ...
    'FontName', 'Times New Roman', ...
    'FontSize', 30);

addPanelLabel = @(ax, lab) set( ...
    text(ax, -0.14, 1.07, lab, ...
    'Units', 'normalized', ...
    'FontName', 'Times New Roman', ...
    'FontSize', 23, ...
    'FontWeight', 'bold'), ...
    'Clipping', 'off');

% Layout
left = 0.17;
width = 0.76;

% Main phase portrait (top)
posA = [left 0.56 width 0.37];

% Combined time series (bottom)
posB = [left 0.11 width 0.32];

% (a) Main phase portrait

ax1 = axes('Position', posA);
hold(ax1, 'on');
plot(ax1, ...
    x_traj(1:85919), y_traj(1:85919), '.', 'Color', cup, 'MarkerSize', 5);

plot(ax1, ...
    x_traj(86631:87386), y_traj(86631:87386), '.', 'Color', cdown, 'MarkerSize', 5);

h3 = plot(ax1, ...
    x_traj(85920:86630), y_traj(85920:86630), '.', 'Color', crandom, 'MarkerSize', 5);

h4 = plot(ax1, [0 1], [0 0], 'k--', ...
    'LineWidth', 3);

xlabel(ax1, 'x');
ylabel(ax1, 'y');

applyStyle(ax1);
setAxisLabelStyle(ax1);
addPanelLabel(ax1, 'A');

ax1.XAxis.TickLabelFormat = '%.1f';
ax1.YAxis.TickLabelFormat = '%.1f';

% Optional legend; position may need adjusting
legend(ax1, h4, ...
    {'Reflecting boundary'}, ...
    'Location', 'southwest', ...
    'Box', 'off'); %'Upward drift', 'Downward drift',  'Diffusive motion', ...     'FontSize', 16, ...

% Inset: zoom near the reflecting boundary

% Inset is inside the main phase portrait
% Coordinates relative to the entire figure
posInset = [0.187 0.692 0.23 0.125];

axInset = axes('Position', posInset);
hold(axInset, 'on');

plot(axInset, ...
    x_traj(1:85919), ...
    y_traj(1:85919), ...
    '.', 'Color', cup, 'MarkerSize', 5);

plot(axInset, ...
    x_traj(86631:87386), ...
    y_traj(86631:87386), ...
    '.', 'Color', cdown, 'MarkerSize', 5);

xlim(axInset, [0.62 0.71]);
ylim(axInset, [-0.1 0.06]);
% Simple box without ticks
set(axInset, 'XTick', [], 'YTick', [], ...
    'LineWidth', 1, 'Box', 'on', 'Color', 'w');

xlabel(axInset, '');
ylabel(axInset, '');

% Arrows inside inset, using DATA coordinates
% Adjust these if needed to match actual branches

%addArrowInAxes(fig, axInset, 0.644, 2.91, 0.645, 2.947, cup);
%addArrowInAxes(fig, axInset, 0.668, 2.91, 0.673, 2.947, cup);
%addArrowInAxes(fig, axInset, 0.668, 2.91, 0.685, 2.947, cup);
%addArrowInAxes(fig, axInset, 0.680, 2.91, 0.685, 2.947, cdown);
% Annotation arrows
% Position = [x_start, y_start, width, height]
% Coordinates are normalized relative to the entire figure.

% Arrow 1: Upward drift
pos1 = [0.253, 0.702, 0.008, 0.035];

annotation('arrow', ...
    [pos1(1), pos1(1)+pos1(3)], ...
    [pos1(2), pos1(2)+pos1(4)], ...
    'Color', cup, ...
    'LineWidth', 1.4, ...
    'HeadLength', 8, ...
    'HeadWidth', 8);

% Arrow 2: Upward drift
pos2 = [0.311, 0.7, 0.0125, 0.0341];

annotation('arrow', ...
    [pos2(1), pos2(1)+pos2(3)], ...
    [pos2(2), pos2(2)+pos2(4)], ...
    'Color', cup, ...
    'LineWidth', 1.4, ...
    'HeadLength', 8, ...
    'HeadWidth', 8);

% Arrow 3: Upward drift
pos3 = [0.2482, 0.7872, -0.0429, 0.0118];

annotation('arrow', ...
    [pos3(1), pos3(1)+pos3(3)], ...
    [pos3(2), pos3(2)+pos3(4)], ...
    'Color', cup, ...
    'LineWidth', 1.4, ...
    'HeadLength', 8, ...
    'HeadWidth', 8);


% Arrow 4: Upward drift
pos4 = [0.3571, 0.7822, 0.0393, 0.0155];

annotation('arrow', ...
    [pos4(1), pos4(1)+pos4(3)], ...
    [pos4(2), pos4(2)+pos4(4)], ...
    'Color', cup, ...
    'LineWidth', 1.4, ...
    'HeadLength', 8, ...
    'HeadWidth', 8);

% Arrow 4: Downward drift
pos5 = [0.2054, 0.7649, 0.0393, -0.0101];

annotation('arrow', ...
    [pos5(1), pos5(1)+pos5(3)], ...
    [pos5(2), pos5(2)+pos5(4)], ...
    'Color', cdown, ...
    'LineWidth', 1.4, ...
    'HeadLength', 8, ...
    'HeadWidth', 8);
% Arrow 4: Downward drift
pos6 = [0.3929, 0.7661, -0.0371, -0.0101];

annotation('arrow', ...
    [pos6(1), pos6(1)+pos6(3)], ...
    [pos6(2), pos6(2)+pos6(4)], ...
    'Color', cdown, ...
    'LineWidth', 1.4, ...
    'HeadLength', 8, ...
    'HeadWidth', 8);

% Ensure inset appears above main axes
uistack(axInset, 'top');

% (b) Combined time series

idx = 83000:88386;

% Correct original simulation time
time = idx + startIdx - 1;

ax2 = axes('Position', posB);
hold(ax2, 'on');

p1 = plot(ax2, time, x_traj(idx), '.', ...
    'Color', cx, 'MarkerSize', 5);

p2 = plot(ax2, time, y_traj(idx), '.', ...
    'Color', cy, 'MarkerSize', 5);

% Sign flip
t_mark = 87235 + startIdx - 1;

p3 = xline(ax2, t_mark, 'k--', ...
    'LineWidth', 3);

xlabel(ax2, 't');
ylabel(ax2, 'x, y');

applyStyle(ax2);
setAxisLabelStyle(ax2);
addPanelLabel(ax2, 'B');

ax2.XAxis.TickLabelFormat = '%.1f';
ax2.YAxis.TickLabelFormat = '%.1f';


    % Create dummy objects for legend (larger markers)
h1 = plot(ax2, nan, nan, '.', 'Color', cx, 'MarkerSize', 30);
h2 = plot(ax2, nan, nan, '.', 'Color', cy, 'MarkerSize', 30);
legend(ax2, [h1 h2 p3], ...
    {'x(t)', 'y(t)', 'Sign flip of \delta_i'}, ...
    'Location', 'northwest', ...
    'Box', 'off'); % 'FontSize', 16, ...

