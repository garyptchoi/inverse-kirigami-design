function [pointsD,target_surface_points,target_surface_tri] = ...
    compute_initial_map_3D(pointsD_standard,shape_name,initial_map_type,scale_factor)

%% load the target surface
% target_surface_points: nv x 3 vertex coordinates
% target_surface_tri: nf x 3 vertex coordinates
% (optional, for analytic map only) analytic_formula: 
%      a string of the mathematical formula of the target surface
% (optional, for Teichmuller map only) target_surface_corners: 
%      4 x 1 corner indices for the Teichmuller map

load([shape_name,'.mat']);

%% construct initial map
switch initial_map_type
    case 1
        % just use the standard deployed configuration
        pointsD = [pointsD_standard, zeros(size(pointsD_standard,1),1)];
        
    case 2
        % use a rescaled version of the standard deployed configuration
        pointsD = [pointsD_standard*scale_factor,  zeros(size(pointsD_standard,1),1)];
        
    case 3
        % analytic map 
        if exist('analytic_formula','var')
            
            X = pointsD_standard(:,1);
            Y = pointsD_standard(:,2);
            pointsD = eval(analytic_formula);
            
        else 
            error('Please supply the analytic formula for the target surface.');
        end
        
    case 4
        % Teichmuller map (only for simply-connected open surface)
       
        TR = triangulation(target_surface_tri,target_surface_points);
        B = TR.freeBoundary;
        if isempty(B)
            error('The prescribed target surface is not a simply-connected open surface. Please use other initial map methods.');
        end
        
        % compute rectangular conformal map (Meng et al., 2016)
        if exist('target_surface_corners','var')
            map = rectangular_conformal_map(target_surface_points,target_surface_tri,...
                target_surface_corners);
        else
            map = rectangular_conformal_map(target_surface_points,target_surface_tri);
        end
            
        % rescale it to get a Teichmuller map onto a unit square
        map(:,2) = map(:,2) / max(map(:,2));
        
        map = map - 0.5;
        
        xrange = max(pointsD_standard(:,1))-min(pointsD_standard(:,1));
        yrange = max(pointsD_standard(:,2))-min(pointsD_standard(:,2));
        
        % resize and shift
        map(:,1) = map(:,1)*xrange + (max(pointsD_standard(:,1))+min(pointsD_standard(:,1)))/2;
        map(:,2) = map(:,2)*yrange + (max(pointsD_standard(:,2))+min(pointsD_standard(:,2)))/2;
        
        % find the inverse mapping
        F1 = TriScatteredInterp(map(:,1:2),target_surface_points(:,1),'natural');
        F2 = TriScatteredInterp(map(:,1:2),target_surface_points(:,2),'natural');
        F3 = TriScatteredInterp(map(:,1:2),target_surface_points(:,3),'natural');

        pointsD = zeros(size(pointsD_standard,1),3);
        pointsD(:,1) = F1(pointsD_standard(:,1),pointsD_standard(:,2));
        pointsD(:,2) = F2(pointsD_standard(:,1),pointsD_standard(:,2));
        pointsD(:,3) = F3(pointsD_standard(:,1),pointsD_standard(:,2));
        
        r = 1;
        % sometimes the points are numerically out-of-range, 
        % try to shrink them a little bit
        while sum(isnan(pointsD(:)))
            r = r*0.99;
            pointsD(:,1) = F1(pointsD_standard(:,1)*r,pointsD_standard(:,2)*r);
            pointsD(:,2) = F2(pointsD_standard(:,1)*r,pointsD_standard(:,2)*r);
            pointsD(:,3) = F3(pointsD_standard(:,1)*r,pointsD_standard(:,2)*r);
            if r < 0.8
                error('There is some error in the Teichmuller initialization!');
            end
        end
            
end