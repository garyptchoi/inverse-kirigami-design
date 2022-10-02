function pairs = make_edge_pairs(edges, Dto0)

    num_edges = size(edges,1);
    pairs = [];            
    paired = zeros(num_edges,1);
    for i = 1:num_edges-1       
        if paired(i) == 1
            continue
        end
        this_edge = edges(i,:);                 
        for j = i+1:num_edges
            if paired(j) == 1
                continue
            end
            other_edge = edges(j,:);          
            
            if sum(ismember(this_edge, other_edge)) == 2
                disp('duplicate edge')
            end
            
            if sum(ismember(Dto0(this_edge), Dto0(other_edge))) == 2                                             
                pairs = [pairs; i j];
                paired(i) = 1;
                paired(j) = 1;
                break                
            end            
        end
    end

end

