function R = R_boundary_rings_generic(points, angles, rings)

    % rings: n x 2, the second column contains the target angle (e.g. pi)
    % dimensions    
    num_rings = size(rings, 1);
    
    % initialize R
    R = zeros(num_rings,1);
    
    % compute and store each set of boundary ring residuals 
    for i = 1:num_rings
        
        % loop through angles in this ring
        for j = 1:length(rings{i,1})
            
            % compute this angle            
            this_angle = atan2_angle(points(angles(rings{i,1}(j),1),:), ...
                                     points(angles(rings{i,1}(j),2),:), ...
                                     points(angles(rings{i,1}(j),3),:));          
            
            % store this angle
            R(i) = R(i) + this_angle;
            
        end
        
        % store this angle
        R(i) = R(i) - rings{i,2};
        
    end    
        
end

