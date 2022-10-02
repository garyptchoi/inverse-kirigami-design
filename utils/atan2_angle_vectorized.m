function angle = atan2_angle_vectorized(center, a, b)

    A = [a(:,1) - center(:,1), a(:,2) - center(:,2)];
    B = [b(:,1) - center(:,1), b(:,2) - center(:,2)];
    
    x = dot(A',B')'./sqrt(A(:,1).^2 +A(:,2).^2)./sqrt(B(:,1).^2 +B(:,2).^2);
    y = twoD_cross_vectorized(center, a, b)./sqrt(A(:,1).^2 +A(:,2).^2)./sqrt(B(:,1).^2 +B(:,2).^2);
    
    angle = atan2(y, x);
    angle(angle<0) = angle(angle<0) + 2*pi;

end

