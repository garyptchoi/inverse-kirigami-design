function p = flatten_triangle(v)
% v: 3x3 [x1 y1 z1; x2 y2 z2; x3 y3 z3]
% tri: 3x2 [X1 Y1; X2 Y2; X3 Y3]

x1 = 0; y1 = 0; x2 = 1; y2 = 0; % arbitrarily set the locations of two vertices
a = v(2,1:3) - v(1,1:3);
b = v(3,1:3) - v(1,1:3);
sin1 = (norm(cross(a,b),2))/(norm(a,2)*norm(b,2));
ori_h = norm(b,2)*sin1;
ratio = norm([x1-x2,y1-y2],2)/norm(a,2);
y3 = ori_h*ratio;
x3 = sqrt(norm(b,2)^2*ratio^2-y3^2);


area_ori = norm(cross(a,b),2)/2;

p = [x1 y1; x2 y2; x3 y3];
area_new = 1*y3/2;

p = p / sqrt(area_new) * sqrt(area_ori);
