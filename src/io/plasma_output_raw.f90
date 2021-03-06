submodule (io:plasma_output) plasma_output_raw

use timeutils, only : date_filename

implicit none (type, external)

contains

module procedure output_root_stream_mpi_raw

!! COLLECT OUTPUT FROM WORKERS AND WRITE TO A FILE USING STREAM I/O.
!! STATE VARS ARE EXPECTED INCLUDE GHOST CELLS

integer :: lx1,lx2all,lx3all,isp
character(:), allocatable :: filenamefull
integer(8) :: recordlength   !can be 8 byte with compiler flag -frecord-marker=8

real(wp), dimension(:,:,:), allocatable :: permarray,tmparray    !permuted variables to be allocated for 2D output


!! SYSTEM SIZES
lx1=size(Phiall,1)
lx2all=size(Phiall,2)
lx3all=size(Phiall,3)


!FIGURE OUT THE FILENAME
filenamefull=date_filename(outdir,ymd,UTsec) // '.dat'
print *, 'Output file name:  ',filenamefull
! call logger(filenamefull,'filename.log')
! call logger(UTsec, 'UTsec.log')


!SOME DEBUG OUTPUT ON FILE SIZE
recordlength=int(8,8)+int(8,8)*int(3,8)*int(lx1,8)*int(lx2all,8)*int(lx3all,8)*int(lsp,8)+ &
             int(8,8)*int(5,8)*int(lx1,8)*int(lx2all,8)*int(lx3all,8)+ &
             int(8,8)*int(lx2,8)*int(lx3all,8)
print *, 'Output bit length:  ',recordlength,lx1,lx2all,lx3all,lsp

!WRITE THE DATA
block
integer :: u
open(newunit=u,file=filenamefull,status='replace',form='unformatted',access='stream',action='write')    !has no problem with > 2GB output files
write(u) real(ymd,wp),UTsec/3600._wp    !no matter what we must output date and time

if (flagswap/=1) then
  select case (flagoutput)
    case (2)    !output ISR-like average parameters
      write(u) &
        neall(1:lx1,1:lx2all,1:lx3all), &
        v1avgall(1:lx1,1:lx2all,1:lx3all), &    !output of ISR-like parameters (ne,Ti,Te,v1,etc.)
        Tavgall(1:lx1,1:lx2all,1:lx3all),&
        Teall(1:lx1,1:lx2all,1:lx3all),&
        J1all(1:lx1,1:lx2all,1:lx3all), &
        J2all(1:lx1,1:lx2all,1:lx3all), &
        J3all(1:lx1,1:lx2all,1:lx3all),&
        v2avgall(1:lx1,1:lx2all,1:lx3all),&
        v3avgall(1:lx1,1:lx2all,1:lx3all)
    case (3)     !just electron density
      print *, '!!!NOTE:  Input file has selected electron density only output, make sure this is what you really want!'
      write(u) neall(1:lx1,1:lx2all,1:lx3all)
    case default    !output everything
      print *, '!!!NOTE:  Input file has selected full output, large files may result!'
      write(u) &
        nsall(1:lx1,1:lx2all,1:lx3all,:),&
        vs1all(1:lx1,1:lx2all,1:lx3all,:), &    !this is full output of all parameters in 3D
        Tsall(1:lx1,1:lx2all,1:lx3all,:),&
        J1all(1:lx1,1:lx2all,1:lx3all),&
        J2all(1:lx1,1:lx2all,1:lx3all), &
        J3all(1:lx1,1:lx2all,1:lx3all),&
        v2avgall(1:lx1,1:lx2all,1:lx3all),&
        v3avgall(1:lx1,1:lx2all,1:lx3all)
    end select
else
!! 2D simulation for which arrays were permuted
  print *, '!!!NOTE:  Permuting arrays prior to output...'
  select case (flagoutput)
    case (2)    !averaged parameters
      allocate(permarray(lx1,lx3all,lx2all))    !temporary work array that has been permuted
      permarray=reshape(neall,[lx1,lx3all,lx2all],order=[1,3,2])
      write(u) permarray
      permarray=reshape(v1avgall,[lx1,lx3all,lx2all],order=[1,3,2])
      write(u) permarray
      permarray=reshape(Tavgall,[lx1,lx3all,lx2all],order=[1,3,2])
      write(u) permarray
      permarray=reshape(Teall,[lx1,lx3all,lx2all],order=[1,3,2])
      write(u) permarray
      permarray=reshape(J1all,[lx1,lx3all,lx2all],order=[1,3,2])
      write(u) permarray
      permarray=reshape(J3all,[lx1,lx3all,lx2all],order=[1,3,2])    !Note that components need to be swapped too
      write(u) permarray
      permarray=reshape(J2all,[lx1,lx3all,lx2all],order=[1,3,2])
      write(u) permarray
      permarray=reshape(v3avgall,[lx1,lx3all,lx2all],order=[1,3,2])    !Note swapping of components
      write(u) permarray
      permarray=reshape(v2avgall,[lx1,lx3all,lx2all],order=[1,3,2])
      write(u) permarray
      deallocate(permarray)
    case (3)     !electron density only output
      print *, '!!!NOTE:  Input file has selected electron density only output, make sure this is what you really want!'
      allocate(permarray(lx1,lx3all,lx2all))    !temporary work array that has been permuted
      permarray=reshape(neall,[lx1,lx3all,lx2all],order=[1,3,2])
      write(u) permarray
      deallocate(permarray)
    case default
      print *, '!!!NOTE:  Input file has selected full output, large files may result!'
      allocate(permarray(lx1,lx3all,lx2all))    !temporary work array that has been permuted
      allocate(tmparray(lx1,lx2all,lx3all))
      do isp=1,lsp
        tmparray=nsall(1:lx1,1:lx2all,1:lx3all,isp)
        permarray=reshape(tmparray,[lx1,lx3all,lx2all],order=[1,3,2])
        write(u) permarray
      end do
      do isp=1,lsp
        tmparray=vs1all(1:lx1,1:lx2all,1:lx3all,isp)
        permarray=reshape(tmparray,[lx1,lx3all,lx2all],order=[1,3,2])
        write(u) permarray
      end do
      do isp=1,lsp
        tmparray=Tsall(1:lx1,1:lx2all,1:lx3all,isp)
        permarray=reshape(tmparray,[lx1,lx3all,lx2all],order=[1,3,2])
        write(u) permarray
      end do
      permarray=reshape(J1all,[lx1,lx3all,lx2all],order=[1,3,2])
      write(u) permarray
      permarray=reshape(J3all,[lx1,lx3all,lx2all],order=[1,3,2])    !Note that components need to be swapped too
      write(u) permarray
      permarray=reshape(J2all,[lx1,lx3all,lx2all],order=[1,3,2])
      write(u) permarray
      permarray=reshape(v3avgall,[lx1,lx3all,lx2all],order=[1,3,2])    !Note swapping of components
      write(u) permarray
      permarray=reshape(v2avgall,[lx1,lx3all,lx2all],order=[1,3,2])
      write(u) permarray
      deallocate(permarray)
      deallocate(tmparray)
  end select
end if
if (gridflag==1) then
  print *, 'Writing topside boundary conditions for inverted-type grid...'
  write(u)  Phiall(1,:,:)
else
  print *, 'Writing topside boundary conditions for non-inverted-type grid...'
  write(u)  Phiall(lx1,:,:)
end if

close(u)
end block

end procedure output_root_stream_mpi_raw


end submodule plasma_output_raw
