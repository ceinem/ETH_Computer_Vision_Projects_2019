%% !!! DO NOT CHANGE THE FUNCTION INTERFACE, OTHERWISE, YOU MAY GET 0 POINT !!! %%
% xy: size 2xn
% XYZ: size 3xn 

function [P, K, R, t, error] = runGoldStandard(xy, XYZ)

%normalize data points
[xy_normalized, XYZ_normalized, T, U] = normalization(xy, XYZ);

%compute DLT with normalized coordinates
[P_normalized] = dlt(xy_normalized, XYZ_normalized);

%minimize geometric error to refine P_normalized
pn = [P_normalized(1,:) P_normalized(2,:) P_normalized(3,:)];
for i=1:20
    [pn] = fminsearch(@fminGoldStandard, pn, [], xy_normalized, XYZ_normalized);
end

pn = (reshape(pn, [4,3]))';

%denormalize projection matrix
P = inv(T) * pn * U;

%factorize prokection matrix into K, R and t
[K, R, t] = decompose(P);

%compute average reprojection error
[~, num_points] = size(xy);
XYZ = [XYZ; ones(1,num_points)];
xy = [xy; ones(1,num_points)];

xy_projected = P * XYZ;

for i = 1:num_points
    scale = xy_projected(3,i);
    xy_projected(:,i) = xy_projected(:,i)/scale;
end

error = sum(vecnorm((xy_projected - xy),2,1))/num_points;

visualization_all_points(P);

end