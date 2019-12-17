function [map cluster] = EM(img)

% use function generate_mu to initialize mus
% use function generate_cov to initialize covariances

% iterate between maximization and expectation
% use function maximization
% use function expectation

img = double(img);
L = size(img,1)*size(img,2);
X = reshape(img,[L,3]);

%number of segments
K = 5;

%Range of the L*a*b space
LAB_range = [max(X(:,1)), min(X(:,1));
             max(X(:,2)), min(X(:,2));
             max(X(:,3)), min(X(:,3))];

%Initial params
alpha = 1/K * ones(1,K);
mu = generate_mu(LAB_range, K);
cov = generate_cov(LAB_range, K);
 

% EM Iterations

while true
    old_mu = mu;
    %Expectation
    P = expectation(mu,cov,alpha,X);
    
    %Maximization
    [mu, cov, alpha] = maximization(P, X);
        
    disp(norm(mu(:)-old_mu(:)));
    
    %Breaking criteria
    if norm(mu(:)-old_mu(:)) < 0.6
        break;
    end
    
end

[~,map] = max(P,[],2);
map = reshape(map,size(img(:,:,1)));
cluster = mu';

mu
cov
alpha


end