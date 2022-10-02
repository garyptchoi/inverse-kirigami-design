function angles = compute_angle(v,f)

if size(v,2) < 3
    v = [v, 1+0*v(:,1)];
end
mesh_cos=zeros(1,length(f)*3);
q = 1;
for j=1:length(f)
    p1=f(j,1);
    p2=f(j,2);
    p3=f(j,3);
    a = sort([p1,p2,p3]);
    p1 = a(1); p2 = a(2); p3 = a(3);
    a3=[v(p1,1)-v(p3,1), v(p1,2)-v(p3,2), v(p1,3)-v(p3,3)];
    b3=[v(p2,1)-v(p3,1), v(p2,2)-v(p3,2), v(p2,3)-v(p3,3)];
    a1=[v(p2,1)-v(p1,1), v(p2,2)-v(p1,2), v(p2,3)-v(p1,3)];
    b1=[v(p3,1)-v(p1,1), v(p3,2)-v(p1,2), v(p3,3)-v(p1,3)];
    a2=[v(p3,1)-v(p2,1), v(p3,2)-v(p2,2), v(p3,3)-v(p2,3)];
    b2=[v(p1,1)-v(p2,1), v(p1,2)-v(p2,2), v(p1,3)-v(p2,3)];
    cos1=(a1(1)*b1(1)+a1(2)*b1(2)+a1(3)*b1(3))/(sqrt(a1(1)^2+a1(2)^2+a1(3)^2)*sqrt(b1(1)^2+b1(2)^2+b1(3)^2));
    cos2=(a2(1)*b2(1)+a2(2)*b2(2)+a2(3)*b2(3))/(sqrt(a2(1)^2+a2(2)^2+a2(3)^2)*sqrt(b2(1)^2+b2(2)^2+b2(3)^2));
    cos3=(a3(1)*b3(1)+a3(2)*b3(2)+a3(3)*b3(3))/(sqrt(a3(1)^2+a3(2)^2+a3(3)^2)*sqrt(b3(1)^2+b3(2)^2+b3(3)^2));
    mesh_cos(q:q+2)=[cos1,cos2,cos3];
    q = q+3;
    
end
angles = acos(mesh_cos);