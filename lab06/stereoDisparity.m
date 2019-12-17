function disp = stereoDisparity(img1, img2, dispRange)

% dispRange: range of possible disparity values
% --> not all values need to be checked

img1 = double(img1);
img2 = double(img2);

box_filt = fspecial('average',3);

for d = dispRange
    img2_shift = shiftImage(img2,d);
    diff_img = (img1 - img2_shift).^2;
    
    diff = conv2(diff_img, box_filt, 'same');
    
    if d == dispRange(1)
        bestDiff = diff;
        disp = d*ones(size(diff));
    else
        mask = diff < bestDiff;
        mask_inv = diff >= bestDiff;
        disp = disp .* mask_inv + d .* mask;
        bestDiff = diff .* mask + bestDiff .* mask_inv;
    end
    
end

end