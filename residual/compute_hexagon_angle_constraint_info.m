function [new_angle_list, hex_rings] = compute_hexagon_angle_constraint_info(...
    pointsD_trivial, anglesD, hdist, vdist, width, height)

    new_angle_list = [];
    
    hex_ring_ref = anglesD(1:12,:);
    % find the direct vertical/horizontal shifts
    for m = 0:width-1
        for n = 0:height-1
            new_angle = zeros(12,3);
            for i = 1:12
                for j = 1:3
                    % find the displaced point
                    old_pos = pointsD_trivial(hex_ring_ref(i,j),:);
                    new_pos = [old_pos(1) + m*hdist, old_pos(2) + n*vdist];
                    [~, id] = min(abs(pointsD_trivial(:,1) - new_pos(1)) + abs(pointsD_trivial(:,2) - new_pos(2)));
                    new_angle(i,j) = id;
                end
            end
            new_angle_list = [new_angle_list; new_angle];
        end
    end
    
    % find the indirect shifts
    for m = 0:width-2
        for n = 0:height-2
            new_angle = zeros(12,3);
            for i = 1:12
                for j = 1:3
                    % find the displaced point
                    old_pos = pointsD_trivial(hex_ring_ref(i,j),:) + (pointsD_trivial(10,:)-pointsD_trivial(5,:));
                    new_pos = [old_pos(1) + m*hdist, old_pos(2) + n*vdist];
                    [~, id] = min(abs(pointsD_trivial(:,1) - new_pos(1)) + abs(pointsD_trivial(:,2) - new_pos(2)));
                    new_angle(i,j) = id;
                end
            end
            new_angle_list = [new_angle_list; new_angle];
        end
    end
                    
    hex_rings = [12*(0:(length(new_angle_list)/12-1))'+1, 12*(1:length(new_angle_list)/12)'];