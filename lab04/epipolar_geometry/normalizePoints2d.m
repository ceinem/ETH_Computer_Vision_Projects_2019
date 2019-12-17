% Normalization of 2d-pts
% Inputs: 
%           xs = 2d points
% Outputs:
%           nxs = normalized points
%           T = 3x3 normalization matrix
%               (s.t. nx=T*x when x is in homogenous coords)
function [nxs, T] = normalizePoints2d(xs)
[~,  num_points] = size(xs);

% Shift all points to be centralized
    xs_centroid_x = sum(xs(1,:))/num_points;
    xs_centroid_y = sum(xs(2,:))/num_points;
    
    T_cent = [1 0 -xs_centroid_x;
              0 1 -xs_centroid_y;
              0 0 1];
          
    xs_at_origin = T_cent * xs;
    
    % Compute Scale
    xs_sum_norm = sum(vecnorm(xs_at_origin(1:2,:)))/num_points;
    
  
    % Compute the overall Transformation matrix 
    T = (sqrt(2)/xs_sum_norm) * T_cent;
    T(3,3) = 1;
    
    nxs = T * xs;

end
