function R = R_edge_pairs(points, edges, edge_pairs)

    % dimensions
    num_pairs = size(edge_pairs, 1);
    
    % compute residual
    R = sum((points(edges(edge_pairs(:,1),2), :) - points(edges(edge_pairs(:,1),1), :)).^2,2) - ...
        sum((points(edges(edge_pairs(:,2),2), :) - points(edges(edge_pairs(:,2),1), :)).^2,2);

end

