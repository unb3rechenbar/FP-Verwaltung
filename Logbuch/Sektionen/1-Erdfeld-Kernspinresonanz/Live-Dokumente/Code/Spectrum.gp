set datafile separator ","

set term png size 1024,500
set output "Spectrum.png"

plot filename using 1:2 w lines