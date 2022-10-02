function [R, J] = overlap_constraint(points, angles)

    if isempty(angles)
        R = zeros(size(angles,1),1);
        J = zeros(size(angles,1), size(points,1)*2);
        % follow matlab fmincon conventions
        R = -R';
        J = -J';
        return;
    end
    
    % residual
    a = points(angles(:,1),:);
    b = points(angles(:,2),:);
    c = points(angles(:,3),:);
    R = (b(:,1)-a(:,1)).*(c(:,2)-a(:,2)) - (b(:,2)-a(:,2)).*(c(:,1)-a(:,1));
    
    % jacobian
    a_ind = 2*(angles(:,1)-1)+1;
    b_ind = 2*(angles(:,2)-1)+1;
    c_ind = 2*(angles(:,3)-1)+1;
    row = [1:size(angles,1),1:size(angles,1),1:size(angles,1),...
        1:size(angles,1),1:size(angles,1),1:size(angles,1)]';
    col = [a_ind; b_ind; c_ind; a_ind+1; b_ind+1; c_ind+1];
    val = [b(:,2)-c(:,2); c(:,2)-a(:,2); a(:,2)-b(:,2); ...
         c(:,1)-b(:,1); a(:,1)-c(:,1); b(:,1)-a(:,1)];
    J = full(sparse(row, col, val, size(angles,1), size(points,1)*2));
    
    
    % follow matlab fmincon conventions
    R = -R';
    J = -J';

end

