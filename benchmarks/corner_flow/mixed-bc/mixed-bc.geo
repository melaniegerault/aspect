cl1 = 1;

// first 3 values for x,y,z and 4th value for mesh resolution at that node
Point(1) = {0, 0, 0, 0.1};
Point(2) = {3, 0, 0, 4};
Point(3) = {3, -1, 0, 4};
Point(4) = {1, -1, 0, 0.2};
Point(5) = {0.1, -0.1, 0, 0.2};

// lines of the box:
Line(1) = {1, 2};
Line(2) = {2, 3};
Line(3) = {3, 4};
Line(4) = {4, 5};
Line(5) = {5, 1};

Line Loop(6) = {1,2,3,4,5};
Plane Surface(7) = {6};

// these define the boundary indicators in deal.II:
Physical Line(0) = {1};
Physical Line(1) = {2};
Physical Line(2) = {3};
Physical Line(3) = {4};
Physical Line(4) = {5};

// you need the physical surface, because that is what deal.II reads in
Physical Surface(6) = {7};

// some parameters for the meshing:
Mesh.Algorithm = 8;
Mesh.RecombineAll = 1;
Mesh.CharacteristicLengthFactor = 0.09;
Mesh.SubdivisionAlgorithm = 1;
Mesh.Smoothing = 20;
Show "*";