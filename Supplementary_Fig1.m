
%% =========================================================
% TIME SERIES OF THREE 2D MAPS
%
% 1. Quadratic Map
% 2. Sine Map
% 3. Chebyshev Map
%
% Each subplot:
%    Left y-axis  : x_n
%    Right y-axis : y_n
%    Common x-axis: n
%
% No x-axis limits are specified.
%% =========================================================

clear;
clc;
%close all;

%% =========================================================
% PARAMETERS
%% =========================================================

iteration = 1e5;       % Maximum iterations
numPoints = 1000;      % Number of initial conditions

% Plot every 20th initial condition
timePlotStep = 20;

% Quadratic map
aQ = 0.003;

% Sine map
r = 1.0;
aS = 0.003;

% Chebyshev map
aC = 0.003;


%% =========================================================
% CREATE FIGURE
%% =========================================================

figure('Color','w', ...
       'Position',[100 100 1100 900]);

t = tiledlayout(3,1, ...
    'TileSpacing','compact', ...
    'Padding','compact');


%% =========================================================
% SUBFIGURE 1
% QUADRATIC MAP
%
% x_{n+1} = 2 - x_n^2 + y_n
% y_{n+1} = y_n + (-1)^n*aQ*x_n
%
% Escape condition: |x_n| > 2
%% =========================================================

ax1 = nexttile;
hold(ax1,'on');

% Initial conditions
xInitQ = 4*linspace(0,1,numPoints)-2;

for j = 8 %1:timePlotStep:numPoints

    x = NaN(iteration+1,1);
    y = NaN(iteration+1,1);

    x(1) = xInitQ(j);
    y(1) = 2;

    lastPoint = 1;
    isign = 1;

    for i = 1:iteration

        % Check escape
        if abs(x(i)) > 2
            break;
        end

        % Map equations
        x(i+1) = 0 - x(i)^2 + y(i);

        y(i+1) = y(i) + aQ*isign*x(i);

        % Check newly generated point
        if abs(x(i+1)) > 2
            break;
        end

        lastPoint = i+1;

        % Alternating sign
        isign = -isign;

    end

    if lastPoint > 20

        n = 0:lastPoint-1;

        % x_n: left axis
        yyaxis(ax1,'left');

        plot(ax1,n,x(1:lastPoint), ...
            '.', ...
            'MarkerSize',4);

        % y_n: right axis
        yyaxis(ax1,'right');

        plot(ax1,n,y(1:lastPoint), ...
            '.', ...
            'MarkerSize',4);

    end

end
 xlim(ax1,[1150 5600]); 
% Left y-axis
yyaxis(ax1,'left');

ylabel('$x_n$', ...
       'Interpreter','latex');

ylim([-2 2]);

%ax1.YColor = 'b';

% Right y-axis
yyaxis(ax1,'right');

ylabel('$y_n$', ...
       'Interpreter','latex');

ylim('auto');

%ax1.YColor = 'r';

% Common x-axis
xlabel('$n$', ...
       'Interpreter','latex');

title('Quadratic Map');

grid on;
box on;


%% =========================================================
% SUBFIGURE 2
% SINE MAP
%
% x_{n+1} = (r+y_n)*sin(pi*x_n)
% y_{n+1} = y_n + (-1)^n*aS*(x_n-0.5)
%
% Escape condition: x_n < 0 or x_n > 1
%% =========================================================

ax2 = nexttile;
hold(ax2,'on');

% Initial conditions
temp = linspace(0,1,numPoints+2);
xInitS = temp(2:end-1);

for j = 36%1:timePlotStep:numPoints

    x = NaN(iteration+1,1);
    y = NaN(iteration+1,1);

    x(1) = xInitS(j);
    y(1) = 1;

    lastPoint = 1;
    isign = 1;

    for i = 1:iteration

        % Check escape
        if x(i) < 0 || x(i) > 1
            break;
        end

        % Map equations
        x(i+1) = y(i)*sin(pi*x(i));

        y(i+1) = y(i) ...
               + aS*isign*(x(i)-0.5);

        % Check newly generated point
        if x(i+1) < 0 || x(i+1) > 1
            break;
        end

        lastPoint = i+1;

        % Alternating sign
        isign = -isign;

    end

    if lastPoint > 20

        n = 0:lastPoint-1;

        % x_n: left axis
        yyaxis(ax2,'left');

        plot(ax2,n,x(1:lastPoint), ...
            '.', ...
            'MarkerSize',4);

        % y_n: right axis
        yyaxis(ax2,'right');

        plot(ax2,n,y(1:lastPoint), ...
            '.', ...
            'MarkerSize',4);

    end

end
 xlim(ax2,[17876 25713]); 

% Left y-axis
yyaxis(ax2,'left');

ylabel('$x_n$', ...
       'Interpreter','latex');

ylim([0 1]);

%ax2.YColor = 'b';

% Right y-axis
yyaxis(ax2,'right');

ylabel('$y_n$', ...
       'Interpreter','latex');

ylim('auto');

%ax2.YColor = 'r';

% Common x-axis
xlabel('$n$', ...
       'Interpreter','latex');

title('Sine Map');

grid on;
box on;


%% =========================================================
% SUBFIGURE 3
% CHEBYSHEV MAP
%
% x_{n+1} = (4+3*y_n)*x_n^3 - 3*(1+y_n)*x_n
% y_{n+1} = y_n + aC*x_n
%
% Escape condition: |x_n| > 1
%% =========================================================

ax3 = nexttile;
hold(ax3,'on');

% Initial conditions
xInitC = 2*linspace(0,1,numPoints)-1;

for j = 3%timePlotStep:numPoints

    x = NaN(iteration+1,1);
    y = NaN(iteration+1,1);

    x(1) = xInitC(j);
    y(1) = 0;

    lastPoint = 1;

    for i = 1:iteration

        % Check escape
        if abs(x(i)) > 1
            break;
        end

        % Map equations
        x(i+1) = (4+3*y(i))*x(i)^3 ...
               - 3*(1+y(i))*x(i);

        y(i+1) = y(i) + aC*x(i);

        % Check newly generated point
        if abs(x(i+1)) > 1
            break;
        end

        lastPoint = i+1;

    end

    if lastPoint > 20

        n = 0:lastPoint-1;

      % x_n: left axis
        yyaxis(ax3,'left');

        plot(ax3,n,x(1:lastPoint), ...
            '.', ...
            'MarkerSize',4);

        % y_n: right axis
        yyaxis(ax3,'right');

        plot(ax3,n,y(1:lastPoint), ...
            '.', ...
            'MarkerSize',4);

    end

end


xlim(ax3,[3226 7000]); 
% Left y-axis
yyaxis(ax3,'left');

ylabel('$x_n$', ...
       'Interpreter','latex');

ylim([-1 1]);

%ax3.YColor = 'b';

% Right y-axis
yyaxis(ax3,'right');

ylabel('$y_n$', ...
       'Interpreter','latex');

ylim('auto');

%ax3.YColor = 'r';

% Common x-axis
xlabel('$n$', ...
       'Interpreter','latex');

title('Chebyshev Map');

grid on;
box on;


%% =========================================================
% FINAL FORMATTING
%% =========================================================

allAxes = [ax1 ax2 ax3];

for k = 1:3

    allAxes(k).FontSize = 11;
    allAxes(k).LineWidth = 1;

    grid(allAxes(k),'on');
    box(allAxes(k),'on');

end

%% =========================================================
% OPTIONAL: MANUALLY SET X-AXIS LIMITS LATER
%% =========================================================

% xlim(ax1,[0 1000]);   % Quadratic map
% xlim(ax2,[0 1000]);   % Sine map
% xlim(ax3,[0 1000]);   % Chebyshev map

%% =========================================================
% OPTIONAL: EXPORT FIGURE
%% =========================================================

% exportgraphics(gcf, ...
%     'ThreeMaps_TimeSeries.png', ...
%     'Resolution',300);


%% =========================================================
% FINAL FORMATTING (FOR yyaxis)
%% =========================================================

allAxes = [ax1 ax2 ax3];

for k = 1:3

    ax = allAxes(k);

    set(ax, ...
        'FontName','Times New Roman', ...
        'FontSize',22, ...
        'TickDir','out', ...
        'LineWidth',1.5, ...
        'Box','on');

    % X-axis label
    set(ax.XLabel, ...
        'FontName','Times New Roman', ...
        'FontSize',26);

    % Left y-axis label
    yyaxis(ax,'left');
    set(ax.YLabel, ...
        'FontName','Times New Roman', ...
        'FontSize',26);

    % Right y-axis label
    yyaxis(ax,'right');
    set(ax.YLabel, ...
        'FontName','Times New Roman', ...
        'FontSize',26);

    % Title
    set(ax.Title, ...
        'FontName','Times New Roman', ...
        'FontSize',24);

end