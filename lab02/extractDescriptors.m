% Extract descriptors.
%
% Input:
%   img           - the gray scale image
%   keypoints     - detected keypoints in a 2 x q matrix
%   
% Output:
%   keypoints     - 2 x q' matrix
%   descriptors   - w x q' matrix, stores for each keypoint a
%                   descriptor. w is the size of the image patch,
%                   represented as vector
function [keypoints, descriptors] = extractDescriptors(img, keypoints)

%get point numbers and image dimensions
[~, num_keypoints] = size(keypoints);
[size_y, size_x] = size(img);

patch_size=9;
half_patch = 4;

new_keypoints = [];

% Itterate through each keypoints
for i = 1:num_keypoints
    
    %Check that keypoints are not too close to the border
    if (keypoints(1,i) > half_patch) && (keypoints(1,i) < size_y - half_patch) && (keypoints(2,i) > half_patch) && (keypoints(2,i) < size_x - half_patch)
        new_keypoints = [new_keypoints, keypoints(:,i)];
        
    end
end

%extract the relevalt patches
descriptors = extractPatches(img, new_keypoints, patch_size);
%return only the selected keypoints
keypoints = new_keypoints;

end