function [] = plot_faces_generic_3D(points, face_sets, fig_number, styles)

    num_face_sets = length(face_sets);

    graph = figure(fig_number);
    for j = 1:num_face_sets
        faces = face_sets{j};
        for i = 1:size(faces,1)                 
            if mod(j,2) == 1
                this_face = fill3(points(faces(i,:),1), points(faces(i,:),2), points(faces(i,:),3), [255 229 204]/255, 'LineWidth',2);
            else
                this_face = fill3(points(faces(i,:),1), points(faces(i,:),2), points(faces(i,:),3), [153 255 153]/255, 'LineWidth',1.5);
            end
            if nargin == 4
                for z = 1:length(styles)
                    set(this_face, styles{z}{1}, styles{z}{2});
                end
            end
        end
    end
        
    ax = gca;               % get the current axis
    ax.Clipping = 'off';    % turn clipping off
    
    assetData = struct('Vertex',points);
    setappdata(gca,'AssetData',assetData);

    dcm_obj = datacursormode(graph);
    set(dcm_obj,'UpdateFcn',@ID_display3D,'Enable','on')
    
end

function txt = ID_display3D(obj,event_obj)

        hAxes = get(get(event_obj,'Target'),'Parent');
        assetData = getappdata(hAxes,'AssetData');

        pos = get(event_obj,'Position');
        id = vertex_search3D([pos(1),pos(2),pos(3)],assetData.Vertex);
        txt = {['(x,y,z) : (',num2str(pos(1)),',',num2str(pos(2)),',',num2str(pos(3)),')'],...
            ['vertex ID : ',int2str(id)]};
end


function index = vertex_search3D(XYZ,vertex)

    k = size(XYZ,1);
    index = zeros(k,1);
    for i = 1:k
        [~,index(i,1)] = min(sqrt((vertex(:,1)-XYZ(i,1)).^2 + (vertex(:,2)-XYZ(i,2)).^2 + (vertex(:,3)-XYZ(i,3)).^2));
    end

    if length(unique(index)) ~= length(index)
        warning('Some points are sharing the same vertex index found')
    end   
end