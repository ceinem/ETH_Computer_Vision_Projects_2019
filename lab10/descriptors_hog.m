function [descriptors,patches] = descriptors_hog(img,vPoints,cellWidth,cellHeight)

    nBins = 8;
    nCellsW = 4; % number of cells, hard coded so that descriptor dimension is 128
    nCellsH = 4; 

    w = cellWidth; % set cell dimensions
    h = cellHeight;   

    pw = w*nCellsW; % patch dimensions
    ph = h*nCellsH; % patch dimensions

    descriptors = zeros(0,nBins*nCellsW*nCellsH); % one histogram for each of the 16 cells
    patches = zeros(0,pw*ph); % image patches stored in rows    
    
    [grad_x,grad_y] = gradient(img);    
    Gdir = (atan2(grad_y, grad_x)); 
    

    
    for i = [1:size(vPoints,1)] % for all local feature points
        loc_patch = img((vPoints(i,1) - nCellsW/2*w):(vPoints(i,1) + nCellsW/2*w-1),...
                          (vPoints(i,2) - nCellsH/2*h):(vPoints(i,2)+nCellsH/2*h-1));
        patches(i,:) = loc_patch(:);

        histogram_per_cell = zeros(nCellsW*nCellsH,8);

        for x=0:nCellsW-1
            for y=0:nCellsH-1            
                %Get the beginning of each cell
                start_index_x = (vPoints(i,1) - nCellsW/2*w) + x*w;
                start_index_y = (vPoints(i,2) - nCellsH/2*h) + y*h;
                
                %Get the gradients over the cell
                local_gradients = Gdir(start_index_x:start_index_x+w-1, start_index_y:start_index_y+h-1);
                %Compute the counted histogram
                histogram_per_cell(x*nCellsW+y+1,:) = histcounts(local_gradients,-pi:2*pi/nBins:pi);
            end
        end

        %Turn histograms into descriptors
        descriptors(i,:) = reshape(histogram_per_cell',[],1);
        

    end % for all local feature points
    
end
