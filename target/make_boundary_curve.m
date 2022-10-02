function curve = make_boundary_curve(xy)
% xy: Nx2 coordinates of boundary spline control points

    t = linspace(0,1,size(xy,1));
    curve = csape(t, xy');
    
    
    
    
    
    
end

