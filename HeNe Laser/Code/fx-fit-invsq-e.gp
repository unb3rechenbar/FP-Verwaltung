set datafile separator ","

set term svg size 1100,600
set output outputname
set tics font "Computer Modern,30"
set key font "Computer Modern,30"
set xlabel font "Computer Modern,30" offset 0,-1
set ylabel font "Computer Modern,30" offset -5,0
set title font "Computer Modern,30"

set lmargin 20
set rmargin 10
set bmargin 5
set tmargin 5

a = aguess
b = bguess
c = cguess
d = dguess

d(x) = rescale * x + offset

f(x) = a / ((b * x + c) ** 2) + d

fit f(x) filename using (d(column(xline))):yline:xerror:yerror xyerrors via a, b, c, d

plot filename using (d(column(xline))):yline:xerror:yerror with xyerrorbars title legname, \
     f(x) with lines lc rgb "red" lw 3 title "inv squared fit"
