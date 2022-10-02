function [R, T, L, B] = shear()
    % return spline boundaries for this target shape

    % choose a shear angle
    shift = .5;
    %gamma = 0;
    
    corners = [1 -1; 1 1; -1 1; -1 -1];
    corners([2 3],1) = corners([2 3],1) + shift;
    corners([1 4],1) = corners([1 4],1) - shift;
    
    R_pts = [corners(1,:); corners(2,:)];
    T_pts = [corners(2,:); corners(3,:)];
    L_pts = [corners(3,:); corners(4,:)];
    B_pts = [corners(4,:); corners(1,:)];    
    

    
    R = make_boundary_curve(R_pts);
    T = make_boundary_curve(T_pts);
    L = make_boundary_curve(L_pts);
    B = make_boundary_curve(B_pts);

    
      
    % target
    figure(1)
    clf
    hold on
    axis equal
    fnplt(R, [0 1], '-k', .5)
    fnplt(T, [0 1], '-k', .5)
    fnplt(L, [0 1], '-k', .5)
    fnplt(B, [0 1], '-k', .5)
    
    plot(R_pts(:,1), R_pts(:,2), 'ok')
    plot(T_pts(:,1), T_pts(:,2), 'ok')
    plot(L_pts(:,1), L_pts(:,2), 'ok')
    plot(B_pts(:,1), B_pts(:,2), 'ok')

end

