function R = R_dev_rings_generic_3D(points, angles, rings)

    % dimensions
    num_points = size(points, 1);
    num_rings = size(rings, 1);
    
    % initialize R
    R = zeros(num_rings,1);
    
    % compute and store each set of 1-ring gradients
    % form of residual is angle1 + angle2 + ... - 2*pi = 0
    for i = 1:num_rings
        
        % loop through angles in this ring
        for j = rings(i,1):rings(i,2)
            
            % compute this angle            
            this_angle = atan2_angle_3D(points(angles(j,1),:), points(angles(j,2),:), points(angles(j,3),:));            
            
            % store this angle
            R(i) = R(i) + this_angle;
            
        end
        
    end
    
    % vectorize dev shift
    R = R - 2*pi;
        
end
