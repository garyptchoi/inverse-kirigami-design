function pointsD = compute_initial_map(pointsD_standard, shape_name, initial_map_type, scale_factor, ...
    boundR, boundT, boundL, boundB)


switch initial_map_type
    case 1
        % just use the standard deployed configuration
        pointsD = pointsD_standard;
        
    case 2
        % use a rescaled version of the standard deployed configuration
        pointsD = pointsD_standard*scale_factor;
        
    case 3
        % conformal map (using Schwarz-Christoffel transformation)
        
        if strcmp(shape_name,'circle')
            % only for circle!
            p = polygon([complex(1,1) complex(-1,1) complex(-1,-1) complex(1,-1)]);
            f = diskmap(p);    
            z = complex(pointsD_standard(:,1),pointsD_standard(:,2));    
            w = evalinv(f,z,1e-6); 
            pointsD = [real(w), imag(w)];
            R = twoD_rotation(-pi/4);
            pointsD = (R*pointsD')';
            
        else
            
            shape = str2func(shape_name);  
            [spline_boundR, spline_boundT, spline_boundL, spline_boundB] = shape();
            
            ptR = fnplt(spline_boundR, [0 1], 'r', 2);
            ptT = fnplt(spline_boundT, [0 1], 'g', 2);
            ptL = fnplt(spline_boundL, [0 1], 'b', 2);
            ptB = fnplt(spline_boundB, [0 1], 'y', 2);

            ptR = unique(ptR','rows','stable')';
            ptT = unique(ptT','rows','stable')';
            ptL = unique(ptL','rows','stable')';
            ptB = unique(ptB','rows','stable')';

            % f: unit disk to the original deployed structure
            pv = pointsD_standard([boundR; flipud(boundT); flipud(boundL); boundB],:);
            pv = complex(pv(:,1),pv(:,2));
            pv = unique(pv,'rows','stable');
            p = polygon(pv);
            f = diskmap(p); % find the S-C map
            f = center(f,0); % move the center to 0

            % g: unit disk to the target shape
            qv =[ptR(:,round(linspace(1,length(ptR)-1,10)))'; ...
                ptT(:,round(linspace(1,length(ptT)-1,10)))'; ...
                ptL(:,round(linspace(1,length(ptL)-1,10)))'; ...
                ptB(:,round(linspace(1,length(ptB)-1,10)))']; 
            qv = complex(qv(:,1),qv(:,2));
            qv = unique(qv,'rows','stable');
            q = polygon(qv); 
            g = diskmap(q); % find the S-C map
            g = center(g,0); % move the center to 0

            % Overall conformal map g \circ f^{-1})(z)
            z = complex(pointsD_standard(:,1),pointsD_standard(:,2));
            w = evalinv(f,z,1e-6); 
            gw = g(w);
            pointsD = [real(gw), imag(gw)];
            
        end
        
    case 4
        % Teichmuller map
        
        shape = str2func(shape_name);  
        [spline_boundR, spline_boundT, spline_boundL, spline_boundB] = shape();

        ptR = fnplt(spline_boundR, [0 1], 'r', 2);
        ptT = fnplt(spline_boundT, [0 1], 'g', 2);
        ptL = fnplt(spline_boundL, [0 1], 'b', 2);
        ptB = fnplt(spline_boundB, [0 1], 'y', 2);
        
        ptR = unique(ptR','rows','stable')';
        ptT = unique(ptT','rows','stable')';
        ptL = unique(ptL','rows','stable')';
        ptB = unique(ptB','rows','stable')';

        qv =[ptR(:,round(linspace(1,length(ptR)-1,20)))'; ...
            ptT(:,round(linspace(1,length(ptT)-1,20)))'; ...
            ptL(:,round(linspace(1,length(ptL)-1,20)))'; ...
            ptB(:,round(linspace(1,length(ptB)-1,20)))']; 
        
        edge_length = sqrt(sum((qv(1:end-1,:) - qv(2:end,:)).^2,2));
        average_edge_length = mean(edge_length);

        target_shape = qv;

        % triangulate
        [v,f] = distmesh2d(@dpoly,@huniform,average_edge_length,...
            [min(target_shape(:,1))-2,min(target_shape(:,2))-2; ...
            max(target_shape(:,1))+2,max(target_shape(:,2))+2], ...
            target_shape,target_shape);
        
        corner_id = zeros(4,1);
        [~,corner_id(1)] = min((v(:,1)-ptB(1,1)).^2+(v(:,2)-ptB(2,1)).^2);
        [~,corner_id(2)] = min((v(:,1)-ptB(1,end)).^2+(v(:,2)-ptB(2,end)).^2);
        [~,corner_id(3)] = min((v(:,1)-ptT(1,1)).^2+(v(:,2)-ptT(2,1)).^2);
        [~,corner_id(4)] = min((v(:,1)-ptT(1,end)).^2+(v(:,2)-ptT(2,end)).^2);
        
        % compute rectangular conformal map (Meng et al., 2016)
        map = rectangular_conformal_map(v,f,corner_id);
        
        % rescale it to get a Teichmuller map onto a unit square
        map(:,2) = map(:,2) / max(map(:,2));
        
        map = map - 0.5;
        
        xrange = max(pointsD_standard(:,1))-min(pointsD_standard(:,1));
        yrange = max(pointsD_standard(:,2))-min(pointsD_standard(:,2));
        
        % resize and shift
        map(:,1) = map(:,1)*xrange + (max(pointsD_standard(:,1))+min(pointsD_standard(:,1)))/2;
        map(:,2) = map(:,2)*yrange + (max(pointsD_standard(:,2))+min(pointsD_standard(:,2)))/2;
        
        % find the inverse mapping
        F1 = TriScatteredInterp(map(:,1:2),v(:,1),'natural');
        F2 = TriScatteredInterp(map(:,1:2),v(:,2),'natural');

        pointsD = zeros(size(pointsD_standard));
        pointsD(:,1) = F1(pointsD_standard(:,1),pointsD_standard(:,2));
        pointsD(:,2) = F2(pointsD_standard(:,1),pointsD_standard(:,2));
        
        r = 1;
        % sometimes the points are numerically out-of-range, 
        % try to shrink them a little bit
        while sum(isnan(pointsD(:)))
            r = r*0.99;
            pointsD(:,1) = F1(pointsD_standard(:,1)*r,pointsD_standard(:,2)*r);
            pointsD(:,2) = F2(pointsD_standard(:,1)*r,pointsD_standard(:,2)*r);
            if r < 0.8
                error('There is some error in the Teichmuller initialization!');
            end
        end
            
end