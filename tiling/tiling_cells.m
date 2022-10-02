function [points, topos] = tiling(width, height, unit, hor_shift, vert_shift, unittopos)

    % initialize storage
    points = unit;        
    unitsize = size(unit,1);
    
    % create total structures
    topos = unittopos;
    num_topos = size(topos,1);
    
    % build the first row
    for i = 2:width
        points = [points; unit + repmat(hor_shift*(i-1),size(unit,1),1)];
        

        for j = 1:num_topos
            topos{j,1} = [topos{j,1}; unittopos{j,1}+(i-1)*unitsize];
        end
        
    end
    
    % build the rest of the structure from the first row
    row = points;
    rowsize = size(row,1);    
    rowtopos = topos;      
    for i = 2:height
        
        points = [points; row + repmat(vert_shift*(i-1),size(row,1),1)];

        for j = 1:num_topos
            topos{j,1} = [topos{j,1}; rowtopos{j,1}+(i-1)*rowsize];
        end
        
    end   

    % consolidate nodes (tiling creates overlapping nodes)
    [points, topos] = consolidate_cells(points, topos);
    
end

