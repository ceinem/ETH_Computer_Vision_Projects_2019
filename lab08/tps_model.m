function [w_x,w_y,E] = tps_model(X,Y,lambda)

    %Compute K
    K = dist2(X,X).*log(dist2(X,X));
    K(isnan(K)) = 0;

    %Assemble system of equations
    N = size(X,1);
    P = [ones(N,1), X];

    A = [K+lambda*eye(N), P; 
    P', zeros(3,3)];


    b_x = [Y(:,1);0;0;0];
    b_y = [Y(:,2);0;0;0];

    %Compute the weights
    w_x = A\b_x ;
    w_y = A\b_y ;

    %Compute bending energy
    omega_x = w_x(1:N);
    omega_y = w_y(1:N);
    E = omega_x'*K*omega_x + omega_y'*K*omega_y;
end

% function U = U(t)
%  if(t==0) 
%      U = 0;
%  else
%      U = t^2 * log(t^2);
%  end
% end


