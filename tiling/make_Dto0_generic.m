function Dto0 = make_Dto0_generic(face_sets0, face_setsD)
% faces aren't duplicated during deployment, so as long as the faces and
% nodes are stored in order in the unit cells, this correspondence will
% hold in the deployed + consolidated structure

    Dto0 = [];
    
    for j = 1:length(face_setsD)
        
        faces0 = face_sets0{j};
        facesD = face_setsD{j};
        
        for i = 1:size(facesD,1)
            Dto0(facesD(i,:)) = faces0(i,:);
        end
        
    end
    