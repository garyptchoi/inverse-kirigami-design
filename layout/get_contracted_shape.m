% Get the contracted shape of a deployed pattern
% works for quad and hexagon kirigami tessellations
% idea: 
% - start from any face
% - find a common edge with another face
% - glue and then remove it from the face list
% - continue until all faces are glued

function solved_points0 = get_contracted_shape(solved_pointsD, face_setsD, Dto0)
    %%
    % initialize pattern points
    solved_points0 = zeros(max(Dto0),2); % arbitrarily large
    
    % start from the central face
    face_centroid = zeros(length(face_setsD{1}),2);
    for jjj = 1:length(face_setsD{1})
        face_centroid(jjj,:) = sum(solved_pointsD(face_setsD{1}(jjj,:),:),1)/6;
    end
    [~, faceid1] = min(sum(abs([face_centroid(:,1) - mean(face_centroid(:,1)), face_centroid(:,2) - mean(face_centroid(:,2))]).^2,2)); faceid1 = faceid1(1);
    face1 = face_setsD{1}(faceid1,:);
    
    face1 = face_setsD{1}(faceid1,:);
    
    solved_points0(Dto0(face1),:) = solved_pointsD(face1,:);
    
    current_indices0 = unique(Dto0(face1));
    current_indicesD = unique(face1);
    current_faces = faceid1;
    edges = [];
    face = face_setsD{1};
    edges = [edges;reshape(face',size(face,1)*size(face,2),1), ...
        reshape(face(:,[2:end, 1])',size(face,1)*size(face,2),1)];

    
    % count occurence in Dto0
    [occurrence,~] = hist(Dto0,unique(Dto0));
    split_points = find(occurrence>1);
    
    face_handled = faceid1;
    %%
%     figure(10)
%     clf
%     axis equal
%     axis off
%     hold on
%     
%     fill(solved_points0(Dto0(face1),1), solved_points0(Dto0(face1),2), [255 229 204]/255);
    while ~isempty(split_points)
        %% find two points that can be merged
        points_available_for_gluing = intersect(split_points, current_indices0);        
        p0 = points_available_for_gluing(1);
        pD = find(Dto0 == p0);
        pD_old = intersect(pD, current_indicesD);
        pD_old = pD_old(1);
        pD_new = setdiff(pD, pD_old); pD_new = pD_new(1);
        check = 1;
        %% check for some index flip
        while check
            %% find the common edge and hence the common point
            [row1,~] = find(edges == pD(1));
            [row2,~] = find(edges == pD(2));
            fixed_pointD = intersect(edges(row1,:), edges(row2,:));
            fixed_pointD = fixed_pointD(1);
            % find the old face containing the split point and the common point
            [faceid,~] = find(face_setsD{1} == fixed_pointD);
            faceid1 = intersect(faceid, current_faces);
            if isempty(faceid1)
                % handle some exceptional case
                fixed_pointD = intersect(edges(row1,:), edges(row2,:));
                if length(fixed_pointD) > 1
                    fixed_pointD = fixed_pointD(2);
                end
                % find the old face containing the split point and the common point
                [faceid,~] = find(face_setsD{1} == fixed_pointD);
                faceid1 = intersect(faceid, current_faces);
            end
            faceid1 = faceid1(1);

            % find the new face containing the split point and the common point
            faceid2 = setdiff(faceid, faceid1);

            face1 = face(faceid1,:);
            face2 = face(faceid2,:);

            % check flip
            if sum(face2 == pD_new) == 0 || sum(Dto0(face1) == Dto0(pD_old)) == 0
                % flipped pD_old and pD_new
                temp = pD_old;
                pD_old = pD_new;
                pD_new = temp;
            else 
                check = 0;
            end
        end
        
        %% translate to match the common point
        translation_vector = solved_points0(Dto0(fixed_pointD),:) - solved_pointsD(fixed_pointD,:);
        points0_face2 = solved_pointsD(face2,:) + repmat(translation_vector,length(face2),1);

        %% rotate with respect to the common point to match the edge
        shift_to_origin = solved_points0(Dto0(fixed_pointD),:);
        points0_face1 = solved_points0(Dto0(face1),:) - repmat(shift_to_origin, length(face1),1);
        points0_face2 = points0_face2 - repmat(shift_to_origin, length(face2),1);
        
        %% rotate
        Rotation_angle = -atan2_angle(0, points0_face1(Dto0(face1) == Dto0(pD_old),:), points0_face2(face2 == pD_new,:));  
        R = twoD_rotation(Rotation_angle);

        points0_face2 = (R*points0_face2')';
        points0_face2 = points0_face2 + repmat(shift_to_origin, length(face2),1);

        count = ones(length(solved_points0),1);
        for t = 1:length(face2)
            % see if the coorindates have already been set
            if solved_points0(Dto0(face2(t)),1)==0 && solved_points0(Dto0(face2(t)),2)==0
                % new point, can safely set
                solved_points0(Dto0(face2(t)),:) = points0_face2(t,:);
            else 
                % avoid small discrepancy by taking average
                solved_points0(Dto0(face2(t)),:) = (solved_points0(Dto0(face2(t)),:).*count(Dto0(face2(t))) + points0_face2(t,:))./(count(Dto0(face2(t)))+1);
                count(Dto0(face2(t))) = count(Dto0(face2(t))) + 1;
            end
        end

%         fill(solved_points0(Dto0(face2),1), solved_points0(Dto0(face2),2), [255 229 204]/255);


        new_indices0 = unique(Dto0(face2));
        new_indicesD = unique(face2);
        current_indices0 = unique([current_indices0, new_indices0]);
        current_indicesD = unique([current_indicesD, new_indicesD]);
        current_faces = [current_faces, faceid2];

        face_handled = [face_handled, faceid2];
        
        split_points = setdiff(split_points, p0);
        
    end

end




