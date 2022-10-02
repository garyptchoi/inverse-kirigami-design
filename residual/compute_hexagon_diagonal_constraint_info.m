function [length_angle_list1, length_angle_rings1, length_angle_list2, ...
    length_angle_rings2, length_angle_list3, length_angle_rings3, ...
    length_edge_list1, length_edge_rings1, length_edge_list2, ...
    length_edge_rings2, length_edge_list3, length_edge_rings3] ...
    = compute_hexagon_diagonal_constraint_info(pointsD_trivial, anglesD, hdist, vdist, width, height)

    %% build angle+edge length constraint (equal diagonal computed by two ways)
    % need to consider all hexagon rings
    length_angle_ref1 = anglesD([1 2 3 4 10 9 8 7],:);
    length_angle_list1 = [];
    
    % find the direct vertical/horizontal shifts
    for m = 0:width-1
        for n = 0:height-1
            new_angle = zeros(8,3);
            for i = 1:8
                for j = 1:3
                    % find the displaced point
                    old_pos = pointsD_trivial(length_angle_ref1(i,j),:);
                    new_pos = [old_pos(1) + m*hdist, old_pos(2) + n*vdist];
                    [~, id] = min(abs(pointsD_trivial(:,1) - new_pos(1)) + abs(pointsD_trivial(:,2) - new_pos(2)));
                    new_angle(i,j) = id;
                end
            end
            length_angle_list1 = [length_angle_list1; new_angle];
        end
    end
    
    % find the indirect shifts
    for m = 0:width-2
        for n = 0:height-2
            new_angle = zeros(8,3);
            for i = 1:8
                for j = 1:3
                    % find the displaced point
                    old_pos = pointsD_trivial(length_angle_ref1(i,j),:) + (pointsD_trivial(10,:)-pointsD_trivial(5,:));
                    new_pos = [old_pos(1) + m*hdist, old_pos(2) + n*vdist];
                    [~, id] = min(abs(pointsD_trivial(:,1) - new_pos(1)) + abs(pointsD_trivial(:,2) - new_pos(2)));
                    new_angle(i,j) = id;
                end
            end
            length_angle_list1 = [length_angle_list1; new_angle];
        end
    end
                    
    length_angle_rings1 = [8*(0:(length(length_angle_list1)/8-1))'+1, 8*(1:length(length_angle_list1)/8)'];
    
    
    
    length_edge_ref = [27 1; 1 2; 11 3; 5 6; 19 5; 3 4];
    length_edge_list1 = [];
    
    % find the direct vertical/horizontal shifts
    for m = 0:width-1
        for n = 0:height-1
            new_edge = zeros(6,2);
            for i = 1:6
                for j = 1:2
                    % find the displaced point
                    old_pos = pointsD_trivial(length_edge_ref(i,j),:);
                    new_pos = [old_pos(1) + m*hdist, old_pos(2) + n*vdist];
                    [~, id] = min(abs(pointsD_trivial(:,1) - new_pos(1)) + abs(pointsD_trivial(:,2) - new_pos(2)));
                    new_edge(i,j) = id;
                end
            end
            length_edge_list1 = [length_edge_list1; new_edge];
        end
    end
    
    % find the indirect shifts
    for m = 0:width-2
        for n = 0:height-2
            new_edge = zeros(6,2);
            for i = 1:6
                for j = 1:2
                    % find the displaced point
                    old_pos = pointsD_trivial(length_edge_ref(i,j),:) + (pointsD_trivial(10,:)-pointsD_trivial(5,:));
                    new_pos = [old_pos(1) + m*hdist, old_pos(2) + n*vdist];
                    [~, id] = min(abs(pointsD_trivial(:,1) - new_pos(1)) + abs(pointsD_trivial(:,2) - new_pos(2)));
                    new_edge(i,j) = id;
                end
            end
            length_edge_list1 = [length_edge_list1; new_edge];
        end
    end
                    
    length_edge_rings1 = [6*(0:(length(length_edge_list1)/6-1))'+1, 6*(1:length(length_edge_list1)/6)'];
    
    %% build angle+edge length constraint (equal diagonal computed by two ways)
    % need to consider all hexagon rings
    length_angle_ref2 = anglesD([5 6 7 8 2 1 12 11],:);
    length_angle_list2 = [];
    
    % find the direct vertical/horizontal shifts
    for m = 0:width-1
        for n = 0:height-1
            new_angle = zeros(8,3);
            for i = 1:8
                for j = 1:3
                    % find the displaced point
                    old_pos = pointsD_trivial(length_angle_ref2(i,j),:);
                    new_pos = [old_pos(1) + m*hdist, old_pos(2) + n*vdist];
                    [~, id] = min(abs(pointsD_trivial(:,1) - new_pos(1)) + abs(pointsD_trivial(:,2) - new_pos(2)));
                    new_angle(i,j) = id;
                end
            end
            length_angle_list2 = [length_angle_list2; new_angle];
        end
    end
    
    % find the indirect shifts
    for m = 0:width-2
        for n = 0:height-2
            new_angle = zeros(8,3);
            for i = 1:8
                for j = 1:3
                    % find the displaced point
                    old_pos = pointsD_trivial(length_angle_ref2(i,j),:) + (pointsD_trivial(10,:)-pointsD_trivial(5,:));
                    new_pos = [old_pos(1) + m*hdist, old_pos(2) + n*vdist];
                    [~, id] = min(abs(pointsD_trivial(:,1) - new_pos(1)) + abs(pointsD_trivial(:,2) - new_pos(2)));
                    new_angle(i,j) = id;
                end
            end
            length_angle_list2 = [length_angle_list2; new_angle];
        end
    end
                    
    length_angle_rings2 = [8*(0:(length(length_angle_list2)/8-1))'+1, 8*(1:length(length_angle_list2)/8)'];
    
    
    
    length_edge_ref2 = [11 3; 3 4; 19 5; 1 2; 27 1; 5 6];
    length_edge_list2 = [];
    
    % find the direct vertical/horizontal shifts
    for m = 0:width-1
        for n = 0:height-1
            new_edge = zeros(6,2);
            for i = 1:6
                for j = 1:2
                    % find the displaced point
                    old_pos = pointsD_trivial(length_edge_ref2(i,j),:);
                    new_pos = [old_pos(1) + m*hdist, old_pos(2) + n*vdist];
                    [~, id] = min(abs(pointsD_trivial(:,1) - new_pos(1)) + abs(pointsD_trivial(:,2) - new_pos(2)));
                    new_edge(i,j) = id;
                end
            end
            length_edge_list2 = [length_edge_list2; new_edge];
        end
    end
    
    % find the indirect shifts
    for m = 0:width-2
        for n = 0:height-2
            new_edge = zeros(6,2);
            for i = 1:6
                for j = 1:2
                    % find the displaced point
                    old_pos = pointsD_trivial(length_edge_ref2(i,j),:) + (pointsD_trivial(10,:)-pointsD_trivial(5,:));
                    new_pos = [old_pos(1) + m*hdist, old_pos(2) + n*vdist];
                    [~, id] = min(abs(pointsD_trivial(:,1) - new_pos(1)) + abs(pointsD_trivial(:,2) - new_pos(2)));
                    new_edge(i,j) = id;
                end
            end
            length_edge_list2 = [length_edge_list2; new_edge];
        end
    end
                    
    length_edge_rings2 = [6*(0:(length(length_edge_list2)/6-1))'+1, 6*(1:length(length_edge_list2)/6)'];
    
    %% build angle+edge length constraint (equal diagonal computed by two ways)
    % need to consider all hexagon rings
    length_angle_ref3 = anglesD([9 10 11 12 6 5 4 3],:);
    length_angle_list3 = [];
    
    % find the direct vertical/horizontal shifts
    for m = 0:width-1
        for n = 0:height-1
            new_angle = zeros(8,3);
            for i = 1:8
                for j = 1:3
                    % find the displaced point
                    old_pos = pointsD_trivial(length_angle_ref3(i,j),:);
                    new_pos = [old_pos(1) + m*hdist, old_pos(2) + n*vdist];
                    [~, id] = min(abs(pointsD_trivial(:,1) - new_pos(1)) + abs(pointsD_trivial(:,2) - new_pos(2)));
                    new_angle(i,j) = id;
                end
            end
            length_angle_list3 = [length_angle_list3; new_angle];
        end
    end
    
    % find the indirect shifts
    for m = 0:width-2
        for n = 0:height-2
            new_angle = zeros(8,3);
            for i = 1:8
                for j = 1:3
                    % find the displaced point
                    old_pos = pointsD_trivial(length_angle_ref3(i,j),:) + (pointsD_trivial(10,:)-pointsD_trivial(5,:));
                    new_pos = [old_pos(1) + m*hdist, old_pos(2) + n*vdist];
                    [~, id] = min(abs(pointsD_trivial(:,1) - new_pos(1)) + abs(pointsD_trivial(:,2) - new_pos(2)));
                    new_angle(i,j) = id;
                end
            end
            length_angle_list3 = [length_angle_list3; new_angle];
        end
    end
                    
    length_angle_rings3 = [8*(0:(length(length_angle_list3)/8-1))'+1, 8*(1:length(length_angle_list3)/8)'];
    
    
    
    length_edge_ref3 = [19 5; 5 6; 27 1; 3 4; 11 3; 1 2];
    length_edge_list3 = [];
    
    % find the direct vertical/horizontal shifts
    for m = 0:width-1
        for n = 0:height-1
            new_edge = zeros(6,2);
            for i = 1:6
                for j = 1:2
                    % find the displaced point
                    old_pos = pointsD_trivial(length_edge_ref3(i,j),:);
                    new_pos = [old_pos(1) + m*hdist, old_pos(2) + n*vdist];
                    [~, id] = min(abs(pointsD_trivial(:,1) - new_pos(1)) + abs(pointsD_trivial(:,2) - new_pos(2)));
                    new_edge(i,j) = id;
                end
            end
            length_edge_list3 = [length_edge_list3; new_edge];
        end
    end
    
    % find the indirect shifts
    for m = 0:width-2
        for n = 0:height-2
            new_edge = zeros(6,2);
            for i = 1:6
                for j = 1:2
                    % find the displaced point
                    old_pos = pointsD_trivial(length_edge_ref3(i,j),:) + (pointsD_trivial(10,:)-pointsD_trivial(5,:));
                    new_pos = [old_pos(1) + m*hdist, old_pos(2) + n*vdist];
                    [~, id] = min(abs(pointsD_trivial(:,1) - new_pos(1)) + abs(pointsD_trivial(:,2) - new_pos(2)));
                    new_edge(i,j) = id;
                end
            end
            length_edge_list3 = [length_edge_list3; new_edge];
        end
    end
                    
    length_edge_rings3 = [6*(0:(length(length_edge_list3)/6-1))'+1, 6*(1:length(length_edge_list3)/6)'];
    