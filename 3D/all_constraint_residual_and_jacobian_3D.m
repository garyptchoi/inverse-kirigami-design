% Compute the residual and jacobian of all equality and inequality constraints
% for 3D surface fitting quad kirigami patterns
%
% Equality constraints:
% - edge length
% - angle sum
% - surface matching
% - quad planarity
% - rectangular boundary angle constraint (if applicable)
% - rectangular boundary side length constraint (if applicable)
% 
% Inequality constraints:
% - no plane intersection


function [R_ineq, R, J_ineq, J] = all_constraint_residual_and_jacobian_3D(...
    points, quads, edges, edge_pairs, angles, rings, boundary_rings, ...
    target_surface_points, target_surface_tri, overlap_angles, fixed, ...
    rectangular_ratio, edges_bottom, edges_right, edges_top, edges_left)

    % compute boundary constraint residuals + Jacobian
    [R_boundary, C_boundary] = target_constraint_3D(points, target_surface_points, target_surface_tri);
    [R_planarity, J_planarity] = quad_planarity_constraint_3D(points, quads); 
    
    % put residuals together
    R = [R_edge_pairs(points, edges, edge_pairs); ... % for edge length constraints
         R_dev_rings_generic_3D(points, angles, rings); ... % for angle sum constraint
         R_boundary; ... % for surface matching constraint
         R_planarity; ... % for quad planarity constraint
         R_boundary_rings_generic_3D(points, angles, boundary_rings); ... % angle constraint for rectangular boundary
         ]'; 

    % assemble Jacobian
    J = [C_edge_pair_rows_3D(points, edges, edge_pairs, fixed); ... 
         C_dev_ring_rows_generic_3D(points, angles, rings, fixed); ...
         C_boundary; ...
         J_planarity; ...
         C_boundary_ring_rows_generic_3D(points, angles, boundary_rings, fixed);...
         ]'; 


    % overlap/plane-intersection is an inequality constraint
    [R_ineq, J_ineq] = overlap_constraint_3D(points, overlap_angles, angles);  
    
    
    if rectangular_ratio ~= 0
        % also enforce the ratio of the width and height of the contracted rectangular shape
        [R_square, C_square] = square_boundary_constraint_3D(points, edges_bottom, edges_right, rectangular_ratio);
        R = [R, R_square'];
        J = [J, C_square'];
            
        if nargin >= 15
            [R_square, C_square] = square_boundary_constraint_3D(points, edges_top, edges_left, rectangular_ratio);
            R = [R, R_square'];
            J = [J, C_square'];

            [R_square, C_square] = square_boundary_constraint_3D(points, edges_top, edges_bottom, 1);
            R = [R, R_square'];
            J = [J, C_square'];
        end
        
    end
end

