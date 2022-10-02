function overlapD = find_overlap_angles(face_setsD, all_adjs, intervals)

    overlapD = [];

    for i = 1:size(all_adjs,1)
        
        % get the two faces
        face1 = face_setsD{intervals(all_adjs(i,1),1)}(intervals(all_adjs(i,1),2),:);
        face2 = face_setsD{intervals(all_adjs(i,2),1)}(intervals(all_adjs(i,2),2),:);
        
        % find the common node
        pivot = intersect(face1, face2);
        
        if ~isempty(pivot)

            % find the other nodes in face1
            overlapD = [overlapD; pivot face1(circshift(face1 == pivot, [0 -1])) face2(circshift(face2 == pivot, [0 1]))];
            overlapD = [overlapD; pivot face2(circshift(face2 == pivot, [0 -1])) face1(circshift(face1 == pivot, [0 1]))];

        end
                                        
    end


end

