%% !!! DO NOT CHANGE THE FUNCTION INTERFACE, OTHERWISE, YOU MAY GET 0 POINT !!! %%
% xy: size 2xn
% XYZ: size 3xn 

function [P, K, R, t, error] = runDLT(xy, XYZ)

% normalize 
[xy_normalized, XYZ_normalized, T, U] = normalization(xy, XYZ);


%compute DLT with normalized coordinates
[Pn] = dlt(xy_normalized, XYZ_normalized);

%denormalize projection matrix
P = inv(T)*Pn*U;


%factorize projection matrix into K, R and t
[K, R, t] = decompose(P);   

%compute average reprojection error
[~, num_points] = size(xy);
XYZ = [XYZ ; ones(1,num_points)];
xy = [xy ; ones(1,num_points)];

xy_projected = P*XYZ;

for i = 1:num_points
    scale = xy_projected(3,i);
    xy_projected(:,i) = xy_projected(:,i)/scale;
end
ErrorTotal = xy_projected - xy;
error = sum(vecnorm(ErrorTotal,2,1))/num_points;

visualization_all_points(P);

end