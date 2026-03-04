cmake_minimum_required(VERSION 3.14)
project(termin_inspect C CXX)

set(CMAKE_C_STANDARD 11)
set(CMAKE_C_STANDARD_REQUIRED ON)
set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

option(TI_BUILD_SHARED "Build shared library" ON)
option(TI_BUILD_TESTS "Build tests" ON)
option(TI_BUILD_CPP "Build C++ inspect/kind core runtime" ON)
option(TI_BUILD_PYTHON "Build Python/nanobind inspect bridge" ON)

set(TI_SOURCES
    src/tc_inspect.c
    src/tc_kind.c
)

set(TI_CPP_SOURCES)
if(TI_BUILD_CPP)
    list(APPEND TI_CPP_SOURCES
        src/tc_inspect_core_instance.cpp
        src/tc_kind_cpp.cpp
    )
endif()

set(TI_PY_SOURCES)
if(TI_BUILD_PYTHON)
    list(APPEND TI_PY_SOURCES
        src/tc_kind_python_instance.cpp
        src/tc_inspect_python.cpp
    )
endif()

set(TI_HEADERS
    include/tc_types.h
    include/tc_value.h
    include/tc_inspect_cpp.hpp
    include/inspect/tc_inspect.h
    include/inspect/tc_kind.h
    include/inspect/tc_kind_cpp.hpp
    include/inspect/tc_kind_python.hpp
    include/inspect/tc_inspect_python.hpp
)

find_package(termin_base REQUIRED)

if(TI_BUILD_PYTHON)
    if(WIN32)
        execute_process(
            COMMAND python -m nanobind --include_dir
            OUTPUT_VARIABLE nanobind_INCLUDE_DIR
            OUTPUT_STRIP_TRAILING_WHITESPACE
        )
    else()
        execute_process(
            COMMAND python3 -m nanobind --include_dir
            OUTPUT_VARIABLE nanobind_INCLUDE_DIR
            OUTPUT_STRIP_TRAILING_WHITESPACE
        )
    endif()
    find_package(Python COMPONENTS Interpreter Development REQUIRED)
    if(WIN32)
        execute_process(
            COMMAND python -m nanobind --cmake_dir
            OUTPUT_VARIABLE nanobind_DIR
            OUTPUT_STRIP_TRAILING_WHITESPACE
        )
    else()
        execute_process(
            COMMAND python3 -m nanobind --cmake_dir
            OUTPUT_VARIABLE nanobind_DIR
            OUTPUT_STRIP_TRAILING_WHITESPACE
        )
    endif()
    find_package(nanobind CONFIG REQUIRED)
    nanobind_build_library(nanobind-static)
endif()

if(TI_BUILD_SHARED)
    add_library(termin_inspect SHARED ${TI_SOURCES} ${TI_CPP_SOURCES} ${TI_PY_SOURCES} ${TI_HEADERS})
    target_compile_definitions(termin_inspect PRIVATE TC_EXPORTS TERMIN_INSPECT_CPP_EXPORTS)
else()
    add_library(termin_inspect STATIC ${TI_SOURCES} ${TI_CPP_SOURCES} ${TI_PY_SOURCES} ${TI_HEADERS})
    target_compile_definitions(termin_inspect PRIVATE TERMIN_INSPECT_CPP_EXPORTS)
endif()

add_library(termin_inspect::termin_inspect ALIAS termin_inspect)

set_target_properties(termin_inspect PROPERTIES
    POSITION_INDEPENDENT_CODE ON
    LIBRARY_OUTPUT_DIRECTORY "${CMAKE_BINARY_DIR}/bin"
    RUNTIME_OUTPUT_DIRECTORY "${CMAKE_BINARY_DIR}/bin"
    ARCHIVE_OUTPUT_DIRECTORY "${CMAKE_BINARY_DIR}/bin"
    EXPORT_NAME termin_inspect
)

target_include_directories(termin_inspect
    PUBLIC
        $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/include>
        $<INSTALL_INTERFACE:include>
)
if(TI_BUILD_PYTHON)
    target_include_directories(termin_inspect PRIVATE ${nanobind_INCLUDE_DIR})
endif()

target_link_libraries(termin_inspect PUBLIC tcbase::termin_base)
if(TI_BUILD_PYTHON)
    target_link_libraries(termin_inspect PRIVATE nanobind-static Python::Python)
endif()

if(WIN32)
    target_compile_definitions(termin_inspect PRIVATE _CRT_SECURE_NO_WARNINGS)
endif()

if(MSVC)
    target_compile_options(termin_inspect PRIVATE /W3)
else()
    target_compile_options(termin_inspect PRIVATE -Wall -Wextra -Wno-stringop-truncation)
endif()

if(TI_BUILD_TESTS)
    enable_testing()
    add_executable(termin_inspect_c_test tests/test_main.c)
    target_link_libraries(termin_inspect_c_test PRIVATE termin_inspect)
    add_test(NAME termin_inspect_c_test COMMAND termin_inspect_c_test)
    set_target_properties(termin_inspect_c_test PROPERTIES
        RUNTIME_OUTPUT_DIRECTORY "${CMAKE_BINARY_DIR}/bin"
    )

    add_executable(termin_inspect_cpp_test tests/test_cpp_inspect.cpp)
    target_link_libraries(termin_inspect_cpp_test PRIVATE termin_inspect)
    add_test(NAME termin_inspect_cpp_test COMMAND termin_inspect_cpp_test)
    set_target_properties(termin_inspect_cpp_test PROPERTIES
        RUNTIME_OUTPUT_DIRECTORY "${CMAKE_BINARY_DIR}/bin"
    )

    if(TI_BUILD_PYTHON)
        add_executable(termin_inspect_python_test tests/test_python_inspect.cpp)
        target_link_libraries(termin_inspect_python_test PRIVATE termin_inspect Python::Python nanobind-static)
        target_include_directories(termin_inspect_python_test PRIVATE ${nanobind_INCLUDE_DIR})
        add_test(NAME termin_inspect_python_test COMMAND termin_inspect_python_test)
        set_target_properties(termin_inspect_python_test PROPERTIES
            RUNTIME_OUTPUT_DIRECTORY "${CMAKE_BINARY_DIR}/bin"
        )
    endif()
endif()

include(CMakePackageConfigHelpers)

write_basic_package_version_file(
    "${CMAKE_CURRENT_BINARY_DIR}/termin_inspectConfigVersion.cmake"
    VERSION 0.1.0
    COMPATIBILITY SameMajorVersion
)

configure_package_config_file(
    "${CMAKE_CURRENT_SOURCE_DIR}/cmake/termin_inspectConfig.cmake.in"
    "${CMAKE_CURRENT_BINARY_DIR}/termin_inspectConfig.cmake"
    INSTALL_DESTINATION lib/cmake/termin_inspect
)

install(TARGETS termin_inspect
    EXPORT termin_inspectTargets
    LIBRARY DESTINATION lib
    ARCHIVE DESTINATION lib
    RUNTIME DESTINATION bin
)

install(DIRECTORY include/ DESTINATION include)

install(EXPORT termin_inspectTargets
    FILE termin_inspectTargets.cmake
    NAMESPACE termin_inspect::
    DESTINATION lib/cmake/termin_inspect
)

install(FILES
    "${CMAKE_CURRENT_BINARY_DIR}/termin_inspectConfig.cmake"
    "${CMAKE_CURRENT_BINARY_DIR}/termin_inspectConfigVersion.cmake"
    DESTINATION lib/cmake/termin_inspect
)
