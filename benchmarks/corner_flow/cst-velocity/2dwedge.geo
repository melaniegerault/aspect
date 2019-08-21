cl1 = 1;

Point(1) = {0, 1, 0, 1};
Point(2) = {1.5, 1, 0, 1};
Point(3) = {1.5, 0, 0, 1};
Point(4) = {1, 0, 0, 1};

// lines of the box:
Line(1) = {1, 2};
Line(2) = {2, 3};
Line(3) = {3, 4};
Line(4) = {4, 1};

Line Loop(5) = {1,2,3,4};

// these define the boundary indicators in deal.II:
Physical Line(0) = {4};
Physical Line(1) = {3};
Physical Line(2) = {2};
Physical Line(3) = {1};

// you need the physical surface, because that is what deal.II reads in
Plane Surface(4) = {5};
Physical Surface(5) = {4};

// some parameters for the meshing:
Mesh.Algorithm = 8;
Mesh.RecombineAll = 1;
Mesh.CharacteristicLengthFactor = 0.09;
Mesh.SubdivisionAlgorithm = 1;
Mesh.Smoothing = 20;
Show "*";
