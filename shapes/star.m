function [R, T, L, B] = star()
    %%
    % original
%     R_pts = [1 -1; 2 -.75; 1.5 0; 1 1];
%     T_pts = [1 1; .75 2; 0 1.5; -1 1];
%     L_pts = [-1 1; -2 .75; -1.5 0; -1 -1];
%     B_pts = [-1 -1; -.75 -2; 0 -1.5; 1 -1];
        
%     R_pts = [2 -.75; 1.5 0; 1 1; .75 2];
%     T_pts = [ .75 2; 0 1.5; -1 1; -2 .75];
%     L_pts = [-2 .75; -1.5 0; -1 -1; -.75 -2];
%     B_pts = [-.75 -2; 0 -1.5; 1 -1; 2 -.75];

    % star
    R_pts = [2 -.75; 1 0; 1 1; .75 2];
    T_pts = [ .75 2; 0 1; -1 1; -2 .75];
    L_pts = [-2 .75; -1 0; -1 -1; -.75 -2];
    B_pts = [-.75 -2; 0 -1; 1 -1; 2 -.75];
    
    
    R = make_boundary_curve(R_pts);
    T = make_boundary_curve(T_pts);
    L = make_boundary_curve(L_pts);
    B = make_boundary_curve(B_pts);

    % target
    figure
    clf
    hold on
    axis equal
    fnplt(R, [0 1], '-r', .5)
    fnplt(T, [0 1], '-g', .5)
    fnplt(L, [0 1], '-b', .5)
    fnplt(B, [0 1], '-y', .5)
    
    plot(R_pts(:,1), R_pts(:,2), 'ok')
    plot(T_pts(:,1), T_pts(:,2), 'ok')
    plot(L_pts(:,1), L_pts(:,2), 'ok')
    plot(B_pts(:,1), B_pts(:,2), 'ok')
    


end