% given 3 points that define an angle in R2
% return the gradients of the angle value w.r.t. the point positions
% grad will be 3x2
% row 1: center grad
% row 2: a grad
% row 3: b grad
function grad = angle_grad(center, a, b)


    % edge vectors
    A = a - center;
    B = b - center;
    
    A_mag = norm(A);
    B_mag = norm(B);
    
    grad = zeros(3,2);

    % set both to be unit vectors
    grad(2,1) = -A(2)/A_mag;
    grad(2,2) = A(1)/A_mag;

    grad(3,1) = -B(2)/B_mag;
    grad(3,2) = B(1)/B_mag;

    % adjust their lengths by their size
    grad(2,:) = -grad(2,:)/A_mag;
    grad(3,:) = grad(3,:)/B_mag;

    % store the center one as well
    grad(1,:) = -(grad(2,:) + grad(3,:));
                                        
        
end

