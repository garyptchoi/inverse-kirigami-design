function [R, J] = quad_planarity_constraint_3D(points, quads)

    nq = size(quads,1);
    
    a = points(quads(:,1),:);
    b = points(quads(:,2),:);
    c = points(quads(:,3),:);
    d = points(quads(:,4),:);
    
    R1 = [(b(:,2)-a(:,2)).*(c(:,3)-a(:,3)) - (b(:,3)-a(:,3)).*(c(:,2)-a(:,2)),...
         (b(:,3)-a(:,3)).*(c(:,1)-a(:,1)) - (b(:,1)-a(:,1)).*(c(:,3)-a(:,3)),...
         (b(:,1)-a(:,1)).*(c(:,2)-a(:,2)) - (b(:,2)-a(:,2)).*(c(:,1)-a(:,1))];
    
    R2 = d - a;
    
    % volume
    R = R1(:,1).*R2(:,1) + R1(:,2).*R2(:,2) + R1(:,3).*R2(:,3);
     
    % jacobian
    a_ind = 3*(quads(:,1)-1)+1;
    b_ind = 3*(quads(:,2)-1)+1;
    c_ind = 3*(quads(:,3)-1)+1;
    d_ind = 3*(quads(:,4)-1)+1;
    row = [1:nq,1:nq,1:nq,1:nq,...
           1:nq,1:nq,1:nq,1:nq, ...
           1:nq,1:nq,1:nq,1:nq]';
    
    col = [a_ind; b_ind; c_ind; d_ind; a_ind+1; b_ind+1; c_ind+1; d_ind+1; a_ind+2; b_ind+2; c_ind+2; d_ind+2];
    
    % take derivatives wrt all variables, use product rule
    val = [(c(:,3)-b(:,3)).*R2(:,2) + (b(:,2)-c(:,2)).*R2(:,3) - R1(:,1); ...
           (a(:,3)-c(:,3)).*R2(:,2) + (c(:,2)-a(:,2)).*R2(:,3); ...
           (b(:,3)-a(:,3)).*R2(:,2) + (a(:,2)-b(:,2)).*R2(:,3); ...
           R1(:,1); ...
           
           (b(:,3)-c(:,3)).*R2(:,1) + (c(:,1)-b(:,1)).*R2(:,3) - R1(:,2); ...
           (c(:,3)-a(:,3)).*R2(:,1) + (a(:,1)-c(:,1)).*R2(:,3); ...
           (a(:,3)-b(:,3)).*R2(:,1) + (b(:,1)-a(:,1)).*R2(:,3); ...
           R1(:,2); ...
           
           (c(:,2)-b(:,2)).*R2(:,1) + (b(:,1)-c(:,1)).*R2(:,2) - R1(:,3); ...
           (a(:,2)-c(:,2)).*R2(:,1) + (c(:,1)-a(:,1)).*R2(:,2); ...
           (b(:,2)-a(:,2)).*R2(:,1) + (a(:,1)-b(:,1)).*R2(:,2); ...
           R1(:,3)];
        
    J = full(sparse(row, col, val, nq, size(points,1)*3));
    
    
    
end

