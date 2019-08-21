cl1 = 1;

// first 3 values for x,y,z and 4th value for mesh resolution at that node
// wedge points
Point(1) = {0, 0, 0, 0.2};
Point(2) = {3, 0, 0, 4};
Point(3) = {3, -1, 0, 4};
Point(4) = {1, -1, 0, 0.2};
// slab point (re-use 1 and 4)
Point(5) = {0, -1, 0, 3};

// lines of the box:
Line(1) = {1, 2};
Line(2) = {2, 3};
Line(3) = {3, 4};
Line(4) = {4, 1};
// lines of the slab
Line(5) = {4, 5};
Line(6) = {5, 1};

// loops of the mantle wedge and the slab
Line Loop(7) = {1,2,3,4};
Line Loop(8) = {-4,5,6};

// define surface as list of line loops
Plane Surface(5000) = {7};
Plane Surface(4000) = {8};

// these define the boundary indicators in deal.II:
Physical Line(0) = {1}; // top
Physical Line(1) = {2}; // side
Physical Line(2) = {3}; // bottom
Physical Line(3) = {5}; // slab-bottom
Physical Line(4) = {6}; // slab-side

// you need the physical surface, because that is what deal.II reads in
Physical Surface("wedge", 5005) = {5000};
Physical Surface("slab", 4004) = {4000};

// some parameters for the meshing:
Mesh.Algorithm = 8;
Mesh.RecombineAll = 1;
Mesh.CharacteristicLengthFactor = 0.09;
Mesh.SubdivisionAlgorithm = 1;
Mesh.Smoothing = 20;
Show "*";
