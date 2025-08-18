function [R, J] = square_boundary_constraint_3D(points,edges_bottom,edges_right,ratio)
    % want: bottom side length = ratio * right side length
    R = [sum(sqrt(sum((points(edges_bottom(:,2), :) - points(edges_bottom(:,1), :)).^2,2))) - ...
        ratio*sum(sqrt(sum((points(edges_right(:,2), :) - points(edges_right(:,1), :)).^2,2)))] ;
    
    % dimensions
    num_points = size(points, 1);
    
    % compute indices into Jacobian considering fixed node columns gone
    J_ind = J_index_3D([], num_points);

    %% 
 
    % get the edge vectors
    edgeA = points(edges_bottom(:,2),:) - points(edges_bottom(:,1),:);
    edgeB = points(edges_right(:,2),:) - points(edges_right(:,1),:);
    edgeB = ratio*edgeB;
    normA = sqrt(edgeA(:,1).^2+edgeA(:,2).^2);
    normB = sqrt(edgeB(:,1).^2+edgeB(:,2).^2);
    
    % index into rows
    col_indA1 = (edges_bottom(:,1)-1)*3+1;
    col_indA2 = (edges_bottom(:,2)-1)*3+1;
    
    col_indB1 = (edges_right(:,1)-1)*3+1;
    col_indB2 = (edges_right(:,2)-1)*3+1;
    
    tempA1 = J_ind(col_indA1);
    tempA2 = J_ind(col_indA2);
    tempB1 = J_ind(col_indB1);
    tempB2 = J_ind(col_indB2);
    
    indexA1 = find(tempA1>0);
    indexA2 = find(tempA2>0);
    indexB1 = find(tempB1>0);
    indexB2 = find(tempB2>0);

    jjj = [tempA1(indexA1), tempA2(indexA2), tempB1(indexB1), tempB2(indexB2),...
        tempA1(indexA1)+1, tempA2(indexA2)+1, tempB1(indexB1)+1, tempB2(indexB2)+1,...
        tempA1(indexA1)+2, tempA2(indexA2)+2, tempB1(indexB1)+2, tempB2(indexB2)+2]';

    iii = ones(1,length(jjj));
    kkk = [-edgeA(indexA1,1)./normA; edgeA(indexA2,1)./normA; edgeB(indexB1,1)./normB; -edgeB(indexB2,1)./normB;...
        -edgeA(indexA1,2)./normA; edgeA(indexA2,2)./normA; edgeB(indexB1,2)./normB; -edgeB(indexB2,2)./normB;...
        -edgeA(indexA1,3)./normA; edgeA(indexA2,3)./normA; edgeB(indexB1,3)./normB; -edgeB(indexB2,3)./normB]; ...

    J = sparse(iii,jjj,kkk,1,3*num_points);
    J = full(J);


end

