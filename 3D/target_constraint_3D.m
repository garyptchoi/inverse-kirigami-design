function [R, J] = target_constraint_3D(points, target_surface_points, target_surface_tri)
% compute 2-norm of deployed boundary points from target shape


    % initilize residual    
    J = sparse([],[],[], length(points), size(points,1)*3);
    
    % for each boundary
        
    points(isnan(points(:,1)),1) = 0;
    points(isnan(points(:,2)),2) = 0;
    points(isnan(points(:,3)),3) = 0;
    points(~isfinite(points(:,1)),1) = 0;
    points(~isfinite(points(:,2)),2) = 0;
    points(~isfinite(points(:,3)),3) = 0;
    
    [ ~, surface_points] = point2trimesh('Faces', target_surface_tri, ...
        'Vertices', target_surface_points, 'QueryPoints', points, 'Algorithm', 'vectorized');

    % compute gradients
    these_grads = surface_points - points;

    % compute distances
    these_dists = (sum(these_grads.^2, 2));

    % constraint functions should be regular points when satisfied
    these_grads = -2*these_grads;

    % avoid division by 0
    these_grads(isnan(these_grads)) = 0;

    % store residuals
    R = these_dists;
        
     
    iii = [1:length(points),1:length(points),1:length(points)]';
    jjj = [3*(1:length(points))' - 2; 3*(1:length(points))' - 1; 3*(1:length(points))'];
    kkk = [these_grads(:,1); these_grads(:,2); these_grads(:,3)];
    J = J + sparse(iii, jjj, kkk, size(J,1), size(J,2));

    J = full(J);
end

