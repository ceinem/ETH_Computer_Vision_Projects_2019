%% !!! DO NOT CHANGE THE FUNCTION INTERFACE, OTHERWISE, YOU MAY GET 0 POINT !!! %%
% xy: size 2xn
% XYZ: size 3xn
% xy_normalized: 3xn
% XYZ_normalized: 4xn

function [xy_normalized, XYZ_normalized, T, U] = normalization(xy, XYZ)
%data normalization

% 1. compute centroid
[~, num_points] = size(xy);
xy = [xy; ones(1,num_points)];
XYZ = [XYZ; ones(1,num_points)];

xy_centroid_x = sum(xy(1,:))/num_points;
xy_centroid_y = sum(xy(2,:))/num_points;
XYZ_centroid_x = sum(XYZ(1,:))/num_points;
XYZ_centroid_y = sum(XYZ(2,:))/num_points;
XYZ_centroid_z = sum(XYZ(3,:))/num_points;

% 2. shift the input points so that the centroid is at the origin
T_1 = [1 0 -xy_centroid_x;
       0 1 -xy_centroid_y;
       0 0 1];

U_1 = [1 0 0 -XYZ_centroid_x;
       0 1 0 -XYZ_centroid_y;
       0 0 1 -XYZ_centroid_z;
       0 0 0 1];
   
xy_at_origin = T_1 * xy;
XYZ_at_origin = U_1 * XYZ;
   
% 3. compute scale

xy_sum_norm = sum(vecnorm(xy_at_origin(1:2,:)))/num_points;
XYZ_sum_norm = sum(vecnorm(XYZ_at_origin(1:3,:)))/num_points;

T_2 = [sqrt(2)/xy_sum_norm 0 0;
       0 sqrt(2)/xy_sum_norm 0;
       0 0 1];
U_2 = [sqrt(3)/XYZ_sum_norm 0 0 0;
       0 sqrt(3)/XYZ_sum_norm 0 0;
       0 0 sqrt(3)/XYZ_sum_norm 0;
       0 0 0 1];

% 4. create T and U transformation matrices (similarity transformation)

T = T_1 * T_2;
U = U_1 * U_2;

% 5. normalize the points according to the transformations

xy_normalized = T * xy;
XYZ_normalized = U * XYZ;

end