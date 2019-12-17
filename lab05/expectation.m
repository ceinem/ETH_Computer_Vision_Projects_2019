function P = expectation(mu,var,alpha,X)

K = length(alpha);
N = size(X,1);
P = zeros(N,K);

for i = 1:N
    for k = 1:K
        P(i,k) = alpha(k) / ((2 * pi)^(3/2) * det(var(:,:,k))^(1/2)) *...
            exp(-0.5*(X(i,:) - mu(k,:)) * pinv(var(:,:,k)) * (X(i,:) - mu(k,:))');  
    end  
    P(i,:) = P(i,:)/sum(P(i,:));
end



end