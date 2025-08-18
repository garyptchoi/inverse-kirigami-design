% compute regularization energy by examining length and angle differences
% between the "same" faces in adjacent unit cells
function E = E_regularization_3D(pointsD, face_setsD, same_face_adjs)

    
    % for each pair of "same" faces    
    E = 0;
    total_num_pairs = 0;
    for i = 1:length(same_face_adjs)        
       
        for j = 1:size(same_face_adjs{i},1)
        
            % get the face indices of this pair
            face1 = face_setsD{i}(same_face_adjs{i}(j,1),:);
            face2 = face_setsD{i}(same_face_adjs{i}(j,2),:);

            % compute edge length differences
            E = E + sum((sqrt(sum((pointsD(face1,:) - pointsD(circshift(face1, [0 -1]),:)).^2, 2)) - ...
                         sqrt(sum((pointsD(face2,:) - pointsD(circshift(face2, [0 -1]),:)).^2, 2))).^2);

            % compute angle differences
            center1 = pointsD(face1,:);
            a1 = pointsD(circshift(face1, [0 -1]),:);
            b1 = pointsD(circshift(face1, [0 1]),:);
            angles1 = arrayfun(@(x)atan2_angle_3D(center1(x,:), a1(x,:), b1(x,:)), 1:length(face1));

            center2 = pointsD(face2,:);
            a2 = pointsD(circshift(face2, [0 -1]),:);
            b2 = pointsD(circshift(face2, [0 1]),:);
            angles2 = arrayfun(@(x)atan2_angle_3D(center2(x,:), a2(x,:), b2(x,:)), 1:length(face2));

            E = E + sum((angles1 - angles2).^2);                        
            

        end
        
        total_num_pairs = total_num_pairs + size(same_face_adjs{i},1);
        
    end
    
    % normalize by number of faces
    E = E/total_num_pairs;
    

end

