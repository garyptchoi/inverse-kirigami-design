% Main program for designing generalized hexagon kirigami patterns
% 
% Note: 
% - The option of controlling the contracted boundary shape is not yet available.
%
% If you use this code in your work, please cite:
%
% G. P. T. Choi, L. H. Dudte, and L. Mahadevan, 
% "Programming shape using kirigami tessellations."
% Nature Materials, 18(9), 999-1004, 2019.
% 
% Copyright (c) 2019-2022, Gary Pui-Tung Choi, Levi H. Dudte, L. Mahadevan
    
clearvars
addpath(genpath('.'))

% Set the kirigami pattern size
width = 4;
height = 2;

% Choose the target deployed shape
shapes = {'circle', 'egg', 'rainbow', 'anvil', 'shear', 'wedge', 'star', 'wavy'}; % Library of pre-defined shapes
% shape_name = shapes{1};
% shape_name = shapes{2};
% shape_name = shapes{3};
shape_name = shapes{4};
% shape_name = shapes{5};
% shape_name = shapes{6};
% shape_name = shapes{7};
% shape_name = shapes{8};
    
% Set the type of the initial map for the optimization in the deployed space
% 1: standard deployed configuration
% 2: standard deployed configuration with rescaling (with optional parameter scale_factor)
% 3: conformal map (Schwarz-Christoffel mapping)
% 4: Teichmuller map (Meng et al., SIIMS 2016)
% initial_map_type = 1;
% initial_map_type = 2; scale_factor = 1.25; % or other positive number
% initial_map_type = 3;
initial_map_type = 4;

if ~exist('scale_factor','var')
    scale_factor = [];
end

% Enforce all angles to be 2*pi/3?  0 (no) / 1 (yes)
% fix_regular_shape = 0;
fix_regular_shape = 1;

%% construct the tessellation and the initial guess

% load the tessellation unit cell  
unit_dir =  'unit_cell_scripts/hexagon/'; 

% construct the tessellation, i.e. use one seed pattern to generate a large shape
% convention: xxxxxD = deployed space, xxxx0 = initial space
% Dto0: keep track of the indices (since the vertices aren't bijective)
[pointsD_standard, edgesD, edge_pairsD, anglesD, ringsD, face_setsD, free, ...
    path_adjs, intervals, Dto0, unitfacesD, cornersD, overlapD, points0] ...
    = make_tessellation_generic_v2(unit_dir, width, height, false);

% identify points and angles on the boundaries, divide the rectangular boundary into 4 segments
[boundR, boundT, boundL, boundB] = find_boundary_points(pointsD_standard, free);

if fix_regular_shape
    boundary_rings = find_boundary_rings_hexagon(pointsD_standard, anglesD, Dto0, free, cornersD);
else
    boundary_rings = [];
end

% make the initial face sets, keep track of the vertices of each seed pattern
face_sets0 = {};
for i = 1:length(face_setsD)
    face_sets0{i} = Dto0(face_setsD{i});
end

% build a new hex angle ring based on the first 12 angles (for ring angle sum = 8*pi)
% need to consider all hexagon rings
hdist = pointsD_standard(1,1) - pointsD_standard(18,1);
vdist = pointsD_standard(13,2) - pointsD_standard(24,2);
[new_angle_list, hexagon_rings] = compute_hexagon_angle_constraint_info(...
    pointsD_standard, anglesD, hdist, vdist, width, height);

% build diagonal length constraint (equal diagonal computed by two ways)
[length_angle_list1, length_angle_rings1, length_angle_list2, length_angle_rings2, ...
    length_angle_list3, length_angle_rings3, length_edge_list1, length_edge_rings1, ...
    length_edge_list2, length_edge_rings2, length_edge_list3, length_edge_rings3] = ...
    compute_hexagon_diagonal_constraint_info(pointsD_standard, anglesD, hdist, vdist, width, height);
    
% Load the target shape
shape = str2func(shape_name);  
[spline_boundR, spline_boundT, spline_boundL, spline_boundB] = shape();

% construct the initial guess in the deployed space
pointsD = compute_initial_map(pointsD_standard, shape_name, initial_map_type, ...
    scale_factor, boundR, boundT, boundL, boundB);

% plot the initial guess
figure(4)
clf
axis equal
axis off
hold on
plot_faces_generic(pointsD, face_setsD, 4)

plot(pointsD(boundR,1), pointsD(boundR,2), 'or')
plot(pointsD(boundT,1), pointsD(boundT,2), 'og')
plot(pointsD(boundL,1), pointsD(boundL,2), 'ob')
plot(pointsD(boundB,1), pointsD(boundB,2), 'oy')

fnplt(spline_boundR, [0 1], 'r', .5)
fnplt(spline_boundT, [0 1], 'g', .5)
fnplt(spline_boundL, [0 1], 'b', .5)
fnplt(spline_boundB, [0 1], 'y', .5)

title('Initial guess in the deployed space');


%% Constrained optimization

% optimization setup

% for the objective function
% find_smoothing_faces does not work for this pattern, use the following method instead
face_centroid = zeros(length(face_setsD{1}),2);
for jjj = 1:length(face_setsD{1})
    face_centroid(jjj,:) = sum(pointsD_standard(face_setsD{1}(jjj,:),:),1)/6;
end
hshift = [pointsD_standard(1,1) - pointsD_standard(18,1), 0]; 
vshift = [0, pointsD_standard(13,2) - pointsD_standard(24,2)]; 
same_face_adjs = [];
for jjj =  1:length(face_setsD{1})
    % compute shifted points, check if there are faces nearby 
    p = face_centroid(jjj,:);
    for t = 1:4
        switch t
            case 1
                temp = p + hshift;
            case 2
                temp = p - hshift;
            case 3
                temp = p + vshift;
            case 4
                temp = p - vshift;
        end
        kkk = find(abs(face_centroid(:,1) - temp(1)) + abs(face_centroid(:,2) - temp(2))< 0.01);
        if ~isempty(kkk)
            % update the list
            same_face_adjs = [same_face_adjs; jjj, kkk];
        end
    end
end
[same_face_adjs_sorted, ~] = sort(same_face_adjs,2);
[~, id3] = unique(same_face_adjs_sorted,'rows');  % make them unique
same_face_adjs = same_face_adjs(sort(id3),:);
temp = cell(1);
temp{1} = same_face_adjs;
same_face_adjs = temp; 
clear temp; clear id3;


boundary_nodes_cell = {boundR, boundT, boundL, boundB};
boundary_target_splines_cell = {spline_boundR, spline_boundT, spline_boundL, spline_boundB};

options = optimoptions(@fmincon, ...
    'Display', 'iter-detailed', ...
    'Algorithm', 'sqp', ...  % 'sqp' or 'interior-point'
    'SpecifyObjectiveGradient', true, ... % please keep it as true
    'SpecifyConstraintGradient', true, ... % please keep it as true
    'MaxFunctionEvaluations', 10000, ... % or try a larger number
    'MaxIterations', 250, ... % or try a larger number
    'ConstraintTolerance', 1e-6, ... % or try a smaller number
    'StepTolerance', 1e-6, ... % or try a smaller number
    'ScaleProblem', 'obj-and-constr', ... 
    'PlotFcn', {@optimplotfval, @optimplotconstrviolation,@optimplotfirstorderopt});

% main optimization procedure
tic;
[solved_pointsD, ~, ~, ~] = fmincon(@(x)OBJ_regularization( ...
    decompose_v(x), face_setsD, same_face_adjs), ... objective function
    compose_v(pointsD), ... initial point
    [], [], [], [], [], [], ... linear constraints
    @(x)all_constraint_residual_and_jacobian_hexagon( ... all constraints 
    decompose_v(x), ... initial point
    edgesD, edge_pairsD, anglesD, ringsD, boundary_rings, ... stencils
    boundary_nodes_cell, ... boundary nodes
    boundary_target_splines_cell, ... target shape
    overlapD, [], ... non-overlap
    face_setsD{1}, new_angle_list, hexagon_rings, ... % for hexagon angle constraint
    length_edge_list1, length_edge_rings1, length_angle_list1, length_angle_rings1, ... % for hex diagonal constraint
    length_edge_list2, length_edge_rings2, length_angle_list2, length_angle_rings2, ... % for hex diagonal constraint
    length_edge_list3, length_edge_rings3, length_angle_list3, length_angle_rings3 ... % for hex diagonal constraint
    ), options ... optimization options
    );
toc;

% decompose the solved deployed structure
solved_pointsD = decompose_v(solved_pointsD);

% get the final contracted structure
solved_points0 = get_contracted_shape(solved_pointsD, face_setsD, Dto0);

% further rotate the contracted structure optimally
solved_pointsD_temp = [solved_pointsD(:,1) - mean(solved_pointsD(:,1)), solved_pointsD(:,2) - mean(solved_pointsD(:,2))];
solved_points0 = [solved_points0(:,1) - mean(solved_points0(:,1)), solved_points0(:,2) - mean(solved_points0(:,2))];
corners = [boundB(1), boundB(end), boundT(1), boundT(end)];
[U, ~, ~] = Kabsch(solved_points0(Dto0(corners),:)', solved_pointsD_temp(corners,:)');
solved_points0 = (U*solved_points0')';


%% plot the results

% plot the optimized deployed structure
h = figure(5);
clf
hold on
axis off
axis equal

plot_faces_generic(solved_pointsD, face_setsD, h)

before = findall(gca);
fnplt(spline_boundR, [0 1], 'k', 2)
added = setdiff(findall(gca), before);
set(added, 'Color', [201 0 22 200]/255);

before = findall(gca);
fnplt(spline_boundT, [0 1], 'k', 2)
added = setdiff(findall(gca), before);
set(added, 'Color', [201 0 22 200]/255);

before = findall(gca);
fnplt(spline_boundL, [0 1], 'k', 2)
added = setdiff(findall(gca), before);
set(added, 'Color', [201 0 22 200]/255);

before = findall(gca);
fnplt(spline_boundB, [0 1], 'k', 2)
added = setdiff(findall(gca), before);
set(added, 'Color', [201 0 22 200]/255);

title('Optimized pattern in the deployed space');

% plot the optimized contracted structure
figure(6)
clf
hold on
axis equal
axis off
plot_faces_generic(solved_points0, face_sets0, 6)
title('Optimized pattern in the contracted space');


%% save the results as obj mesh files  

name = strcat('results/hexagon_',shape_name, '_w', num2str(width), '_h', num2str(height),...
    '_i', num2str(initial_map_type),'_f', num2str(fix_regular_shape));
write_mesh_generic([name, '_contracted.obj'], solved_points0(Dto0,:), face_setsD);
write_mesh_generic([name, '_deployed.obj'], solved_pointsD, face_setsD);
