function [best_k, best_b] = ransacLine(data, iter, threshold)
% data: a 2xn dataset with n data points
% iter: the number of iterations
% threshold: the threshold of the distances between points and the fitting line

num_pts = size(data, 2); % Total number of points
best_num_inliers = 0;   % Best fitting line with largest number of inliers
best_k = 0; best_b = 0;     % parameters for best fitting line

for i=1:iter
    % Randomly select 2 points and fit line to these
    % Tip: Matlab command randperm / randsample is useful here

    samples = data(:,randsample(num_pts,2));
    
    % Model is y = k*x + b. You can ignore vertical lines for the purpose
    % of simplicity.
    
    line = polyfit(samples(1,:),samples(2,:),1);
    cur_k = line(1);
    cur_b = line(2);
    
    
    % Compute the distances between all points with the fitting line
        distance = (1/norm([cur_k, -1])) * abs(cur_k*data(1,:) - data(2,:) + cur_b);
    
    % Compute the inliers with distances smaller than the threshold
        within_thres = distance < threshold;
    % Update the number of inliers and fitting model if the current model
    % is better.
    
    num_inliners = sum(within_thres);
    if num_inliners > best_num_inliers
        best_num_inliers = num_inliners;
        best_k = cur_k;
        best_b = cur_b;
end


end
