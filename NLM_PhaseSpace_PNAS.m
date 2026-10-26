%% Cleaner and more efficient version
clear; clc; close all;

% Parameters
iteration = 10^6;
numPoints = 1000;
a = 0.005;
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
threshold = 800000;
longIndices = find(lifetime >= threshold & lifetime < iteration-1);

fprintf('Found %d trajectories with lifetime >= %d\n', length(longIndices), threshold);

%%
% Plot a specific trajectory (j=801 as in your code)
j = 643; %33;
startIdx = 20;
endIdx = lifetime(j);

% Extract trajectory data
x_traj = x0(startIdx:endIdx, j);
y_traj = y0(startIdx:endIdx, j);
timeVec = 1:length(x_traj);


% Plot x vs time
figure;
plot(timeVec, x_traj, '.', 'MarkerSize', 3);
xlabel('Time (t)');
ylabel('x');
title(sprintf('x(t) for trajectory %d', j));
grid on;

% Plot y vs time
figure;
plot(timeVec, y_traj, '.', 'MarkerSize', 3);
xlabel('Time (t)');
ylabel('y');
title(sprintf('y(t) for trajectory %d', j));
grid on;
%axis([76386 87525 -0.5 1])

% Plot phase space: x vs r+y
figure;
plot(x_traj, r + y_traj, '.', 'MarkerSize', 3);
xlabel('x');
ylabel('r + y');
title('Phase space: x vs r+y');
grid on;


%% FIG
% Plot up and down trajectories
cup=[237/255,196/255,152/255];%[88/255,83/255,159/255];%[237/255,196/255,152/255];
cdown=[0.58, 0.40, 0.74];%[216/255,105/255,103/255];%[197/255,197/255,225/255];%[212/255,151/255,157/255];
crandom=[0.00,0.45,0.74]; [0.64,0.08,0.18];

% --- axis style (keep data clipped) ---
applyStyle = @(ax) set(ax,'FontName','Times New Roman',...
    'FontSize',22,...
    'TickDir','out',...
    'LineWidth',1.5,...
    'Box','on');   % NOTE: do NOT set ax.Clipping = 'off'

setAxisLabelStyle = @(ax) set([ax.XLabel ax.YLabel],...
    'FontName','Times New Roman',...
    'FontSize',28);

% --- panel label (allow label outside axes) ---
addPanelLabel = @(ax, lab) set( ...
    text(ax,-0.19,1.07,lab,'Units','normalized',...
        'FontName','Times New Roman','FontSize',16,'FontWeight','bold'), ...
    'Clipping','off');

%%
figure%('Position', [100 100 560 420])

% Main figure
ax1 = axes('Position', [0.13 0.15 0.82 0.78]);
hold(ax1, 'on');

plot(ax1, x_traj(1:348502), y_traj(1:348502), '.', 'Color', cup, 'MarkerSize', 5);
plot(ax1, x_traj(348503:348804), y_traj(348503:348804), '.', 'Color', crandom, 'MarkerSize', 5);
plot(ax1, x_traj(348805:349928), y_traj(348805:349928), '.', 'Color', cdown, 'MarkerSize', 5);
plot(ax1, x_traj(351249:end), y_traj(351249:end), '.', 'Color', crandom, 'MarkerSize', 5);

xlabel(ax1, 'x');
ylabel(ax1, 'y');
axis([0 1 -0.4 1])
%yticks(2.6:0.4:4);

applyStyle(ax1);
setAxisLabelStyle(ax1);
ax1.XAxis.TickLabelFormat = '%.1f';
ax1.YAxis.TickLabelFormat = '%.1f';

% % Zoom inset
% axPos = [0.2 0.2 0.25 0.25]; % [left bottom width height]
% axZoom = axes('Position', axPos);
% hold(axZoom, 'on');
% 
% % Plot all data points
% scatter(axZoom, x_traj(1:348502), r+y_traj(1:348502), 5, cup, 'filled');
% scatter(axZoom, x_traj(348805:349928), r+y_traj(348805:349928), 5, cdown, 'filled');
% 
% % Zoom region
% axis(axZoom, [0.635 0.7 2.97 3.03]);
% 
% % Simple box without ticks
% set(axZoom, 'XTick', [], 'YTick', [], ...
%     'LineWidth', 1, 'Box', 'on', 'Color', 'w');
% 
% xlabel(axZoom, '');
% ylabel(axZoom, '');