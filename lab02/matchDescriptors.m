% Match descriptors.
%
% Input:
%   descr1        - k x q descriptor of first image
%   descr2        - k x q' descriptor of second image
%   matching      - matching type ('one-way', 'mutual', 'ratio')
%   
% Output:
%   matches       - 2 x m matrix storing the indices of the matching
%                   descriptors
function matches = matchDescriptors(descr1, descr2, matching)
    %compute the SSD
    distances = ssd(descr1, descr2);
    
    %get the number of descriptors
    [~, num_descr_1] = size(descr1);
    
    matches = [];
    
    if strcmp(matching, 'one-way')
        %Itterate through each Descriptor for image 1
        for i = 1:num_descr_1
            % search the corresponding descriptor in image 2 with the
            % lowest SSD and get it's index
            [~, match_2] = min(distances(i,:));
            %add both indices to the matches list
            matches = [matches [i; match_2]];
        end
        %error('Not implemented.');    
    elseif strcmp(matching, 'mutual')
        %error('Not implemented.');
        %Itterate through each Descriptor for image 1
        for i = 1:num_descr_1
            
            %get the descriptor from image 2, that matches to image 1
            [~, match_2] = min(distances(i,:));
            % for the descriptor from image 2, get the descriptor that
            % matches it back to image 1
            [~, match_1] = min(distances(:,match_2));
            
            % if the original descriptor from image 1, and the one matched
            % back from image 2 are equal, add them to the matches list
            if(match_1 == i)
                matches = [matches [i; match_2]];
            end
        end
    elseif strcmp(matching, 'ratio')
        %error('Not implemented.');
        %Itterate through each Descriptor for image 1
        for i = 1:num_descr_1
            %get the 2 best matching descriptors from image 2 and their SSD
            %values
            [match_val, match] = mink(distances(i,:),2);
            
            % compute the ratio of the SSD values and check if it's below
            % threshold, if yes, add to list
            if match_val(1)/match_val(2) < 0.5
                matches = [matches [i; match(1)]];
            end
        end
        
    else
        error('Unknown matching type.');
    end
end

function distances = ssd(descr1, descr2)
    %compute the squared euclidian distance between each descriptor pair
    distances = pdist2(descr1', descr2','squaredeuclidean');
end