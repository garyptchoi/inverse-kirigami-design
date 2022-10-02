% face_sets0: all nodes in initial space
function [face_adjs, intervals] = face_adjs_generic(face_sets0)    


    % make all edges and intervals
    edges = [];
    intervals = [];
    num_face_sets = length(face_sets0);
    total_faces = 0;
    for i = 1:num_face_sets
       
        faces = face_sets0{i};
        num_faces = size(faces, 1);
        
        for k = 1:size(faces,2)
            edges = [edges; faces(:,[k mod(k,size(faces,2))+1]) (total_faces+1:total_faces+num_faces)'];            
        end        
        
        intervals = [intervals; repmat(i, num_faces, 1) (1:num_faces)'];        
        total_faces = total_faces + num_faces;
        
    end
    
    % first node in each edge should be smaller or equal
    edges(edges(:,1) > edges(:,2),[1 2]) = edges(edges(:,1) > edges(:,2),[2 1]);    

    % sort edges and edge_points
    edges = sortrows(edges);
    
    % look at the difference between consecutive rows to find duplicates
    diff_edges = diff(edges);
    %diff_edges = logical(cat(1,diff_edges(:,1) == 0 & diff_edges(:,2) == 0,0));        
    diff_edges = [sum(logical(diff_edges(:,[1,2])),2) == 0; false];
    

    % make boolean vector of all corresponding duplicate edge locations
    other_diff_edges = [false; diff_edges];
    other_diff_edges(end) = [];

    % make list of column adjacenciess
    face_adjs = [edges(diff_edges,3) edges(other_diff_edges,3)];
    
    % remove redundant adjs
    face_adjs(face_adjs(:,1) > face_adjs(:,2),[1 2]) = face_adjs(face_adjs(:,1) > face_adjs(:,2),[2 1]);    

    % sort face_adjs and edge_points
    face_adjs = sortrows(face_adjs);
    
    % look at the difference between consecutive rows to find duplicates
    diff_face_adjs = diff(face_adjs);    
    diff_face_adjs = [sum(logical(diff_face_adjs),2) == 0; false];
    face_adjs(diff_face_adjs, :) = [];
    

end

