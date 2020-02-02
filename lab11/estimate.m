function meanStateAPriori = estimate(particles, particles_w)

%Multiplying each particle with the respective weight. It is assumed, that
%all the weights sum up to one.
meanStateAPriori = sum(particles_w .* particles,1);

end

