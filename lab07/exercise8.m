% =========================================================================
% Exercise 8
% =========================================================================

% Initialize VLFeat (http://www.vlfeat.org/)

clear all
clc

%K Matrix for house images (approx.)
K = [  670.0000     0     393.000
         0       670.0000 275.000
         0          0        1];

%Load images
imgName1 = '../data/house.000.pgm';
imgName2 = '../data/house.004.pgm';

img1 = single(imread(imgName1));
img2 = single(imread(imgName2));

%extract SIFT features and match
[fa, da] = vl_sift(img1);
[fb, db] = vl_sift(img2);

%don't take features at the top of the image - only background
filter = fa(2,:) > 100;
fa = fa(:,find(filter));
da = da(:,find(filter));

[matches, scores] = vl_ubcmatch(da, db);

%showFeatureMatches(img1, fa(1:2, matches(1,:)), img2, fb(1:2, matches(2,:)), 20);

%% Compute essential matrix and projection matrices and triangulate matched points

%use 8-point ransac or 5-point ransac - compute (you can also optimize it to get best possible results)
%and decompose the essential matrix and create the projection matrices


fa_hom = makehomogeneous(fa(1:2, matches(1,:)));
fb_hom = makehomogeneous(fb(1:2, matches(2,:)));

%RANSAC to find inliers and compute Fundamental Matrix
feedback = 1;
[F, inliers] = ransacfitfundmatrix(fa_hom, fb_hom, 0.0001, feedback);
fa_hom_in = fa_hom(:,inliers);
fb_hom_in = fb_hom(:,inliers);
%showFeatureMatches(img1, fa_hom_in(1:2,:), img2, fb_hom_in(1:2, :), 21);
outliers = setdiff(1:size(matches,2),inliers);

% showFeatureMatches(img1, fa_hom(1:2,outliers), img2, fb_hom(1:2,outliers), 21);
% pause(1)
% showFeatureMatches(img1, fa_hom(1:2,inliers), img2, fb_hom(1:2,inliers), 22);


%Compute Essential Matrix
E = K' * F * K;


x1_calibrated = K \ fa_hom_in;
x2_calibrated = K \ fb_hom_in;

%Ger Camera positions
Ps{1} = eye(4);
Ps{2} = decomposeE(E, x1_calibrated, x2_calibrated);

%From the Fix
if (det(Ps{2}) < 0 )
    Ps{2}(1:3,1:3) = -Ps{2}(1:3,1:3);
    Ps{2}(1:3, 4) = -Ps{2}(1:3, 4);
end

%triangulate the inlier matches with the computed projection matrix
[X2, ~] = linearTriangulation(Ps{1}, x1_calibrated, Ps{2}, x2_calibrated);

%% Add an addtional view of the scene 

imgName3 = '../data/house.002.pgm';
img3 = single(imread(imgName3));
[fc, dc] = vl_sift(img3);

%match against the features from image 1 that where triangulated

fa_inlier = fa(:,matches(1,inliers));
da_inlier = da(:,matches(1,inliers));

[matches_img3, ~] = vl_ubcmatch(da_inlier, dc);

fa_in_img3_hom = makehomogeneous(fa_inlier(1:2, matches_img3(1,:)));
fc_hom = makehomogeneous(fc(1:2, matches_img3(2,:)));


x3_calibrated = K \ fc_hom;
x1_in_img3_calibrated = K \ fa_in_img3_hom;

%Use Ransac to get projection matrix and camera position
[Ps{3}, inliers3] = ransacfitprojmatrix(x3_calibrated, X2(:,matches_img3(1,:)), 0.05, feedback) ;
outliers3 = setdiff(1:size(matches_img3,2),inliers3);

% showFeatureMatches(img1, fa_in_img3_hom(1:2,outliers3), img3, fc_hom(1:2,outliers3), 21);
% pause(1)
% showFeatureMatches(img1, fa_in_img3_hom(1:2,inliers3), img3, fc_hom(1:2,inliers3), 22);


%From the Fix
if (det(Ps{3}) < 0 )
    Ps{3}(1:3,1:3) = -Ps{3}(1:3,1:3);
    Ps{3}(1:3, 4) = -Ps{3}(1:3, 4);
end

%Triangulate new points
[X3, ~] = linearTriangulation(Ps{1}, x1_in_img3_calibrated(:,inliers3), Ps{3}, x3_calibrated(:,inliers3));

%triangulate the inlier matches with the computed projection matrix

%% Add more views...
%image 4

imgName4 = '../data/house.001.pgm';
img4 = single(imread(imgName4));
[fd, dd] = vl_sift(img4);

%match against the features from image 1 that where triangulated
[matches_img4, ~] = vl_ubcmatch(da_inlier, dd);

fa_in_img4_hom = makehomogeneous(fa_inlier(1:2, matches_img4(1,:)));
fd_hom = makehomogeneous(fd(1:2, matches_img4(2,:)));


x4_calibrated = K \ fd_hom;
x1_in_img4_calibrated = K \ fa_in_img4_hom;

%Use Ransac to get projection Matrix
[Ps{4}, inliers4] = ransacfitprojmatrix(x4_calibrated, X2(:,matches_img4(1,:)), 0.05, feedback) ;
outliers4 = setdiff(1:size(matches_img4,2),inliers4);
% 
% showFeatureMatches(img1, fa_in_img4_hom(1:2,outliers4), img4, fd_hom(1:2,outliers4), 21);
% pause(1)
% showFeatureMatches(img1, fa_in_img4_hom(1:2,inliers4), img4, fd_hom(1:2,inliers4), 22);


%From the Fix
if (det(Ps{4}) < 0 )
    Ps{4}(1:3,1:3) = -Ps{4}(1:3,1:3);
    Ps{4}(1:3, 4) = -Ps{4}(1:3, 4);
end

%Triangulate new points
[X4, ~] = linearTriangulation(Ps{1}, x1_in_img4_calibrated(:,inliers4), Ps{4}, x4_calibrated(:,inliers4));




%image 5

imgName5 = '../data/house.003.pgm';
img5 = single(imread(imgName5));
[fe, de] = vl_sift(img5);

%match against the features from image 1 that where triangulated


[matches_img5, ~] = vl_ubcmatch(da_inlier, de);

fa_in_img5_hom = makehomogeneous(fa_inlier(1:2, matches_img5(1,:)));
fe_hom = makehomogeneous(fe(1:2, matches_img5(2,:)));


x5_calibrated = K \ fe_hom;
x1_in_img5_calibrated = K \ fa_in_img5_hom;

%Use Ransac to get projection Matrix
[Ps{5}, inliers5] = ransacfitprojmatrix(x5_calibrated, X2(:,matches_img5(1,:)), 0.05, feedback) ;
outliers5 = setdiff(1:size(matches_img5,2),inliers5);

% showFeatureMatches(img1, fa_in_img5_hom(1:2,outliers5), img5, fe_hom(1:2,outliers5), 21);
% pause(1)
% showFeatureMatches(img1, fa_in_img5_hom(1:2,inliers5), img5, fe_hom(1:2,inliers5), 22);



%From the Fix
if (det(Ps{5}) < 0 )
    Ps{5}(1:3,1:3) = -Ps{5}(1:3,1:3);
    Ps{5}(1:3, 4) = -Ps{5}(1:3, 4);
end


[X5, ~] = linearTriangulation(Ps{1}, x1_in_img5_calibrated(:,inliers5), Ps{5}, x5_calibrated(:,inliers5));




%% Plot stuff

fig = 10;
figure(fig);

%use plot3 to plot the triangulated 3D points
plot3(X2(1,:),X2(2,:),X2(3,:),'r.'); 
hold on;
plot3(X3(1,:),X3(2,:),X3(3,:),'b.'); 
hold on;
plot3(X4(1,:),X4(2,:),X4(3,:),'g.'); 
hold on;
plot3(X5(1,:),X5(2,:),X5(3,:),'y.'); 
hold on;


%draw cameras
drawCameras(Ps, fig);