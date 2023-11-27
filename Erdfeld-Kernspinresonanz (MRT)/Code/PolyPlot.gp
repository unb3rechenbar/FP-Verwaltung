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
g = 1
h = 1
i = 1
j = 1

f(x) = a*x**9 + b*x**8 + c*x**7 + d*x**6 + e*x**5 + f*x**4 + g*x**3 + h*x**2 + i*x + j

fit f(x) filename using 1:2 via a, b, c ,d, e, f, g, h, i, j

plot filename using 1:2 title legname, \
     f(x) with lines lc rgb "red" lw 3 title "poly. fit 9. order"