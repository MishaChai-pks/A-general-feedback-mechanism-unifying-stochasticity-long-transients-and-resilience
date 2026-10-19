%%
function [x005, y005] = plot_a5()

iteration=1000000;
numPoints=100;
lifetime=zeros(1,numPoints);
x0=ones(iteration,numPoints);
y0=ones(iteration,numPoints);
x0(1,:)=linspace(0,1,numPoints);
%x0(1,:)=rand(1,numPoints);
y0(1,:)=ones(1,numPoints);   %-0.3  -1.3
a=0.005; 
r=3;
for j=1:numPoints
    isign=1;
    for i=1:iteration   
       if x0(i,j)<1 && x0(i,j)>=0
            x0(i+1,j)=(r+y0(i,j)).*x0(i,j).*(1-x0(i,j));
            y0(i+1,j)=y0(i,j)+a.*isign.*(x0(i,j)-0.5);
            isign=-isign;
          
        else
            break;
        end
    end
    lifetime(:,j)=i-1;
end
% figure
% for j=2:numPoints
%     scatter(x0(1000:lifetime(:,j),j),y0(1000:lifetime(:,j),j),1,'filled')
%     hold on
%     xlabel('x')
%     ylabel('y')
% end
% figure
% for j=2:numPoints
%     scatter(20:100:lifetime(:,j),x0(20:100:lifetime(:,j),j),1,'filled')
%     hold on
%     xlabel('t')
%     ylabel('x')
% end
% figure
% for j=2:numPoints
%     scatter(20:lifetime(:,j),y0(20:lifetime(:,j),j),1,'filled')
%     hold on
%     xlabel('t')
%     ylabel('y')
% end
[nlongtime]=find(lifetime>799999);
% [~,nlongtime]=find(y0<-1);
% 
% % [~,nlongtime]=find(y0<-0.4);
% nlongtime=unique(nlongtime);
% 
% for j=nlongtime
%     % figure
%     % scatter(x0(200:lifetime(:,j),j),y0(200:lifetime(:,j),j),1,'filled')
%     % xlabel('x')
%     % ylabel('y')
%     figure('Position', [100, 100, 1200, 400]);
%     subplot(1,2,1)
%     scatter(200:lifetime(:,j),x0(200:lifetime(:,j),j),1,'filled')
%     xlabel('t')
%     ylabel('x')
%     subplot(1,2,2)
%     scatter(200:lifetime(:,j),y0(200:lifetime(:,j),j),1,'filled')
%     xlabel('t')
%     ylabel('y')
% end

j=nlongtime(2);

Nmax = 1e8;                     % big safety cap
x005 = zeros(1,Nmax);
y005 = zeros(1,Nmax);
x005(1)=x0(1,j);
y005(1)=y0(1,j);

i = 1;
while (x005(i) > 0) && (x005(i) < 1) && (i < Nmax)
    xi = x005(i);
    yi = y005(i);

    x005(i+1) = (r + yi) * xi * (1 - xi);
    y005(i+1) = yi + a * isign * (xi - 0.5);

    isign = -isign;
    i = i + 1;
end

x005 = x005(1:i);               % trim
y005 = y005(1:i);


% figure
% % scatter(200:length(x004),x004(200:end),1,'filled')
% scatter(1:length(x005),x005(1:end),1,'filled')
% xlabel('t')
% ylabel('x')
% 
% 
% figure
% scatter(1:length(x005),y005(1:end),1,'filled')
% xlabel('t')
% ylabel('y')

