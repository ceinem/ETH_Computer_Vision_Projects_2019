% Compute the fundamental matrix using the eight point algorithm and RANSAC
% Input
%   x1, x2 	  Point correspondences 3xN
%   threshold     RANSAC threshold
%
% Output
%   best_inliers  Boolean inlier mask for the best model
%   best_F        Best fundamental matrix
%
function [best_inliers, best_F] = ransac8pF(x1, x2, threshold)

iter = 1000;

num_pts = size(x1, 2); % Total number of correspondences
best_num_inliers = 0; best_inliers = [];
best_F = 0;
S_error = [];


M = 0;
p = 0;
N = 8;

for i=1:iter
    
    if p > 0.99
        break;
    end
    
    % Randomly select 8 points and estimate the fundamental matrix using these.
    samples = randsample(num_pts, 8);
    samples_x1 = x1(:,samples);
    samples_x2 = x2(:,samples);
    
    [Fh, F] = fundamentalMatrix(samples_x1, samples_x2);
    
    % Compute the Sampson error.
    
    S_error = distPointsLines(x2, Fh * x1) +...
        distPointsLines(x1, Fh' * x2);
    
    % Compute the inliers with errors smaller than the threshold.
    inliers = (S_error < threshold);    

    
    % Update the number of inliers and fitting model if the current model
    % is better.
    
    if sum(inliers) > best_num_inliers
        best_num_inliers = sum(inliers);
        best_inliers = inliers;
    end
    
    r = best_num_inliers/num_pts;
    p = 1-(1-r^N)^M;
    M = M + 1;
    
end

disp(best_num_inliers)
disp(mean(S_error))


[Fh, F] = fundamentalMatrix(x1(:,find(best_inliers)), x2(:,find(best_inliers)));


end


