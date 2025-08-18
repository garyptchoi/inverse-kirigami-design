% given 3 points that define an angle in R2
% return the gradients of the angle value w.r.t. the point positions
% grad will be 3x2
% row 1: center grad
% row 2: a grad
% row 3: b grad
function grad = angle_grad_3D(center, a, b)

    % edge vectors
    A = a - center;
    B = b - center;
    
    A_mag = norm(A);
    B_mag = norm(B);
    
    edge_dot = hawk_dot(A, B);
    
    grad = zeros(3,3);
        
    grad(2,:) = 1/A_mag*(1/B_mag*B - edge_dot/A_mag^2/B_mag*A); % a
    grad(3,:) = 1/B_mag*(1/A_mag*A - edge_dot/B_mag^2/A_mag*B); % b

    grad(1,:) = -(grad(2,:) + grad(3,:)); % center

    % compute acos derivative chain rule prefactor
    dphi_dz = -1/sqrt(1 - (edge_dot/A_mag/B_mag).^2);

    % apply prefactor
    grad = sign(twoD_cross(center,a,b))*dphi_dz*grad;
    grad(isnan(grad)) = 0;
    
end

