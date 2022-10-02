% Compute the residual and jacobian of all equality and inequality constraints
%
% Equality constraints:
% - boundary shape matching
% - edge length
% - angle sum
% - rectangular boundary angle constraint (if applicable)
% - rectangular boundary side length constraint (if applicable)
% 
% Inequality constraints:
% - non-overlap

function [R_ineq, R, J_ineq, J] = all_constraint_residual_and_jacobian(...
    points, edges, edge_pairs, angles, rings, boundary_rings, bounds, splines, overlap_angles, ...
    fixed, rectangular_ratio, edges_bottom, edges_right, edges_top, edges_left)

    % compute boundary constraint residuals + Jacobian
    [R_boundary, C_boundary] = target_constraint(points, bounds, splines);
    
    % put residuals together
    R = [R_edge_pairs(points, edges, edge_pairs); ... % for edge length constraint
         R_dev_rings_generic(points, angles, rings); ... % for angle sum constraint
         R_boundary; ... % for boundary matching constraint
         R_boundary_rings_generic(points, angles, boundary_rings); % angle constraint for rectangular boundary
         ]'; 
     
    % assemble Jacobian
    J = [C_edge_pair_rows(points, edges, edge_pairs, fixed); ...
         C_dev_ring_rows_generic(points, angles, rings, fixed); ...
         C_boundary; ...
         C_boundary_ring_rows_generic(points, angles, boundary_rings, fixed);
         ]'; 

    % overlap is an inequality constraint
    [R_ineq, J_ineq] = overlap_constraint(points, overlap_angles);    
    
    if rectangular_ratio ~= 0
        % also enforce the ratio of the width and height of the contracted rectangular shape
        [R_square, C_square] = square_boundary_constraint(points, edges_bottom, edges_right, rectangular_ratio);
        R = [R, R_square'];
        J = [J, C_square'];
            
        if nargin >= 14
            [R_square, C_square] = square_boundary_constraint(points, edges_top, edges_left, rectangular_ratio);
            R = [R, R_square'];
            J = [J, C_square'];

            [R_square, C_square] = square_boundary_constraint(points, edges_top, edges_bottom, 1);
            R = [R, R_square'];
            J = [J, C_square'];
        end
        
    end
end

