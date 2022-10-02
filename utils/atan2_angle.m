function angle = atan2_angle(center, a, b)

    A = a - center;
    B = b - center; 
    
    x = dot(A,B)/norm(A)/norm(B);
    y = twoD_cross(center, a, b)/norm(A)/norm(B);
    
    angle = atan2(y, x);
    if angle < 0
        angle = 2*pi + angle;
    end


end

