% Compute the residual and jacobian of all equality and inequality constraints
% for the hexagon kirigami patterns
%
% Equality constraints:
% - boundary shape matching
% - edge length
% - angle sum
% - hexagon diagonal+angle constraint
% - fixed angle constraint 
% 
% Inequality constraints:
% - non-overlap

function [R_ineq, R, J_ineq, J] = all_constraint_residual_and_jacobian_hexagon(...
    points, edges, edge_pairs, angles, rings, boundary_rings, bounds, splines, ...
    overlap_angles, fixed, face, new_angle_list, hex_rings, length_edge_list1, ...
    length_edge_rings1, length_angle_list1, length_angle_rings1, length_edge_list2, ...
    length_edge_rings2, length_angle_list2, length_angle_rings2, length_edge_list3, ...
    length_edge_rings3, length_angle_list3, length_angle_rings3)


    % compute boundary constraint residuals + Jacobian
    [R_boundary, C_boundary] = target_constraint(points, bounds, splines);
    

    R = [R_edge_pairs(points, edges, edge_pairs); ... % edge length constraint
         R_dev_rings_generic_hexagon(points, new_angle_list, hex_rings); ... % angle sum constraint for each hex ring hole
         R_hexagon_diagonal(points, length_edge_list1, length_edge_rings1, length_angle_list1, length_angle_rings1); ... % new length+angle constraint for diagonal
         R_hexagon_diagonal(points, length_edge_list2, length_edge_rings2, length_angle_list2, length_angle_rings2); ... % new length+angle constraint for diagonal
         R_hexagon_diagonal(points, length_edge_list3, length_edge_rings3, length_angle_list3, length_angle_rings3); ... % new length+angle constraint for diagonal
         R_boundary; ... % for boundary matching constraint
         R_boundary_rings_generic(points, angles, boundary_rings)]'; 
    
    % assemble Jacobian
    J = [C_edge_pair_rows(points, edges, edge_pairs, fixed); ... 
         C_dev_ring_rows_generic(points, new_angle_list, hex_rings, fixed); ...
         C_hexagon_diagonal(points, length_edge_list1, length_edge_rings1, length_angle_list1, length_angle_rings1, fixed); ...
         C_hexagon_diagonal(points, length_edge_list2, length_edge_rings2, length_angle_list2, length_angle_rings2, fixed); ...
         C_hexagon_diagonal(points, length_edge_list3, length_edge_rings3, length_angle_list3, length_angle_rings3, fixed); ...
         C_boundary; ...
         C_boundary_ring_rows_generic(points, angles, boundary_rings, fixed)]'; 

    % overlap is an inequality constraint
    [R_ineq, J_ineq] = overlap_constraint(points, overlap_angles);
end

