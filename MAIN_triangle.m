% Main program for designing generalized triangle (kagome) kirigami patterns
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
width = 3;
height = 4;

% Choose the 2D target deployed shape from a library of pre-defined shapes
shapes = {'circle','egg','rainbow','anvil','shear','wedge','star','wavy','rect'}; 
% shape_name = shapes{1};
shape_name = shapes{2};
% shape_name = shapes{3};
% shape_name = shapes{4};
% shape_name = shapes{5};
% shape_name = shapes{6};
% shape_name = shapes{7};
% shape_name = shapes{8};
% shape_name = shapes{9};

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

% Require the contracted pattern to be rectangular? 0 (no) / 1 (yes)
fix_contracted_boundary_shape = 0;
% fix_contracted_boundary_shape = 1;

% Further specify the width-to-height ratio if the pattern is required to 
% be rectangular? 0 (no/not applicable) / other positive number (the prescribed ratio)
rectangular_ratio = 0; % not specified / not applicable
% rectangular_ratio = 1; % desired to be a square
% rectangular_ratio = 2; % 2 means desired width-to-height ratio = 2:1, can be changed to other values


%% construct the tessellation and the initial guess

% load the tessellation unit cell  
unit_dir =  'unit_cell_scripts/triangle/'; 

% construct the tessellation, i.e. use one seed pattern to generate a large shape
% convention: xxxxxD = deployed space, xxxx0 = initial space
% Dto0: keep track of the indices (since the vertices aren't bijective)
[pointsD_standard, edgesD, edge_pairsD, anglesD, ringsD, face_setsD, free, ...
    path_adjs, intervals, Dto0, unitfacesD, cornersD, overlapD, points0] ...
    = make_tessellation_generic(unit_dir, width, height, false);
    
% make the initial face sets, keep track of the vertices of each seed pattern
face_sets0 = {};
for i = 1:length(face_setsD)
    face_sets0{i} = Dto0(face_setsD{i});
end

% identify points and angles on the boundaries, divide the rectangular boundary into 4 segments
[boundR, boundT, boundL, boundB] = find_boundary_points(pointsD_standard, free);
if fix_contracted_boundary_shape
    boundary_rings = find_boundary_rings_kagome(pointsD_standard, anglesD, Dto0, free, cornersD);
else
    boundary_rings = []; % for free boundary
    rectangular_ratio = 0;
end

% find the actual boundary
ymin = min(points0(:,2));
ymax = max(points0(:,2));
xval = sort(unique(points0(:,1)));
xmin1 = xval(1);
xmin2 = xval(2);
xmax1 = xval(end);
xmax2 = xval(end-1);

boundLD = find(points0(Dto0,1) == xmin1 | points0(Dto0,1) == xmin2);
boundRD = find(points0(Dto0,1) == xmax1 | points0(Dto0,1) == xmax2);
boundTD = find(points0(Dto0,2) == ymax);
boundBD = find(points0(Dto0,2) == ymin);

% find the boundary edges in edgesD
edges_bottom = edgesD(find(ismember(edgesD(:,1),boundBD).*ismember(edgesD(:,2),boundBD)),:);
edges_right = edgesD(find(ismember(edgesD(:,1),boundRD).*ismember(edgesD(:,2),boundRD)),:);
edges_top = edgesD(find(ismember(edgesD(:,1),boundTD).*ismember(edgesD(:,2),boundTD)),:);
edges_left = edgesD(find(ismember(edgesD(:,1),boundLD).*ismember(edgesD(:,2),boundLD)),:);
        
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


%% Constrained optimization

% optimization setup

% for the objective function
same_face_adjs = find_smoothing_faces(unitfacesD, width, height);

boundary_nodes_cell = {boundR, boundT, boundL, boundB};
boundary_target_splines_cell = {spline_boundR, spline_boundT, spline_boundL, spline_boundB};

options = optimoptions(@fmincon, ...
    'Display', 'iter-detailed', ...
    'Algorithm', 'sqp', ... % 'sqp' or 'interior-point'
    'SpecifyObjectiveGradient', true, ...
    'SpecifyConstraintGradient', true, ...
    'MaxFunctionEvaluations', 10000, ...
    'MaxIterations', 250, ... 
    'ConstraintTolerance', 1e-6, ... 
    'StepTolerance', 1e-6, ... 
    'ScaleProblem', 'obj-and-constr', ... 
    'PlotFcn', {@optimplotfval, @optimplotconstrviolation,@optimplotfirstorderopt});

% main optimization procedure
tic;
[solved_pointsD, ~, ~, ~] = fmincon(@(x)OBJ_regularization( ...
    decompose_v(x), face_setsD, same_face_adjs), ... objective function
    compose_v(pointsD), ... initial point
    [], [], [], [], [], [], ... linear constraints
    @(x)all_constraint_residual_and_jacobian( ... 
    decompose_v(x), ... initial point
    edgesD, edge_pairsD, anglesD, ringsD, boundary_rings, ... stencils
    boundary_nodes_cell, ... boundary nodes
    boundary_target_splines_cell, ... target shape
    overlapD, [], ... non-overlap
    sqrt(3)/2*rectangular_ratio, edges_bottom, edges_right, edges_top, edges_left), ... contracted boundary shape control
    options ... optimization options
    );
toc;
        
% decompose the solved deployed structure
solved_pointsD = decompose_v(solved_pointsD);

% get the final contracted structure
solved_points0 = get_contracted_shape_v2(solved_pointsD, face_setsD, intervals, path_adjs, Dto0);
        
% further rotate the contracted structure optimally
solved_pointsD_temp = [solved_pointsD(:,1) - mean(solved_pointsD(:,1)), solved_pointsD(:,2) - mean(solved_pointsD(:,2))];
solved_points0 = [solved_points0(:,1) - mean(solved_points0(:,1)), solved_points0(:,2) - mean(solved_points0(:,2))];
corners = [boundB(1), boundB(end), boundT(1), boundT(end)];
[U, ~, ~] = Kabsch(solved_points0(Dto0(corners),:)', solved_pointsD_temp(corners,:)');
solved_points0 = (U*solved_points0')';
if fix_contracted_boundary_shape
    boundB_vec = solved_points0(Dto0(boundB(end)),:) - solved_points0(Dto0(boundB(1)),:);
    R = twoD_rotation(-angle(complex(boundB_vec(1),boundB_vec(2))));
    solved_points0 = (R*solved_points0')';
end


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

% plot the optimized contracted structure
figure(6)
clf
hold on
axis equal
axis off
plot_faces_generic(solved_points0, face_sets0, 6)


%% save the results as obj mesh files  

name = strcat('results/triangle_',shape_name, '_w', num2str(width), '_h', num2str(height),...
    '_i', num2str(initial_map_type), '_f', num2str(fix_contracted_boundary_shape),...
    '_r',num2str(rectangular_ratio));
write_mesh_generic([name, '_contracted.obj'], solved_points0(Dto0,:), face_setsD);
write_mesh_generic([name, '_deployed.obj'], solved_pointsD, face_setsD);
