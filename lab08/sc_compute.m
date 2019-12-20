function d = sc_compute(X,nbBins_theta,nbBins_r,smallest_r,biggest_r)

X = X';

normalization = mean2(sqrt(dist2(X,X)));  
smallest_r = smallest_r*normalization;
biggest_r = biggest_r*normalization;

theta_bin_size = 360/nbBins_theta;
delta_r(1) = smallest_r;
log_range_r = log(biggest_r) - log(smallest_r);

%Adjusted spacing
for i = 1:nbBins_r
    delta_r(i+1) =  exp(log(smallest_r) + log_range_r*i/nbBins_r);
end



%Initialize d
d = zeros(max(size(X)), nbBins_theta*nbBins_r);

%Itterate over all points
for i = 1:size(X,1)
    for j = 1:size(X,1)
        
        r_dist = norm(X(i,:)-X(j,:));
        %check if distance is within limits
        if  (r_dist < biggest_r && r_dist > smallest_r)
            
            %compute the angle
            theta = rad2deg(atan2 (X(j,2) - X(i,2),X(j,1) - X(i,1)));
            theta = mod(theta,360);
            
            %Computing the angle index. The modulus ensures, that the index
            %is always between 1 and nbBins_theta, instead of 0 to
            %nbBins_theta-1
            theta_idx = mod(ceil(theta/theta_bin_size)-1,nbBins_theta)+1;
            r_idx = max(find(r_dist >= delta_r));

            %Assigining to the respective bin
            d(i,theta_idx + (r_idx-1)*nbBins_theta) = ...
                                        d(i,theta_idx + (r_idx-1)*nbBins_theta) +1; 
        end
    end
end




end

