% compute regularization energy by examining length and angle differences
% between the "same" faces in adjacent unit cells
function J = J_regularization(pointsD, face_setsD, same_face_adjs)

    
    % for each pair of "same" faces 
    J = zeros(1,2*size(pointsD,1));
    total_num_pairs = 0;
    for i = 1:length(same_face_adjs)        
       
        for j = 1:size(same_face_adjs{i},1)
        
            % GET THE PAIR OF FACES
            
            % face 1            
            face1 = face_setsD{i}(same_face_adjs{i}(j,1),:);
            next_face1 = circshift(face1, [0 -1]);
            prev_face1 = circshift(face1, [0 1]);
            
            % face 2           
            face2 = face_setsD{i}(same_face_adjs{i}(j,2),:);
            next_face2 = circshift(face2, [0 -1]);
            prev_face2 = circshift(face2, [0 1]);

            % EDGES
            
            % compute unit edge vectors
            e1 = pointsD(next_face1,:) - pointsD(face1,:);
            e2 = pointsD(next_face2,:) - pointsD(face2,:);
            
            
            % compute edge lengths
            l1 = sqrt(sum(e1.^2, 2));
            l2 = sqrt(sum(e2.^2, 2));
            
                                 
            % normalize edge vectors
            e1 = cell2mat(arrayfun(@(x)e1(x,:)'/l1(x), 1:length(l1), 'UniformOutput', 0))';
            e2 = cell2mat(arrayfun(@(x)e2(x,:)'/l2(x), 1:length(l2), 'UniformOutput', 0))';
                        
            
            
            
            % compute edge length gradients
            face1_length_grads = cell2mat(arrayfun(@(x)2*e1(x,:)'*(l1(x)-l2(x)), 1:length(l1), 'UniformOutput', 0))';
            face2_length_grads = cell2mat(arrayfun(@(x)2*e2(x,:)'*(l2(x)-l1(x)), 1:length(l2), 'UniformOutput', 0))';
            
            
            % store gradients
            
            % face1
            J(reshape([2*face1-1; 2*face1], 1, 2*length(face1))) = J(reshape([2*face1-1; 2*face1], 1, 2*length(face1))) + reshape(-face1_length_grads', 1, 2*length(face1)); 
            J(reshape([2*next_face1-1; 2*next_face1], 1, 2*length(next_face1))) = J(reshape([2*next_face1-1; 2*next_face1], 1, 2*length(next_face1))) + reshape(face1_length_grads', 1, 2*length(next_face1));
            
            % face2
            J(reshape([2*face2-1; 2*face2], 1, 2*length(face2))) = J(reshape([2*face2-1; 2*face2], 1, 2*length(face2))) + reshape(-face2_length_grads', 1, 2*length(face2));           
            J(reshape([2*next_face2-1; 2*next_face2], 1, 2*length(next_face2))) = J(reshape([2*next_face2-1; 2*next_face2], 1, 2*length(next_face2))) + reshape(face2_length_grads', 1, 2*length(next_face2));
            
            
            % ANGLES
            
            
            % compute angle differences
            c1 = pointsD(face1,:);
            a1 = pointsD(circshift(face1, [0 -1]),:);
            b1 = pointsD(circshift(face1, [0 1]),:);
            angles1 = arrayfun(@(x)atan2_angle(c1(x,:), a1(x,:), b1(x,:)), 1:length(face1));

            c2 = pointsD(face2,:);
            a2 = pointsD(circshift(face2, [0 -1]),:);
            b2 = pointsD(circshift(face2, [0 1]),:);
            angles2 = arrayfun(@(x)atan2_angle(c2(x,:), a2(x,:), b2(x,:)), 1:length(face2));
            
            % for each pair of angles
            for k = 1:length(face1)
               
                % compute gradients of angles w.r.t. their nodes
                this_angle_grad1 = angle_grad(c1(k,:), a1(k,:), b1(k,:));
                this_angle_grad2 = angle_grad(c2(k,:), a2(k,:), b2(k,:));
                
                % apply prefactors
                this_angle_grad1 = this_angle_grad1*2*(angles1(k) - angles2(k));
                this_angle_grad2 = this_angle_grad2*2*(angles2(k) - angles1(k));
                
                
                % store these gradients
                J(2*face1(k)-1:2*face1(k)) = J(2*face1(k)-1:2*face1(k)) + this_angle_grad1(1,:);
                J(2*next_face1(k)-1:2*next_face1(k)) = J(2*next_face1(k)-1:2*next_face1(k)) + this_angle_grad1(2,:);
                J(2*prev_face1(k)-1:2*prev_face1(k)) = J(2*prev_face1(k)-1:2*prev_face1(k)) + this_angle_grad1(3,:);
                
                J(2*face2(k)-1:2*face2(k)) = J(2*face2(k)-1:2*face2(k)) + this_angle_grad2(1,:);
                J(2*next_face2(k)-1:2*next_face2(k)) = J(2*next_face2(k)-1:2*next_face2(k)) + this_angle_grad2(2,:);
                J(2*prev_face2(k)-1:2*prev_face2(k)) = J(2*prev_face2(k)-1:2*prev_face2(k)) + this_angle_grad2(3,:);
                
            end            
           
        end        
        
        % for normalization
        total_num_pairs = total_num_pairs + size(same_face_adjs{i},1);
                
    end
    
    % normalize by number of faces
    J = J/total_num_pairs;

end

