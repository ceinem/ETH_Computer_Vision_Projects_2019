% Generate initial values for the K
% covariance matrices

function cov = generate_cov(LAB_range, K)

cov = zeros(3,3,K);
for i=1:K
    cov(:,:,i) = diag((LAB_range(:,1)-LAB_range(:,2)).*rand(3,1) + LAB_range(:,2));
end

end