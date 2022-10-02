function [points, topos] = consolidate_cells(points, topos)
% finds and remove redundant positions in points from points and topos
    
    % scan positions
    num_points = size(points,1);        
    num_topos = size(topos,1);
    
    num_redundant = 0;
    ind = 1;
    while ind < num_points - num_redundant   
        
        % compare this position with all positions of higher index
        dists = sum((points(ind+1:num_points-num_redundant,:) - repmat(points(ind,:), num_points-num_redundant-ind, 1)).^2,2);
        [dists, order] = sort(dists);
        order = order + ind;
        
        % get the redundant indices
        redundant = order(dists < .00001);
        redundant = flipud(sort(redundant));        
        
        
        % swap all redundant nodes to the end of the valid nodes (in place)
        for i = 1:length(redundant)
            
            % swap to position
            swap = num_points - num_redundant - i + 1;
            
            % swap the positions in place
            points([redundant(i) swap],:) = points([swap redundant(i)],:);
            
            % swap node indices in topo structures
            for j = 1:num_topos                
                topos{j,1}(topos{j,1} == redundant(i)) = ind;   
                topos{j,1}(topos{j,1} == swap) = redundant(i);
            end            
            
        end 
        
        
        % increment index
        ind = ind + 1;
        num_redundant = num_redundant + length(redundant);
        
        
    end
    
    % delete the redundant nodes from points
    points((num_points-num_redundant+1):num_points,:) = [];
    
    % remove redundant topos (some topos will have duplicates due to
    % overlapping unit cells)
    for j = 1:num_topos
        if topos{j,2} == 1
            %[dup, index] = sortrows(sort(topos{j,1},2)); % sort to find differences
            [dup, index] = sortrows(topos{j,1}); % sortrows to find differences            
            topos{j,1} = topos{j,1}(index, :); % reorder raw structure by sort
            
            % delete redundant locations
            overlap = find(sum(logical(diff(dup,1)),2) == 0)+1;
            topos{j,1}(overlap,:) = []; 
            index(overlap) = [];
            [~,rev_index] = sort(index);
            
            % recover the original order of topos
            topos{j,1} = topos{j,1}(rev_index,:);
            
        end
    end    
    
end

