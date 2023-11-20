set datafile separator ","

set term png size 1024,1024
set output "Spectrum.png"

plot filename u 2e3
