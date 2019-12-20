function costMatrixC = chi2_cost(ShapeDescriptors1,ShapeDescriptors2)

%Make sure sizes match
if(size(ShapeDescriptors1,2) ~= size(ShapeDescriptors2,2))
    error ('not matching sizes')
end

%Make sure sizes match
if(size(ShapeDescriptors1,1) ~= size(ShapeDescriptors2,1))
    error ('Sizes Match, but result will not be square')
end

%Initialize Cost function
costMatrixC = zeros(size(ShapeDescriptors1,1), size(ShapeDescriptors2,1));

%Looping through all the shape descriptors 
for i = 1:size(ShapeDescriptors1,1)
    for j = 1:size(ShapeDescriptors2,1)
        %Looping through all the dimensions
        for k = 1:size(ShapeDescriptors1,2)
            %the 0.000001 just to make sure we don't devide by zero
            costMatrixC(i,j) = costMatrixC(i,j) + 0.5 * ((ShapeDescriptors1(i,k)-ShapeDescriptors2(j,k))^2 /(ShapeDescriptors1(i,k)+ShapeDescriptors2(j,k)+0.0001)) ;
        end
    end
end

end

