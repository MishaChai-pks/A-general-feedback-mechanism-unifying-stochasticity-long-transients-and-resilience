% the (a, escape rate) figure, big a

function lifetime_a_1 = a_BIG()

numPoints=5000;
r=3;
xleave=rand(1,numPoints);
kcontrol_a=1;
% a_big = 0.01:-0.00002:0.006;
for control=0.01:-0.00002:0.006
    for j=1:numPoints
        isign=1;
        xpark=xleave(j);ypark=1;
        for i=1:2*10^6
            if xpark<1 && xpark>=0
                xpark1=(r+ypark).*xpark.*(1-xpark);
                ypark=ypark+control.*isign.*(xpark-0.5);
                xpark=xpark1;
                isign=-isign;
            else
                break;
            end
        end
        lifetime_a_1(kcontrol_a,j)=i-1;
    end
    kcontrol_a=kcontrol_a+1;
end

save('lifetime_a_1.mat', 'lifetime_a_1')
