function angles = make_angles(faces)

    num_face_sets = length(faces);
    
    angles = [];
    for i = 1:num_face_sets
        
        these_faces = faces{i};
        
        for j = 1:size(these_faces,1)
            
            a = these_faces(j,:)';
            b = circshift(these_faces(j,:)', -1);
            c = circshift(these_faces(j,:)', 1);
            
            angles = [angles; a b c];
            
        end
        
    end
    
end

