set datafile separator ","

set term svg size 1100,600
set output outputname
set tics font "Helvetica,25"
set key font "Helvetica,25"
set xlabel font "Helvetica,25" offset 0,-1
set ylabel font "Helvetica,25" offset -5,0
set title font "Helvetica,25"

set lmargin 20
set rmargin 10
set bmargin 5
set tmargin 5

a = 1
b = -2000
c = 50
d = 0

f(x) = a * exp(-((x + b)/c)**2/2) + d

fit f(x) filename using 1:2 via a, b, c, d

plot filename using 1:2 ps 2 title legname, \
     f(x) with lines lc rgb "red" lw 3 title "gaussian fit"