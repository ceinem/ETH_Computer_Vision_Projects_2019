function [particles, particles_w] = resample(particles,particles_w)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here


N = length(particles);
%weighted sampling with replacement of the particles





sample_id = randsample(1:size(particles), N, true,particles_w);
particles = particles(sample_id,:);
particles_w = particles_w(sample_id,:);
particles_w = particles_w ./sum(particles_w);
end

