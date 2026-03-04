#----------------------------------------------------------------
# Generated CMake target import file.
#----------------------------------------------------------------

# Commands may need to know the format version.
set(CMAKE_IMPORT_FILE_VERSION 1)

# Import target "termin_inspect::termin_inspect" for configuration ""
set_property(TARGET termin_inspect::termin_inspect APPEND PROPERTY IMPORTED_CONFIGURATIONS NOCONFIG)
set_target_properties(termin_inspect::termin_inspect PROPERTIES
  IMPORTED_LOCATION_NOCONFIG "${_IMPORT_PREFIX}/lib/libtermin_inspect.so"
  IMPORTED_SONAME_NOCONFIG "libtermin_inspect.so"
  )

list(APPEND _cmake_import_check_targets termin_inspect::termin_inspect )
list(APPEND _cmake_import_check_files_for_termin_inspect::termin_inspect "${_IMPORT_PREFIX}/lib/libtermin_inspect.so" )

# Commands beyond this point should not need to know the version.
set(CMAKE_IMPORT_FILE_VERSION)
