/*
  Copyright (C) 2017 - 2019 by the authors of the ASPECT code.

  This file is part of ASPECT.

  ASPECT is free software; you can redistribute it and/or modify
  it under the terms of the GNU General Public License as published by
  the Free Software Foundation; either version 2, or (at your option)
  any later version.

  ASPECT is distributed in the hope that it will be useful,
  but WITHOUT ANY WARRANTY; without even the implied warranty of
  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  GNU General Public License for more details.

  You should have received a copy of the GNU General Public License
  along with ASPECT; see the file LICENSE.  If not see
  <http://www.gnu.org/licenses/>.
*/


#include <aspect/simulator.h>
#include <aspect/global.h>
#include <aspect/mesh_deformation/free_surface.h>
#include <aspect/volume_of_fluid/handler.h>
#include <aspect/newton.h>
#include <aspect/melt.h>

#include <deal.II/numerics/vector_tools.h>

#include <aspect/stokes_matrix_free.h>


namespace aspect
{

  namespace
  {
    /**
     * Converts a function with a certain number of components into a Function@<dim@>
     * with optionally having additional zero components.
     **/
    template <int dim>
    class VectorFunctionFromVectorFunctionObject : public Function<dim>
    {
      public:
        /**
         * Converts a function with @p n_object_components components into a Function@dim@
         * while optionally providing additional components that are set to zero.
         *
         * @param function_object The function that will form the components
         *     of the resulting Function object.
         * @param first_component The first component that should be
         *     filled.
         * @param n_object_components The number of components that should be
         *     filled from the first.
         * @param n_total_components The total number of vector components of the
         *     resulting Function object.
         **/

        VectorFunctionFromVectorFunctionObject (const std::function<void (const Point<dim> &,Vector<double> &)> &function_object,
                                                const unsigned int first_component,
                                                const unsigned int n_object_components,
                                                const unsigned int n_total_components)
          :
          Function<dim>(n_total_components),
          function_object (function_object),
          first_component (first_component),
          n_object_components (n_object_components)
        {
          Assert ((n_object_components > 0
                   &&
                   first_component+n_object_components <= n_total_components),
                  ExcMessage ("Number of objects components needs to be less than number of total components"));
        }



        double
        value (const Point<dim> &p,
               const unsigned int component) const
        {
          Assert (component < this->n_components,
                  ExcIndexRange (component, 0, this->n_components));

          if (component < first_component)
            return 0;
          else if (component >= first_component + n_object_components)
            return 0;
          else
            {
              Vector<double> temp(n_object_components);
              function_object (p, temp);
              return temp(component - first_component);
            }
        }



        void
        vector_value (const Point<dim>   &p,
                      Vector<double>     &values) const
        {
          AssertDimension(values.size(), this->n_components);

          // set everything to zero, and then the right components to their correct values
          values = 0;
          Vector<double> temp(n_object_components);
          function_object (p, temp);
          for (unsigned int i = 0; i < n_object_components; i++)
            {
              values(first_component + i) = temp(i);
            }
        }



      private:
        /**
         * The function object which we call when this class's solution() function is called.
         **/
        const std::function<void (const Point<dim> &,Vector<double> &)> function_object;

        /**
         * The first vector component whose value is to be filled by the given
         * function.
         */
        const unsigned int first_component;
        /**
         * The number of vector components whose values are to be filled by the given
         * function.
         */
        const unsigned int n_object_components;

    };

  }



  template <int dim>
  double Simulator<dim>::assemble_and_solve_temperature (const bool compute_initial_residual,
                                                         double *initial_residual)
  {
    assemble_advection_system (AdvectionField::temperature());

    if (compute_initial_residual)
      {
        Assert(initial_residual != nullptr, ExcInternalError());
        *initial_residual = system_rhs.block(introspection.block_indices.temperature).l2_norm();
      }

    const double current_residual = solve_advection(AdvectionField::temperature());
    current_linearization_point.block(introspection.block_indices.temperature)
      = solution.block(introspection.block_indices.temperature);

    if ((initial_residual != nullptr) && (*initial_residual > 0))
      return current_residual / *initial_residual;

    return 0.0;
  }



  template <int dim>
  std::vector<double> Simulator<dim>::assemble_and_solve_composition (const bool compute_initial_residual,
                                                                      std::vector<double> *initial_residual)
  {
    std::vector<double> current_residual(introspection.n_compositional_fields,0.0);

    if (compute_initial_residual)
      {
        Assert(initial_residual != nullptr, ExcInternalError());
        Assert(initial_residual->size() == introspection.n_compositional_fields, ExcInternalError());
      }

    for (unsigned int c=0; c < introspection.n_compositional_fields; ++c)
      {
        const AdvectionField adv_field (AdvectionField::composition(c));
        const typename Parameters<dim>::AdvectionFieldMethod::Kind method = adv_field.advection_method(introspection);
        switch (method)
          {
            case Parameters<dim>::AdvectionFieldMethod::fem_field:
            case Parameters<dim>::AdvectionFieldMethod::fem_melt_field:
            case Parameters<dim>::AdvectionFieldMethod::prescribed_field_with_diffusion:
            {
              // if this is a prescribed field with diffusion, we first have to copy the material model
              // outputs into the prescribed field before we assemle and solve the equation
              if (method == Parameters<dim>::AdvectionFieldMethod::prescribed_field_with_diffusion)
                {
                  interpolate_material_output_into_compositional_field(c);

                  // Also set the old_solution block to the prescribed field. The old
                  // solution is the one that is used to assemble the diffusion system in
                  // assemble_advection_system() for this solver scheme.
                  old_solution.block(adv_field.block_index(introspection)) = solution.block(adv_field.block_index(introspection));
                }

              assemble_advection_system (adv_field);

              if (compute_initial_residual)
                (*initial_residual)[c] = system_rhs.block(introspection.block_indices.compositional_fields[c]).l2_norm();

              current_residual[c] = solve_advection(adv_field);

              // Release the contents of the matrix block we used again:
              const unsigned int block_idx = adv_field.block_index(introspection);
              if (adv_field.compositional_variable!=0)
                system_matrix.block(block_idx, block_idx).clear();

              // No need to call the post_advection_solver signal here: It is
              // automatically called from solve_advection() above.

              break;
            }

            case Parameters<dim>::AdvectionFieldMethod::particles:
            {
              interpolate_particle_properties(adv_field);
              break;
            }

            case Parameters<dim>::AdvectionFieldMethod::prescribed_field:
            {
              interpolate_material_output_into_compositional_field(c);

              // Call the signal in case the user wants to do something with the variable:
              SolverControl dummy;
              signals.post_advection_solver(*this,
                                            adv_field.is_temperature(),
                                            adv_field.compositional_variable,
                                            dummy);
              break;
            }

            case Parameters<dim>::AdvectionFieldMethod::volume_of_fluid:
              volume_of_fluid_handler->do_volume_of_fluid_update(adv_field);
              break;

            case Parameters<dim>::AdvectionFieldMethod::static_field:
            {
              // Do nothing here, but at least call the signal in case the
              // user wants to do something with the variable:
              SolverControl dummy;
              signals.post_advection_solver(*this,
                                            adv_field.is_temperature(),
                                            adv_field.compositional_variable,
                                            dummy);
              break;
            }

            default:
              AssertThrow(false,ExcNotImplemented());
          }
      }

    // for consistency we update the current linearization point only after we have solved
    // all fields, so that we use the same point in time for every field when solving
    for (unsigned int c=0; c<introspection.n_compositional_fields; ++c)
      {
        current_linearization_point.block(introspection.block_indices.compositional_fields[c])
          = solution.block(introspection.block_indices.compositional_fields[c]);

        if ((initial_residual != nullptr) && (*initial_residual)[c] > 0)
          current_residual[c] /= (*initial_residual)[c];
        else
          current_residual[c] = 0.0;
      }

    return current_residual;
  }



  template <int dim>
  double Simulator<dim>::assemble_and_solve_stokes (const bool compute_initial_residual,
                                                    double *initial_nonlinear_residual)
  {
    // If the Stokes matrix depends on the solution, or we have active
    // velocity boundary conditions, we need to re-assemble the system matrix
    // (and preconditioner) every time. If we have active boundary conditions,
    // they could a) depend on the solution, or b) be inhomogeneous. In both
    // cases, just assembling the RHS will be incorrect.  If no active
    // boundaries exist, we only have no-slip or free slip conditions, so we
    // don't need to force assembly of the matrix.
    if (stokes_matrix_depends_on_solution()
        ||
        (boundary_velocity_manager.get_active_boundary_velocity_conditions().size() > 0))
      rebuild_stokes_matrix = rebuild_stokes_preconditioner = true;

    // set constraints for p_c if porosity is below a threshold
    if (nonlinear_iteration == 0 && parameters.include_melt_transport)
      {
        compute_current_constraints();
        if (rebuild_sparsity_and_matrices)
          {
            setup_system_matrix (introspection.index_sets.system_partitioning);
            setup_system_preconditioner (introspection.index_sets.system_partitioning);

            rebuild_stokes_matrix = rebuild_stokes_preconditioner = true;
          }
      }

    assemble_stokes_system ();

    // Update coefficients and add correction to system rhs for
    // marix-free method
    if (stokes_matrix_free)
      {
        stokes_matrix_free->evaluate_material_model();
        stokes_matrix_free->correct_stokes_rhs();
      }

    // Assemble preconditioner for matrix-based
    if (!stokes_matrix_free)
      {
        build_stokes_preconditioner();
      }

    if (compute_initial_residual)
      {
        Assert(initial_nonlinear_residual != nullptr, ExcInternalError());
        *initial_nonlinear_residual = compute_initial_stokes_residual();
      }

    const double current_nonlinear_residual = solve_stokes().first;

    current_linearization_point.block(introspection.block_indices.velocities)
      = solution.block(introspection.block_indices.velocities);

    if (introspection.block_indices.velocities != introspection.block_indices.pressure)
      current_linearization_point.block(introspection.block_indices.pressure)
        = solution.block(introspection.block_indices.pressure);

    if (parameters.include_melt_transport)
      {
        // Note that the compaction pressure is in the fluid pressure block
        // and will therefore be updated as well.
        const unsigned int fluid_velocity_block = introspection.variable("fluid velocity").block_index;
        const unsigned int fluid_pressure_block = introspection.variable("fluid pressure").block_index;
        current_linearization_point.block(fluid_velocity_block) = solution.block(fluid_velocity_block);
        current_linearization_point.block(fluid_pressure_block) = solution.block(fluid_pressure_block);
      }

    if ((initial_nonlinear_residual != nullptr) && (*initial_nonlinear_residual > 0))
      return current_nonlinear_residual / *initial_nonlinear_residual;
    else
      return 0.0;
  }



  template <int dim>
  void Simulator<dim>::solve_single_advection_single_stokes ()
  {
    assemble_and_solve_temperature();
    assemble_and_solve_composition();
    assemble_and_solve_stokes();

    if (parameters.run_postprocessors_on_nonlinear_iterations)
      postprocess ();
  }



  template <int dim>
  void Simulator<dim>::solve_no_advection_iterated_stokes ()
  {
    double initial_stokes_residual = 0.0;

    const unsigned int max_nonlinear_iterations =
      (pre_refinement_step < parameters.initial_adaptive_refinement)
      ?
      std::min(parameters.max_nonlinear_iterations,
               parameters.max_nonlinear_iterations_in_prerefinement)
      :
      parameters.max_nonlinear_iterations;
    do
      {
        const double relative_nonlinear_stokes_residual =
          assemble_and_solve_stokes(nonlinear_iteration == 0, &initial_stokes_residual);

        pcout << "      Relative nonlinear residual (Stokes system) after nonlinear iteration " << nonlinear_iteration+1
              << ": " << relative_nonlinear_stokes_residual
              << std::endl
              << std::endl;

        if (parameters.run_postprocessors_on_nonlinear_iterations)
          postprocess ();

        if (relative_nonlinear_stokes_residual < parameters.nonlinear_tolerance)
          break;

        ++nonlinear_iteration;
      }
    while (nonlinear_iteration < max_nonlinear_iterations);
  }



  template <int dim>
  void Simulator<dim>::solve_first_timestep_only_single_stokes ()
  {
    if (timestep_number == 0)
      assemble_and_solve_stokes();
  }



  template <int dim>
  void Simulator<dim>::solve_iterated_advection_and_stokes ()
  {
    double initial_temperature_residual = 0;
    double initial_stokes_residual      = 0;
    std::vector<double> initial_composition_residual (introspection.n_compositional_fields,0);

    const unsigned int max_nonlinear_iterations =
      (pre_refinement_step < parameters.initial_adaptive_refinement)
      ?
      std::min(parameters.max_nonlinear_iterations,
               parameters.max_nonlinear_iterations_in_prerefinement)
      :
      parameters.max_nonlinear_iterations;

    do
      {
        const double relative_temperature_residual =
          assemble_and_solve_temperature(nonlinear_iteration == 0, &initial_temperature_residual);

        const std::vector<double>  relative_composition_residual =
          assemble_and_solve_composition(nonlinear_iteration == 0, &initial_composition_residual);

        const double relative_nonlinear_stokes_residual =
          assemble_and_solve_stokes(nonlinear_iteration == 0, &initial_stokes_residual);

        // write the residual output in the same order as the solutions
        pcout << "      Relative nonlinear residuals (temperature, compositional fields, Stokes system): " << relative_temperature_residual;
        for (unsigned int c=0; c<introspection.n_compositional_fields; ++c)
          pcout << ", " << relative_composition_residual[c];
        pcout << ", " << relative_nonlinear_stokes_residual;
        pcout << std::endl;

        double max = 0.0;
        for (unsigned int c=0; c<introspection.n_compositional_fields; ++c)
          {
            // in models with melt migration the melt advection equation includes the divergence of the velocity
            // and can not be expected to converge to a smaller value than the residual of the Stokes equation.
            // thus, we set a threshold for the initial composition residual.
            // this only plays a role if the right-hand side of the advection equation is very small.
            const double threshold = (parameters.include_melt_transport && c == introspection.compositional_index_for_name("porosity")
                                      ?
                                      parameters.linear_stokes_solver_tolerance * time_step
                                      :
                                      0.0);
            if (initial_composition_residual[c]>threshold)
              max = std::max(relative_composition_residual[c],max);
          }

        max = std::max(relative_nonlinear_stokes_residual, max);
        max = std::max(relative_temperature_residual, max);
        pcout << "      Relative nonlinear residual (total system) after nonlinear iteration " << nonlinear_iteration+1
              << ": " << max
              << std::endl
              << std::endl;

        if (parameters.run_postprocessors_on_nonlinear_iterations)
          postprocess ();

        if (max < parameters.nonlinear_tolerance)
          break;

        ++nonlinear_iteration;
      }
    while (nonlinear_iteration < max_nonlinear_iterations);
  }



  template <int dim>
  void Simulator<dim>::solve_single_advection_iterated_stokes ()
  {
    // solve the temperature and composition systems once...
    assemble_and_solve_temperature();

    assemble_and_solve_composition();

    // ...and then iterate the solution of the Stokes system
    double initial_stokes_residual = 0;

    const unsigned int max_nonlinear_iterations =
      (pre_refinement_step < parameters.initial_adaptive_refinement)
      ?
      std::min(parameters.max_nonlinear_iterations,
               parameters.max_nonlinear_iterations_in_prerefinement)
      :
      parameters.max_nonlinear_iterations;

    do
      {
        const double relative_nonlinear_stokes_residual =
          assemble_and_solve_stokes(nonlinear_iteration == 0, &initial_stokes_residual);

        pcout << "      Relative nonlinear residual (Stokes system) after nonlinear iteration " << nonlinear_iteration+1
              << ": " << relative_nonlinear_stokes_residual
              << std::endl
              << std::endl;

        if (parameters.run_postprocessors_on_nonlinear_iterations)
          postprocess ();

        // if reached convergence, exit nonlinear iterations.
        if (relative_nonlinear_stokes_residual < parameters.nonlinear_tolerance)
          break;

        ++nonlinear_iteration;
      }
    while (nonlinear_iteration < max_nonlinear_iterations);
  }



  template <int dim>
  void Simulator<dim>::solve_iterated_advection_and_newton_stokes ()
  {
    // Now store the linear_tolerance we started out with, because we might change
    // it within this timestep.
    double begin_linear_tolerance = parameters.linear_stokes_solver_tolerance;

    std::vector<double> initial_composition_residual (parameters.n_compositional_fields,0);

    double initial_residual = 1;

    double velocity_residual = 0;
    double pressure_residual = 0;
    double residual = 1;
    double residual_old = 1;

    double switch_initial_residual = 1;
    double newton_residual_for_derivative_scaling_factor = 1;

    bool use_picard = true;

    const Newton::Parameters::Stabilization starting_preconditioner_stabilization = newton_handler->parameters.preconditioner_stabilization;
    const Newton::Parameters::Stabilization starting_velocity_block_stabilization = newton_handler->parameters.velocity_block_stabilization;

    const unsigned int max_nonlinear_iterations =
      (pre_refinement_step < parameters.initial_adaptive_refinement)
      ?
      std::min(parameters.max_nonlinear_iterations,
               parameters.max_nonlinear_iterations_in_prerefinement)
      :
      parameters.max_nonlinear_iterations;

    // Now iterate out the nonlinearities.
    std::pair<double,double> stokes_residuals (numbers::signaling_nan<double>(),
                                               numbers::signaling_nan<double>());
    for (nonlinear_iteration = 0; nonlinear_iteration < max_nonlinear_iterations; ++nonlinear_iteration)
      {
        assemble_and_solve_temperature();
        assemble_and_solve_composition();

        if (use_picard == true && (residual/initial_residual <= newton_handler->parameters.nonlinear_switch_tolerance ||
                                   nonlinear_iteration >= newton_handler->parameters.max_pre_newton_nonlinear_iterations))
          {
            use_picard = false;
            pcout << "   Switching from defect correction form of Picard to the Newton solver scheme." << std::endl;

            /**
             * This method allows to slowly introduce the derivatives based
             * on the improvement of the residual. If we do not use it, we
             * just set it so the newton_derivative_scaling_factor goes from
             * zero to one when switching on the Newton solver.
             */
            if (!newton_handler->parameters.use_newton_residual_scaling_method)
              newton_residual_for_derivative_scaling_factor = 0;
          }

        newton_handler->parameters.newton_derivative_scaling_factor
          = (std::max(0.0,
                      (1.0-(newton_residual_for_derivative_scaling_factor/switch_initial_residual))));


        /**
         * copied from solver.cc
         */

        // Many parts of the solver depend on the block layout (velocity = 0,
        // pressure = 1). For example the linearized_stokes_initial_guess vector or the StokesBlock matrix
        // wrapper. Let us make sure that this holds (and shorten their names):
        const unsigned int block_vel = introspection.block_indices.velocities;
        const unsigned int block_p = (parameters.include_melt_transport) ?
                                     introspection.variable("fluid pressure").block_index
                                     : introspection.block_indices.pressure;
        Assert(block_vel == 0, ExcNotImplemented());
        Assert(block_p == 1, ExcNotImplemented());
        Assert(!parameters.include_melt_transport
               || introspection.variable("compaction pressure").block_index == 1, ExcNotImplemented());

        // create a completely distributed vector that will be used for
        // the scaled and denormalized solution and later used as a
        // starting guess for the linear solver
        LinearAlgebra::BlockVector linearized_stokes_initial_guess(introspection.index_sets.stokes_partitioning, mpi_communicator);
        linearized_stokes_initial_guess.block(block_vel) = current_linearization_point.block(block_vel);
        linearized_stokes_initial_guess.block(block_p) = current_linearization_point.block(block_p);

        if (nonlinear_iteration == 0)
          {
            initial_residual = compute_initial_newton_residual(linearized_stokes_initial_guess);
            switch_initial_residual = initial_residual;
            residual = initial_residual;
          }

        assemble_newton_stokes_system = assemble_newton_stokes_matrix = true;

        if (nonlinear_iteration == 0)
          {
            assemble_newton_stokes_system = assemble_newton_stokes_matrix = false;
          }
        else
          {
            denormalize_pressure (last_pressure_normalization_adjustment,
                                  linearized_stokes_initial_guess,
                                  current_linearization_point);
          }

        if (nonlinear_iteration <= 1)
          {
            set_assemblers();
            compute_current_constraints ();
          }

        // the Stokes matrix depends on the viscosity. if the viscosity
        // depends on other solution variables, then after we need to
        // update the Stokes matrix in every time step and so need to set
        // the following flag. if we change the Stokes matrix we also
        // need to update the Stokes preconditioner.
        rebuild_stokes_matrix = rebuild_stokes_preconditioner = assemble_newton_stokes_matrix = true;

        assemble_stokes_system();

        /**
         * Eisenstat Walker method for determining the tolerance
         */
        if (nonlinear_iteration > 1)
          {
            velocity_residual = system_rhs.block(introspection.block_indices.velocities).l2_norm();
            pressure_residual = system_rhs.block(introspection.block_indices.pressure).l2_norm();
            residual = std::sqrt(velocity_residual * velocity_residual + pressure_residual * pressure_residual);

            if (!use_picard || newton_handler->parameters.use_Eisenstat_Walker_method_for_Picard_iterations)
              {
                const bool EisenstatWalkerChoiceOne = true;
                parameters.linear_stokes_solver_tolerance = compute_Eisenstat_Walker_linear_tolerance(EisenstatWalkerChoiceOne,
                                                            newton_handler->parameters.maximum_linear_stokes_solver_tolerance,
                                                            parameters.linear_stokes_solver_tolerance,
                                                            stokes_residuals.second,
                                                            residual,
                                                            residual_old);

                pcout << "   The linear solver tolerance is set to "
                      << parameters.linear_stokes_solver_tolerance
                      << ". ";
                if (!use_picard)
                  {
                    pcout << "Stabilization Preconditioner is "
                          << Newton::to_string(newton_handler->parameters.preconditioner_stabilization)
                          << " and A block is "
                          << Newton::to_string(newton_handler->parameters.velocity_block_stabilization)
                          << ".";
                  }
                pcout << std::endl;
              }
          }

        build_stokes_preconditioner();

        if (newton_handler->parameters.use_Newton_failsafe == false)
          {
            stokes_residuals = solve_stokes();
          }
        else
          {
            try
              {
                stokes_residuals = solve_stokes();
              }
            catch (...)
              {
                // start the solve over again and try with a stabilized version
                pcout << "Solve failed and catched, try again with stabilisation" << std::endl;
                newton_handler->parameters.preconditioner_stabilization = Newton::Parameters::Stabilization::SPD;
                newton_handler->parameters.velocity_block_stabilization = Newton::Parameters::Stabilization::SPD;
                rebuild_stokes_matrix = rebuild_stokes_preconditioner = assemble_newton_stokes_matrix = true;

                assemble_stokes_system();
                /**
                 * Eisenstat Walker method for determining the tolerance
                 */
                if (nonlinear_iteration > 1)
                  {
                    residual_old = residual;
                    velocity_residual = system_rhs.block(introspection.block_indices.velocities).l2_norm();
                    pressure_residual = system_rhs.block(introspection.block_indices.pressure).l2_norm();
                    residual = std::sqrt(velocity_residual * velocity_residual + pressure_residual * pressure_residual);

                    if (!use_picard)
                      {
                        const bool EisenstatWalkerChoiceOne = true;
                        parameters.linear_stokes_solver_tolerance = compute_Eisenstat_Walker_linear_tolerance(EisenstatWalkerChoiceOne,
                                                                    newton_handler->parameters.maximum_linear_stokes_solver_tolerance,
                                                                    parameters.linear_stokes_solver_tolerance,
                                                                    stokes_residuals.second,
                                                                    residual,
                                                                    residual_old);

                        pcout << "   The linear solver tolerance is set to " << parameters.linear_stokes_solver_tolerance << std::endl;
                      }
                  }

                build_stokes_preconditioner();
                stokes_residuals = solve_stokes();
              }
          }

        velocity_residual = system_rhs.block(introspection.block_indices.velocities).l2_norm();
        pressure_residual = system_rhs.block(introspection.block_indices.pressure).l2_norm();
        residual = std::sqrt(velocity_residual * velocity_residual + pressure_residual * pressure_residual);

        double test_residual = residual;
        if (nonlinear_iteration == 0)
          {
            /**
             * The first nonlinear iteration we are computing the whole system in a non-defect corrected Picard way,
             * to make sure that the boundary conditions are correct in combination with correct initial guesses.
             */
            current_linearization_point.block(introspection.block_indices.velocities) = solution.block(introspection.block_indices.velocities);
            current_linearization_point.block(introspection.block_indices.pressure) = solution.block(introspection.block_indices.pressure);

            residual = stokes_residuals.first;

            pcout << "      Relative nonlinear residual (total Newton system) after nonlinear iteration " << nonlinear_iteration+1
                  << ": " << stokes_residuals.first/initial_residual << ", norm of the rhs: " << stokes_residuals.first << std::endl;

          }
        else
          {
            /**
             * We may need to do a line search if the solution update doesn't decrease the norm of the rhs enough.
             * This is done by adding the solution update to the current linearization point and then assembling
             * the Newton right hand side. If the Newton residual has decreased enough by using this update,
             * then we continue, otherwise we reset the current linearization point with the help of the backup and
             * add each iteration an increasingly smaller solution update until the decreasing residual condition
             * is met, or the line search iteration limit is reached.
             */
            LinearAlgebra::BlockVector backup_linearization_point(introspection.index_sets.stokes_partitioning, mpi_communicator);
            backup_linearization_point.block(introspection.block_indices.pressure) = current_linearization_point.block(introspection.block_indices.pressure);
            backup_linearization_point.block(introspection.block_indices.velocities) = current_linearization_point.block(introspection.block_indices.velocities);


            double test_velocity_residual = 0;
            double test_pressure_residual = 0;
            double lambda = 1;
            double alpha = 1e-4;
            unsigned int line_search_iteration = 0;


            /**
             * Do the loop for the line search. Even when we
             * don't do a line search we go into this loop
             */
            do
              {
                // Reset the current linearization point and the search direction
                current_linearization_point.block(introspection.block_indices.pressure) = backup_linearization_point.block(introspection.block_indices.pressure);
                current_linearization_point.block(introspection.block_indices.velocities) = backup_linearization_point.block(introspection.block_indices.velocities);

                LinearAlgebra::BlockVector search_direction = solution;
                search_direction *= lambda;

                current_linearization_point.block(introspection.block_indices.pressure) += search_direction.block(introspection.block_indices.pressure);
                current_linearization_point.block(introspection.block_indices.velocities) += search_direction.block(introspection.block_indices.velocities);

                // Rebuild the rhs to determine the new residual.
                assemble_newton_stokes_matrix = rebuild_stokes_preconditioner = false;
                rebuild_stokes_matrix = true;

                assemble_stokes_system();

                test_velocity_residual = system_rhs.block(introspection.block_indices.velocities).l2_norm();
                test_pressure_residual = system_rhs.block(introspection.block_indices.pressure).l2_norm();
                test_residual = std::sqrt(test_velocity_residual * test_velocity_residual
                                          + test_pressure_residual * test_pressure_residual);

                // Determine if the decrease is sufficient.
                if (test_residual < (1.0 - alpha * lambda) * residual
                    ||
                    line_search_iteration >= newton_handler->parameters.max_newton_line_search_iterations
                    ||
                    use_picard)
                  {
                    pcout << "      Relative nonlinear residual (total Newton system) after nonlinear iteration " << nonlinear_iteration+1
                          << ": " << test_residual/initial_residual << ", norm of the rhs: " << test_residual
                          << ", newton_derivative_scaling_factor: " << newton_handler->parameters.newton_derivative_scaling_factor
                          << std::endl;
                    residual = test_residual;
                    break;
                  }
                else
                  {

                    pcout << "   Line search iteration " << line_search_iteration << ", with norm of the rhs "
                          << test_residual << " and going to " << (1.0 - alpha * lambda) * residual
                          << ", relative residual: " << test_residual/initial_residual << std::endl;

                    /**
                     * The line search step was not sufficient to decrease the residual
                     * enough, so we take a smaller step to see if it improves the residual.
                     */
                    lambda *= (2.0/3.0);// TODO: make a parameter out of this.
                  }

                line_search_iteration++;
                Assert(line_search_iteration <= newton_handler->parameters.max_newton_line_search_iterations,
                       ExcMessage ("This tests the while condition. This condition should "
                                   "actually never be false, because the break statement "
                                   "above should have caught it."));
              }
            while (line_search_iteration <= newton_handler->parameters.max_newton_line_search_iterations);
            // The while condition should actually never be false, because the break statement above should have caught it.
          }


        if (use_picard == true)
          {
            // When we are using (defect corrected) Picard, keep the
            // newton_derivative_scaling_factor at zero. The newton_derivative_scaling_factor
            // is calculated above as std::max(0.0, (1.0-(
            // newton_residual_for_derivative_scaling_factor/switch_initial_residual)))
            switch_initial_residual = residual;
            newton_residual_for_derivative_scaling_factor = residual;
          }
        else
          {
            /**
             * This method allows to slowly introduce the derivatives based
             * on the improvement of the residual. This method was suggested
             * by Raid Hassani.
             */
            if (newton_handler->parameters.use_newton_residual_scaling_method)
              newton_residual_for_derivative_scaling_factor = test_residual;
            else
              newton_residual_for_derivative_scaling_factor = 0;
          }

        residual_old = residual;

        pcout << std::endl;
        if (nonlinear_iteration != 0)
          last_pressure_normalization_adjustment = normalize_pressure(current_linearization_point);

        if (parameters.run_postprocessors_on_nonlinear_iterations)
          postprocess ();

        if (residual/initial_residual < parameters.nonlinear_tolerance)
          {
            break;
          }
      }

    // Reset the Newton stabilization at the end of the timestep.
    newton_handler->parameters.preconditioner_stabilization = starting_preconditioner_stabilization;
    newton_handler->parameters.velocity_block_stabilization = starting_velocity_block_stabilization;

    // Reset the linear tolerance to what it was at the beginning of the time step.
    parameters.linear_stokes_solver_tolerance = begin_linear_tolerance;

    // When we are finished iterating, we need to set the final solution to the current linearization point,
    // because the solution vector is used in the postprocess.
    solution = current_linearization_point;
  }


  template <int dim>
  void Simulator<dim>::solve_single_advection_iterated_newton_stokes ()
  {
    // Solve the temperature and composition systems once...
    assemble_and_solve_temperature();
    assemble_and_solve_composition();

    // ...and then iterate the solution of the Stokes system

    // Now store the linear_tolerance we started out with, because we might change
    // it within this timestep.
    double begin_linear_tolerance = parameters.linear_stokes_solver_tolerance;

    // The below is copied from solve_iterated_advection_and_newton_stokes()
    std::vector<double> initial_composition_residual (parameters.n_compositional_fields,0);

    double initial_residual = 1;

    double velocity_residual = 0;
    double pressure_residual = 0;
    double residual = 1;
    double residual_old = 1;

    double switch_initial_residual = 1;
    double newton_residual_for_derivative_scaling_factor = 1;

    bool use_picard = true;

    const Newton::Parameters::Stabilization starting_preconditioner_stabilization = newton_handler->parameters.preconditioner_stabilization;
    const Newton::Parameters::Stabilization starting_velocity_block_stabilization = newton_handler->parameters.velocity_block_stabilization;

    const unsigned int max_nonlinear_iterations =
      (pre_refinement_step < parameters.initial_adaptive_refinement)
      ?
      std::min(parameters.max_nonlinear_iterations,
               parameters.max_nonlinear_iterations_in_prerefinement)
      :
      parameters.max_nonlinear_iterations;

    // Now iterate out the nonlinearities.
    std::pair<double,double> stokes_residuals (numbers::signaling_nan<double>(),
                                               numbers::signaling_nan<double>());
    for (nonlinear_iteration = 0; nonlinear_iteration < max_nonlinear_iterations; ++nonlinear_iteration)
      {
        if (use_picard == true && (residual/initial_residual <= newton_handler->parameters.nonlinear_switch_tolerance ||
                                   nonlinear_iteration >= newton_handler->parameters.max_pre_newton_nonlinear_iterations))
          {
            use_picard = false;
            pcout << "   Switching from defect correction form of Picard to the Newton solver scheme." << std::endl;

            /**
             * This method allows to slowly introduce the derivatives based
             * on the improvement of the residual. If we do not use it, we
             * just set it so the newton_derivative_scaling_factor goes from
             * zero to one when switching on the Newton solver.
             */
            if (!newton_handler->parameters.use_newton_residual_scaling_method)
              newton_residual_for_derivative_scaling_factor = 0;
          }

        newton_handler->parameters.newton_derivative_scaling_factor
          = (std::max(0.0,
                      (1.0-(newton_residual_for_derivative_scaling_factor/switch_initial_residual))));


        /**
         * copied from solver.cc
         */

        // Many parts of the solver depend on the block layout (velocity = 0,
        // pressure = 1). For example the linearized_stokes_initial_guess vector or the StokesBlock matrix
        // wrapper. Let us make sure that this holds (and shorten their names):
        const unsigned int block_vel = introspection.block_indices.velocities;
        const unsigned int block_p = (parameters.include_melt_transport) ?
                                     introspection.variable("fluid pressure").block_index
                                     : introspection.block_indices.pressure;
        Assert(block_vel == 0, ExcNotImplemented());
        Assert(block_p == 1, ExcNotImplemented());
        Assert(!parameters.include_melt_transport
               || introspection.variable("compaction pressure").block_index == 1, ExcNotImplemented());

        // create a completely distributed vector that will be used for
        // the scaled and denormalized solution and later used as a
        // starting guess for the linear solver
        LinearAlgebra::BlockVector linearized_stokes_initial_guess(introspection.index_sets.stokes_partitioning, mpi_communicator);
        linearized_stokes_initial_guess.block(block_vel) = current_linearization_point.block(block_vel);
        linearized_stokes_initial_guess.block(block_p) = current_linearization_point.block(block_p);

        if (nonlinear_iteration == 0)
          {
            initial_residual = compute_initial_newton_residual(linearized_stokes_initial_guess);
            switch_initial_residual = initial_residual;
            residual = initial_residual;
          }

        assemble_newton_stokes_system = assemble_newton_stokes_matrix = true;

        if (nonlinear_iteration == 0)
          {
            assemble_newton_stokes_system = assemble_newton_stokes_matrix = false;
          }
        else
          {
            denormalize_pressure (last_pressure_normalization_adjustment,
                                  linearized_stokes_initial_guess,
                                  current_linearization_point);
          }

        if (nonlinear_iteration <= 1)
          {
            set_assemblers();
            compute_current_constraints ();
          }

        // the Stokes matrix depends on the viscosity. if the viscosity
        // depends on other solution variables, then after we need to
        // update the Stokes matrix in every time step and so need to set
        // the following flag. if we change the Stokes matrix we also
        // need to update the Stokes preconditioner.
        rebuild_stokes_matrix = rebuild_stokes_preconditioner = assemble_newton_stokes_matrix = true;

        assemble_stokes_system();

        /**
         * Eisenstat Walker method for determining the tolerance
         */
        if (nonlinear_iteration > 1)
          {
            velocity_residual = system_rhs.block(introspection.block_indices.velocities).l2_norm();
            pressure_residual = system_rhs.block(introspection.block_indices.pressure).l2_norm();
            residual = std::sqrt(velocity_residual * velocity_residual + pressure_residual * pressure_residual);

            if (!use_picard || newton_handler->parameters.use_Eisenstat_Walker_method_for_Picard_iterations)
              {
                const bool EisenstatWalkerChoiceOne = true;
                parameters.linear_stokes_solver_tolerance = compute_Eisenstat_Walker_linear_tolerance(EisenstatWalkerChoiceOne,
                                                            newton_handler->parameters.maximum_linear_stokes_solver_tolerance,
                                                            parameters.linear_stokes_solver_tolerance,
                                                            stokes_residuals.second,
                                                            residual,
                                                            residual_old);

                pcout << "   The linear solver tolerance is set to "
                      << parameters.linear_stokes_solver_tolerance
                      << ". ";
                if (!use_picard)
                  {
                    pcout << "Stabilization Preconditioner is "
                          << Newton::to_string(newton_handler->parameters.preconditioner_stabilization)
                          << " and A block is "
                          << Newton::to_string(newton_handler->parameters.velocity_block_stabilization)
                          << ".";
                  }
                pcout << std::endl;
              }
          }

        build_stokes_preconditioner();

        if (newton_handler->parameters.use_Newton_failsafe == false)
          {
            stokes_residuals = solve_stokes();
          }
        else
          {
            try
              {
                stokes_residuals = solve_stokes();
              }
            catch (...)
              {
                // start the solve over again and try with a stabilized version
                pcout << "Solve failed and catched, try again with stabilisation" << std::endl;
                newton_handler->parameters.preconditioner_stabilization = Newton::Parameters::Stabilization::SPD;
                newton_handler->parameters.velocity_block_stabilization = Newton::Parameters::Stabilization::SPD;
                rebuild_stokes_matrix = rebuild_stokes_preconditioner = assemble_newton_stokes_matrix = true;

                assemble_stokes_system();
                /**
                 * Eisenstat Walker method for determining the tolerance
                 */
                if (nonlinear_iteration > 1)
                  {
                    residual_old = residual;
                    velocity_residual = system_rhs.block(introspection.block_indices.velocities).l2_norm();
                    pressure_residual = system_rhs.block(introspection.block_indices.pressure).l2_norm();
                    residual = std::sqrt(velocity_residual * velocity_residual + pressure_residual * pressure_residual);

                    if (!use_picard)
                      {
                        const bool EisenstatWalkerChoiceOne = true;
                        parameters.linear_stokes_solver_tolerance = compute_Eisenstat_Walker_linear_tolerance(EisenstatWalkerChoiceOne,
                                                                    newton_handler->parameters.maximum_linear_stokes_solver_tolerance,
                                                                    parameters.linear_stokes_solver_tolerance,
                                                                    stokes_residuals.second,
                                                                    residual,
                                                                    residual_old);

                        pcout << "   The linear solver tolerance is set to " << parameters.linear_stokes_solver_tolerance << std::endl;
                      }
                  }

                build_stokes_preconditioner();
                stokes_residuals = solve_stokes();
              }
          }

        velocity_residual = system_rhs.block(introspection.block_indices.velocities).l2_norm();
        pressure_residual = system_rhs.block(introspection.block_indices.pressure).l2_norm();
        residual = std::sqrt(velocity_residual * velocity_residual + pressure_residual * pressure_residual);

        double test_residual = residual;
        if (nonlinear_iteration == 0)
          {
            /**
             * The first nonlinear iteration we are computing the whole system in a non-defect corrected Picard way,
             * to make sure that the boundary conditions are correct in combination with correct initial guesses.
             */
            current_linearization_point.block(introspection.block_indices.velocities) = solution.block(introspection.block_indices.velocities);
            current_linearization_point.block(introspection.block_indices.pressure) = solution.block(introspection.block_indices.pressure);

            residual = stokes_residuals.first;

            pcout << "      Relative nonlinear residual (total Newton system) after nonlinear iteration " << nonlinear_iteration+1
                  << ": " << stokes_residuals.first/initial_residual << ", norm of the rhs: " << stokes_residuals.first << std::endl;

          }
        else
          {
            /**
             * We may need to do a line search if the solution update doesn't decrease the norm of the rhs enough.
             * This is done by adding the solution update to the current linearization point and then assembling
             * the Newton right hand side. If the Newton residual has decreased enough by using this update,
             * then we continue, otherwise we reset the current linearization point with the help of the backup and
             * add each iteration an increasingly smaller solution update until the decreasing residual condition
             * is met, or the line search iteration limit is reached.
             */
            LinearAlgebra::BlockVector backup_linearization_point(introspection.index_sets.stokes_partitioning, mpi_communicator);
            backup_linearization_point.block(introspection.block_indices.pressure) = current_linearization_point.block(introspection.block_indices.pressure);
            backup_linearization_point.block(introspection.block_indices.velocities) = current_linearization_point.block(introspection.block_indices.velocities);


            double test_velocity_residual = 0;
            double test_pressure_residual = 0;
            double lambda = 1;
            double alpha = 1e-4;
            unsigned int line_search_iteration = 0;


            /**
             * Do the loop for the line search. Even when we
             * don't do a line search we go into this loop
             */
            do
              {
                // Reset the current linearization point and the search direction
                current_linearization_point.block(introspection.block_indices.pressure) = backup_linearization_point.block(introspection.block_indices.pressure);
                current_linearization_point.block(introspection.block_indices.velocities) = backup_linearization_point.block(introspection.block_indices.velocities);

                LinearAlgebra::BlockVector search_direction = solution;
                search_direction *= lambda;

                current_linearization_point.block(introspection.block_indices.pressure) += search_direction.block(introspection.block_indices.pressure);
                current_linearization_point.block(introspection.block_indices.velocities) += search_direction.block(introspection.block_indices.velocities);

                // Rebuild the rhs to determine the new residual.
                assemble_newton_stokes_matrix = rebuild_stokes_preconditioner = false;
                rebuild_stokes_matrix = true;

                assemble_stokes_system();

                test_velocity_residual = system_rhs.block(introspection.block_indices.velocities).l2_norm();
                test_pressure_residual = system_rhs.block(introspection.block_indices.pressure).l2_norm();
                test_residual = std::sqrt(test_velocity_residual * test_velocity_residual
                                          + test_pressure_residual * test_pressure_residual);

                // Determine if the decrease is sufficient.
                if (test_residual < (1.0 - alpha * lambda) * residual
                    ||
                    line_search_iteration >= newton_handler->parameters.max_newton_line_search_iterations
                    ||
                    use_picard)
                  {
                    pcout << "      Relative nonlinear residual (total Newton system) after nonlinear iteration " << nonlinear_iteration+1
                          << ": " << test_residual/initial_residual << ", norm of the rhs: " << test_residual
                          << ", newton_derivative_scaling_factor: " << newton_handler->parameters.newton_derivative_scaling_factor
                          << std::endl;
                    residual = test_residual;
                    break;
                  }
                else
                  {

                    pcout << "   Line search iteration " << line_search_iteration << ", with norm of the rhs "
                          << test_residual << " and going to " << (1.0 - alpha * lambda) * residual
                          << ", relative residual: " << test_residual/initial_residual << std::endl;

                    /**
                     * The line search step was not sufficient to decrease the residual
                     * enough, so we take a smaller step to see if it improves the residual.
                     */
                    lambda *= (2.0/3.0);// TODO: make a parameter out of this.
                  }

                line_search_iteration++;
                Assert(line_search_iteration <= newton_handler->parameters.max_newton_line_search_iterations,
                       ExcMessage ("This tests the while condition. This condition should "
                                   "actually never be false, because the break statement "
                                   "above should have caught it."));
              }
            while (line_search_iteration <= newton_handler->parameters.max_newton_line_search_iterations);
            // The while condition should actually never be false, because the break statement above should have caught it.
          }


        if (use_picard == true)
          {
            // When we are using (defect corrected) Picard, keep the
            // newton_derivative_scaling_factor at zero. The newton_derivative_scaling_factor
            // is calculated above as std::max(0.0, (1.0-(
            // newton_residual_for_derivative_scaling_factor/switch_initial_residual)))
            switch_initial_residual = residual;
            newton_residual_for_derivative_scaling_factor = residual;
          }
        else
          {
            /**
             * This method allows to slowly introduce the derivatives based
             * on the improvement of the residual. This method was suggested
             * by Raid Hassani.
             */
            if (newton_handler->parameters.use_newton_residual_scaling_method)
              newton_residual_for_derivative_scaling_factor = test_residual;
            else
              newton_residual_for_derivative_scaling_factor = 0;
          }

        residual_old = residual;

        pcout << std::endl;
        if (nonlinear_iteration != 0)
          last_pressure_normalization_adjustment = normalize_pressure(current_linearization_point);

        if (parameters.run_postprocessors_on_nonlinear_iterations)
          postprocess ();

        if (residual/initial_residual < parameters.nonlinear_tolerance)
          {
            break;
          }
      }

    // Reset the Newton stabilization at the end of the timestep.
    newton_handler->parameters.preconditioner_stabilization = starting_preconditioner_stabilization;
    newton_handler->parameters.velocity_block_stabilization = starting_velocity_block_stabilization;

    // Reset the linear tolerance to what it was at the beginning of the time step.
    parameters.linear_stokes_solver_tolerance = begin_linear_tolerance;

    // When we are finished iterating, we need to set the final solution to the current linearization point,
    // because the solution vector is used in the postprocess.
    solution = current_linearization_point;
  }



  template <int dim>
  void Simulator<dim>::solve_single_advection_no_stokes ()
  {
    assemble_and_solve_temperature();
    assemble_and_solve_composition();

    // Assign Stokes solution
    LinearAlgebra::BlockVector distributed_stokes_solution (introspection.index_sets.system_partitioning, mpi_communicator);

    auto lambda = [&](const Point<dim> &p, Vector<double> &result)
    {
      prescribed_stokes_solution->stokes_solution(p, result);
    };

    VectorFunctionFromVectorFunctionObject<dim> func(
      lambda,
      0,
      parameters.include_melt_transport ? 2*dim+3 : dim+1, // velocity and pressure
      introspection.n_components);

    VectorTools::interpolate (*mapping, dof_handler, func, distributed_stokes_solution);

    // distribute hanging node and other constraints
    current_constraints.distribute (distributed_stokes_solution);

    solution.block(introspection.block_indices.velocities) =
      distributed_stokes_solution.block(introspection.block_indices.velocities);
    solution.block(introspection.block_indices.pressure) =
      distributed_stokes_solution.block(introspection.block_indices.pressure);

    if (parameters.include_melt_transport)
      {
        const unsigned int block_u_f = introspection.variable("fluid velocity").block_index;
        const unsigned int block_p_f = introspection.variable("fluid pressure").block_index;
        solution.block(block_u_f) = distributed_stokes_solution.block(block_u_f);
        solution.block(block_p_f) = distributed_stokes_solution.block(block_p_f);
      }

    if (parameters.run_postprocessors_on_nonlinear_iterations)
      postprocess ();
  }



  template <int dim>
  void Simulator<dim>::solve_no_advection_no_stokes ()
  {
    if (parameters.run_postprocessors_on_nonlinear_iterations)
      postprocess ();
  }
}

// explicit instantiation of the functions we implement in this file
namespace aspect
{
#define INSTANTIATE(dim) \
  template double Simulator<dim>::assemble_and_solve_temperature(const bool, double*); \
  template std::vector<double> Simulator<dim>::assemble_and_solve_composition(const bool, std::vector<double> *); \
  template double Simulator<dim>::assemble_and_solve_stokes(const bool, double*); \
  template void Simulator<dim>::solve_single_advection_single_stokes(); \
  template void Simulator<dim>::solve_no_advection_iterated_stokes(); \
  template void Simulator<dim>::solve_iterated_advection_and_stokes(); \
  template void Simulator<dim>::solve_single_advection_iterated_stokes(); \
  template void Simulator<dim>::solve_iterated_advection_and_newton_stokes(); \
  template void Simulator<dim>::solve_single_advection_iterated_newton_stokes(); \
  template void Simulator<dim>::solve_single_advection_no_stokes(); \
  template void Simulator<dim>::solve_first_timestep_only_single_stokes(); \
  template void Simulator<dim>::solve_no_advection_no_stokes();

  ASPECT_INSTANTIATE(INSTANTIATE)
}
