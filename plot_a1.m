%%
function [x001, y001] = plot_a1()
iteration=10000;
numPoints=1000;
x0=ones(iteration,numPoints);
y0=ones(iteration,numPoints);
x0(1,:)=linspace(0,1,numPoints);
%x0(1,:)=rand(1,numPoints);
y0(1,:)=ones(1,numPoints);   %-0.3  -1.3
%y0(1,:)=1.3*rand(1,numPoints)-1.3;  
a=0.05; 
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
%     scatter(20:lifetime(:,j),x0(20:lifetime(:,j),j),1,'filled')
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
 [nlongtime]=find(lifetime>=500);
% for j=nlongtime(1:20)
%     % figure
%     % scatter(x0(200:lifetime(:,j),j),y0(200:lifetime(:,j),j),1,'filled')
%     % xlabel('x')
%     % ylabel('y')
%     figure
%     scatter(20:lifetime(:,j),x0(20:lifetime(:,j),j),1,'filled')
%     xlabel('t')
%     ylabel('x')
%     % figure
%     % scatter(200:lifetime(:,j),y0(200:lifetime(:,j),j),1,'filled')
%     % xlabel('t')
%     % ylabel('y')
% end

j=nlongtime(18); %12 4
x001=x0(1:lifetime(:,j),j);
y001=y0(1:lifetime(:,j),j);
% figure
% scatter(1:length(x001),x001(1:end),3,'filled')
% xlabel('t')
% ylabel('x')


