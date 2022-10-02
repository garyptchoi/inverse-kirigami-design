% returns interior angle of triangle at this point
function theta = LOC_angle(center, a, b)



    % compute edge lengths
    A = norm(b - center);
    B = norm(a - center);
    C = norm(b - a);   
    
    if abs((A^2 + B^2 - C^2)/(2*A*B)) > 1
       
        %fprintf('problematic points given to LOC_angle\n')        
        theta = pi;
        
    else
    
    
        % compute angle with Law of Cosines
        theta =  acos((A^2 + B^2 - C^2)/(2*A*B)); 
    
    end
    
    
    
    
end

