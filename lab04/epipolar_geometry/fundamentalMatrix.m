% Compute the fundamental matrix using the eight point algorithm
% Input
% 	x1s, x2s 	Point correspondences 3xN
%
% Output
% 	Fh 		Fundamental matrix with the det F = 0 constraint
% 	F 		Initial fundamental matrix obtained from the eight point algorithm
%
function [Fh, F] = fundamentalMatrix(x1s, x2s)

%Normalize Points
[nx1s, T_1] = normalizePoints2d(x1s);
[nx2s, T_2] = normalizePoints2d(x2s);

x_1 = nx1s(1,:);
x_2 = nx2s(1,:);
y_1 = nx1s(2,:);
y_2 = nx2s(2,:);

M = [x_1 .* x_2;
    y_1 .* x_2;
    x_2;
    y_2 .* x_1;
    y_1 .* y_2;
    y_2;
    x_1;
    y_1;
    ones(1,size(nx1s,2))]';

[A, B, V] = svd(M);
%nF_vec = V(:,end);
%nF = [nF_vec(1:3,1)' ; nF_vec(4:6,1)' ; nF_vec(7:9,1)'];

nF = transpose(reshape(V(:,9),[3,3]));

[U,S,V_f] = svd(nF);
S(3,3) = 0;
nFh = U*S*V_f';

F = T_2'*nF*T_1;
Fh = T_2'*nFh*T_1;
end