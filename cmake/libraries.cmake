# this reads libraries.json in memory, as a single source of truth
if(CMAKE_VERSION VERSION_LESS 3.19)
  # FIXME: we should eventually require CMake 3.19 for this and other stability enhancements.

  message(STATUS "Due to CMake < 3.19, using fallback Gemini library versions in ${CMAKE_CURRENT_LIST_FILE}")

  set(glow_git https://github.com/gemini3d/glow.git)
  set(glow_tag v0.981.0.1)

  set(lapack_zip https://github.com/scivision/lapack/archive/v3.9.0.2.zip)
  set(lapack_git https://github.com/scivision/lapack.git)
  set(lapack_tag v3.9.0.2)

  set(h5fortran_zip https://github.com/geospace-code/h5fortran/archive/v3.4.5.zip)
  set(h5fortran_git https://github.com/geospace-code/h5fortran.git)
  set(h5fortran_tag v3.4.5)

  set(hwm14_git https://github.com/space-physics/hwm14.git)
  set(hwm14_tag cade327)

  set(msis2_zip https://map.nrl.navy.mil/map/pub/nrl/NRLMSIS/NRLMSIS2.0/NRLMSIS2.0.zip)
  set(msis2_sha1 fa817dfee637ec2298a6ec882345d13d0b087a85)

  set(mumps_zip https://github.com/scivision/mumps/archive/v5.3.5.2.zip)
  set(mumps_git https://github.com/scivision/mumps.git)
  set(mumps_tag v5.3.5.2)

  set(nc4fortran_git https://github.com/geospace-code/nc4fortran.git)
  set(nc4fortran_tag v1.1.2)

  set(scalapack_git https://github.com/scivision/scalapack.git)
  set(scalapack_tag v2.1.0.11)

  set(pygemini_git https://github.com/gemini3d/pygemini.git)
  set(pygemini_tag main)

  return()
endif()

# preferred method CMake >= 3.19
file(READ ${CMAKE_CURRENT_LIST_DIR}/libraries.json _libj)

string(JSON glow_git GET ${_libj} glow git)
string(JSON glow_tag GET ${_libj} glow tag)

string(JSON lapack_zip GET ${_libj} lapack zip)
string(JSON lapack_git GET ${_libj} lapack git)
string(JSON lapack_tag GET ${_libj} lapack tag)

string(JSON h5fortran_git GET ${_libj} h5fortran git)
string(JSON h5fortran_zip GET ${_libj} h5fortran zip)
string(JSON h5fortran_tag GET ${_libj} h5fortran tag)

string(JSON hwm14_git GET ${_libj} hwm14 git)
string(JSON hwm14_tag GET ${_libj} hwm14 tag)

string(JSON msis2_zip GET ${_libj} msis2 zip)
string(JSON msis2_sha1 GET ${_libj} msis2 sha1)

string(JSON mumps_zip GET ${_libj} mumps zip)
string(JSON mumps_git GET ${_libj} mumps git)
string(JSON mumps_tag GET ${_libj} mumps tag)

string(JSON nc4fortran_git GET ${_libj} nc4fortran git)
string(JSON nc4fortran_tag GET ${_libj} nc4fortran tag)

string(JSON scalapack_git GET ${_libj} scalapack git)
string(JSON scalapack_tag GET ${_libj} scalapack tag)

string(JSON pygemini_git GET ${_libj} pygemini git)
string(JSON pygemini_tag GET ${_libj} pygemini tag)
