function [p,M,v] = flatten_polygon(v)
% v: 4x3 [x1 y1 z1; x2 y2 z2; x3 y3 z3; x4 y4 z4] or 3x3
% p: 4x2 [X1 Y1; X2 Y2; X3 Y3] or 3x2

% idea: 
% move v1 to (0,0,0)
% compute the unit normal (right hand)
% rotate it to (0,0,1)

%% shift first point to origin
v = [v(:,1) - v(1,1), v(:,2) - v(1,2), v(:,3) - v(1,3)];

%% compute unit normal

N = cross(v(2,:), v(3,:));
N = N ./ norm(N);

%% rotate about an axis
deg = acos(N(:,3))*180/pi;
u = cross(N,[ 0 0 1]);
M = AxelRot(deg,u);
M = M(1:3,1:3);

p = (M*v')';
p(:,3) = [];

end
