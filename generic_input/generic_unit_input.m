function [points0, pointsD, faces0, facesD, shift0, shiftD, corners0, cornersD, overlapD] = generic_unit_input(unit_dir)


    disp('unit cell directory:')
    disp(unit_dir)

    % points
    points_files = dir(strcat(unit_dir, 'points_*'));

    disp(points_files(1).name)
    disp(points_files(2).name)

    points0 = dlmread(strcat(unit_dir, points_files(1).name));
    pointsD = dlmread(strcat(unit_dir, points_files(2).name));


    % faces
    faces_files = dir(strcat(unit_dir, 'faces_*'));
    num_face_files = length(faces_files)-1;

    faces0 = {};
    facesD = {};
    for i = 1:2:num_face_files  

        disp(faces_files(i).name)
        disp(faces_files(i+1).name)

        these_faces0 = dlmread(strcat(unit_dir, faces_files(i).name));
        these_facesD = dlmread(strcat(unit_dir, faces_files(i+1).name));

        faces0{(i+1)/2,1} = these_faces0;
        facesD{(i+1)/2,1} = these_facesD;

    end

    % shifts
    shift_files = dir(strcat(unit_dir, 'shift*'));

    disp(shift_files(1).name)
    disp(shift_files(2).name)

    shift0 = dlmread(strcat(unit_dir, shift_files(1).name));
    shiftD = dlmread(strcat(unit_dir, shift_files(2).name));



    % corners
    corners_files = dir(strcat(unit_dir, 'corners*'));

    disp(corners_files(1).name)
    disp(corners_files(2).name)

    corners0 = dlmread(strcat(unit_dir, corners_files(1).name));
    cornersD = dlmread(strcat(unit_dir, corners_files(2).name));
    
    
    
    % non-overlapping
    overlap_files = dir(strcat(unit_dir, 'overlap*'));

    disp(overlap_files(1).name)
    disp(overlap_files(2).name)

    overlap0 = dlmread(strcat(unit_dir, overlap_files(1).name));
    overlapD = dlmread(strcat(unit_dir, overlap_files(2).name));



end


