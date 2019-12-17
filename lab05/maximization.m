function [mu, var, alpha] = maximization(P, X)

K = size(P,2);
N = size(X,1);
alpha = zeros(K,1);
mu = zeros(K,3);
var = zeros(3,3,K);


for k = 1:K
    total_Ik = sum(P(:,k));
    total_Iluk = 0;
    
    alpha(k) =  total_Ik / N;
    mu(k,:) = sum(X(:,:) .* (P(:,k) * ones(1,3))) /total_Ik;
    
    for l = 1:N
        total_Iluk = total_Iluk  + (P(l,k) * (X(l,:) - mu(k,:))' * (X(l,:) - mu(k,:)))/total_Ik;  
    end
     var(:,:,k) = total_Iluk;
end
end