function edges = make_edges(faces)
% if called on a deployed set of faces, should have no duplicates

    % make edges
    num_face_sets = length(faces);
    
    edges = [];
    for i = 1:num_face_sets
        
        these_faces = faces{i};
        
        for j = 1:size(these_faces,1)
            
            a = these_faces(j,:)';
            b = circshift(these_faces(j,:)', -1);
            
            edges = [edges; a b];
            
        end
        
    end
        
    
    
    % remove redundant edges
    edges(edges(:,1) > edges(:,2),:) = edges(edges(:,1) > edges(:,2),[2 1]); % higher index in second row
    edges = sortrows(edges);
    diff_edges = [1 1; diff(edges)];
    edges(sum(diff_edges == 0,2) == 2, :) = [];    
    
end

