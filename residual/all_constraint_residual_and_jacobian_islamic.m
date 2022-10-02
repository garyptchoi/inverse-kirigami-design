% Compute the residual and jacobian of all equality and inequality constraints
% for the ancient islamic triangle and quad kirigami patterns
%
% Equality constraints:
% - boundary shape matching
% - edge length
% - angle sum
% - fixed angle constraint
% 
% Inequality constraints:
% - non-overlap

function [R_ineq, R, J_ineq, J] = all_constraint_residual_and_jacobian_islamic(...
    points, edges, edge_pairs, angles, rings, boundary_rings, bounds, splines, overlap_angles, ...
    fixed, flip_angles, fixed_angles)

    if nargin < 12
        fixed_angles = [];
    end
    
    % compute boundary constraint residuals + Jacobian
    [R_boundary, C_boundary] = target_constraint(points, bounds, splines);
    
    % put residuals together
    R = [R_edge_pairs(points, edges, edge_pairs); ... % for edge length constraints
         R_dev_rings_generic(points, angles, rings); ... % for angle sum constraint
         R_boundary; ... % for boundary matching constraint
         R_boundary_rings_generic(points, angles, fixed_angles); ... % for fixing some interior angles
         R_boundary_rings_generic(points, angles, boundary_rings)]'; %  for fixed boundary angles

    % assemble Jacobian
    J = [C_edge_pair_rows(points, edges, edge_pairs, fixed); ...
         C_dev_ring_rows_generic(points, angles, rings, fixed); ...
         C_boundary; ...
         C_boundary_ring_rows_generic(points, angles, fixed_angles); ...
         C_boundary_ring_rows_generic(points, angles, boundary_rings, fixed)]'; 

    % overlap is an inequality constraint
    [R_ineq1, J_ineq1] = overlap_constraint(points, overlap_angles);    
    % add another overlap constraint for avoiding self-flipping
    [R_ineq2, J_ineq2] = overlap_constraint(points, flip_angles);   
    R_ineq = [R_ineq1, R_ineq2];
    J_ineq = [J_ineq1, J_ineq2];
end

