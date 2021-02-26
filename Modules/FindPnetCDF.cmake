# - Try to find PNETCDF
# source: https://ftp.space.dtu.dk/pub/Ioana/pism0.6.1-10/CMake/FindPNetCDF.cmake
# license: GPL v3 (https://ftp.space.dtu.dk/pub/Ioana/pism0.6.1-10/COPYING)
#
# - Find PNetCDF
# Find the native PNetCDF includes and library
#
#  PNETCDF_INCLUDE_DIRS - where to find pnetcdf.mod, etc
#  PNETCDF_LIBRARY_DIRS - Link these libraries when using PnetCDF 
#  PNETCDF_FOUND        - True if PNetCDF was found
#
# Normal usage would be:
#  find_package (PNetCDF REQUIRED)
#  target_link_libraries (uses_pnetcdf ${PNETCDF_LIBRARY_DIRS})

find_path (PNETCDF_INCLUDE_DIRS pnetcdf.mod
  HINTS "${PNETCDF_ROOT}/include" "$ENV{PNETCDF_ROOT}/include")

string(REGEX REPLACE "/include/?$" ""
  PNETCDF_LIB_HINT ${PNETCDF_INCLUDE_DIRS})

find_library (PNETCDF_LIBRARY_DIRS
  NAMES pnetcdf
  HINTS ${PNETCDF_LIB_HINT} PATH_SUFFIXES lib lib64)

if ((NOT PNETCDF_LIBRARY_DIRS) OR (NOT PNETCDF_INCLUDE_DIRS))
  message(STATUS "Trying to find PNetCDF using LD_LIBRARY_PATH (we're desperate)...")

  file(TO_CMAKE_PATH "$ENV{LD_LIBRARY_PATH}" LD_LIBRARY_PATH)

  find_library(PNETCDF_LIBRARY_DIRS
    NAMES pnetcdf
    HINTS ${LD_LIBRARY_PATH})

  if (PNETCDF_LIBRARY_DIRS)
    get_filename_component(PNETCDF_LIB_DIR ${PNETCDF_LIBRARY_DIRS} PATH)
    string(REGEX REPLACE "/(lib|lib64)/?$" "/include"
      PNETCDF_H_HINT ${PNETCDF_LIBRARY_DIRS})

    find_path (PNETCDF_INCLUDES pnetcdf.mod
      HINTS ${PNETCDF_H_HINT}
      DOC "Path to pnetcdf.mod")
  endif()
endif()

# handle the QUIETLY and REQUIRED arguments and set PNETCDF_FOUND to TRUE if
# all listed variables are TRUE
include (FindPackageHandleStandardArgs)
find_package_handle_standard_args (PNetCDF DEFAULT_MSG PNETCDF_LIBRARY_DIRS PNETCDF_INCLUDE_DIRS)

mark_as_advanced (PNetCDF DEFAULT_MSG PNETCDF_LIBRARY_DIRS PNETCDF_INCLUDE_DIRS)

if(PNetCDF_FOUND)
  if(NOT TARGET PNetCDF::PNetCDF)
    add_library(PNetCDF::PNetCDF UNKNOWN IMPORTED)
    set_target_properties(PNetCDF::PNetCDF PROPERTIES
      IMPORTED_LOCATION "${PNETCDF_LIBRARY_DIRS}"
      INTERFACE_INCLUDE_DIRECTORIES "${PNETCDF_INCLUDE_DIRS}")
  endif()
endif()
