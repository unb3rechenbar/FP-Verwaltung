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
d = 1
e = 1
f = 1

f(x) = a*x**5 + b*x**4 + c*x**3 + d*x**2 + e*x + f

fit f(x) filename using 1:2 via a, b, c ,d, e, f

plot filename using 1:2 title legname, \
     f(x) with lines lc rgb "red" lw 3 title "poly. fit 5. order"