# CMAKE generated file: DO NOT EDIT!
# Generated by "Unix Makefiles" Generator, CMake Version 3.19

# Delete rule output on recipe failure.
.DELETE_ON_ERROR:


#=============================================================================
# Special targets provided by cmake.

# Disable implicit rules so canonical targets will work.
.SUFFIXES:


# Disable VCS-based implicit rules.
% : %,v


# Disable VCS-based implicit rules.
% : RCS/%


# Disable VCS-based implicit rules.
% : RCS/%,v


# Disable VCS-based implicit rules.
% : SCCS/s.%


# Disable VCS-based implicit rules.
% : s.%


.SUFFIXES: .hpux_make_needs_suffix_list


# Command-line flag to silence nested $(MAKE).
$(VERBOSE)MAKESILENT = -s

#Suppress display of executed commands.
$(VERBOSE).SILENT:

# A target that is always out of date.
cmake_force:

.PHONY : cmake_force

#=============================================================================
# Set environment variables for the build.

# The shell in which to execute make rules.
SHELL = /bin/sh

# The CMake executable.
CMAKE_COMMAND = /usr/local/Cellar/cmake/3.19.1/bin/cmake

# The command to remove a file.
RM = /usr/local/Cellar/cmake/3.19.1/bin/cmake -E rm -f

# Escaping for special characters.
EQUALS = =

# The top-level source directory on which CMake was run.
CMAKE_SOURCE_DIR = /Users/meiliangjun1_vendor/Desktop/Demos/Study/OpenGL/glfw/coordinate_systems

# The top-level build directory on which CMake was run.
CMAKE_BINARY_DIR = /Users/meiliangjun1_vendor/Desktop/Demos/Study/OpenGL/glfw/coordinate_systems/build

# Include any dependencies generated for this target.
include CMakeFiles/texture.dir/depend.make

# Include the progress variables for this target.
include CMakeFiles/texture.dir/progress.make

# Include the compile flags for this target's objects.
include CMakeFiles/texture.dir/flags.make

CMakeFiles/texture.dir/Shader.cpp.o: CMakeFiles/texture.dir/flags.make
CMakeFiles/texture.dir/Shader.cpp.o: ../Shader.cpp
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green --progress-dir=/Users/meiliangjun1_vendor/Desktop/Demos/Study/OpenGL/glfw/coordinate_systems/build/CMakeFiles --progress-num=$(CMAKE_PROGRESS_1) "Building CXX object CMakeFiles/texture.dir/Shader.cpp.o"
	/Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/c++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -o CMakeFiles/texture.dir/Shader.cpp.o -c /Users/meiliangjun1_vendor/Desktop/Demos/Study/OpenGL/glfw/coordinate_systems/Shader.cpp

CMakeFiles/texture.dir/Shader.cpp.i: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Preprocessing CXX source to CMakeFiles/texture.dir/Shader.cpp.i"
	/Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/c++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -E /Users/meiliangjun1_vendor/Desktop/Demos/Study/OpenGL/glfw/coordinate_systems/Shader.cpp > CMakeFiles/texture.dir/Shader.cpp.i

CMakeFiles/texture.dir/Shader.cpp.s: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Compiling CXX source to assembly CMakeFiles/texture.dir/Shader.cpp.s"
	/Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/c++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -S /Users/meiliangjun1_vendor/Desktop/Demos/Study/OpenGL/glfw/coordinate_systems/Shader.cpp -o CMakeFiles/texture.dir/Shader.cpp.s

CMakeFiles/texture.dir/main.cpp.o: CMakeFiles/texture.dir/flags.make
CMakeFiles/texture.dir/main.cpp.o: ../main.cpp
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green --progress-dir=/Users/meiliangjun1_vendor/Desktop/Demos/Study/OpenGL/glfw/coordinate_systems/build/CMakeFiles --progress-num=$(CMAKE_PROGRESS_2) "Building CXX object CMakeFiles/texture.dir/main.cpp.o"
	/Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/c++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -o CMakeFiles/texture.dir/main.cpp.o -c /Users/meiliangjun1_vendor/Desktop/Demos/Study/OpenGL/glfw/coordinate_systems/main.cpp

CMakeFiles/texture.dir/main.cpp.i: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Preprocessing CXX source to CMakeFiles/texture.dir/main.cpp.i"
	/Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/c++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -E /Users/meiliangjun1_vendor/Desktop/Demos/Study/OpenGL/glfw/coordinate_systems/main.cpp > CMakeFiles/texture.dir/main.cpp.i

CMakeFiles/texture.dir/main.cpp.s: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Compiling CXX source to assembly CMakeFiles/texture.dir/main.cpp.s"
	/Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/c++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -S /Users/meiliangjun1_vendor/Desktop/Demos/Study/OpenGL/glfw/coordinate_systems/main.cpp -o CMakeFiles/texture.dir/main.cpp.s

# Object files for target texture
texture_OBJECTS = \
"CMakeFiles/texture.dir/Shader.cpp.o" \
"CMakeFiles/texture.dir/main.cpp.o"

# External object files for target texture
texture_EXTERNAL_OBJECTS =

texture: CMakeFiles/texture.dir/Shader.cpp.o
texture: CMakeFiles/texture.dir/main.cpp.o
texture: CMakeFiles/texture.dir/build.make
texture: CMakeFiles/texture.dir/link.txt
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green --bold --progress-dir=/Users/meiliangjun1_vendor/Desktop/Demos/Study/OpenGL/glfw/coordinate_systems/build/CMakeFiles --progress-num=$(CMAKE_PROGRESS_3) "Linking CXX executable texture"
	$(CMAKE_COMMAND) -E cmake_link_script CMakeFiles/texture.dir/link.txt --verbose=$(VERBOSE)

# Rule to build all files generated by this target.
CMakeFiles/texture.dir/build: texture

.PHONY : CMakeFiles/texture.dir/build

CMakeFiles/texture.dir/clean:
	$(CMAKE_COMMAND) -P CMakeFiles/texture.dir/cmake_clean.cmake
.PHONY : CMakeFiles/texture.dir/clean

CMakeFiles/texture.dir/depend:
	cd /Users/meiliangjun1_vendor/Desktop/Demos/Study/OpenGL/glfw/coordinate_systems/build && $(CMAKE_COMMAND) -E cmake_depends "Unix Makefiles" /Users/meiliangjun1_vendor/Desktop/Demos/Study/OpenGL/glfw/coordinate_systems /Users/meiliangjun1_vendor/Desktop/Demos/Study/OpenGL/glfw/coordinate_systems /Users/meiliangjun1_vendor/Desktop/Demos/Study/OpenGL/glfw/coordinate_systems/build /Users/meiliangjun1_vendor/Desktop/Demos/Study/OpenGL/glfw/coordinate_systems/build /Users/meiliangjun1_vendor/Desktop/Demos/Study/OpenGL/glfw/coordinate_systems/build/CMakeFiles/texture.dir/DependInfo.cmake --color=$(COLOR)
.PHONY : CMakeFiles/texture.dir/depend
