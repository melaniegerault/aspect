# CMAKE generated file: DO NOT EDIT!
# Generated by "Unix Makefiles" Generator, CMake Version 3.14

# Delete rule output on recipe failure.
.DELETE_ON_ERROR:


#=============================================================================
# Special targets provided by cmake.

# Disable implicit rules so canonical targets will work.
.SUFFIXES:


# Remove some rules from gmake that .SUFFIXES does not remove.
SUFFIXES =

.SUFFIXES: .hpux_make_needs_suffix_list


# Suppress display of executed commands.
$(VERBOSE).SILENT:


# A target that is always out of date.
cmake_force:

.PHONY : cmake_force

#=============================================================================
# Set environment variables for the build.

# The shell in which to execute make rules.
SHELL = /bin/sh

# The CMake executable.
CMAKE_COMMAND = /Applications/deal.II.app/Contents/Resources/spack/opt/spack/darwin-mojave-x86_64/clang-10.0.1-apple/cmake-3.14.4-iz6anjhk565p4sahfpmcftym4wifjzya/bin/cmake

# The command to remove a file.
RM = /Applications/deal.II.app/Contents/Resources/spack/opt/spack/darwin-mojave-x86_64/clang-10.0.1-apple/cmake-3.14.4-iz6anjhk565p4sahfpmcftym4wifjzya/bin/cmake -E remove -f

# Escaping for special characters.
EQUALS = =

# The top-level source directory on which CMake was run.
CMAKE_SOURCE_DIR = /Users/melanie/aspect/benchmarks/corner_flow

# The top-level build directory on which CMake was run.
CMAKE_BINARY_DIR = /Users/melanie/aspect/benchmarks/corner_flow

# Include any dependencies generated for this target.
include CMakeFiles/wedge.dir/depend.make

# Include the progress variables for this target.
include CMakeFiles/wedge.dir/progress.make

# Include the compile flags for this target's objects.
include CMakeFiles/wedge.dir/flags.make

CMakeFiles/wedge.dir/wedge.cc.o: CMakeFiles/wedge.dir/flags.make
CMakeFiles/wedge.dir/wedge.cc.o: wedge.cc
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green --progress-dir=/Users/melanie/aspect/benchmarks/corner_flow/CMakeFiles --progress-num=$(CMAKE_PROGRESS_1) "Building CXX object CMakeFiles/wedge.dir/wedge.cc.o"
	/Applications/deal.II.app/Contents/Resources/spack/opt/spack/darwin-mojave-x86_64/clang-10.0.1-apple/openmpi-3.1.4-qz6zsrmc4l4tdlthlxppwr34bmdxlswa/bin/mpicxx  $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -o CMakeFiles/wedge.dir/wedge.cc.o -c /Users/melanie/aspect/benchmarks/corner_flow/wedge.cc

CMakeFiles/wedge.dir/wedge.cc.i: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Preprocessing CXX source to CMakeFiles/wedge.dir/wedge.cc.i"
	/Applications/deal.II.app/Contents/Resources/spack/opt/spack/darwin-mojave-x86_64/clang-10.0.1-apple/openmpi-3.1.4-qz6zsrmc4l4tdlthlxppwr34bmdxlswa/bin/mpicxx $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -E /Users/melanie/aspect/benchmarks/corner_flow/wedge.cc > CMakeFiles/wedge.dir/wedge.cc.i

CMakeFiles/wedge.dir/wedge.cc.s: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Compiling CXX source to assembly CMakeFiles/wedge.dir/wedge.cc.s"
	/Applications/deal.II.app/Contents/Resources/spack/opt/spack/darwin-mojave-x86_64/clang-10.0.1-apple/openmpi-3.1.4-qz6zsrmc4l4tdlthlxppwr34bmdxlswa/bin/mpicxx $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -S /Users/melanie/aspect/benchmarks/corner_flow/wedge.cc -o CMakeFiles/wedge.dir/wedge.cc.s

# Object files for target wedge
wedge_OBJECTS = \
"CMakeFiles/wedge.dir/wedge.cc.o"

# External object files for target wedge
wedge_EXTERNAL_OBJECTS =

libwedge.so: CMakeFiles/wedge.dir/wedge.cc.o
libwedge.so: CMakeFiles/wedge.dir/build.make
libwedge.so: /Applications/deal.II.app/Contents/Resources/lib/libdeal_II.g.9.1.1.dylib
libwedge.so: /Applications/deal.II.app/Contents/Resources/spack/opt/spack/darwin-mojave-x86_64/clang-10.0.1-apple/intel-tbb-2019.4-ukubytfxbefk2jyz4jkpmcusue7ca3zo/lib/libtbb_debug.dylib
libwedge.so: /Applications/deal.II.app/Contents/Resources/spack/opt/spack/darwin-mojave-x86_64/clang-10.0.1-apple/boost-1.70.0-kl27accx4oo6wouath344kvgytgp2fkf/lib/libboost_iostreams-mt.dylib
libwedge.so: /Applications/deal.II.app/Contents/Resources/spack/opt/spack/darwin-mojave-x86_64/clang-10.0.1-apple/boost-1.70.0-kl27accx4oo6wouath344kvgytgp2fkf/lib/libboost_serialization-mt.dylib
libwedge.so: /Applications/deal.II.app/Contents/Resources/spack/opt/spack/darwin-mojave-x86_64/clang-10.0.1-apple/boost-1.70.0-kl27accx4oo6wouath344kvgytgp2fkf/lib/libboost_system-mt.dylib
libwedge.so: /Applications/deal.II.app/Contents/Resources/spack/opt/spack/darwin-mojave-x86_64/clang-10.0.1-apple/boost-1.70.0-kl27accx4oo6wouath344kvgytgp2fkf/lib/libboost_thread-mt.dylib
libwedge.so: /Applications/deal.II.app/Contents/Resources/spack/opt/spack/darwin-mojave-x86_64/clang-10.0.1-apple/boost-1.70.0-kl27accx4oo6wouath344kvgytgp2fkf/lib/libboost_regex-mt.dylib
libwedge.so: /Applications/deal.II.app/Contents/Resources/spack/opt/spack/darwin-mojave-x86_64/clang-10.0.1-apple/boost-1.70.0-kl27accx4oo6wouath344kvgytgp2fkf/lib/libboost_chrono-mt.dylib
libwedge.so: /Applications/deal.II.app/Contents/Resources/spack/opt/spack/darwin-mojave-x86_64/clang-10.0.1-apple/boost-1.70.0-kl27accx4oo6wouath344kvgytgp2fkf/lib/libboost_date_time-mt.dylib
libwedge.so: /Applications/deal.II.app/Contents/Resources/spack/opt/spack/darwin-mojave-x86_64/clang-10.0.1-apple/boost-1.70.0-kl27accx4oo6wouath344kvgytgp2fkf/lib/libboost_atomic-mt.dylib
libwedge.so: /Applications/deal.II.app/Contents/Resources/spack/opt/spack/darwin-mojave-x86_64/clang-10.0.1-apple/ginkgo-1.0.0-boykgmhpww37l5vfpxxyf5rukn5rnl2p/lib/libginkgo.dylib
libwedge.so: /Applications/deal.II.app/Contents/Resources/spack/opt/spack/darwin-mojave-x86_64/clang-10.0.1-apple/ginkgo-1.0.0-boykgmhpww37l5vfpxxyf5rukn5rnl2p/lib/libginkgo_reference.dylib
libwedge.so: /Applications/deal.II.app/Contents/Resources/spack/opt/spack/darwin-mojave-x86_64/clang-10.0.1-apple/ginkgo-1.0.0-boykgmhpww37l5vfpxxyf5rukn5rnl2p/lib/libginkgo_omp.dylib
libwedge.so: /Applications/deal.II.app/Contents/Resources/spack/opt/spack/darwin-mojave-x86_64/clang-10.0.1-apple/ginkgo-1.0.0-boykgmhpww37l5vfpxxyf5rukn5rnl2p/lib/libginkgo_cuda.dylib
libwedge.so: /Applications/deal.II.app/Contents/Resources/spack/opt/spack/darwin-mojave-x86_64/clang-10.0.1-apple/trilinos-12.14.1-ocevb2wvpcwiz5ltpn3lmkjegq3sr7wz/lib/libmuelu-adapters.dylib
libwedge.so: /Applications/deal.II.app/Contents/Resources/spack/opt/spack/darwin-mojave-x86_64/clang-10.0.1-apple/trilinos-12.14.1-ocevb2wvpcwiz5ltpn3lmkjegq3sr7wz/lib/libmuelu-interface.dylib
libwedge.so: /Applications/deal.II.app/Contents/Resources/spack/opt/spack/darwin-mojave-x86_64/clang-10.0.1-apple/trilinos-12.14.1-ocevb2wvpcwiz5ltpn3lmkjegq3sr7wz/lib/libmuelu.dylib
libwedge.so: /Applications/deal.II.app/Contents/Resources/spack/opt/spack/darwin-mojave-x86_64/clang-10.0.1-apple/trilinos-12.14.1-ocevb2wvpcwiz5ltpn3lmkjegq3sr7wz/lib/libifpack2.dylib
libwedge.so: /Applications/deal.II.app/Contents/Resources/spack/opt/spack/darwin-mojave-x86_64/clang-10.0.1-apple/trilinos-12.14.1-ocevb2wvpcwiz5ltpn3lmkjegq3sr7wz/lib/libanasazitpetra.dylib
libwedge.so: /Applications/deal.II.app/Contents/Resources/spack/opt/spack/darwin-mojave-x86_64/clang-10.0.1-apple/trilinos-12.14.1-ocevb2wvpcwiz5ltpn3lmkjegq3sr7wz/lib/libModeLaplace.dylib
libwedge.so: /Applications/deal.II.app/Contents/Resources/spack/opt/spack/darwin-mojave-x86_64/clang-10.0.1-apple/trilinos-12.14.1-ocevb2wvpcwiz5ltpn3lmkjegq3sr7wz/lib/libanasaziepetra.dylib
libwedge.so: /Applications/deal.II.app/Contents/Resources/spack/opt/spack/darwin-mojave-x86_64/clang-10.0.1-apple/trilinos-12.14.1-ocevb2wvpcwiz5ltpn3lmkjegq3sr7wz/lib/libanasazi.dylib
libwedge.so: /Applications/deal.II.app/Contents/Resources/spack/opt/spack/darwin-mojave-x86_64/clang-10.0.1-apple/trilinos-12.14.1-ocevb2wvpcwiz5ltpn3lmkjegq3sr7wz/lib/libmapvarlib.dylib
libwedge.so: /Applications/deal.II.app/Contents/Resources/spack/opt/spack/darwin-mojave-x86_64/clang-10.0.1-apple/trilinos-12.14.1-ocevb2wvpcwiz5ltpn3lmkjegq3sr7wz/lib/libsuplib_cpp.dylib
libwedge.so: /Applications/deal.II.app/Contents/Resources/spack/opt/spack/darwin-mojave-x86_64/clang-10.0.1-apple/trilinos-12.14.1-ocevb2wvpcwiz5ltpn3lmkjegq3sr7wz/lib/libsuplib_c.dylib
libwedge.so: /Applications/deal.II.app/Contents/Resources/spack/opt/spack/darwin-mojave-x86_64/clang-10.0.1-apple/trilinos-12.14.1-ocevb2wvpcwiz5ltpn3lmkjegq3sr7wz/lib/libsuplib.dylib
libwedge.so: /Applications/deal.II.app/Contents/Resources/spack/opt/spack/darwin-mojave-x86_64/clang-10.0.1-apple/trilinos-12.14.1-ocevb2wvpcwiz5ltpn3lmkjegq3sr7wz/lib/libsupes.dylib
libwedge.so: /Applications/deal.II.app/Contents/Resources/spack/opt/spack/darwin-mojave-x86_64/clang-10.0.1-apple/trilinos-12.14.1-ocevb2wvpcwiz5ltpn3lmkjegq3sr7wz/lib/libaprepro_lib.dylib
libwedge.so: /Applications/deal.II.app/Contents/Resources/spack/opt/spack/darwin-mojave-x86_64/clang-10.0.1-apple/trilinos-12.14.1-ocevb2wvpcwiz5ltpn3lmkjegq3sr7wz/lib/libio_info_lib.dylib
libwedge.so: /Applications/deal.II.app/Contents/Resources/spack/opt/spack/darwin-mojave-x86_64/clang-10.0.1-apple/trilinos-12.14.1-ocevb2wvpcwiz5ltpn3lmkjegq3sr7wz/lib/libIonit.dylib
libwedge.so: /Applications/deal.II.app/Contents/Resources/spack/opt/spack/darwin-mojave-x86_64/clang-10.0.1-apple/trilinos-12.14.1-ocevb2wvpcwiz5ltpn3lmkjegq3sr7wz/lib/libIotr.dylib
libwedge.so: /Applications/deal.II.app/Contents/Resources/spack/opt/spack/darwin-mojave-x86_64/clang-10.0.1-apple/trilinos-12.14.1-ocevb2wvpcwiz5ltpn3lmkjegq3sr7wz/lib/libIohb.dylib
libwedge.so: /Applications/deal.II.app/Contents/Resources/spack/opt/spack/darwin-mojave-x86_64/clang-10.0.1-apple/trilinos-12.14.1-ocevb2wvpcwiz5ltpn3lmkjegq3sr7wz/lib/libIogs.dylib
libwedge.so: /Applications/deal.II.app/Contents/Resources/spack/opt/spack/darwin-mojave-x86_64/clang-10.0.1-apple/trilinos-12.14.1-ocevb2wvpcwiz5ltpn3lmkjegq3sr7wz/lib/libIogn.dylib
libwedge.so: /Applications/deal.II.app/Contents/Resources/spack/opt/spack/darwin-mojave-x86_64/clang-10.0.1-apple/trilinos-12.14.1-ocevb2wvpcwiz5ltpn3lmkjegq3sr7wz/lib/libIovs.dylib
libwedge.so: /Applications/deal.II.app/Contents/Resources/spack/opt/spack/darwin-mojave-x86_64/clang-10.0.1-apple/trilinos-12.14.1-ocevb2wvpcwiz5ltpn3lmkjegq3sr7wz/lib/libIoexo_fac.dylib
libwedge.so: /Applications/deal.II.app/Contents/Resources/spack/opt/spack/darwin-mojave-x86_64/clang-10.0.1-apple/trilinos-12.14.1-ocevb2wvpcwiz5ltpn3lmkjegq3sr7wz/lib/libIofx.dylib
libwedge.so: /Applications/deal.II.app/Contents/Resources/spack/opt/spack/darwin-mojave-x86_64/clang-10.0.1-apple/trilinos-12.14.1-ocevb2wvpcwiz5ltpn3lmkjegq3sr7wz/lib/libIoex.dylib
libwedge.so: /Applications/deal.II.app/Contents/Resources/spack/opt/spack/darwin-mojave-x86_64/clang-10.0.1-apple/trilinos-12.14.1-ocevb2wvpcwiz5ltpn3lmkjegq3sr7wz/lib/libIoss.dylib
libwedge.so: /Applications/deal.II.app/Contents/Resources/spack/opt/spack/darwin-mojave-x86_64/clang-10.0.1-apple/trilinos-12.14.1-ocevb2wvpcwiz5ltpn3lmkjegq3sr7wz/lib/libnemesis.dylib
libwedge.so: /Applications/deal.II.app/Contents/Resources/spack/opt/spack/darwin-mojave-x86_64/clang-10.0.1-apple/trilinos-12.14.1-ocevb2wvpcwiz5ltpn3lmkjegq3sr7wz/lib/libexoIIv2for32.dylib
libwedge.so: /Applications/deal.II.app/Contents/Resources/spack/opt/spack/darwin-mojave-x86_64/clang-10.0.1-apple/trilinos-12.14.1-ocevb2wvpcwiz5ltpn3lmkjegq3sr7wz/lib/libexodus_for.dylib
libwedge.so: /Applications/deal.II.app/Contents/Resources/spack/opt/spack/darwin-mojave-x86_64/clang-10.0.1-apple/trilinos-12.14.1-ocevb2wvpcwiz5ltpn3lmkjegq3sr7wz/lib/libexodus.dylib
libwedge.so: /Applications/deal.II.app/Contents/Resources/spack/opt/spack/darwin-mojave-x86_64/clang-10.0.1-apple/trilinos-12.14.1-ocevb2wvpcwiz5ltpn3lmkjegq3sr7wz/lib/libamesos2.dylib
libwedge.so: /Applications/deal.II.app/Contents/Resources/spack/opt/spack/darwin-mojave-x86_64/clang-10.0.1-apple/trilinos-12.14.1-ocevb2wvpcwiz5ltpn3lmkjegq3sr7wz/lib/libbelosxpetra.dylib
libwedge.so: /Applications/deal.II.app/Contents/Resources/spack/opt/spack/darwin-mojave-x86_64/clang-10.0.1-apple/trilinos-12.14.1-ocevb2wvpcwiz5ltpn3lmkjegq3sr7wz/lib/libbelostpetra.dylib
libwedge.so: /Applications/deal.II.app/Contents/Resources/spack/opt/spack/darwin-mojave-x86_64/clang-10.0.1-apple/trilinos-12.14.1-ocevb2wvpcwiz5ltpn3lmkjegq3sr7wz/lib/libbelosepetra.dylib
libwedge.so: /Applications/deal.II.app/Contents/Resources/spack/opt/spack/darwin-mojave-x86_64/clang-10.0.1-apple/trilinos-12.14.1-ocevb2wvpcwiz5ltpn3lmkjegq3sr7wz/lib/libbelos.dylib
libwedge.so: /Applications/deal.II.app/Contents/Resources/spack/opt/spack/darwin-mojave-x86_64/clang-10.0.1-apple/trilinos-12.14.1-ocevb2wvpcwiz5ltpn3lmkjegq3sr7wz/lib/libml.dylib
libwedge.so: /Applications/deal.II.app/Contents/Resources/spack/opt/spack/darwin-mojave-x86_64/clang-10.0.1-apple/trilinos-12.14.1-ocevb2wvpcwiz5ltpn3lmkjegq3sr7wz/lib/libifpack.dylib
libwedge.so: /Applications/deal.II.app/Contents/Resources/spack/opt/spack/darwin-mojave-x86_64/clang-10.0.1-apple/trilinos-12.14.1-ocevb2wvpcwiz5ltpn3lmkjegq3sr7wz/lib/libzoltan2.dylib
libwedge.so: /Applications/deal.II.app/Contents/Resources/spack/opt/spack/darwin-mojave-x86_64/clang-10.0.1-apple/trilinos-12.14.1-ocevb2wvpcwiz5ltpn3lmkjegq3sr7wz/lib/libamesos.dylib
libwedge.so: /Applications/deal.II.app/Contents/Resources/spack/opt/spack/darwin-mojave-x86_64/clang-10.0.1-apple/trilinos-12.14.1-ocevb2wvpcwiz5ltpn3lmkjegq3sr7wz/lib/libgaleri-xpetra.dylib
libwedge.so: /Applications/deal.II.app/Contents/Resources/spack/opt/spack/darwin-mojave-x86_64/clang-10.0.1-apple/trilinos-12.14.1-ocevb2wvpcwiz5ltpn3lmkjegq3sr7wz/lib/libgaleri-epetra.dylib
libwedge.so: /Applications/deal.II.app/Contents/Resources/spack/opt/spack/darwin-mojave-x86_64/clang-10.0.1-apple/trilinos-12.14.1-ocevb2wvpcwiz5ltpn3lmkjegq3sr7wz/lib/libaztecoo.dylib
libwedge.so: /Applications/deal.II.app/Contents/Resources/spack/opt/spack/darwin-mojave-x86_64/clang-10.0.1-apple/trilinos-12.14.1-ocevb2wvpcwiz5ltpn3lmkjegq3sr7wz/lib/libxpetra-sup.dylib
libwedge.so: /Applications/deal.II.app/Contents/Resources/spack/opt/spack/darwin-mojave-x86_64/clang-10.0.1-apple/trilinos-12.14.1-ocevb2wvpcwiz5ltpn3lmkjegq3sr7wz/lib/libxpetra.dylib
libwedge.so: /Applications/deal.II.app/Contents/Resources/spack/opt/spack/darwin-mojave-x86_64/clang-10.0.1-apple/trilinos-12.14.1-ocevb2wvpcwiz5ltpn3lmkjegq3sr7wz/lib/libepetraext.dylib
libwedge.so: /Applications/deal.II.app/Contents/Resources/spack/opt/spack/darwin-mojave-x86_64/clang-10.0.1-apple/trilinos-12.14.1-ocevb2wvpcwiz5ltpn3lmkjegq3sr7wz/lib/libtrilinosss.dylib
libwedge.so: /Applications/deal.II.app/Contents/Resources/spack/opt/spack/darwin-mojave-x86_64/clang-10.0.1-apple/trilinos-12.14.1-ocevb2wvpcwiz5ltpn3lmkjegq3sr7wz/lib/libtpetraext.dylib
libwedge.so: /Applications/deal.II.app/Contents/Resources/spack/opt/spack/darwin-mojave-x86_64/clang-10.0.1-apple/trilinos-12.14.1-ocevb2wvpcwiz5ltpn3lmkjegq3sr7wz/lib/libtpetrainout.dylib
libwedge.so: /Applications/deal.II.app/Contents/Resources/spack/opt/spack/darwin-mojave-x86_64/clang-10.0.1-apple/trilinos-12.14.1-ocevb2wvpcwiz5ltpn3lmkjegq3sr7wz/lib/libtpetra.dylib
libwedge.so: /Applications/deal.II.app/Contents/Resources/spack/opt/spack/darwin-mojave-x86_64/clang-10.0.1-apple/trilinos-12.14.1-ocevb2wvpcwiz5ltpn3lmkjegq3sr7wz/lib/libkokkostsqr.dylib
libwedge.so: /Applications/deal.II.app/Contents/Resources/spack/opt/spack/darwin-mojave-x86_64/clang-10.0.1-apple/trilinos-12.14.1-ocevb2wvpcwiz5ltpn3lmkjegq3sr7wz/lib/libtpetraclassiclinalg.dylib
libwedge.so: /Applications/deal.II.app/Contents/Resources/spack/opt/spack/darwin-mojave-x86_64/clang-10.0.1-apple/trilinos-12.14.1-ocevb2wvpcwiz5ltpn3lmkjegq3sr7wz/lib/libtpetraclassicnodeapi.dylib
libwedge.so: /Applications/deal.II.app/Contents/Resources/spack/opt/spack/darwin-mojave-x86_64/clang-10.0.1-apple/trilinos-12.14.1-ocevb2wvpcwiz5ltpn3lmkjegq3sr7wz/lib/libtpetraclassic.dylib
libwedge.so: /Applications/deal.II.app/Contents/Resources/spack/opt/spack/darwin-mojave-x86_64/clang-10.0.1-apple/trilinos-12.14.1-ocevb2wvpcwiz5ltpn3lmkjegq3sr7wz/lib/libtriutils.dylib
libwedge.so: /Applications/deal.II.app/Contents/Resources/spack/opt/spack/darwin-mojave-x86_64/clang-10.0.1-apple/trilinos-12.14.1-ocevb2wvpcwiz5ltpn3lmkjegq3sr7wz/lib/libzoltan.dylib
libwedge.so: /Applications/deal.II.app/Contents/Resources/spack/opt/spack/darwin-mojave-x86_64/clang-10.0.1-apple/trilinos-12.14.1-ocevb2wvpcwiz5ltpn3lmkjegq3sr7wz/lib/libepetra.dylib
libwedge.so: /Applications/deal.II.app/Contents/Resources/spack/opt/spack/darwin-mojave-x86_64/clang-10.0.1-apple/trilinos-12.14.1-ocevb2wvpcwiz5ltpn3lmkjegq3sr7wz/lib/libsacado.dylib
libwedge.so: /Applications/deal.II.app/Contents/Resources/spack/opt/spack/darwin-mojave-x86_64/clang-10.0.1-apple/trilinos-12.14.1-ocevb2wvpcwiz5ltpn3lmkjegq3sr7wz/lib/libkokkoskernels.dylib
libwedge.so: /Applications/deal.II.app/Contents/Resources/spack/opt/spack/darwin-mojave-x86_64/clang-10.0.1-apple/trilinos-12.14.1-ocevb2wvpcwiz5ltpn3lmkjegq3sr7wz/lib/libteuchoskokkoscomm.dylib
libwedge.so: /Applications/deal.II.app/Contents/Resources/spack/opt/spack/darwin-mojave-x86_64/clang-10.0.1-apple/trilinos-12.14.1-ocevb2wvpcwiz5ltpn3lmkjegq3sr7wz/lib/libteuchoskokkoscompat.dylib
libwedge.so: /Applications/deal.II.app/Contents/Resources/spack/opt/spack/darwin-mojave-x86_64/clang-10.0.1-apple/trilinos-12.14.1-ocevb2wvpcwiz5ltpn3lmkjegq3sr7wz/lib/libteuchosremainder.dylib
libwedge.so: /Applications/deal.II.app/Contents/Resources/spack/opt/spack/darwin-mojave-x86_64/clang-10.0.1-apple/trilinos-12.14.1-ocevb2wvpcwiz5ltpn3lmkjegq3sr7wz/lib/libteuchosnumerics.dylib
libwedge.so: /Applications/deal.II.app/Contents/Resources/spack/opt/spack/darwin-mojave-x86_64/clang-10.0.1-apple/trilinos-12.14.1-ocevb2wvpcwiz5ltpn3lmkjegq3sr7wz/lib/libteuchoscomm.dylib
libwedge.so: /Applications/deal.II.app/Contents/Resources/spack/opt/spack/darwin-mojave-x86_64/clang-10.0.1-apple/trilinos-12.14.1-ocevb2wvpcwiz5ltpn3lmkjegq3sr7wz/lib/libteuchosparameterlist.dylib
libwedge.so: /Applications/deal.II.app/Contents/Resources/spack/opt/spack/darwin-mojave-x86_64/clang-10.0.1-apple/trilinos-12.14.1-ocevb2wvpcwiz5ltpn3lmkjegq3sr7wz/lib/libteuchosparser.dylib
libwedge.so: /Applications/deal.II.app/Contents/Resources/spack/opt/spack/darwin-mojave-x86_64/clang-10.0.1-apple/trilinos-12.14.1-ocevb2wvpcwiz5ltpn3lmkjegq3sr7wz/lib/libteuchoscore.dylib
libwedge.so: /Applications/deal.II.app/Contents/Resources/spack/opt/spack/darwin-mojave-x86_64/clang-10.0.1-apple/trilinos-12.14.1-ocevb2wvpcwiz5ltpn3lmkjegq3sr7wz/lib/libkokkosalgorithms.dylib
libwedge.so: /Applications/deal.II.app/Contents/Resources/spack/opt/spack/darwin-mojave-x86_64/clang-10.0.1-apple/trilinos-12.14.1-ocevb2wvpcwiz5ltpn3lmkjegq3sr7wz/lib/libkokkoscontainers.dylib
libwedge.so: /Applications/deal.II.app/Contents/Resources/spack/opt/spack/darwin-mojave-x86_64/clang-10.0.1-apple/trilinos-12.14.1-ocevb2wvpcwiz5ltpn3lmkjegq3sr7wz/lib/libkokkoscore.dylib
libwedge.so: /Applications/deal.II.app/Contents/Resources/spack/opt/spack/darwin-mojave-x86_64/clang-10.0.1-apple/trilinos-12.14.1-ocevb2wvpcwiz5ltpn3lmkjegq3sr7wz/lib/libgtest.dylib
libwedge.so: /Applications/deal.II.app/Contents/Resources/spack/opt/spack/darwin-mojave-x86_64/clang-10.0.1-apple/matio-1.5.13-goohnvcv4fnaxr44lyeyqnaks4cxfvce/lib/libmatio.dylib
libwedge.so: /Applications/deal.II.app/Contents/Resources/spack/opt/spack/darwin-mojave-x86_64/clang-10.0.1-apple/mumps-5.2.0-po54g6rqzjflf53lhwnsnkli3ilx5ej6/lib/libdmumps.dylib
libwedge.so: /Applications/deal.II.app/Contents/Resources/spack/opt/spack/darwin-mojave-x86_64/clang-10.0.1-apple/mumps-5.2.0-po54g6rqzjflf53lhwnsnkli3ilx5ej6/lib/libmumps_common.dylib
libwedge.so: /Applications/deal.II.app/Contents/Resources/spack/opt/spack/darwin-mojave-x86_64/clang-10.0.1-apple/mumps-5.2.0-po54g6rqzjflf53lhwnsnkli3ilx5ej6/lib/libpord.dylib
libwedge.so: /usr/lib/libdl.dylib
libwedge.so: /Applications/deal.II.app/Contents/Resources/spack/opt/spack/darwin-mojave-x86_64/clang-10.0.1-apple/suite-sparse-5.3.0-q5k5dy73ecpr6h5e5n67alszipxrum67/lib/libumfpack.dylib
libwedge.so: /Applications/deal.II.app/Contents/Resources/spack/opt/spack/darwin-mojave-x86_64/clang-10.0.1-apple/suite-sparse-5.3.0-q5k5dy73ecpr6h5e5n67alszipxrum67/lib/libcholmod.dylib
libwedge.so: /Applications/deal.II.app/Contents/Resources/spack/opt/spack/darwin-mojave-x86_64/clang-10.0.1-apple/suite-sparse-5.3.0-q5k5dy73ecpr6h5e5n67alszipxrum67/lib/libccolamd.dylib
libwedge.so: /Applications/deal.II.app/Contents/Resources/spack/opt/spack/darwin-mojave-x86_64/clang-10.0.1-apple/suite-sparse-5.3.0-q5k5dy73ecpr6h5e5n67alszipxrum67/lib/libcolamd.dylib
libwedge.so: /Applications/deal.II.app/Contents/Resources/spack/opt/spack/darwin-mojave-x86_64/clang-10.0.1-apple/suite-sparse-5.3.0-q5k5dy73ecpr6h5e5n67alszipxrum67/lib/libcamd.dylib
libwedge.so: /Applications/deal.II.app/Contents/Resources/spack/opt/spack/darwin-mojave-x86_64/clang-10.0.1-apple/suite-sparse-5.3.0-q5k5dy73ecpr6h5e5n67alszipxrum67/lib/libsuitesparseconfig.dylib
libwedge.so: /Applications/deal.II.app/Contents/Resources/spack/opt/spack/darwin-mojave-x86_64/clang-10.0.1-apple/suite-sparse-5.3.0-q5k5dy73ecpr6h5e5n67alszipxrum67/lib/libamd.dylib
libwedge.so: /Applications/deal.II.app/Contents/Resources/spack/opt/spack/darwin-mojave-x86_64/clang-10.0.1-apple/adol-c-develop-sk2ebe7qi5xxyibvgeemuh47642dji22/lib64/libadolc.dylib
libwedge.so: /Applications/deal.II.app/Contents/Resources/spack/opt/spack/darwin-mojave-x86_64/clang-10.0.1-apple/arpack-ng-3.7.0-lm2hfosfwh2rf4n3rwq2ygtkgog22j4c/lib/libarpack.dylib
libwedge.so: /Applications/deal.II.app/Contents/Resources/spack/opt/spack/darwin-mojave-x86_64/clang-10.0.1-apple/assimp-4.0.1-odxma6udgq5hopwpkc5dbftywzcsice2/lib/libassimp.dylib
libwedge.so: /Applications/deal.II.app/Contents/Resources/spack/opt/spack/darwin-mojave-x86_64/clang-10.0.1-apple/gsl-2.5-qeaufn2qqrohifqcoan2tigxwvfll5vt/lib/libgsl.dylib
libwedge.so: /Applications/deal.II.app/Contents/Resources/spack/opt/spack/darwin-mojave-x86_64/clang-10.0.1-apple/gsl-2.5-qeaufn2qqrohifqcoan2tigxwvfll5vt/lib/libgslcblas.dylib
libwedge.so: /Applications/deal.II.app/Contents/Resources/spack/opt/spack/darwin-mojave-x86_64/clang-10.0.1-apple/muparser-2.2.6.1-tdgtam6gdimdonf75kua42itwsexgxmb/lib/libmuparser.dylib
libwedge.so: /Applications/deal.II.app/Contents/Resources/spack/opt/spack/darwin-mojave-x86_64/clang-10.0.1-apple/netcdf-cxx-4.2-ro7ea7doeeytdzygeq2v7mjuzbnssxej/lib/libnetcdf_c++.dylib
libwedge.so: /Applications/deal.II.app/Contents/Resources/spack/opt/spack/darwin-mojave-x86_64/clang-10.0.1-apple/netcdf-4.6.3-oskbmippnu3ekr237pdygtk2obifjjay/lib/libnetcdf.dylib
libwedge.so: /Applications/deal.II.app/Contents/Resources/spack/opt/spack/darwin-mojave-x86_64/clang-10.0.1-apple/oce-0.18.3-ox4dhuoisrzmhrtc5ffpe7t6udw6xauq/lib/libTKBO.dylib
libwedge.so: /Applications/deal.II.app/Contents/Resources/spack/opt/spack/darwin-mojave-x86_64/clang-10.0.1-apple/oce-0.18.3-ox4dhuoisrzmhrtc5ffpe7t6udw6xauq/lib/libTKBool.dylib
libwedge.so: /Applications/deal.II.app/Contents/Resources/spack/opt/spack/darwin-mojave-x86_64/clang-10.0.1-apple/oce-0.18.3-ox4dhuoisrzmhrtc5ffpe7t6udw6xauq/lib/libTKBRep.dylib
libwedge.so: /Applications/deal.II.app/Contents/Resources/spack/opt/spack/darwin-mojave-x86_64/clang-10.0.1-apple/oce-0.18.3-ox4dhuoisrzmhrtc5ffpe7t6udw6xauq/lib/libTKernel.dylib
libwedge.so: /Applications/deal.II.app/Contents/Resources/spack/opt/spack/darwin-mojave-x86_64/clang-10.0.1-apple/oce-0.18.3-ox4dhuoisrzmhrtc5ffpe7t6udw6xauq/lib/libTKFeat.dylib
libwedge.so: /Applications/deal.II.app/Contents/Resources/spack/opt/spack/darwin-mojave-x86_64/clang-10.0.1-apple/oce-0.18.3-ox4dhuoisrzmhrtc5ffpe7t6udw6xauq/lib/libTKFillet.dylib
libwedge.so: /Applications/deal.II.app/Contents/Resources/spack/opt/spack/darwin-mojave-x86_64/clang-10.0.1-apple/oce-0.18.3-ox4dhuoisrzmhrtc5ffpe7t6udw6xauq/lib/libTKG2d.dylib
libwedge.so: /Applications/deal.II.app/Contents/Resources/spack/opt/spack/darwin-mojave-x86_64/clang-10.0.1-apple/oce-0.18.3-ox4dhuoisrzmhrtc5ffpe7t6udw6xauq/lib/libTKG3d.dylib
libwedge.so: /Applications/deal.II.app/Contents/Resources/spack/opt/spack/darwin-mojave-x86_64/clang-10.0.1-apple/oce-0.18.3-ox4dhuoisrzmhrtc5ffpe7t6udw6xauq/lib/libTKGeomAlgo.dylib
libwedge.so: /Applications/deal.II.app/Contents/Resources/spack/opt/spack/darwin-mojave-x86_64/clang-10.0.1-apple/oce-0.18.3-ox4dhuoisrzmhrtc5ffpe7t6udw6xauq/lib/libTKGeomBase.dylib
libwedge.so: /Applications/deal.II.app/Contents/Resources/spack/opt/spack/darwin-mojave-x86_64/clang-10.0.1-apple/oce-0.18.3-ox4dhuoisrzmhrtc5ffpe7t6udw6xauq/lib/libTKHLR.dylib
libwedge.so: /Applications/deal.II.app/Contents/Resources/spack/opt/spack/darwin-mojave-x86_64/clang-10.0.1-apple/oce-0.18.3-ox4dhuoisrzmhrtc5ffpe7t6udw6xauq/lib/libTKIGES.dylib
libwedge.so: /Applications/deal.II.app/Contents/Resources/spack/opt/spack/darwin-mojave-x86_64/clang-10.0.1-apple/oce-0.18.3-ox4dhuoisrzmhrtc5ffpe7t6udw6xauq/lib/libTKMath.dylib
libwedge.so: /Applications/deal.II.app/Contents/Resources/spack/opt/spack/darwin-mojave-x86_64/clang-10.0.1-apple/oce-0.18.3-ox4dhuoisrzmhrtc5ffpe7t6udw6xauq/lib/libTKMesh.dylib
libwedge.so: /Applications/deal.II.app/Contents/Resources/spack/opt/spack/darwin-mojave-x86_64/clang-10.0.1-apple/oce-0.18.3-ox4dhuoisrzmhrtc5ffpe7t6udw6xauq/lib/libTKOffset.dylib
libwedge.so: /Applications/deal.II.app/Contents/Resources/spack/opt/spack/darwin-mojave-x86_64/clang-10.0.1-apple/oce-0.18.3-ox4dhuoisrzmhrtc5ffpe7t6udw6xauq/lib/libTKPrim.dylib
libwedge.so: /Applications/deal.II.app/Contents/Resources/spack/opt/spack/darwin-mojave-x86_64/clang-10.0.1-apple/oce-0.18.3-ox4dhuoisrzmhrtc5ffpe7t6udw6xauq/lib/libTKShHealing.dylib
libwedge.so: /Applications/deal.II.app/Contents/Resources/spack/opt/spack/darwin-mojave-x86_64/clang-10.0.1-apple/oce-0.18.3-ox4dhuoisrzmhrtc5ffpe7t6udw6xauq/lib/libTKSTEP.dylib
libwedge.so: /Applications/deal.II.app/Contents/Resources/spack/opt/spack/darwin-mojave-x86_64/clang-10.0.1-apple/oce-0.18.3-ox4dhuoisrzmhrtc5ffpe7t6udw6xauq/lib/libTKSTEPAttr.dylib
libwedge.so: /Applications/deal.II.app/Contents/Resources/spack/opt/spack/darwin-mojave-x86_64/clang-10.0.1-apple/oce-0.18.3-ox4dhuoisrzmhrtc5ffpe7t6udw6xauq/lib/libTKSTEPBase.dylib
libwedge.so: /Applications/deal.II.app/Contents/Resources/spack/opt/spack/darwin-mojave-x86_64/clang-10.0.1-apple/oce-0.18.3-ox4dhuoisrzmhrtc5ffpe7t6udw6xauq/lib/libTKSTEP209.dylib
libwedge.so: /Applications/deal.II.app/Contents/Resources/spack/opt/spack/darwin-mojave-x86_64/clang-10.0.1-apple/oce-0.18.3-ox4dhuoisrzmhrtc5ffpe7t6udw6xauq/lib/libTKSTL.dylib
libwedge.so: /Applications/deal.II.app/Contents/Resources/spack/opt/spack/darwin-mojave-x86_64/clang-10.0.1-apple/oce-0.18.3-ox4dhuoisrzmhrtc5ffpe7t6udw6xauq/lib/libTKTopAlgo.dylib
libwedge.so: /Applications/deal.II.app/Contents/Resources/spack/opt/spack/darwin-mojave-x86_64/clang-10.0.1-apple/oce-0.18.3-ox4dhuoisrzmhrtc5ffpe7t6udw6xauq/lib/libTKXSBase.dylib
libwedge.so: /Applications/deal.II.app/Contents/Resources/spack/opt/spack/darwin-mojave-x86_64/clang-10.0.1-apple/p4est-2.0-4524vx7hd7w3xmzbwckwliy6kxfkvuu3/lib/libp4est.dylib
libwedge.so: /Applications/deal.II.app/Contents/Resources/spack/opt/spack/darwin-mojave-x86_64/clang-10.0.1-apple/p4est-2.0-4524vx7hd7w3xmzbwckwliy6kxfkvuu3/lib/libsc.dylib
libwedge.so: /Applications/deal.II.app/Contents/Resources/spack/opt/spack/darwin-mojave-x86_64/clang-10.0.1-apple/netlib-scalapack-2.0.2-6n2jnrwquciwnlxdprsyu36rvkwo43by/lib/libscalapack.dylib
libwedge.so: /Applications/deal.II.app/Contents/Resources/spack/opt/spack/darwin-mojave-x86_64/clang-10.0.1-apple/slepc-3.10.0-dqvms5bwlqnn6dmbiyfw6g3p4qfsffxs/lib/libslepc.dylib
libwedge.so: /Applications/deal.II.app/Contents/Resources/spack/opt/spack/darwin-mojave-x86_64/clang-10.0.1-apple/petsc-3.10.0-a6f2z36otjmx4is6ddvsdfygjwc33msq/lib/libpetsc.dylib
libwedge.so: /Applications/deal.II.app/Contents/Resources/spack/opt/spack/darwin-mojave-x86_64/clang-10.0.1-apple/superlu-dist-5.4.0-23n4okuzbmm7b7fabhvy3rbc6sozwwre/lib/libsuperlu_dist.dylib
libwedge.so: /Applications/deal.II.app/Contents/Resources/spack/opt/spack/darwin-mojave-x86_64/clang-10.0.1-apple/hypre-2.15.1-rn2bm5qdae7qgbhid3gexzd6axkmcbuh/lib/libHYPRE.a
libwedge.so: /Applications/deal.II.app/Contents/Resources/spack/opt/spack/darwin-mojave-x86_64/clang-10.0.1-apple/openblas-0.3.6-3yts3o25cqf437oxaa4qzfhiw3swc7j2/lib/libopenblas.dylib
libwedge.so: /Applications/deal.II.app/Contents/Resources/spack/opt/spack/darwin-mojave-x86_64/clang-10.0.1-apple/hdf5-1.10.5-g5opz5px3dgy64jjeixmac2mpgsiisbn/lib/libhdf5hl_fortran.dylib
libwedge.so: /Applications/deal.II.app/Contents/Resources/spack/opt/spack/darwin-mojave-x86_64/clang-10.0.1-apple/hdf5-1.10.5-g5opz5px3dgy64jjeixmac2mpgsiisbn/lib/libhdf5_fortran.dylib
libwedge.so: /Applications/deal.II.app/Contents/Resources/spack/opt/spack/darwin-mojave-x86_64/clang-10.0.1-apple/hdf5-1.10.5-g5opz5px3dgy64jjeixmac2mpgsiisbn/lib/libhdf5_hl.dylib
libwedge.so: /Applications/deal.II.app/Contents/Resources/spack/opt/spack/darwin-mojave-x86_64/clang-10.0.1-apple/hdf5-1.10.5-g5opz5px3dgy64jjeixmac2mpgsiisbn/lib/libhdf5.dylib
libwedge.so: /Applications/deal.II.app/Contents/Resources/spack/opt/spack/darwin-mojave-x86_64/clang-10.0.1-apple/parmetis-4.0.3-crsuyixmqebjr4r3ax63l64cehgjxzcd/lib/libparmetis.dylib
libwedge.so: /Applications/deal.II.app/Contents/Resources/spack/opt/spack/darwin-mojave-x86_64/clang-10.0.1-apple/metis-5.1.0-3ey7d524jlwosi24e5ogezffennzegwu/lib/libmetis.dylib
libwedge.so: /Applications/deal.II.app/Contents/Resources/spack/opt/spack/darwin-mojave-x86_64/clang-10.0.1-apple/zlib-1.2.11-nqnlnxddpa4qfz5cnf4grnct57ds25ks/lib/libz.dylib
libwedge.so: /Applications/deal.II.app/Contents/Resources/spack/opt/spack/darwin-mojave-x86_64/clang-10.0.1-apple/openmpi-3.1.4-qz6zsrmc4l4tdlthlxppwr34bmdxlswa/lib/libmpi_usempif08.dylib
libwedge.so: /Applications/deal.II.app/Contents/Resources/spack/opt/spack/darwin-mojave-x86_64/clang-10.0.1-apple/openmpi-3.1.4-qz6zsrmc4l4tdlthlxppwr34bmdxlswa/lib/libmpi_usempi_ignore_tkr.a
libwedge.so: /Applications/deal.II.app/Contents/Resources/spack/opt/spack/darwin-mojave-x86_64/clang-10.0.1-apple/openmpi-3.1.4-qz6zsrmc4l4tdlthlxppwr34bmdxlswa/lib/libmpi_mpifh.dylib
libwedge.so: /usr/lib/libc++.dylib
libwedge.so: /Applications/deal.II.app/Contents/Resources/spack/opt/spack/darwin-mojave-x86_64/clang-10.0.1-apple/openmpi-3.1.4-qz6zsrmc4l4tdlthlxppwr34bmdxlswa/lib/libmpi_cxx.dylib
libwedge.so: /Applications/deal.II.app/Contents/Resources/spack/opt/spack/darwin-mojave-x86_64/clang-10.0.1-apple/openmpi-3.1.4-qz6zsrmc4l4tdlthlxppwr34bmdxlswa/lib/libmpi.dylib
libwedge.so: /Applications/deal.II.app/Contents/Resources/spack/opt/spack/darwin-mojave-x86_64/clang-10.0.1-apple/sundials-3.2.1-4qo36xoixaqhb6iks36y6nbdwo7evmpm/lib/libsundials_idas.dylib
libwedge.so: /Applications/deal.II.app/Contents/Resources/spack/opt/spack/darwin-mojave-x86_64/clang-10.0.1-apple/sundials-3.2.1-4qo36xoixaqhb6iks36y6nbdwo7evmpm/lib/libsundials_arkode.dylib
libwedge.so: /Applications/deal.II.app/Contents/Resources/spack/opt/spack/darwin-mojave-x86_64/clang-10.0.1-apple/sundials-3.2.1-4qo36xoixaqhb6iks36y6nbdwo7evmpm/lib/libsundials_kinsol.dylib
libwedge.so: /Applications/deal.II.app/Contents/Resources/spack/opt/spack/darwin-mojave-x86_64/clang-10.0.1-apple/sundials-3.2.1-4qo36xoixaqhb6iks36y6nbdwo7evmpm/lib/libsundials_nvecserial.dylib
libwedge.so: /Applications/deal.II.app/Contents/Resources/spack/opt/spack/darwin-mojave-x86_64/clang-10.0.1-apple/sundials-3.2.1-4qo36xoixaqhb6iks36y6nbdwo7evmpm/lib/libsundials_nvecparallel.dylib
libwedge.so: /Applications/deal.II.app/Contents/Resources/spack/opt/spack/darwin-mojave-x86_64/clang-10.0.1-apple/symengine-0.4.0-bx6qefqtb3vm4cayngw7gpjfgutvc5i3/lib/libsymengine.0.4.0.dylib
libwedge.so: /Applications/deal.II.app/Contents/Resources/spack/opt/spack/darwin-mojave-x86_64/clang-10.0.1-apple/gmp-6.1.2-tnmh5ox367hsh2ug3w6szwiuzybftvhf/lib/libgmp.dylib
libwedge.so: /Applications/deal.II.app/Contents/Resources/spack/opt/spack/darwin-mojave-x86_64/clang-10.0.1-apple/mpc-1.1.0-imway55esd65xav66sfa5yu53tjm42pv/lib/libmpc.dylib
libwedge.so: /Applications/deal.II.app/Contents/Resources/spack/opt/spack/darwin-mojave-x86_64/clang-10.0.1-apple/mpfr-4.0.1-4hroyalueqwgja2gbtekpx55ncbdtqej/lib/libmpfr.dylib
libwedge.so: CMakeFiles/wedge.dir/link.txt
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green --bold --progress-dir=/Users/melanie/aspect/benchmarks/corner_flow/CMakeFiles --progress-num=$(CMAKE_PROGRESS_2) "Linking CXX shared library libwedge.so"
	$(CMAKE_COMMAND) -E cmake_link_script CMakeFiles/wedge.dir/link.txt --verbose=$(VERBOSE)
	ln -sf /Users/melanie/aspect/build/aspect .

# Rule to build all files generated by this target.
CMakeFiles/wedge.dir/build: libwedge.so

.PHONY : CMakeFiles/wedge.dir/build

CMakeFiles/wedge.dir/clean:
	$(CMAKE_COMMAND) -P CMakeFiles/wedge.dir/cmake_clean.cmake
.PHONY : CMakeFiles/wedge.dir/clean

CMakeFiles/wedge.dir/depend:
	cd /Users/melanie/aspect/benchmarks/corner_flow && $(CMAKE_COMMAND) -E cmake_depends "Unix Makefiles" /Users/melanie/aspect/benchmarks/corner_flow /Users/melanie/aspect/benchmarks/corner_flow /Users/melanie/aspect/benchmarks/corner_flow /Users/melanie/aspect/benchmarks/corner_flow /Users/melanie/aspect/benchmarks/corner_flow/CMakeFiles/wedge.dir/DependInfo.cmake --color=$(COLOR)
.PHONY : CMakeFiles/wedge.dir/depend
