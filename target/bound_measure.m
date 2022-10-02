function [r, dr] = bound_measure(t, bound_points, bound_spline)
% compute objective contribution from this boundary   

    % get tangent function of spline (does this work?)
    bound_spline_prime = fnder(bound_spline, 1);
    
    % sum to get residual of this boundary
    r = 0;
    for i = 1:length(t)
    
        % current projection on spline
        spline_point = ppval(bound_spline, t(i))';
        
        % tangent vector at projection point
        spline_T = ppval(bound_spline_prime, t(i))';
        
        % residual component
        r = r + sum((bound_points(i,:) - spline_point).^2);
        
        % derivative
        dr(i) = -2*dot(bound_points(i,:) - spline_point, spline_T);
        
    end


end

