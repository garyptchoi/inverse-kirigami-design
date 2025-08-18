function rows = C_edge_pair_rows_3D(points, edges, edge_pairs, fixed)

    % account for no fixed input
    if nargin < 4
        fixed = [];
    end

    % dimensions
    num_points = size(points, 1);
    num_pairs = size(edge_pairs, 1);
    num_fixed = max(size(fixed));
    num_active_points = num_points - num_fixed;
    
    % compute indices into Jacobian considering fixed node columns gone
    J_ind = J_index_3D(fixed, num_points);

    % get the edge vectors
    edgeA = points(edges(edge_pairs(:,1),2),:) - points(edges(edge_pairs(:,1),1),:);
    edgeB = points(edges(edge_pairs(:,2),2),:) - points(edges(edge_pairs(:,2),1),:);
    
    % index into rows
    col_indA1 = (edges(edge_pairs(:,1),1)-1)*3+1;
    col_indA2 = (edges(edge_pairs(:,1),2)-1)*3+1;
    
    col_indB1 = (edges(edge_pairs(:,2),1)-1)*3+1;
    col_indB2 = (edges(edge_pairs(:,2),2)-1)*3+1;
    
    
    tempA1 = J_ind(col_indA1);
    tempA2 = J_ind(col_indA2);
    tempB1 = J_ind(col_indB1);
    tempB2 = J_ind(col_indB2);
    
    indexA1 = find(tempA1>0);
    indexA2 = find(tempA2>0);
    indexB1 = find(tempB1>0);
    indexB2 = find(tempB2>0);

    iii = [indexA1,indexA2,indexB1,indexB2,indexA1,indexA2,indexB1,indexB2,indexA1,indexA2,indexB1,indexB2]';
    jjj = [tempA1(indexA1), tempA2(indexA2), tempB1(indexB1), tempB2(indexB2),...
        tempA1(indexA1)+1, tempA2(indexA2)+1, tempB1(indexB1)+1, tempB2(indexB2)+1,...
        tempA1(indexA1)+2, tempA2(indexA2)+2, tempB1(indexB1)+2, tempB2(indexB2)+2]';
    kkk = [-2*edgeA(indexA1,1); 2*edgeA(indexA2,1); 2*edgeB(indexB1,1); -2*edgeB(indexB2,1);...
        -2*edgeA(indexA1,2); 2*edgeA(indexA2,2); 2*edgeB(indexB1,2); -2*edgeB(indexB2,2);...
        -2*edgeA(indexA1,3); 2*edgeA(indexA2,3); 2*edgeB(indexB1,3); -2*edgeB(indexB2,3)];
    rows = sparse(iii,jjj,kkk,num_pairs,3*num_active_points);
    rows = full(rows);

end

