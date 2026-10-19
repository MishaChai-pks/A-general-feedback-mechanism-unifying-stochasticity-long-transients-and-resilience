%% SUPER LONG TRANSIENT a
function lifetime_a_LT = a_long_transient()
tic;
numPoints = 5000; 
r = 3;          
control_values = 0.005:-0.001:0.001;
num_controls = length(control_values);
lifetime_a_LT = zeros(num_controls, numPoints);
xleave = rand(1, numPoints);

for k_idx = 1:num_controls
    control = control_values(k_idx);
    
    for j = 1:numPoints
        isign = 1;
        xpark = xleave(j);
        ypark = 1;
        
        max_iter = 2e8;
        
        for i = 1:max_iter
            if xpark < 1 && xpark > 0
                xpark1 = (r + ypark) .* xpark .* (1 - xpark);
                ypark = ypark + control .* isign .* (xpark - 0.5);
                xpark = xpark1;
                isign = -isign;
            else
                lifetime_a_LT(k_idx, j) = i - 1;
                break;
            end
        end
        
        if i == max_iter
            lifetime_a_LT(k_idx, j) = max_iter;
        end
    end
    
end
toc;
save('lifetime_a_LT.mat', 'lifetime_a_LT');

