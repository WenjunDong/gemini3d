module nc4fortran
!! this is a dummy interface that errors intentionally

implicit none (type, external)

type netcdf_file
contains
procedure, public :: initialize, read, write, exist, finalize
end type netcdf_file

contains

subroutine initialize(self,filename,ierr, status,action,comp_lvl)
class(netcdf_file), intent(inout)  :: self
character(*), intent(in)           :: filename
integer, intent(out), optional     :: ierr
character(*), intent(in), optional :: status
character(*), intent(in), optional :: action
integer, intent(in), optional      :: comp_lvl
error stop 'NetCDF4 / nc4fortran not available'
end subroutine initialize


subroutine read(self, dname, value, ierr)
class(netcdf_file), intent(in)     :: self
character(*), intent(in)         :: dname
class(*), intent(inout)      :: value(..)
integer, intent(out), optional :: ierr
error stop 'NetCDF4 / nc4fortran not available'
end subroutine read

subroutine write(self, dname, value, dims, ierr)
class(netcdf_file), intent(in)     :: self
character(*), intent(in)         :: dname
class(*), intent(in)      :: value(..)
character(*), intent(in), optional :: dims(:)
integer, intent(out), optional :: ierr
error stop 'NetCDF4 / nc4fortran not available'
end subroutine

logical function exist(self, dname)
class(netcdf_file), intent(in)     :: self
character(*), intent(in)         :: dname
exist = .false.
error stop 'nc4fortran not available'
end function exist

subroutine finalize(self, ierr)
class(netcdf_file), intent(in) :: self
integer, intent(out), optional :: ierr
error stop 'NetCDF4 / nc4fortran not available'
end subroutine finalize

end module nc4fortran