function [map, peak] = meanshiftSeg(img)
img = double(img);
L = size(img,1)*size(img,2);
X = reshape(img,[L,3]);

radius = 30;

[map, peak] = mean_shift(X, radius);
map = reshape(map,[size(img,1),size(img,2)]);

end



function [map, peak] = mean_shift(X, r)
    peak = []; 
    L = size(X,1);
    map = zeros(L,1);

    for i=1:L
        cur_peak = find_peak(X, i, r);

        %First peak is definitely in 
        if i==1
            peak = [peak; cur_peak];
            map(i) = size(peak,1);
        else
            %Distance from peaks to cur_peak
            peak_distance = sqrt(sum((peak(:,1) - cur_peak(1)).^2, 2)+sum((peak(:,2) - cur_peak(2)).^2, 2)+sum((peak(:,3) - cur_peak(3)).^2, 2));
        
            %Find all within distance R/2 
            idx = find(peak_distance < r/2);
            %If no other peak is close enough, add it as new peak
            if isempty(idx)
                peak = [peak; cur_peak];
                map(i) = size(peak,1);
            else
                %If another peak is close enough, add it to that peak
                [~, min_id] = min(peak_distance(idx));
                map(i) = idx(min_id);
            end
        end
    end
end


function peak = find_peak(X, xl, r)
    cur_peak = X(xl,:);

    while true
        %compute the distance of every point to the cur_peak
        dist_point_space = sqrt(sum((X(:,1) - cur_peak(1)).^2, 2)+sum((X(:,2) - cur_peak(2)).^2, 2)+sum((X(:,3) - cur_peak(3)).^2, 2));
        %Take every point closer than r in for new peak
        new_peak = mean(X(dist_point_space < r,:),1);
        %check how far the new and the old are apart
        distance = norm(cur_peak-new_peak);
        %update
        cur_peak = new_peak;
        %if update was too small, stop the process
        if distance < 1
            break;
        end
    end
    peak = new_peak;

end