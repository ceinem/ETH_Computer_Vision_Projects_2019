% Generate initial values for mu
% K is the number of segments

function mu = generate_mu(LAB_range, K)

mu = zeros(K,3);
for i = 1:K
    mu(i,:) = (LAB_range(:,1)-LAB_range(:,2)).*rand(3,1) + LAB_range(:,2);
end


end