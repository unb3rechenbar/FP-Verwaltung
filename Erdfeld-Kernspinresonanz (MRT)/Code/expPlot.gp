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

a = 1
b = 1
c = 1

f(x) = a * exp(b * x) + c

fit f(x) filename using 1:2 via a, b, c

plot filename using 1:2 title legname, \
     f(x) with lines lc rgb "red" lw 3 title "exp. fit"