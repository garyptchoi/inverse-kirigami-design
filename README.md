# Inverse Kirigami Design
Constrained optimization framework for inverse kirigami design

<img src = "https://github.com/garyptchoi/inverse-kirigami-design/blob/main/inverse-kirigami-design.png" width="680" height="425" />

If you use this code in your work, please cite the following paper:

G. P. T. Choi, L. H. Dudte, and L. Mahadevan, 
"[Programming shape using kirigami tessellations](https://doi.org/10.1038/s41563-019-0452-y)." Nature Materials, 18(9), 999-1004, 2019.

Copyright (c) 2019-2022, Gary P. T. Choi, Levi H. Dudte, L. Mahadevan

https://math.mit.edu/~ptchoi

===============================================================

Main programs:
* MAIN_quad.m: producing generalized quad kirigami patterns
* MAIN_triangle.m: producing generalized triangle kirigami patterns
* MAIN_hexagon.m: producing generalized hexagon kirigami patterns
* MAIN_islamicquad.m: producing generalized ancient Islamic quad kirigami patterns
* MAIN_islamictriangle.m: producing generalized ancient Islamic triangle kirigami patterns

In each main program, the following parameters can be changed:
* width: the number of columns of unit cells in the kirigami pattern
* height: the number of rows of unit cells in the kirigami pattern
* shape_name: load a pre-defined target shape in the library
* initial_map_type: the type of the initial map for the optimization in the deployed space (1: standard, 2: rescaled, 3: conformal, 4: Teichmuller)
* (only for quad and triangle) fix_contracted_boundary_shape: enforce the desired contracted pattern to be rectangular (0: no, 1: yes)
* (only for quad and triangle) rectangular_ratio: further specify the width-to-height ratio if the contracted pattern is required to be rectangular (0:  no/not applicable, other positive number: the prescribed ratio)
* (only for hexagon) fix_regular_shape: enforce the all angles to be $2\pi/3$ (0: no, 1: yes)


Remarks:
* Some precomputed examples can be found in the "results" folder
  * All parameters used are encoded in the file names:
     * (For quad/triangle) unitcelltype_shapename_width_height_initialmaptype_fixcontractedboundary_rectangularratio_contracted/deployed
     * (For hexagon) unitcelltype_shapename_width_height_initialmaptype_fixregularshape_contracted/deployed
     * (For ancient Islamic) unitcelltype_shapename_width_height_initialmaptype_contracted/deployed
* To create other user-defined target shapes, see the functions in the "shapes" folder 
* If the optimization terminates prematurely or does not produce a desirable pattern, please try:
  * Changing the algorithm used in fmincon (sqp or interior-point)
  * Changing other fmincon parameters (MaxFunctionEvaluations, MaxIterations, ConstraintTolerance, StepTolerance)
  * Using other types of initial map (standard, rescaled, conformal, Teichmuller)
  * Changing the kirigami pattern size (width, height)
  
===============================================================

Dependencies:

* [Schwarz-Christoffel Toolbox](https://github.com/tobydriscoll/sc-toolbox) (for conformal initial map)

* [Rectangular Conformal Map](https://github.com/garyptchoi/rectangular-conformal-map) (for Teichmuller initial map)

* [DistMesh](http://persson.berkeley.edu/distmesh/) (for Teichmuller initial map)

* [Kabsch Algorithm](https://www.mathworks.com/matlabcentral/fileexchange/25746-kabsch-algorithm) (for rotating the resulting contracted pattern)
