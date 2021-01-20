program check

use, intrinsic :: iso_fortran_env, only : real32
implicit none (type, external)

external :: hwm14, dwm07

integer :: day, iyd
real(real32) :: ut, sec, alt, glat, glon, stl, f107a, f107
real(real32), dimension(2) :: ap, apqt, qw, dw, wTotal

day = 150
iyd = 95000 + day
ut = 12
sec = ut * 3600
alt = 100
glat = -45
glon = -85
stl = ut + glon/15
ap(2) = 80.0

call hwm14(iyd,sec,alt,glat,glon,stl,f107a,f107,apqt,qw)
call dwm07(iyd,sec,alt,glat,glon,ap,dw)
call hwm14(iyd,sec,alt,glat,glon,stl,f107a,f107,ap, wTotal)

print '(3(f12.3,f10.3))', qw, dw, wTotal

if (any(abs(qw - [-14.340, 31.622]) > 0.01)) error stop 'quiet winds tolerance'
if (any(abs(dw - [0.086, -0.037]) > 0.01)) error stop 'disturbed winds tolerance'
if (any(abs(wTotal - [-14.253, 31.59]) > 0.01)) error stop 'Total wind tolerance'

end program
