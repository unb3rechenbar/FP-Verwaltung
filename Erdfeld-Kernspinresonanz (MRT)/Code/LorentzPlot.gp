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

a = 1000
w0 = 2000
gamma = 20
d = 0.5


# lorentz function
f(x) = a / ((x**2 - w0**2)**2 + gamma**2 * w0**2) + d

fit f(x) filename using 1:2 via a, w0, gamma, d

plot filename using 1:2 title legname, \
     f(x) with lines lc rgb "red" title "lorentz fit"