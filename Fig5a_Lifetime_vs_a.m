%% PLOT N(t)-t
function lifetime_a_plot = a_plot()

a_plot = [0.0080, 0.0070, 0.0060, 0.0058, 0.0057, 0.0056, 0.0055, 0.0054, 0.0053];

numPoints=5000;
r=3;
xleave=rand(1,numPoints);
kcontrol_a=1;
for control=a_plot
    for j=1:numPoints
        isign=1;
        xpark=xleave(j);ypark=1;
        for i=1:2*10^8
            if xpark<1 && xpark>=0
                xpark1=(r+ypark).*xpark.*(1-xpark);
                ypark=ypark+control.*isign.*(xpark-0.5);
                xpark=xpark1;
                isign=-isign;
            else
                break;
            end
        end
        lifetime_a_plot(kcontrol_a,j)=i-1;
    end
    kcontrol_a=kcontrol_a+1;
end
toc
save('lifetime_a_plot.mat', 'lifetime_a_plot');
