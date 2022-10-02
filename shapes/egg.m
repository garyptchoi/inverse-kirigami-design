function [R, T, L, B] = egg()
    % return spline boundaries for this target shape

    offset = (sqrt(2)-1);
    %offset = .25;

    s = sqrt(2)/2;
    
    corners = [s s; -s s; -s -s; s -s];
    corners(1,:) = corners(1,:)*.75;
    corners(2,:) = corners(2,:)*.75;
    
    %corners([3 4],2) = corners([3 4],2) - .2;
    corners([3 4],1) = corners([3 4],1)*.71;
    
    
    sides = [s*(1+offset) -.2; -s*(1+offset) -.2];
    
    sides = sides*.71;
    
    
        
    
    
    R_pts = [corners(4,:); sides(1,:); corners(1,:)];
    T_pts = [corners(1,:); 0 s*(1+offset); corners(2,:)];
    L_pts = [corners(2,:); sides(2,:); corners(3,:)];
    B_pts = [corners(3,:); 0 -s*(1+offset); corners(4,:)];
    
    T_pts(2,:) = T_pts(2,:)*.95;
    B_pts(2,:) = B_pts(2,:)*.95;
    
    % resize to fit square better
    scale = 1.5;
    
    R_pts = scale*R_pts;
    L_pts = scale*L_pts;
    T_pts = scale*T_pts;
    B_pts = scale*B_pts;
    

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
%     


end

