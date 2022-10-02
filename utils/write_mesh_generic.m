function [] = write_mesh_generic(filename, points, face_sets)

    fid = fopen(filename, 'w');
    
    num_faces = 0;
    
    for i = 1:length(face_sets)
        num_faces = num_faces + size(face_sets{i},1);
    end
    
    fprintf(fid, '# %d vertices, %d faces\n', size(points,1), num_faces);
    
    for i = 1:size(points,1)
        fprintf(fid, 'v %.20g %.20g 0\n', points(i,1), points(i,2));
    end
    
    for z = 1:length(face_sets)
        
        faces = face_sets{z};
        
        for i = 1:size(faces,1)
            fprintf(fid, 'f ');
            for j = 1:size(faces,2)
                fprintf(fid, '%d// ', faces(i,j));
            end
            fprintf(fid, '\n');
        end
    
    end
    
    
    
    fclose(fid);
    
end

