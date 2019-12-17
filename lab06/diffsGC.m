function diffs = diffsGC(img1, img2, dispRange)

max_range = dispRange(end) - dispRange(1) ;
diffs = zeros(size(img1,1), size(img1,2) ,max_range) ;

box_filt = fspecial('average',3) ;

for i = 0:max_range
    img2_shift = shiftImage( img2, i-ceil(max_range/2) ) ;

    diffs(:,:,i+1) = (img1 - img2_shift).^2 ;
    diffs(:,:,i+1) = conv2( diffs(:,:,i+1), box_filt,'same') ;  
end

end