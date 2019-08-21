#include <aspect/geometry_model/interface.h>
#include <aspect/simulator_access.h>
#include <aspect/global.h>
#include <deal.II/grid/grid_generator.h>
#include <deal.II/grid/tria_iterator.h>
#include <deal.II/grid/tria_accessor.h>
#include <deal.II/grid/tria.h>
#include <deal.II/grid/grid_in.h>
#include <fstream>

using namespace dealii;


/*
 * Boundaries are set up as follows:
 * *----3---*
 * |\       |
 * | \  (?) |
 * 5  0     2
 * |   \    |
 * *-4--*-1-*
 */

// This is hardcoded to have a horizontal extension of 1.5, and vertical extension of 1.0. 
// I would suggest to make this more general. 

template <int dim>
class Wedge : public aspect::GeometryModel::Interface<dim>
{
public:

    virtual
    void create_coarse_mesh (parallel::distributed::Triangulation<dim> &coarse_grid) const;
    
    static
    void
    declare_parameters (ParameterHandler &prm)
    {
        prm.enter_subsection("Geometry model");
        {
          prm.enter_subsection("Wedge");
          {
            // The model ennds more inpus parameters (depth, width, position where the wedge starts)
            prm.declare_entry ("file", "2dwedge.msh",
                               Patterns::Anything (),
                               "leave empty for a sheared hyper_rectangle.");
          }
          prm.leave_subsection();
        }
        prm.leave_subsection();
    }
    
    virtual
    void
    parse_parameters (ParameterHandler &prm)
    {
        prm.enter_subsection("Geometry model");
        {
          prm.enter_subsection("Wedge");
          {
            // The new parameters need to be parse here. 
            filename = prm.get ("file");
          }
          prm.leave_subsection();
        }
        prm.leave_subsection();
    }
    
    virtual
    double maximal_depth() const
    {
        // This needs to be changed to the vertical extension of the domain.
        return 1.0;
    }

    virtual
    double length_scale () const
    {
        // This needs to be changed to 0.1 times the vertical extension of the domain.
        return 0.1;
    }

    virtual
    double depth(const Point<dim> &position) const
    {
        // Instead of 1.0, this should use the vertical extension of the domain.
        return 0.0-position[1];
    }

    double
    height_above_reference_surface(const Point<dim> &/*position*/) const
    {
      AssertThrow(false,ExcInternalError());
      return 0.0;
    }

    aspect::Utilities::Coordinates::CoordinateSystem
    natural_coordinate_system() const
    {
      return aspect::Utilities::Coordinates::CoordinateSystem::cartesian;
    }

    bool
    point_is_in_domain(const Point<dim> &/*point*/) const
    {
      return true;
    }

    virtual
    Point<dim> representative_point(const double depth) const
    {
        // This needs to be generalized. 
        // Instead of 1.5, use horizontal extension of the domain.
        // Instead of 1.0, use vertical extension of the domain.
        if (dim==2)
            return Point<dim>(1.5, 0-depth);
        else
            return Point<dim>(1.5, 1.0-depth, 0.5);
    }

    virtual
    std::set<types::boundary_id>
    get_used_boundary_indicators () const
    {
        std::set<types::boundary_id> ids;
        ids.insert(0);ids.insert(1);ids.insert(2);ids.insert(3);ids.insert(4);
        return ids;
    }


    virtual
    std::map<std::string,types::boundary_id>
    get_symbolic_boundary_names_map () const
    {
        std::map<std::string, types::boundary_id> names;
        names["top"] = 0;
        names["side"] = 1;
        names["bottom"] = 2;
	names["slab-bottom"] = 3;
        names["slab-side"] = 4;        
	return names;
    }

private:
    std::string filename;

};


void mesh_2d(Triangulation<2> &coarse_grid, const std::string &filename)
{
    if (filename.size()>0)
    {
        GridIn<2> gridin;
        gridin.attach_triangulation(coarse_grid);
        std::ifstream f(filename.c_str());
        gridin.read_msh(f);
        return;
    }

    // Make this more clear and flexible: Instead of just skipping the rest of the function if there
    // is no file name, either make it an input file option or at least make the code here more clear.
    std::vector<unsigned int> reps(2, 10);

    // These are the coordinates of the rectangle we start with. Change this to use input parameters
    // with horizontal and vertical dimension of the box. 
    Point<2> p1(0,0);
    Point<2> p2(1.5,1);
    GridGenerator::subdivided_hyper_rectangle(coarse_grid,
                                              reps,
                                              p1,p2,
                                              /*colorize*/false);

    // assign colors:
    {
    Triangulation<2>::active_cell_iterator
    cell = coarse_grid.begin_active(),
    endc = coarse_grid.end();
    for (; cell!=endc; ++cell)
      {
        for (unsigned int face=0; face<GeometryInfo<2>::faces_per_cell; ++face)
            if (cell->face(face)->at_boundary())
            {
                // All of these hardcoded numbers have to be changed to reflect coordinates for the left and top boundary, and the depth where the subdivision of the (left) wedge boundary should be (currently 0.9)
                Point<2> center = cell->face(face)->center();
                if (std::abs(center[0])<1e-10)
                {
                    // left side
                    cell->face(face)->set_boundary_id(
                                (center[1]>0.9)?0:1
                                );
                }
                else if (std::abs(center[1]-1.0)<1e-10)
                {
                    // top
                    cell->face(face)->set_boundary_id(2);
                }
                else
                    cell->face(face)->set_boundary_id(3);
            }
      }
    }

    //move the vertices
    {
        std::vector<bool> vertex_touched (coarse_grid.n_vertices(), false);

        Triangulation<2>::active_cell_iterator cell;
        for (cell = coarse_grid.begin_active();  cell != coarse_grid.end();  ++cell)
        for(unsigned int v = 0; v < GeometryInfo<2>::vertices_per_cell;  ++v)
            if(vertex_touched[cell->vertex_index(v)] == false)
            {
                vertex_touched[cell->vertex_index(v)] = true;

                // These operations move the coordinates to make the wedge shape. 
                // TODO: Make this more flexible using input parameters. 
                Point<2> &vertex = cell->vertex(v);
                const double d = 1.0-vertex[1];
                vertex[0] = d + vertex[0]*(1.5-d)/1.5;
            }
    }
}




template <>
void Wedge<2>::create_coarse_mesh (parallel::distributed::Triangulation<2> &coarse_grid) const
{
    mesh_2d(coarse_grid, filename);
}

template <>
void Wedge<3>::create_coarse_mesh (parallel::distributed::Triangulation<3> &coarse_grid) const
{
    Triangulation<2> grid_2d;
    mesh_2d (grid_2d, filename);

    // This is the third dimension. Change it from 1.0 to an input variable. 
    GridGenerator::extrude_triangulation (grid_2d,
                                          10,1.0,
                                          coarse_grid);

    // colors for front/back (4->3, 5->3):
    parallel::distributed::Triangulation<3>::active_cell_iterator
    cell = coarse_grid.begin_active(),
    endc = coarse_grid.end();
    for (; cell!=endc; ++cell)
      {
        for (unsigned int face=0; face<GeometryInfo<3>::faces_per_cell; ++face)
            if (cell->face(face)->at_boundary())
            {
                if (cell->face(face)->boundary_id()>3)
                    cell->face(face)->set_boundary_id(3);
            }
      }
}


// explicit instantiations
ASPECT_REGISTER_GEOMETRY_MODEL(Wedge,
                               "wedge",
                               "Mantle wedge geometry for benchmark with van Keken et al. 2008.")
