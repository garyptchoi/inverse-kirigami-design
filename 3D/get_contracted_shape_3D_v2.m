% intervals: mx2, first column is index to set in face_sets, second column
% is index into face in that set
function points0 = get_contracted_shape_3D_v2(pointsD, face_sets, intervals, face_adjs, Dto0)

    % initialize pattern points
    points0 = zeros(max(Dto0),2);
    pointsD_flattened = zeros(length(pointsD), 2);
    
    % get and place the first face
    face1 = face_sets{intervals(face_adjs(1,1),1)}(intervals(face_adjs(1,1),2),:);

    pointsD_flattened(face1,:) = flatten_triangle(pointsD(face1,:));
    points0(Dto0(face1),:) = pointsD_flattened(face1,:);
    
    %%
    for i = 1:size(face_adjs,1)

        % get the indices in deployed space of these two faces
        face1 = face_sets{intervals(face_adjs(i,1),1)}(intervals(face_adjs(i,1),2),:);
        face2 = face_sets{intervals(face_adjs(i,2),1)}(intervals(face_adjs(i,2),2),:);

        % find node indices of contact between these two faces
        intersection = intersect(Dto0(face1),Dto0(face2));
        % intersection should contain 2 points
        % take the first point as the common point
        fixed_pointD = face1(Dto0(face1) == intersection(1));
        fixed_pointD2 = face2(Dto0(face2) == intersection(1));

        pointsD_flattened(face2,:) = flatten_triangle(pointsD(face2,:));
    
        % translate face2 points into place
        translation_vector = points0(Dto0(fixed_pointD),:) - pointsD_flattened(fixed_pointD2,:); 
        points0_face2 = pointsD_flattened(face2,:) + repmat(translation_vector,length(face2),1);
       
        % rotate with respect to the common point to match the edge
        shift_to_origin = points0(intersection(1),:);
        points0_face1 = points0(Dto0(face1),:) - repmat(shift_to_origin, length(face1),1);
        points0_face2 = points0_face2 - repmat(shift_to_origin, length(face2),1);
        
        rotation_node_1 = points0_face1((Dto0(face1) == intersection(2)),:);       
        rotation_node_2 = points0_face2((Dto0(face2) == intersection(2)),:);
        
        Rotation_angle = -atan2_angle([0, 0], rotation_node_1, rotation_node_2);  
        R = twoD_rotation(Rotation_angle);

        points0_face2 = (R*points0_face2')';
        points0_face2 = points0_face2 + repmat(shift_to_origin, length(face2),1);
        
        for t = 1:length(face2)
            % see if the coorindates have already been set
            if points0(Dto0(face2(t)),1)==0 && points0(Dto0(face2(t)),2)==0
              % new point, can safely set
              points0(Dto0(face2(t)),:) = points0_face2(t,:);
            end
        end
        
    end
    
    % convert face_sets to pattern space before drawing
    face_sets0 = {};
    for i = 1:length(face_sets)       
        face_sets0{i} = Dto0(face_sets{i});        
    end
    

end




