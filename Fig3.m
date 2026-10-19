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


%% FIG
% Plot up and down trajectories
cup=[237/255,196/255,152/255];%[88/255,83/255,159/255];%[237/255,196/255,152/255];
cdown=[0.58, 0.40, 0.74];%[216/255,105/255,103/255];%[197/255,197/255,225/255];%[212/255,151/255,157/255];
crandom=[0.64,0.08,0.18];%[0.00,0.45,0.74]

% --- axis style (keep data clipped) ---
applyStyle = @(ax) set(ax,'FontName','Times New Roman',...
    'FontSize',22,...
    'TickDir','out',...
    'LineWidth',1.5,...
    'Box','on');   % NOTE: do NOT set ax.Clipping = 'off'

setAxisLabelStyle = @(ax) set([ax.XLabel ax.YLabel],...
    'FontName','Times New Roman',...
    'FontSize',26);

% --- panel label (allow label outside axes) ---
addPanelLabel = @(ax, lab) set( ...
    text(ax,-0.19,1.07,lab,'Units','normalized',...
        'FontName','Times New Roman','FontSize',16,'FontWeight','bold'), ...
    'Clipping','off');

figure('Position', [100 100 1120 840])
% First create and set up the left two plots
ax1 = subplot(2, 2, 1);
hold(ax1, 'on')
scatter(x_traj(1:85919), r + y_traj(1:85919), 5, cup, 'filled')
scatter(x_traj(86631:87386), r + y_traj(86631:87386), 5, cdown, 'filled'); %move downward
scatter(x_traj(85920:86630), r + y_traj(85920:86630), 5, crandom, 'filled'); %chaotic
plot(ax1, [0 1], [3 3], 'k--', 'LineWidth', 1.5)
%plot(x_traj(1:85919), r + y_traj(1:85919), '.', 'Color', cup, 'MarkerSize', 5); %move upward
%plot(x_traj(86631:87386), r + y_traj(86631:87386), '.', 'Color', cdown, 'MarkerSize', 5); %move downward
%plot(x_traj(85920:86630), r + y_traj(85920:86630), '.', 'Color', crandom, 'MarkerSize', 5); %chaotic
xlabel('x');
ylabel('r + y');
% ===== "fake point" for legend=====
% h1 = plot(nan, nan, '.', 'Color', cup,     'MarkerSize', 15);
% h2 = plot(nan, nan, '.', 'Color', cdown,   'MarkerSize', 15);
% h3 = plot(nan, nan, '.', 'Color', crandom, 'MarkerSize', 15);

legend('Upward drift (\delta_i>0)', 'Downward drift (\delta_i<0)','Diffusive motion', 'Reflecting boundary', ...
        'Location','southwest','Box','off','FontSize', 12);
set(gca, 'FontSize', 12, 'TickDir', 'out', 'LineWidth', 1, 'Box', 'on')
applyStyle(ax1);
setAxisLabelStyle(ax1);
addPanelLabel(ax1,'(a)');
% 
%x_cross=x_traj(87298); y_cross=y_traj(87298); 
ax2 = subplot(2, 2, 3);
hold(ax2, 'on')
scatter(x_traj(1:85919), r + y_traj(1:85919), 5, cup, 'filled'); %move upward
scatter(x_traj(86631:87386), r + y_traj(86631:87386), 5, cdown, 'filled'); %move downward
%p4=plot(x_cross, y_cross+r, 'r*', 'MarkerSize', 10, 'LineWidth', 2);
%plot(x_traj(1:85919), r + y_traj(1:85919), '.', 'Color', cup, 'MarkerSize', 5); %move upward
%plot(x_traj(86631:87386), r + y_traj(86631:87386), '.', 'Color', cdown, 'MarkerSize', 5); %move downward
x1_fig = [0.2152, 0.1679]; y1_fig = [0.359, 0.3869];
x2_fig = [0.3607, 0.4071]; y2_fig = [0.3375, 0.3641];
x3_fig = [0.2, 0.2455]; y3_fig = [0.2946, 0.2718];
x4_fig = [0.4411, 0.3955]; y4_fig = [0.3161, 0.292];

annotation('textarrow', x1_fig, y1_fig, 'LineWidth', 1.5, 'Color', cup);
annotation('textarrow', x2_fig, y2_fig, 'LineWidth', 1.5, 'Color', cup);
annotation('textarrow', x3_fig, y3_fig, 'LineWidth', 1.5, 'Color', cdown);
annotation('textarrow', x4_fig, y4_fig, 'LineWidth', 1.5, 'Color', cdown);

xlabel('x');
ylabel('r + y');
axis([0.62 0.71 2.9 3.06])
applyStyle(ax2);
setAxisLabelStyle(ax2);
addPanelLabel(ax2,'(b)');

% Get position information for the left two plots
ax1_pos = ax1.Position;
ax2_pos = ax2.Position;

% Calculate centered position
left_bottom = ax2_pos(2);
left_top = ax1_pos(2) + ax1_pos(4);
left_total_height = left_top - left_bottom;
vertical_center = left_bottom + left_total_height / 2;

% ====== Adjustment here: Increase height ratio ======
phase_height = left_total_height * 0.7;      % Increased to 70%
phase_width = 0.38;
phase_left = 0.55;

% ====== Adjustment here: Ensure it does not exceed boundaries ======
phase_bottom = max(0.1, vertical_center - phase_height / 2);  % Minimum bottom boundary is 0.1

% Create centered phase portrait
time = 83000:88386;
cx = [0, 0.45, 0.74];
cy = [0.85, 0.33, 0.1];

% ====== Adjustment here: Reduce gap, increase usable height ======
gap = 0.04 * phase_height;                   % Reduced gap
h_each = (phase_height - gap) / 2;

% Top axis: x(t)
ax3 = axes('Position', ...
    [phase_left, phase_bottom + h_each + gap, phase_width, h_each]);
hold(ax3,'on')
scatter(time, x_traj(83000:88386), 3, cx, 'filled');
ylabel('x');
set(ax3, 'FontSize', 12, 'TickDir', 'out', 'LineWidth', 1, 'Box', 'on')
ax3.XTick = [];
ax3.XTickLabel = [];

% Bottom axis: y(t)
ax4 = axes('Position', ...
    [phase_left, phase_bottom, phase_width, h_each]);
hold(ax4,'on')
scatter(time, y_traj(83000:88386), 3, cx, 'filled');
ylabel('y');
xlabel('t');

t_mark = 87235;
p5 = xline(ax3, t_mark, 'k--', 'LineWidth', 1.5);
xline(ax4, t_mark, 'k--', 'LineWidth', 1.5);
legend(p5, 'Sign flip of \delta_i', 'Location', 'southwest','Box','off')
linkaxes([ax3 ax4], 'x')

applyStyle(ax3);
applyStyle(ax4);
setAxisLabelStyle(ax3);
setAxisLabelStyle(ax4);
addPanelLabel(ax3,'(c)');

ax1.XAxis.TickLabelFormat = '%.1f';
ax1.YAxis.TickLabelFormat = '%.1f';

ax2.XAxis.TickLabelFormat = '%.2f';
ax2.YAxis.TickLabelFormat = '%.2f';


ax3.XAxis.TickLabelFormat = '%.1f';
ax3.YAxis.TickLabelFormat = '%.1f';

ax4.XAxis.TickLabelFormat = '%.1f';
ax4.YAxis.TickLabelFormat = '%.1f';


