
% run those functions and save the data,mat
% lifetime_a_1 = a_BIG();
% lifetime_a_2 = a_SMALL();
% lifetime_a_plot = a_plot();
% lifetime_a_LT = a_long_transient();

%% load data
load('lifetime_a_1.mat');
load('lifetime_a_2.mat');
load('lifetime_a_plot.mat');
load('lifetime_a_LT.mat');
numPoints = 5000;


%%
% Surviving probability figure
% a_big
a_big = 0.01:-0.00002:0.006;

clear C_a numSur_a  coeffvals_1
for k=1:201    
    clear ic occurrences
    [C_a{k},~,ic]=unique(lifetime_a_1(k,:));
    occurrences = histcounts(ic, 1:numel(C_a{k})+1);
    numSur_a{k}(:,1)=numPoints;
    for j=2:length(C_a{k})
        numSur_a{k}(j)=numSur_a{k}(j-1)-occurrences(j-1);
    end
    %semilogy(C_a{k},numSur_a{k},'LineWidth',1)
    %hold on
    [~,iCslope]=find(numSur_a{k}<300&numSur_a{k}>10);
    %[~,iCslope]=find(C_a{k}>0.5*10^5&C_a{k}<10^8);
    fitsx=(C_a{k}(iCslope))'; fitsy=(numSur_a{k}(iCslope))';
    slopefunc=fit(fitsx,log(fitsy),'poly1');
    u=fitsx;
    coeffvals_1(k,:)=coeffvalues(slopefunc);
    v=exp(coeffvals_1(k,1)*u+coeffvals_1(k,2));
    %semilogy(u,v,'r--','LineWidth',2.0);
    clear slopefunc u v
end

eta_1=abs(coeffvals_1(:,1));  %escape rate
lifetime_eta_1=1./eta_1; % mean residence time

%% small a

figure
clear C_a numSur_a coeffvals_2
for k=1:16 
   
    clear ic occurrences
    [C_a{k},~,ic]=unique(lifetime_a_2(k,:));
    occurrences = histcounts(ic, 1:numel(C_a{k})+1);

    numSur_a{k}(:,1)=numPoints;
    for j=2:length(C_a{k})
        numSur_a{k}(j)=numSur_a{k}(j-1)-occurrences(j-1);
    end

    semilogy(C_a{k},numSur_a{k},'LineWidth',1)
    hold on

    [~,iCslope]=find(numSur_a{k}<300&numSur_a{k}>10);
    fitsx=(C_a{k}(iCslope))'; fitsy=(numSur_a{k}(iCslope))';

    slopefunc=fit(fitsx,log(fitsy),'poly1');
    u=fitsx;
    coeffvals_2(k,:)=coeffvalues(slopefunc);
    v=exp(coeffvals_2(k,1)*u+coeffvals_2(k,2));

    semilogy(u,v,'r--','LineWidth',2.0);
    clear slopefunc u v

end

a_small = 0.0059:-0.00004:0.0053;
a_small = a_small(2:end);

eta_2=abs(coeffvals_2(2:end,1));  %first data doesn't fit well
lifetime_eta_2=1./eta_2;

% figure
% plot(a_small,eta_2,'bo','MarkerSize',4,'LineWidth',1)
% xlabel('a')
% ylabel('escape rate')
% 
% figure
% plot(a_small,lifetime_eta_2,'bo','MarkerSize',3,'LineWidth',1)
% xlabel('a')
% ylabel('lifetime')
% 
% color3=[0.58,0.67,0.79];
% figure
% plot(a_small,eta_2,'bo','MarkerSize',4,'LineWidth',1)
% hold on
% plot(a_big,eta_1,'bo','MarkerSize',4,'LineWidth',1)
% patch([0.005,0.01,0.01,0.005],[0,0,1.2*10^(-4),1.2*10^(-4)], color3, 'FaceAlpha', 0.3, 'EdgeColor', 'none');
% xlabel('a')
% ylabel('Escape Rate')
% axis([0.005, 0.01, 0, 1.2*10^(-4)])
% 
% figure
% plot(a_big,lifetime_eta_1,'bo','MarkerSize',3,'LineWidth',1)
% hold on
% plot(a_small,lifetime_eta_2,'bo','MarkerSize',3,'LineWidth',1)
% patch([0.005,0.01,0.01,0.005],[0, 0, 8*10^7, 8*10^7], color3, 'FaceAlpha', 0.3, 'EdgeColor', 'none');
% xlabel('a')
% ylabel('Lifetime')
% axis([0.005, 0.01, 0, 8*10^7])


fitsx=a_big'; fitsy=eta_1;
slopefunc=fit(fitsx,fitsy,'poly1');
u=fitsx;
coeffvals=coeffvalues(slopefunc);
v=coeffvals(1)*u+coeffvals(2);
% figure
% plot(a_big,eta_1,'bo','MarkerSize',3,'LineWidth',1)
% hold on
% p1=semilogy(u,v,'r--','LineWidth',2.0);
% xlabel('a')
% ylabel('lifetime')
% legend(p1, ['slope = ', num2str(coeffvals(1))])


%%
%-FIG--
% --- axis style (keep data clipped) ---
applyStyle = @(ax) set(ax,'FontName','Times New Roman',...
    'FontSize',22,...
    'TickDir','out',...
    'LineWidth',1.5,...
    'Box','on');   % NOTE: do NOT set ax.Clipping = 'off'

setAxisLabelStyle = @(ax) set([ax.XLabel ax.YLabel],...
    'FontName','Times New Roman',...
    'FontSize',30);

% --- panel label (allow label outside axes) ---
setTitleStyle = @(tobj) set(tobj,...
    'FontName','Times New Roman',...
    'FontSize',16,...
    'FontWeight','bold');

addPanelLabel = @(ax, lab) set( ...
    text(ax,-0.14,1.07,lab,'Units','normalized',...
        'FontName','Times New Roman', ...
        'FontSize',23,'FontWeight','bold'), ...
    'Clipping','off');

fig = figure('Position', [100 100 560 840], ...
    'Color', 'white');

% Two rows, one column

posA = [0.17 0.53 0.76 0.37];
posB = [0.17 0.12 0.76 0.37];

%--(a)--
ax1 = axes('Position', posA);
clear C_a numSur_a
for k=1:8

    clear ic occurrences
    [C_a{k},~,ic]=unique(lifetime_a_plot(k,:));
    occurrences = histcounts(ic, 1:numel(C_a{k})+1);

    numSur_a{k}(:,1)=numPoints;
    for j=2:length(C_a{k})
        numSur_a{k}(j)=numSur_a{k}(j-1)-occurrences(j-1);
    end

    loglog(C_a{k},numSur_a{k},'LineWidth',2)
    hold on

end
xlabel('t')
ylabel('N(t)')
axis([10 2*10^8 10 5000])
applyStyle(ax1);
setAxisLabelStyle(ax1);
%addPanelLabel(ax1, 'A');

lgd = legend;
lgd.FontName = 'Times New Roman';
lgd.FontSize = 16;

% ---- fit line ----
k_fit=8;
[~, iCslope] = find(C_a{k_fit} > 60 & C_a{k_fit} < 2500);
fitsx = (C_a{k_fit}(iCslope))';
fitsy = (numSur_a{k_fit}(iCslope))';

slopefunc = fit(log(fitsx), log(fitsy), 'poly1');
u = fitsx;
coeffvals = coeffvalues(slopefunc);
v = exp(coeffvals(1) * log(u) + coeffvals(2));

offset_factor = 1.1;  % 10% above
v_offset = v * offset_factor;
loglog(u, v_offset, 'r--', 'LineWidth', 3.0);

cpowerx = [10, 3500, 3500, 10];
cpowery = [10, 10, 5000, 5000];
cexp2x=[3500,2*10^8,2*10^8,3500];
cexp2y=[10, 10, 5000, 5000];
color2=[0.63,0.83,0.37]; 
color3=[0.58,0.67,0.79];

patch(cpowerx,cpowery, color2, 'FaceAlpha', 0.3, 'EdgeColor', 'none');
patch(cexp2x,cexp2y, color3, 'FaceAlpha', 0.3, 'EdgeColor', 'none');

lg1 = legend(ax1, '0.0080', '0.0070', '0.0060', '0.0058', '0.0057', '0.0056', '0.0055', '0.0054','\alpha_1 = -0.5011', ...
    'Location','southwest');
set(lg1,'Box','off');

% ---- zoom inset ----
% Inset position
insetWidth  = 0.2;
insetHeight = insetWidth * 560 / 840;

axPos = [0.62 0.73 insetWidth insetHeight];

axZoom = axes('Position', axPos);

semilogy(C_a{1}, numSur_a{1}, 'LineWidth',2); hold on
semilogy(C_a{2}, numSur_a{2}, 'LineWidth',2); hold on
semilogy(C_a{3}, numSur_a{3}, 'LineWidth',2); hold on
semilogy(C_a{4}, numSur_a{4}, 'LineWidth',2); hold on
semilogy(C_a{5}, numSur_a{5}, 'LineWidth',2); hold on
semilogy(C_a{6}, numSur_a{6}, 'LineWidth',2); hold on
semilogy(C_a{7}, numSur_a{7}, 'LineWidth',2); hold on
semilogy(C_a{8}, numSur_a{8}, 'LineWidth',2);

axis([4000,4*10^7,10,310])
applyStyle(axZoom);
set(axZoom, 'XTickLabel', []);
set(axZoom, 'YTickLabel', []);

%--(c)--
ax3 = axes('Position', posB);

clear C_a numSur_a
for k=1:5
    clear ic occurrences
    [C_a{k},~,ic]=unique(lifetime_a_LT(k,:));
    occurrences = histcounts(ic, 1:numel(C_a{k})+1);

    numSur_a{k}(:,1)=numPoints;
    for j=2:length(C_a{k})
        numSur_a{k}(j)=numSur_a{k}(j-1)-occurrences(j-1);
    end

    loglog(C_a{k},numSur_a{k},'LineWidth',2)
    hold on
end

axis([10 2*10^8 10 5000])

% ---- fit line ----
k_fit=5;
[~, iCslope] = find(C_a{k_fit} > 60 & C_a{k_fit} < 6900);
fitsx = (C_a{k_fit}(iCslope))';
fitsy = (numSur_a{k_fit}(iCslope))';

slopefunc = fit(log(fitsx), log(fitsy), 'poly1');
u = fitsx;
coeffvals = coeffvalues(slopefunc);
v = exp(coeffvals(1) * log(u) + coeffvals(2));

offset_factor = 1.1;  % 10% above
v_offset = v * offset_factor;
ss1 = loglog(u, v_offset, 'r--', 'LineWidth', 3.0);

% ---- shaded regions ----
cpowerx = [10, 6500, 6500, 10];
cpowery = [10, 10, 5000, 5000];
cexp2x=[6500,2*10^8,2*10^8,6500];
cexp2y=[10, 10, 5000, 5000];

patch(cpowerx,cpowery, color2, 'FaceAlpha', 0.3, 'EdgeColor', 'none');
patch(cexp2x,cexp2y, color3, 'FaceAlpha', 0.3, 'EdgeColor', 'none');

xlabel('t')
ylabel('N(t)')
lg3 = legend(ax3, '0.005', '0.004', '0.003', '0.002', '0.001', '\alpha_2 = -0.5228', ...
    'Location','southwest');
set(lg3,'Box','off');
applyStyle(ax3);
setAxisLabelStyle(ax3);
%addPanelLabel(ax3, 'B');

lgd = legend;
lgd.FontName = 'Times New Roman';
lgd.FontSize = 16;

% Share x-axis
linkaxes([ax1, ax3], 'x');

% Hide upper x-axis tick labels
ax1.XAxis.TickLabels = {};
xlabel(ax1, '');

% Keep lower x-axis label
xlabel(ax3, 't');

% Fix axes positions
set([ax1, ax3], 'PositionConstraint', 'innerposition');

ax1.Position = posA;
ax3.Position = posB;

% Fix axis limits
xlim(ax1, [10, 2e8]);

%%
% ------------------------------- Mean Lifetime ----------------------------------------
figure('Position', [100 100 560 420]);
ax4 = gca;  

loglog(a_big, lifetime_eta_1, 'bo', 'MarkerSize', 4, 'LineWidth', 1.5); hold on
loglog(a_small, lifetime_eta_2, 'bo', 'MarkerSize', 4, 'LineWidth', 1.5);

patch([0.005,0.01,0.01,0.005],[10^3, 10^3, 10^8, 10^8], ...
    color3, 'FaceAlpha', 0.3, 'EdgeColor', 'none');

xlabel('a')
ylabel('Mean Lifetime')
axis([0.005, 0.01, 10^3, 10^8])

% ---- fit line ----
fitsx = a_small';
fitsy = lifetime_eta_2;

slopefunc = fit(log(fitsx), log(fitsy), 'poly1');
u = fitsx;
coeffvals = coeffvalues(slopefunc);
v = exp(coeffvals(1) * log(u) + coeffvals(2));

offset_factor = 1.0;  % 10% above
v_offset = v * offset_factor;

s2 = loglog(u, v_offset, 'r--', 'LineWidth', 3.0);

lg4 = legend(s2, ...
    ['$|\beta| = ', num2str(abs(coeffvals(1))), '$'], ...
    'Interpreter','latex', ...
    'Location','northeast'); %'FontSize', 16
%text(0.6619, 0.8162, '$\tau \sim (1/a)^{|\beta|}$', ...
  %  'Units','normalized', ...
  %  'Interpreter','latex', ...
  %      'FontSize', 16)
set(lg4,'Box','off');

applyStyle(ax4);
setAxisLabelStyle(ax4);
