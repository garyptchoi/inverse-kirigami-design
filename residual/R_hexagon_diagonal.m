function R = R_hexagon_diagonal(points, length_edge_list, length_edge_rings, length_angle_list, length_angle_rings)

    % to guarantee that the hex rings form a closed loop, 
    % we make use of information in the deployed space and 
    % compute the diagonal in the contracted space in 2 ways.
    % If the loop is closed then the two ways should give the same
    % diagonal.

    % dimensions
    num_points = size(points, 1);
    num_rings = size(length_edge_rings, 1);
    
    % initialize R
    R = zeros(num_rings,1);
    
    % compute the diagonal in two ways
    % form of residual is diagonal1 - diagonal2 = 0
    for i = 1:num_rings
        angles = length_angle_list(length_angle_rings(i,1):length_angle_rings(i,2),:);
        edges = length_edge_list(length_edge_rings(i,1):length_edge_rings(i,2),:);
        
        alpha = 2*pi - atan2_angle(points(angles(1,1),:), points(angles(1,2),:), points(angles(1,3),:)) - atan2_angle(points(angles(2,1),:), points(angles(2,2),:), points(angles(2,3),:)); 
        beta  = 2*pi - atan2_angle(points(angles(3,1),:), points(angles(3,2),:), points(angles(3,3),:)) - atan2_angle(points(angles(4,1),:), points(angles(4,2),:), points(angles(4,3),:)); 
        gamma = 2*pi - atan2_angle(points(angles(5,1),:), points(angles(5,2),:), points(angles(5,3),:)) - atan2_angle(points(angles(6,1),:), points(angles(6,2),:), points(angles(6,3),:)); 
        delta = 2*pi - atan2_angle(points(angles(7,1),:), points(angles(7,2),:), points(angles(7,3),:)) - atan2_angle(points(angles(8,1),:), points(angles(8,2),:), points(angles(8,3),:)); 
        
        a = sqrt(sum((points(edges(1,2), :) - points(edges(1,1), :)).^2,2));
        b = sqrt(sum((points(edges(2,2), :) - points(edges(2,1), :)).^2,2));
        c = sqrt(sum((points(edges(3,2), :) - points(edges(3,1), :)).^2,2));
        d = sqrt(sum((points(edges(4,2), :) - points(edges(4,1), :)).^2,2));
        e = sqrt(sum((points(edges(5,2), :) - points(edges(5,1), :)).^2,2));
        f = sqrt(sum((points(edges(6,2), :) - points(edges(6,1), :)).^2,2));

        diag1 = (a - b*sin(beta)/sin(alpha+beta))^2 + (c - b*sin(alpha)/sin(alpha+beta))^2 + 2*(a - b*sin(beta)/sin(alpha+beta))*(c - b*sin(alpha)/sin(alpha+beta))*cos(alpha+beta);
        diag2 = (d - e*sin(delta)/sin(gamma+delta))^2 + (f - e*sin(gamma)/sin(gamma+delta))^2 + 2*(d - e*sin(delta)/sin(gamma+delta))*(f - e*sin(gamma)/sin(gamma+delta))*cos(gamma+delta);
        
        R(i) = diag1 - diag2;
    end   
end

