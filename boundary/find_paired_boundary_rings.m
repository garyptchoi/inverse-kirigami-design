function paired_boundary_rings = find_paired_boundary_rings(pointsD, anglesD, Dto0, free, cornersD)
% prepare square initial space boundary constraint stencils

    % original anglesD
    original_anglesD = anglesD;

    % for every node in free, need to know all angles with it as center
    anglesD_ind = 1:size(anglesD,1);    
    
    % remove interior angles
    boundary = ismember(anglesD(:,1), free);
    anglesD = anglesD(boundary,:);
    anglesD_ind = anglesD_ind(boundary);
    
    % sort based on center nodes in initial space
    [~,ind] = sortrows(Dto0(anglesD));
    anglesD = anglesD(ind,:);
    anglesD_ind = anglesD_ind(ind);    
    
    
    % group the angles centered on boundary nodes    
    boundary_rings = {};    
    last_center = Dto0(anglesD(1,1));
    this_ring = anglesD_ind(1);
    
    for i = 2:length(anglesD_ind)        
        
        % get this center node
        this_center = Dto0(anglesD(i,1));
        
        % start or augment ring
        if this_center ~= last_center % new ring
            boundary_rings{end+1} = this_ring;
            this_ring = anglesD_ind(i);                                
        else % same ring
            this_ring = [this_ring anglesD_ind(i)];  
            
            if i == length(anglesD_ind)
                boundary_rings{end+1} = this_ring;
                continue
            end
            
        end        
        
        % prep for next iter
        last_center = this_center;        
        
    end
    
    % identify the four corners
    cornersD = cornersD(ismember(cornersD, free));
    maxX = max(pointsD(cornersD,1));
    minX = min(pointsD(cornersD,1));
    maxY = max(pointsD(cornersD,2));
    minY = min(pointsD(cornersD,2));
    
    % corner node indices
    BL = cornersD(abs(pointsD(cornersD,1)-minX) < eps & abs(pointsD(cornersD,2)-minY) < eps);
    BR = cornersD(abs(pointsD(cornersD,1)-maxX) < eps & abs(pointsD(cornersD,2)-minY) < eps);
    TR = cornersD(abs(pointsD(cornersD,1)-maxX) < eps & abs(pointsD(cornersD,2)-maxY) < eps);
    TL = cornersD(abs(pointsD(cornersD,1)-minX) < eps & abs(pointsD(cornersD,2)-maxY) < eps);
    cornersD = [BL BR TR TL];   
    
    % assign angle defects at corners and regular boundary rings
    boundary_rings = boundary_rings';
    for i = 1:length(boundary_rings)        
        % corner
        if ismember(original_anglesD(boundary_rings{i}(1),1), cornersD)         
            boundary_rings{i,2} = pi/2;            
        % straight boundary
        else
            boundary_rings{i,2} = pi;            
        end
    end    
    
    
    % added to find_boundary_rings on 12-12-2016
    
    % pair rings to make more forgiving stencils
    % (i.e. allow for two consecutive rings to take on values pi+epsilon,
    % pi-epsilon so that they sum to 2pi, rather than strictly = pi)
    boundary_ring_pairs = [];
    for i = 1:size(boundary_rings,1)-1
        for j = i+1:size(boundary_rings,1)
            if sum(sum(ismember(Dto0(original_anglesD(boundary_rings{i,1},1)), ...
                                Dto0(original_anglesD(boundary_rings{j,1},:))))) > 0
                boundary_ring_pairs = [boundary_ring_pairs; i j];
            end
        end
    end
    
    % assemble the more flexible rings
    paired_boundary_rings = cell(size(boundary_ring_pairs,1),2);
    for i = 1:size(boundary_ring_pairs,1)       
        paired_boundary_rings{i,1} = ...
            [boundary_rings{boundary_ring_pairs(i,1),1} boundary_rings{boundary_ring_pairs(i,2),1}];
        paired_boundary_rings{i,2} = ...
            boundary_rings{boundary_ring_pairs(i,1),2} + boundary_rings{boundary_ring_pairs(i,2),2};        
    end
                
    
end

