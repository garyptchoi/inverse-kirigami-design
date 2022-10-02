% given 3 sets of points that define an angle in R2
% return the gradients of the angle value w.r.t. the point positions
% gradi will be nx2
% grad1: center grad
% grad2: a grad
% grad3: b grad
function [grad1, grad2, grad3] = angle_grad_vectorized(center, a, b)


    % edge vectors
    A = [a(:,1) - center(:,1), a(:,2) - center(:,2)];
    B = [b(:,1) - center(:,1), b(:,2) - center(:,2)];
    
    A_mag = sqrt(A(:,1).^2 +A(:,2).^2);
    B_mag = sqrt(B(:,1).^2 +B(:,2).^2);
    
    grad2 = zeros(size(center,1),2);
    grad3 = zeros(size(center,1),2);

    % set both to be unit vectors
    grad2(:,1) = -A(:,2)./A_mag;
    grad2(:,2) = A(:,1)./A_mag;

    grad3(:,1) = -B(:,2)./B_mag;
    grad3(:,2) = B(:,1)./B_mag;

    % adjust their lengths by their size
    grad2 = -[grad2(:,1)./A_mag, grad2(:,2)./A_mag];
    grad3 = [grad3(:,1)./B_mag, grad3(:,2)./B_mag];

    % store the center one as well
    grad1 = -(grad2 + grad3);

end

