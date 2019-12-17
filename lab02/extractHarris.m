% Extract Harris corners.
%
% Input:
%   img           - n x m gray scale image
%   sigma         - smoothing Gaussian sigma
%                   suggested values: .5, 1, 2
%   k             - Harris response function constant
%                   suggested interval: [4e-2, 6e-2]
%   thresh        - scalar value to threshold corner strength
%                   suggested interval: [1e-6, 1e-4]
%   
% Output:
%   corners       - 2 x q matrix storing the keypoint positions
%   C             - n x m gray scale image storing the corner strength
function [corners, C] = extractHarris(img, sigma, k, thresh)

    % Initialize Sobel Filter to compute gradients
    %dx = [1 0 -1; 2 0 -2; 1 0 -1];
    dx = [-1 0 1];
    dy = dx';
    
    %Adjusting image brightness values to make them easier to work with
    img = img *256;
    
    % computing Image gradients
    I_x = conv2(img, dx, 'same');
    I_y = conv2(img, dy, 'same');

    % Computing the products of gradients
    I_x2 = I_x .* I_x;
    I_y2 = I_y .* I_y;
    I_xy = I_x .* I_y;
        
    % Smoothening 
    I_x2_blur = imgaussfilt(I_x2, sigma);
    I_y2_blur = imgaussfilt(I_y2, sigma);
    I_xy_blur = imgaussfilt(I_xy, sigma);

    % Computing the harris response. This consists of the determinant and
    % the trace of the M-Matrix, whose explicit computation i skipped. 
    har = (I_x2_blur .* I_y2_blur - I_xy_blur .^2) - k * (I_x2_blur + I_y2_blur).^2;

    C = har;
    
    %computing the maxima of the harris reponse in a 3x3 patch/8
    %neighborhood
    local_max = imregionalmax(har,8);
    
    %finding all points that both are maxima and whose value is also above
    %the threshold and extracting their coordinates
    [rows, cols] = find(local_max .* (C > thresh));
    
    %saving cornoer coordinates
    corners = [rows cols]';
end