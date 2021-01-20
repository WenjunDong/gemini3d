# this enables CMake imported target HWM14::HWM14
include(FetchContent)

FetchContent_Declare(hwm14proj
GIT_REPOSITORY ${hwm14_git}
GIT_TAG ${hwm14_tag}
GIT_SHALLOW true
)

FetchContent_MakeAvailable(hwm14proj)

add_library(HWM14::HWM14 INTERFACE IMPORTED)
set_target_properties(HWM14::HWM14 PROPERTIES
  INTERFACE_LINK_LIBRARIES hwm14)

# HWM14 (and executables using it) need these files in same directory as executable e.g. gemini.bin
file(COPY ${hwm14proj_SOURCE_DIR}/src/hwm14/hwm123114.bin DESTINATION ${PROJECT_BINARY_DIR})
file(COPY ${hwm14proj_SOURCE_DIR}/src/hwm14/dwm07b104i.dat DESTINATION ${PROJECT_BINARY_DIR})
file(COPY ${hwm14proj_SOURCE_DIR}/src/hwm14/gd2qd.dat DESTINATION ${PROJECT_BINARY_DIR})

if(BUILD_TESTING)
  add_executable(test_hwm14 vendor/hwm14/test_hwm14.f90)
  target_link_libraries(test_hwm14 PRIVATE HWM14::HWM14)

  add_test(NAME gemini:hwm14
    COMMAND $<TARGET_FILE:test_hwm14>
    WORKING_DIRECTORY ${PROJECT_BINARY_DIR})
endif(BUILD_TESTING)
