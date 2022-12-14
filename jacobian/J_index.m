% num_nodes: total # of nodes in the structure
% fixed: n x 1 vector of the indices of 'fixed' nodes in the structure
% indices: 2n x 1 vector of column indices for the Jacobian
% (fixed nodes aren't included in the Jacobian)
function indices = J_index(fixed, num_nodes)

    % dimensions
    num_fixed = max(size(fixed));
    
    % initialize index map
    indices = 1:2*num_nodes;
    
    % subtract out fixed nodes
    for i = 1:num_fixed
       
        indices((fixed(i) - 1)*2+1:(fixed(i) - 1)*2+2) = -1;
        
        indices((fixed(i) - 1)*2+3:2*num_nodes) = indices((fixed(i) - 1)*2+3:2*num_nodes) + ...
                                                repmat(-2, 1, 2*num_nodes - ((fixed(i) - 1)*2+2));
        
    end

end