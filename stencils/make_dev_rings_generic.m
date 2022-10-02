function [rings, anglesD] = make_dev_rings_generic(anglesD, Dto0)
% returns a sorted anglesD and intervals constituting rings on anglesD
    
    % map the deployed angles to initial indices
    angles0 = Dto0(anglesD);
    
    % sort both by central node in angles
    [angles0, ind] = sortrows(angles0);    
    anglesD = anglesD(ind,:);      
    
    % find angles belonging to the same central node
    ring_breaks = find([true; logical(diff(angles0(:,1)))]);
    ring_breaks = [ring_breaks; size(angles0,1)+1];
    
    % determine if outer nodes in angles at each central node form a ring
    rings = [];
    for i = 1:length(ring_breaks)-1
       
        % get the outer nodes
        this_ring = angles0(ring_breaks(i):ring_breaks(i+1)-1, [2 3]);
        
        % count their appearances in the angles
        C = histc(reshape(this_ring, size(this_ring,1)*size(this_ring,2), 1), unique(this_ring));
        
        % if each node index appears twice then you've found a ring
        if sum(C==2) == length(C)            
            rings = [rings; ring_breaks(i) ring_breaks(i+1)-1];
        end
        
    end
        
end

