function rows = C_dev_ring_rows_generic(points, angles, rings, fixed)

    % account for no fixed input
    if nargin < 5
        fixed = [];
    end

    % dimensions
    num_points = size(points, 1);    
    num_rings = size(rings, 1);
    num_fixed = max(size(fixed));
    num_active_points = num_points - num_fixed;

    % compute indices into Jacobian considering fixed node columns gone
    J_ind = J_index(fixed, num_points);

    %%
    % initialize J
    rows = zeros(num_rings, 2*num_active_points);

    % compute and store each set of 1-ring gradients
    % loop through rings
    for i = 1:num_rings

        % loop through all angles in this ring
        for j = rings(i,1):rings(i,2)
            
            % compute gradient of this angle (assume proper node order)
            this_grad = angle_grad(points(angles(j,1),:), points(angles(j,2),:), points(angles(j,3),:));
            
            % get node indices of this angle            
            nodes = [(angles(j,1)-1)*2+1 (angles(j,2)-1)*2+1 (angles(j,3)-1)*2+1];
            
            % store this gradient of this angle
            for z = 1:3
                if J_ind(nodes(z)) > 0
                    rows(i,J_ind(nodes(z)):J_ind(nodes(z))+1) = rows(i,J_ind(nodes(z)):J_ind(nodes(z))+1) + this_grad(z,:);
                end
            end
        
        end
        
    end
end

