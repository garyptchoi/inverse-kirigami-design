function [R, T, L, B] = find_boundary_points(pointsD, free)
% use common extreme x,y values to determine boundaries

    % find points on the boundary
    [free_points, index] = sortrows(pointsD(free,:));
    
    L = free(index(free_points(:,1) == free_points(1,1)));
    R = free(index(free_points(:,1) == free_points(end,1)));
        
    free_points = pointsD(free,:);
    free_points = free_points(:,[2 1]);
    [free_points, index] = sortrows(free_points);
    
    B = free(index(free_points(:,1) == free_points(1,1)));
    T = free(index(free_points(:,1) == free_points(end,1)));
    
end

