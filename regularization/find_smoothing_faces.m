% finds pairs of "same" faces in adjacent unit cells
% theses pairs are global indices which can be used in conjuction with 
% intervals to access faces in face_sets[0/D]
function same_face_adjs = find_smoothing_faces(unit_face_sets, width, height)

    % sizes of each face set in unit cells
    unit_face_set_sizes = arrayfun(@(i)size(unit_face_sets{i},1), 1:length(unit_face_sets));
    
    
    % assemble all pairs of tiled versions of the "same" face   
    same_face_adjs = {};
    for i = 1:length(unit_face_set_sizes)
       
        these_same_face_adjs = [];
        
        for j = 1:unit_face_set_sizes(i)
            
           
            % for this unique face in the unit cell, find all other indices
            % of its appearances in the entire pattern
            these_faces = reshape(j:unit_face_set_sizes(i):(width*height*unit_face_set_sizes(i)), width, height)';
            
            % find connected faces
            for k = 1:width-1
                these_same_face_adjs = [these_same_face_adjs; [these_faces(:,k) these_faces(:,k+1)]];
            end
            for k = 1:height-1
                these_same_face_adjs = [these_same_face_adjs; [these_faces(k,:); these_faces(k+1,:)]'];
            end
            
        end
        
        same_face_adjs{i} = these_same_face_adjs;
        
    end   
    
end

