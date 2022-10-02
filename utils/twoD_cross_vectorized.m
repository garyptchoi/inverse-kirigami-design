% returns cross product of two vectors in 2D

% a,b,center can be list of vectors

function Z = twoD_cross_vectorized(center, a, b)
A = [a(:,1) - center(:,1), a(:,2) - center(:,2)];
B = [b(:,1) - center(:,1), b(:,2) - center(:,2)];

Z = A(:,1).*B(:,2)-B(:,1).*A(:,2);


end