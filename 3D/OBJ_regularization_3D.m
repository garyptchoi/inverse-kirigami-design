% objective + grad function handle for regularization energy
function [E, J] = OBJ_regularization_3D(pointsD, face_setsD, same_face_adjs)
    % minimize the length and angle change across the entire domain
    E = E_regularization_3D(pointsD, face_setsD, same_face_adjs);
    J = J_regularization_3D(pointsD, face_setsD, same_face_adjs);    

end