function [R, J] = overlap_constraint_3D(points, overlap_angles, angles)
    % extension of the 2D overlap constraint for 3D
    % avoid plane intersections
    
    if isempty(overlap_angles)
        R = zeros(size(overlap_angles,1),1);
        J = zeros(size(overlap_angles,1), size(points,1)*3);
        % follow matlab fmincon conventions
        R = -R';
        J = -J';
        return;
    end
    
    %% 
    % a = points(overlap_angles(:,1),:);
    % b = points(overlap_angles(:,2),:);
    % c = points(overlap_angles(:,3),:);
    % d: the 4th point on the second face
    % idea: use (b-a x c-a).(c-a x d-a) > 0
    
    overlap_angles = [overlap_angles, zeros(length(overlap_angles),1)];
    for i = 1:length(overlap_angles)
        id = angles(:,1) == overlap_angles(i,1) & angles(:,2) == overlap_angles(i,3);
        overlap_angles(i,4) = angles(id,3);
    end
    
    a = points(overlap_angles(:,1),:);
    b = points(overlap_angles(:,2),:);
    c = points(overlap_angles(:,3),:);
    d = points(overlap_angles(:,4),:);
    
    
    num = size(overlap_angles,1);
    
    R1 = [(b(:,2)-a(:,2)).*(c(:,3)-a(:,3)) - (b(:,3)-a(:,3)).*(c(:,2)-a(:,2)),...
         (b(:,3)-a(:,3)).*(c(:,1)-a(:,1)) - (b(:,1)-a(:,1)).*(c(:,3)-a(:,3)),...
         (b(:,1)-a(:,1)).*(c(:,2)-a(:,2)) - (b(:,2)-a(:,2)).*(c(:,1)-a(:,1))];
    
    R2 = [(c(:,2)-a(:,2)).*(d(:,3)-a(:,3)) - (c(:,3)-a(:,3)).*(d(:,2)-a(:,2)),...
         (c(:,3)-a(:,3)).*(d(:,1)-a(:,1)) - (c(:,1)-a(:,1)).*(d(:,3)-a(:,3)),...
         (c(:,1)-a(:,1)).*(d(:,2)-a(:,2)) - (c(:,2)-a(:,2)).*(d(:,1)-a(:,1))];
    
    R = R1(:,1).*R2(:,1) + R1(:,2).*R2(:,2) + R1(:,3).*R2(:,3);
     
    % jacobian
    a_ind = 3*(overlap_angles(:,1)-1)+1;
    b_ind = 3*(overlap_angles(:,2)-1)+1;
    c_ind = 3*(overlap_angles(:,3)-1)+1;
    d_ind = 3*(overlap_angles(:,4)-1)+1;
    row = [1:num,1:num,1:num,1:num,...
           1:num,1:num,1:num,1:num, ...
           1:num,1:num,1:num,1:num]';
    
    col = [a_ind; b_ind; c_ind; d_ind; a_ind+1; b_ind+1; c_ind+1; d_ind+1; a_ind+2; b_ind+2; c_ind+2; d_ind+2];
    val = [(c(:,3)-b(:,3)).*R2(:,2) + (b(:,2)-c(:,2)).*R2(:,3) + (d(:,3)-c(:,3)).*R1(:,2) + (c(:,2)-d(:,2)).*R1(:,3); ...
           (a(:,3)-c(:,3)).*R2(:,2) + (c(:,2)-a(:,2)).*R2(:,3); ...
           (b(:,3)-a(:,3)).*R2(:,2) + (a(:,2)-b(:,2)).*R2(:,3) + (a(:,3)-d(:,3)).*R1(:,2) + (d(:,2)-a(:,2)).*R1(:,3); ...
           (c(:,3)-a(:,3)).*R1(:,2) + (a(:,2)-c(:,2)).*R1(:,3); ...
           
           (b(:,3)-c(:,3)).*R2(:,1) + (c(:,1)-b(:,1)).*R2(:,3) + (c(:,3)-d(:,3)).*R1(:,1) + (d(:,1)-c(:,1)).*R1(:,3); ...
           (c(:,3)-a(:,3)).*R2(:,1) + (a(:,1)-c(:,1)).*R2(:,3); ...
           (a(:,3)-b(:,3)).*R2(:,1) + (b(:,1)-a(:,1)).*R2(:,3) + (d(:,3)-a(:,3)).*R1(:,1) + (a(:,1)-d(:,1)).*R1(:,3); ...
           (a(:,3)-c(:,3)).*R1(:,1) + (c(:,1)-a(:,1)).*R1(:,3); ...
           
           (c(:,2)-b(:,2)).*R2(:,1) + (b(:,1)-c(:,1)).*R2(:,2) + (d(:,2)-c(:,2)).*R1(:,1) + (c(:,1)-d(:,1)).*R1(:,2); ...
           (a(:,2)-c(:,2)).*R2(:,1) + (c(:,1)-a(:,1)).*R2(:,2); ...
           (b(:,2)-a(:,2)).*R2(:,1) + (a(:,1)-b(:,1)).*R2(:,2) + (a(:,2)-d(:,2)).*R1(:,1) + (d(:,1)-a(:,1)).*R1(:,2); ...
           (c(:,2)-a(:,2)).*R1(:,1) + (a(:,1)-c(:,1)).*R1(:,2)];
        
    J = full(sparse(row, col, val, num, size(points,1)*3));
    
    % follow matlab fmincon conventions
    R = -R';
    J = -J';
    
    
end
    
    