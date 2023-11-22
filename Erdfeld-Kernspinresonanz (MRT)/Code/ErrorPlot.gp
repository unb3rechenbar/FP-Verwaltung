set datafile separator ","

set term svg size 1000,600
set output outputname

set bars small
set style fill solid

plot filename every ::1 using 1:2:3 with yerrorbars title legname