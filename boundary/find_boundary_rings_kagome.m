function boundary_rings = find_boundary_rings_kagome(pointsD, anglesD, Dto0, free, cornersD)
% prepare initial space boundary constraint stencils for kagome

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
    
    % assign angle defects at corners and regular boundary rings
    boundary_rings = boundary_rings';
    for i = 1:length(boundary_rings)    
        boundary_rings{i,2} = pi/3*length(boundary_rings{i,1});
               
    end
        
end

