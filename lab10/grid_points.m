function vPoints = grid_points(img,nPointsX,nPointsY,border)

    vPoints = [];
    [height,width,~] = size(img);
    
    size_x = floor((height-2*border-1)/(nPointsX-1));
    grid_x = (border+1):(size_x):(height-border);
    
    size_y = floor((width-2*border-1)/(nPointsY-1));
    grid_y = (border+1):(size_y):(width-border);
     
    for x=1:nPointsX
        for y=1:nPointsY
            vPoints = [vPoints; grid_x(x), grid_y(y)];
        end
    end
    
end
