function particles = propagate(particles,sizeFrame,params)

%Defining the A matrix as well as the noise
if(params.model == 0) 
    A = [1, 0;
         0, 1];
     w = normrnd(0,params.sigma_position,2,params.num_particles);
elseif(params.model == 1)
    A = [1, 0, 1, 0;
         0, 1, 0, 1;
         0, 0, 1, 0;
         0, 0, 0, 1];
     w = [normrnd(0,params.sigma_position,2,params.num_particles);
          normrnd(0,params.sigma_velocity,2,params.num_particles)];
end

%Propagating the particles through the model
particles = A * particles' + w;

particles = particles';

%Making sure everything stays inside the frame
particles(:,1) = min(sizeFrame(2),particles(:,1));
particles(:,1) = max(1,particles(:,1));
particles(:,2) = min(sizeFrame(1),particles(:,2));
particles(:,2) = max(1,particles(:,2));



end

