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

# Utility rule file for info.

# Include the progress variables for this target.
include CMakeFiles/info.dir/progress.make

CMakeFiles/info:
	/Applications/deal.II.app/Contents/Resources/spack/opt/spack/darwin-mojave-x86_64/clang-10.0.1-apple/cmake-3.14.4-iz6anjhk565p4sahfpmcftym4wifjzya/bin/cmake -P /Users/melanie/aspect/benchmarks/corner_flow/CMakeFiles/print_usage.cmake

info: CMakeFiles/info
info: CMakeFiles/info.dir/build.make

.PHONY : info

# Rule to build all files generated by this target.
CMakeFiles/info.dir/build: info

.PHONY : CMakeFiles/info.dir/build

CMakeFiles/info.dir/clean:
	$(CMAKE_COMMAND) -P CMakeFiles/info.dir/cmake_clean.cmake
.PHONY : CMakeFiles/info.dir/clean

CMakeFiles/info.dir/depend:
	cd /Users/melanie/aspect/benchmarks/corner_flow && $(CMAKE_COMMAND) -E cmake_depends "Unix Makefiles" /Users/melanie/aspect/benchmarks/corner_flow /Users/melanie/aspect/benchmarks/corner_flow /Users/melanie/aspect/benchmarks/corner_flow /Users/melanie/aspect/benchmarks/corner_flow /Users/melanie/aspect/benchmarks/corner_flow/CMakeFiles/info.dir/DependInfo.cmake --color=$(COLOR)
.PHONY : CMakeFiles/info.dir/depend
