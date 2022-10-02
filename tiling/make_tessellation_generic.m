function [pointsD, edgesD, edge_pairsD, anglesD, ringsD, facesD, free, path_adjs, intervals, Dto0, unitfacesD, cornersD, overlapD, points0] = ...
    make_tessellation_generic(unit_dir, width, height, plot_toggle)   
    
    % close existing figures
    if plot_toggle        
        close all
    end
    
    label_nodes = false; 
    draw_layout_path = false; 
    draw_corner_nodes = false;
    draw_angle = plot_toggle;
    draw_edge_pair = plot_toggle;
    
    % |-_-| |-_-| |-_-| |-_-| |-_-| |-_-| |-_-| |-_-| |-_-| |-_-| |-_-| |-_-|
    %
    % Unit Cell
    %
    % |-_-| |-_-| |-_-| |-_-| |-_-| |-_-| |-_-| |-_-| |-_-| |-_-| |-_-| |-_-|


    % generate unit cell (initial and deployed)
    [unit0, unitD, unitfaces0, unitfacesD, shift0, shiftD, unitcorners0, unitcornersD, unitoverlapD] = generic_unit_input(unit_dir);
    unitedges0 = make_edges(unitfaces0);
    unitedgesD = make_edges(unitfacesD);
    unitanglesD = make_angles(unitfacesD);

    % center
    unit0 = unit0 - repmat(sum(unit0,1)/size(unit0,1), size(unit0,1), 1);
    unitD = unitD - repmat(sum(unitD,1)/size(unitD,1), size(unitD,1), 1);

    % show the unit cells (initial and deployed)
    if plot_toggle       
        figure(1)
        hold on
        axis equal
        axis off
        plot_faces_generic(unit0, unitfaces0, 1)      
        if label_nodes
            for i = 1:size(unit0,1)
                text(unit0(i,1), unit0(i,2), num2str(i))
            end
        end
        
        figure(2)
        hold on
        axis equal
        axis off
        plot_faces_generic(unitD, unitfacesD, 2)
        
    end


    % |-_-| |-_-| |-_-| |-_-| |-_-| |-_-| |-_-| |-_-| |-_-| |-_-| |-_-| |-_-|
    %
    % Tiling
    %
    % |-_-| |-_-| |-_-| |-_-| |-_-| |-_-| |-_-| |-_-| |-_-| |-_-| |-_-| |-_-|

    
    % tile initial tessellation   
    unittopos0 = {unitedges0 1};
    for i = 1:size(unitfaces0,1)
        unittopos0{i+1,1} = unitfaces0{i,1};
        unittopos0{i+1,2} = 1;
    end
    unittopos0{size(unitfaces0,1)+2,1} = unitcorners0;
    unittopos0{size(unitfaces0,1)+2,2} = 1;    
       
    hor_shift = shift0(1,:);
    vert_shift = shift0(2,:);    
    
    [points0, topos0] = tiling_cells(width, height, unit0, hor_shift, vert_shift, unittopos0);        

    edges0 = topos0{1,1};
    faces0 = {};
    for i = 1:size(unitfaces0,1)
        faces0{i} = topos0{i+1};
    end
    corners0 = topos0{size(unitfaces0,1)+2};
    
    
    % tile deployed tessellation    
    unittoposD = {unitedgesD 1; unitanglesD 1};
    for i = 1:size(unitfacesD,1)
        unittoposD{i+2,1} = unitfacesD{i,1};
        unittoposD{i+2,2} = 1;
    end
    unittoposD{size(unitfacesD,1)+3,1} = unitcornersD;
    unittoposD{size(unitfacesD,1)+3,2} = 1;
    unittoposD{size(unitfacesD,1)+4,1} = unitoverlapD;
    unittoposD{size(unitfacesD,1)+4,2} = 1;
    
    hor_shift = shiftD(1,:);
    vert_shift = shiftD(2,:);
        
    [pointsD, toposD] = tiling_cells(width, height, unitD, hor_shift, vert_shift, unittoposD);

    edgesD = toposD{1};
    anglesD = toposD{2};
    facesD = {};
    for i = 1:size(unitfacesD,1)
        facesD{i} = toposD{i+2};
    end
    cornersD = toposD{size(unitfacesD,1)+3};
    
    
    % center
    points0 = points0 - repmat(sum(points0,1)/size(points0,1), size(points0,1), 1);
    pointsD = pointsD - repmat(sum(pointsD,1)/size(pointsD,1), size(pointsD,1), 1);
    
    
    
    % rescale
    rescale = 1/max(max(abs(pointsD)));
    pointsD = pointsD*rescale; % rescale to 2x2
    points0 = points0*rescale;
    
    
    % % compute node correspondence from deployed to initial   
    Dto0 = make_Dto0_generic(faces0, facesD);

    % show the tessellations (initial and deployed)
    if plot_toggle
        
        figure(3)
        clf
        hold on
        axis equal 
        axis off
        plot_faces_generic(points0, faces0, 3)
        if draw_corner_nodes
            plot(points0(corners0,1), points0(corners0,2), 'or', 'LineWidth', 1)
        end
        
        figure(4)
        clf
        hold on
        axis equal 
        axis off
        plot_faces_generic(pointsD, facesD, 4)
        if draw_corner_nodes
            plot(pointsD(cornersD,1), pointsD(cornersD,2), 'or', 'LineWidth', 1)
        end
    
        
        if label_nodes
            
            % label points
            for i = 1:length(Dto0)            
                text(pointsD(i,1), pointsD(i,2)+.01, num2str(i))
            end

            figure(3)
            hold on
            for i = 1:size(points0,1)
                text(points0(i,1), points0(i,2)+.01, num2str(i))
            end
            
            figure(2)
            for i = 1:size(unitD,1)
                text(unitD(i,1), unitD(i,2), strcat(num2str(i), '->', num2str(Dto0(i))))
            end
        
            
        end
    end    
    
    
    % |-_-| |-_-| |-_-| |-_-| |-_-| |-_-| |-_-| |-_-| |-_-| |-_-| |-_-| |-_-|
    %
    % Edge Pairs (Deployed -- Inverse)
    %
    % |-_-| |-_-| |-_-| |-_-| |-_-| |-_-| |-_-| |-_-| |-_-| |-_-| |-_-| |-_-|


    % make edge pairs using correspondence between deployed and initial nodes
    edge_pairsD = make_edge_pairs(edgesD, Dto0);


    if draw_edge_pair
        % draw edge pair stencils
        figure(4)
        hold on
        for i = 1:size(edge_pairsD,1)  
            ptA = (pointsD(edgesD(edge_pairsD(i,1),1),:) + pointsD(edgesD(edge_pairsD(i,1),2),:))/2;
            ptB = (pointsD(edgesD(edge_pairsD(i,2),1),:) + pointsD(edgesD(edge_pairsD(i,2),2),:))/2;            
            plot([ptA(1) ptB(1)], [ptA(2) ptB(2)], '--r', 'LineWidth',2)                          
        end
    end


    % |-_-| |-_-| |-_-| |-_-| |-_-| |-_-| |-_-| |-_-| |-_-| |-_-| |-_-| |-_-|
    %
    % Developability Rings (Deployed -- Inverse)
    %
    % |-_-| |-_-| |-_-| |-_-| |-_-| |-_-| |-_-| |-_-| |-_-| |-_-| |-_-| |-_-|

    % cuts down and orders alphas, betas and phis to correspond to rings
    [ringsD, anglesD] = make_dev_rings_generic(anglesD, Dto0);

    
    if draw_angle
    
        % draw the angles in the rings
        % choose a length scale
        r = 1/sqrt(size(pointsD,1))/2; 


        figure(4)
        hold on
        
        for i = 1:size(ringsD,1)

            for j = ringsD(i,1):ringsD(i,2)

                % get this angle stencil
                this_angle = anglesD(j,:);
                

                % compute this angle
                theta = LOC_angle(pointsD(this_angle(1),:), pointsD(this_angle(2),:), pointsD(this_angle(3),:));
                if twoD_cross(pointsD(this_angle(1),:), pointsD(this_angle(2),:), pointsD(this_angle(3),:)) < 0
                    theta = 2*pi - theta;
                end

                % get the start position
                A = -pointsD(this_angle(1),:) + pointsD(this_angle(2),:);
                A = A/norm(A)*r;

                % draw arc
                R = twoD_rotation(theta/20);
                arc = A;                
                res = 20;
                for z = 1:res
                    arc = [arc; (R*arc(end,:)')'];
                end
                arc = arc + repmat(pointsD(this_angle(1),:), res+1, 1);


                plot(arc(:,1), arc(:,2), '-b', 'LineWidth',2)



            end

        end
    
    end
    
    
    % draw angles on points0
    if draw_angle
        % draw the angles in the rings
        % choose a length scale
        r = 1/sqrt(size(points0,1))/2; 

        figure(3)
        hold on
        for i = 1:size(ringsD,1)
            for j = ringsD(i,1):ringsD(i,2)

                % get this angle stencil
                this_angle = Dto0(anglesD(j,:));
                % compute this angle
                theta = LOC_angle(points0(this_angle(1),:), points0(this_angle(2),:), points0(this_angle(3),:));
                if twoD_cross(points0(this_angle(1),:), points0(this_angle(2),:), points0(this_angle(3),:)) < 0
                    theta = 2*pi - theta;
                end

                % get the start position
                A = -points0(this_angle(1),:) + points0(this_angle(2),:);
                A = A/norm(A)*r;

                % draw arc
                R = twoD_rotation(theta/20);
                arc = A;                
                res = 20;
                for z = 1:res
                    arc = [arc; (R*arc(end,:)')'];
                end
                arc = arc + repmat(points0(this_angle(1),:), res+1, 1);
                plot(arc(:,1), arc(:,2), '-b', 'LineWidth',2)

            end
        end
    end
    
    
    % |-_-| |-_-| |-_-| |-_-| |-_-| |-_-| |-_-| |-_-| |-_-| |-_-| |-_-| |-_-|
    %
    % Free Nodes on the Boundary
    %
    % |-_-| |-_-| |-_-| |-_-| |-_-| |-_-| |-_-| |-_-| |-_-| |-_-| |-_-| |-_-|
    
    % find free nodes (nodes that don't belong to any constraint stencils)
    num_points = size(pointsD,1);
    free = (1:num_points)';    
    for i = 1:size(ringsD, 1)
        free = free(~ismember(free, anglesD(ringsD(i,1):ringsD(i,2),1)));
    end
    
    % |-_-| |-_-| |-_-| |-_-| |-_-| |-_-| |-_-| |-_-| |-_-| |-_-| |-_-| |-_-|
    %
    % Face Adjacencies (For Layout of Inverse Problem Solutions)
    %
    % |-_-| |-_-| |-_-| |-_-| |-_-| |-_-| |-_-| |-_-| |-_-| |-_-| |-_-| |-_-|
        
    
    % compute column adjacencies
    [all_adjs, intervals] = face_adjs_generic(faces0);
    
    
    % build sparse matrix of column connections
    G = graph(all_adjs(:,1), all_adjs(:,2));
    
    % compute breadth first traverse over column connections
    start_node = 1;
    disc = bfsearch(G, start_node, {'discovernode', 'edgetonew'});
    
    % plot layout path
    path_adjs = disc.Edge(~isnan(disc.Edge(:,1)),:);  
    
    if draw_layout_path
        
        figure(3)
        hold on
        for i = 1:size(path_adjs,1)
            
            % get face indices
            face1 = path_adjs(i,1);
            face2 = path_adjs(i,2);    

            % compute centroids of faces
            ptA = sum(points0(faces0{intervals(face1,1)}(intervals(face1,2),:),:),1)/size(faces0{intervals(face1,1)},2);
            ptB = sum(points0(faces0{intervals(face2,1)}(intervals(face2,2),:),:),1)/size(faces0{intervals(face2,1)},2);

            % plot centroid paths
            plot([ptA(1) ptB(1)], [ptA(2) ptB(2)], '-b')

        end
        
        ptStart = sum(points0(faces0{intervals(start_node,1)}(intervals(start_node,2),:),:),1)/size(faces0{intervals(start_node,1)},2);            
        plot(ptStart(1), ptStart(2), 'ob')
        
    end
    
    
    
    % |-_-| |-_-| |-_-| |-_-| |-_-| |-_-| |-_-| |-_-| |-_-| |-_-| |-_-| |-_-|
    %
    % Non-overlap Stencils
    %
    % |-_-| |-_-| |-_-| |-_-| |-_-| |-_-| |-_-| |-_-| |-_-| |-_-| |-_-| |-_-|
    
        
    overlapD = find_overlap_angles(facesD, all_adjs, intervals);     
    

end

