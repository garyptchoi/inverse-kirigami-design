function [R, J] = target_constraint(points, bounds, splines)
% compute 2-norm of deployed boundary points from target shape

    % initilize residual    
    R = zeros(sum(arrayfun(@(x)length(bounds{x}), 1:length(bounds))), 1);
    J = sparse([],[],[],sum(arrayfun(@(x)length(bounds{x}), 1:length(bounds))), size(points,1)*2);
    
    % for each boundary
    total_num_nodes = 0;
    for i = 1:length(bounds)
       
        % get this boundary
        bound = bounds{i};
        spline_bound = splines{i};
        
        
        % initialize parameter guess to middle of spline
        t0 = repmat(.5, 1, length(bound));        
        
        options = optimoptions('fmincon', 'display', 'none');        
        [tf, ~] = fmincon(@(x)bound_measure(x, points(bound,:), spline_bound), t0, [], [], [], [], zeros(size(t0)), ones(size(t0)), [], options);
        
        
        % compute tangent vectors to determine signs of fval
        spline_bound_prime = fnder(spline_bound, 1);
        spline_T = ppval(spline_bound_prime, tf)';
        spline_points = ppval(spline_bound, tf)';
        
        
        % compute gradients
        these_grads = spline_points - points(bound,:);
        
        % compute distances
        these_dists = sqrt(sum(these_grads.^2, 2));
                
        % constraint functions should be regular points when satisfied
        
        check_direction = (twoD_cross_vectorized(spline_points, spline_points + spline_T, points(bound,:)) < 0);
        these_grads(check_direction,:) = these_grads(check_direction,:)./repmat(these_dists(check_direction), [1,size(these_grads,2)]);% normalize gradient
        these_dists(check_direction) = -these_dists(check_direction); % flip distance sign  
        these_grads(~check_direction,:) = -these_grads(~check_direction,:)./repmat(these_dists(~check_direction), [1,size(these_grads,2)]); % normalize and flip direction 
        
        
        % store residuals
        R(total_num_nodes+1:total_num_nodes+length(bound)) = these_dists;
        
        % store gradients
        iii = total_num_nodes + [1:length(bound),1:length(bound)]';
        jjj = [2*bound - 1; 2*bound];
        kkk = [these_grads(:,1); these_grads(:,2)];
        J = J + sparse(iii, jjj, kkk, size(J,1), size(J,2));
        
        % increment total number of preceding nodes
        total_num_nodes = total_num_nodes + length(bound);
      
        
    end
    
    J = full(J);
end

