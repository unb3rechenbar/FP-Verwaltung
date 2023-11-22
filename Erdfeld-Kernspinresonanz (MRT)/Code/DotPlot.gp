set datafile separator ","

set term svg size 1000,600
set output outputname
set tics font "Helvetica,25"
set key font "Helvetica,25"
set xlabel font "Helvetica,25"
set ylabel font "Helvetica,25"
set title font "Helvetica,25"

plot filename every ::1 using 1:2 title legname