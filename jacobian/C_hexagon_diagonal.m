function rows = C_hexagon_diagonal(points, length_edge_list, length_edge_rings, length_angle_list, length_angle_rings, fixed)

    % account for no fixed input
    if nargin < 6
        fixed = [];
    end
    % dimensions
    num_points = size(points, 1);    
    num_rings = size(length_edge_rings, 1);
    num_fixed = max(size(fixed));
    num_active_points = num_points - num_fixed;

    % compute indices into Jacobian considering fixed node columns gone
    J_ind = J_index(fixed, num_points);

    % initialize J
    rows = zeros(num_rings, 2*num_active_points);

    % compute and store each set of 1-ring gradients
    % loop through rings
    for i = 1:num_rings

        angles = length_angle_list(length_angle_rings(i,1):length_angle_rings(i,2),:);
        edges = length_edge_list(length_edge_rings(i,1):length_edge_rings(i,2),:);
        
        
        alpha = 2*pi - atan2_angle(points(angles(1,1),:), points(angles(1,2),:), points(angles(1,3),:)) - atan2_angle(points(angles(2,1),:), points(angles(2,2),:), points(angles(2,3),:)); 
        beta = 2*pi - atan2_angle(points(angles(3,1),:), points(angles(3,2),:), points(angles(3,3),:)) - atan2_angle(points(angles(4,1),:), points(angles(4,2),:), points(angles(4,3),:)); 
        gamma = 2*pi - atan2_angle(points(angles(5,1),:), points(angles(5,2),:), points(angles(5,3),:)) - atan2_angle(points(angles(6,1),:), points(angles(6,2),:), points(angles(6,3),:)); 
        delta = 2*pi - atan2_angle(points(angles(7,1),:), points(angles(7,2),:), points(angles(7,3),:)) - atan2_angle(points(angles(8,1),:), points(angles(8,2),:), points(angles(8,3),:)); 
        
        % vector form
        edgea = (points(edges(1,2), :) - points(edges(1,1), :));
        edgeb = (points(edges(2,2), :) - points(edges(2,1), :));
        edgec = (points(edges(3,2), :) - points(edges(3,1), :));
        edged = (points(edges(4,2), :) - points(edges(4,1), :));
        edgee = (points(edges(5,2), :) - points(edges(5,1), :));
        edgef = (points(edges(6,2), :) - points(edges(6,1), :));

        % edge length
        a = sqrt(sum((points(edges(1,2), :) - points(edges(1,1), :)).^2,2));
        b = sqrt(sum((points(edges(2,2), :) - points(edges(2,1), :)).^2,2));
        c = sqrt(sum((points(edges(3,2), :) - points(edges(3,1), :)).^2,2));
        d = sqrt(sum((points(edges(4,2), :) - points(edges(4,1), :)).^2,2));
        e = sqrt(sum((points(edges(5,2), :) - points(edges(5,1), :)).^2,2));
        f = sqrt(sum((points(edges(6,2), :) - points(edges(6,1), :)).^2,2));
        
        %% for the edges
        
        % index into rows
        col_inda1 = (edges(1,1)-1)*2+1;
        col_inda2 = (edges(1,2)-1)*2+1;
        
        col_indb1 = (edges(2,1)-1)*2+1;
        col_indb2 = (edges(2,2)-1)*2+1;
        
        col_indc1 = (edges(3,1)-1)*2+1;
        col_indc2 = (edges(3,2)-1)*2+1;
        
        col_indd1 = (edges(4,1)-1)*2+1;
        col_indd2 = (edges(4,2)-1)*2+1;
        
        col_inde1 = (edges(5,1)-1)*2+1;
        col_inde2 = (edges(5,2)-1)*2+1;
        
        col_indf1 = (edges(6,1)-1)*2+1;
        col_indf2 = (edges(6,2)-1)*2+1;
        
        
        grada = (2*(a - b*sin(beta)/sin(alpha+beta)) + 2*(c - b*sin(alpha)/sin(alpha+beta))*cos(alpha+beta))*edgea/a;
        gradb = (-2*(a - b*sin(beta)/sin(alpha+beta))*sin(beta)/sin(alpha+beta) -2*(c - b*sin(alpha)/sin(alpha+beta))*sin(alpha)/sin(alpha+beta) ...
                -2*(a - b*sin(beta)/sin(alpha+beta))*sin(alpha)/sin(alpha+beta)*cos(alpha+beta) -2*(c - b*sin(alpha)/sin(alpha+beta))*sin(beta)/sin(alpha+beta)*cos(alpha+beta))*edgeb/b;
        gradc = (2*(c - b*sin(alpha)/sin(alpha+beta)) + 2*(a - b*sin(beta)/sin(alpha+beta))*cos(alpha+beta))*edgec/c;
        gradd = (2*(d - e*sin(delta)/sin(gamma+delta)) + 2*(f - e*sin(gamma)/sin(gamma+delta))*cos(gamma+delta))*edged/d; 
        grade = (-2*(d - e*sin(delta)/sin(gamma+delta))*sin(delta)/sin(gamma+delta) -2*(f - e*sin(gamma)/sin(gamma+delta))*sin(gamma)/sin(gamma+delta) ...
                -2*(d - e*sin(delta)/sin(gamma+delta))*sin(gamma)/sin(gamma+delta)*cos(gamma+delta) -2*(f - e*sin(gamma)/sin(gamma+delta))*sin(delta)/sin(gamma+delta)*cos(gamma+delta))*edgee/e;
        gradf = (2*(f - e*sin(gamma)/sin(gamma+delta)) + 2*(d - e*sin(delta)/sin(gamma+delta))*cos(gamma+delta))*edgef/f;
        
        
% %         % store the gradients
        if J_ind(col_inda1) > 0 
            rows(i,J_ind(col_inda1):J_ind(col_inda1)+1) = rows(i,J_ind(col_inda1):J_ind(col_inda1)+1) - grada;                                
        end
        if J_ind(col_inda2) > 0 
            rows(i,J_ind(col_inda2):J_ind(col_inda2)+1) = rows(i,J_ind(col_inda2):J_ind(col_inda2)+1) + grada;                                
        end
        if J_ind(col_indb1) > 0 
            rows(i,J_ind(col_indb1):J_ind(col_indb1)+1) = rows(i,J_ind(col_indb1):J_ind(col_indb1)+1) - gradb;                                
        end
        if J_ind(col_indb2) > 0 
            rows(i,J_ind(col_indb2):J_ind(col_indb2)+1) = rows(i,J_ind(col_indb2):J_ind(col_indb2)+1) + gradb;                                    
        end
        if J_ind(col_indc1) > 0 
            rows(i,J_ind(col_indc1):J_ind(col_indc1)+1) = rows(i,J_ind(col_indc1):J_ind(col_indc1)+1) - gradc;                                
        end
        if J_ind(col_indc2) > 0 
            rows(i,J_ind(col_indc2):J_ind(col_indc2)+1) = rows(i,J_ind(col_indc2):J_ind(col_indc2)+1) + gradc;                                
        end
        
        
        if J_ind(col_indd1) > 0 
            rows(i,J_ind(col_indd1):J_ind(col_indd1)+1) = rows(i,J_ind(col_indd1):J_ind(col_indd1)+1) + gradd;                               
        end
        if J_ind(col_indd2) > 0
            rows(i,J_ind(col_indd2):J_ind(col_indd2)+1) = rows(i,J_ind(col_indd2):J_ind(col_indd2)+1) - gradd;                           
        end
        if J_ind(col_inde1) > 0 
            rows(i,J_ind(col_inde1):J_ind(col_inde1)+1) = rows(i,J_ind(col_inde1):J_ind(col_inde1)+1) + grade;                                     
        end
        if J_ind(col_inde2) > 0
            rows(i,J_ind(col_inde2):J_ind(col_inde2)+1) = rows(i,J_ind(col_inde2):J_ind(col_inde2)+1) - grade;                                                  
        end
        if J_ind(col_indf1) > 0 
            rows(i,J_ind(col_indf1):J_ind(col_indf1)+1) = rows(i,J_ind(col_indf1):J_ind(col_indf1)+1) + gradf;                             
        end
        if J_ind(col_indf2) > 0
            rows(i,J_ind(col_indf2):J_ind(col_indf2)+1) = rows(i,J_ind(col_indf2):J_ind(col_indf2)+1) - gradf;                                
        end
        
        
        %% for the angles
        for j = 1:length(angles)
            
            % compute gradient of this angle (assume proper node order)
            this_grad = angle_grad(points(angles(j,1),:), points(angles(j,2),:), points(angles(j,3),:));
            
            % get node indices of this angle            
            nodes = [(angles(j,1)-1)*2+1 (angles(j,2)-1)*2+1 (angles(j,3)-1)*2+1];
            
            % store this gradient of this angle
            if j == 1 || j == 2
                % diff wrt the angle in alpha
                % note the negative sign as alpha = 2pi - angle - angle
                for z = 1:3
                    if J_ind(nodes(z)) > 0
                        rows(i,J_ind(nodes(z)):J_ind(nodes(z))+1) = rows(i,J_ind(nodes(z)):J_ind(nodes(z))+1) - this_grad(z,:)*( ...
                            2*(a - b*sin(beta)/sin(alpha+beta))*b*sin(beta)/sin(alpha+beta)^2*cos(alpha+beta) ...
                        + 2*(c - b*sin(alpha)/sin(alpha+beta))*(-b)*(cos(alpha)*sin(alpha+beta) - sin(alpha)*cos(alpha+beta))/sin(alpha+beta)^2 ...
                        + 2*b*sin(beta)/sin(alpha+beta)^2*cos(alpha+beta)*(c - b*sin(alpha)/sin(alpha+beta))*cos(alpha+beta) ...
                        + 2*(a - b*sin(beta)/sin(alpha+beta))*(-b)*(cos(alpha)*sin(alpha+beta) - sin(alpha)*cos(alpha+beta))/sin(alpha+beta)^2*cos(alpha+beta) ...
                        + 2*(a - b*sin(beta)/sin(alpha+beta))*(c - b*sin(alpha)/sin(alpha+beta))*(-sin(alpha+beta)) ); 
                    end
                end
                    
            elseif j == 3 || j == 4
                % diff wrt the angle in beta
                for z = 1:3
                    if J_ind(nodes(z)) > 0
                        rows(i,J_ind(nodes(z)):J_ind(nodes(z))+1) = rows(i,J_ind(nodes(z)):J_ind(nodes(z))+1) - this_grad(z,:)*( ...
                            2*(c - b*sin(alpha)/sin(beta+alpha))*b*sin(alpha)/sin(beta+alpha)^2*cos(beta+alpha) ...
                        + 2*(a - b*sin(beta)/sin(beta+alpha))*(-b)*(cos(beta)*sin(beta+alpha) - sin(beta)*cos(beta+alpha))/sin(beta+alpha)^2 ...
                        + 2*b*sin(alpha)/sin(beta+alpha)^2*cos(beta+alpha)*(a - b*sin(beta)/sin(beta+alpha))*cos(beta+alpha) ...
                        + 2*(c - b*sin(alpha)/sin(beta+alpha))*(-b)*(cos(beta)*sin(beta+alpha) - sin(beta)*cos(beta+alpha))/sin(beta+alpha)^2*cos(beta+alpha) ...
                        + 2*(c - b*sin(alpha)/sin(beta+alpha))*(a - b*sin(beta)/sin(beta+alpha))*(-sin(beta+alpha)) ); 
                    end
                end
                    
            elseif j == 5 || j == 6
                % diff wrt the angle in gamma
                for z = 1:3
                    if J_ind(nodes(z)) > 0
                        rows(i,J_ind(nodes(z)):J_ind(nodes(z))+1) = rows(i,J_ind(nodes(z)):J_ind(nodes(z))+1) + this_grad(z,:)*( ...
                            2*(d - e*sin(delta)/sin(gamma+delta))*e*sin(delta)/sin(gamma+delta)^2*cos(gamma+delta) ...
                        + 2*(f - e*sin(gamma)/sin(gamma+delta))*(-e)*(cos(gamma)*sin(gamma+delta) - sin(gamma)*cos(gamma+delta))/sin(gamma+delta)^2 ...
                        + 2*e*sin(delta)/sin(gamma+delta)^2*cos(gamma+delta)*(f - e*sin(gamma)/sin(gamma+delta))*cos(gamma+delta) ...
                        + 2*(d - e*sin(delta)/sin(gamma+delta))*(-e)*(cos(gamma)*sin(gamma+delta) - sin(gamma)*cos(gamma+delta))/sin(gamma+delta)^2*cos(gamma+delta) ...
                        + 2*(d - e*sin(delta)/sin(gamma+delta))*(f - e*sin(gamma)/sin(gamma+delta))*(-sin(gamma+delta)) ); 
                    end
                end
                    
            elseif j == 7 || j == 8
                % diff wrt the angle in delta
                for z = 1:3
                    if J_ind(nodes(z)) > 0
                        rows(i,J_ind(nodes(z)):J_ind(nodes(z))+1) = rows(i,J_ind(nodes(z)):J_ind(nodes(z))+1) + this_grad(z,:)*( ...
                            2*(f - e*sin(gamma)/sin(delta+gamma))*e*sin(gamma)/sin(delta+gamma)^2*cos(delta+gamma) ...
                        + 2*(d - e*sin(delta)/sin(delta+gamma))*(-e)*(cos(delta)*sin(delta+gamma) - sin(delta)*cos(delta+gamma))/sin(delta+gamma)^2 ...
                        + 2*e*sin(gamma)/sin(delta+gamma)^2*cos(delta+gamma)*(d - e*sin(delta)/sin(delta+gamma))*cos(delta+gamma) ...
                        + 2*(f - e*sin(gamma)/sin(delta+gamma))*(-e)*(cos(delta)*sin(delta+gamma) - sin(delta)*cos(delta+gamma))/sin(delta+gamma)^2*cos(delta+gamma) ...
                        + 2*(f - e*sin(gamma)/sin(delta+gamma))*(d - e*sin(delta)/sin(delta+gamma))*(-sin(delta+gamma)) ); 
                    end
                end
            end
                    
        end
        
    end

end

