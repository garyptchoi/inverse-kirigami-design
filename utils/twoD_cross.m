% returns cross product of two vectors in 2D
function Z = twoD_cross(center, a, b)
A = a - center;
B = b - center;

Z = A(1)*B(2)-B(1)*A(2);


end