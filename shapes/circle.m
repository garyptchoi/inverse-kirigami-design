function [R, T, L, B] = circle()
    % return spline boundaries for this target shape

    offset = sqrt(2)-1;
    %offset = .25;

    s = sqrt(2)/2;
    
    R = [s -s; s*(1+offset) 0; s s];
    T = [s s; 0 s*(1+offset); -s s];
    L = [-s s; -s*(1+offset) 0; -s -s];
    B = [-s -s; 0 -s*(1+offset); s -s];

    R = make_boundary_curve(R);
    T = make_boundary_curve(T);
    L = make_boundary_curve(L);
    B = make_boundary_curve(B);

    % target
    figure(1)
    clf
    hold on
    axis equal
    fnplt(R, [0 1], 'k', .5)
    fnplt(L, [0 1], 'k', .5)
    fnplt(T, [0 1], 'k', .5)
    fnplt(B, [0 1], 'k', .5)
    
    


end

