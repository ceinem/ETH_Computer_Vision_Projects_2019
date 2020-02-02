function particles_w = observe(particles,frame,H,W,hist_bin,hist_target,sigma_observe)

N = length(particles);
particles_w = zeros(N,1);

%Itterate over each particle
for i = 1:N
    %Define the boundaries of the box
    xMin = particles(i,1) - 0.5*W; 
    xMax = particles(i,1) + 0.5*W;
    yMin = particles(i,2) - 0.5*H;
    yMax = particles(i,2) + 0.5*H;
    
    
    %Compute the histogramd
    cur_hist = color_histogram(xMin,yMin,xMax,yMax,frame, hist_bin);
    %Compute the current cost
    cur_cost = chi2_cost(cur_hist, hist_target);
    
    %Compute the particle weights
    particles_w(i) = 1/(sqrt(2*pi)*sigma_observe) * exp(-cur_cost^2/(2*sigma_observe^2));
end

%Make sure particle weights sum up to 1
particles_w = particles_w ./ sum(particles_w);

end

