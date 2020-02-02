function hist = color_histogram(xMin,yMin,xMax,yMax,frame, hist_bin)

%Make sure everything is within the frame
xMin = round(max(1,xMin));
yMin = round(max(1,yMin));
xMax = round(min(size(frame,2),xMax));
yMax = round(min(size(frame,1),yMax));

%Extract the boxes for the individual color channels
box_red = frame(yMin:yMax, xMin:xMax, 1);
box_green = frame(yMin:yMax, xMin:xMax, 2);
box_blue = frame(yMin:yMax, xMin:xMax, 3);

%Compute the histograms for each channel
hist_red = imhist(box_red, hist_bin);
hist_green = imhist(box_green, hist_bin);
hist_blue = imhist(box_blue, hist_bin);

%Combine into one histogram and normalise
hist = [hist_red; hist_green; hist_blue];
hist = hist./sum(hist);

end

