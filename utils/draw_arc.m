function [] = draw_arc(center, a, b, r, fig_number, styles)

    
   

    % compute this angle
    theta = LOC_angle(center, a, b);
    if twoD_cross(center, a, b) < 0
        theta = 2*pi - theta;
    end

    % get the start position
    A = a-center;
    A = A/norm(A)*r;

    % draw arc
    R = twoD_rotation(theta/20);
    arc = A;                
    res = 20;
    for z = 1:res
        arc = [arc; (R*arc(end,:)')'];
    end
    arc = arc + repmat(center, res+1, 1);

    figure(fig_number)
    hold on
    curve = plot(arc(:,1), arc(:,2), '-b');
    
    if nargin == 6
        for i = 1:length(styles)
            set(curve, styles{i}{1}, styles{i}{2})
        end
    end
    
    
    


    
    
    
    

end

