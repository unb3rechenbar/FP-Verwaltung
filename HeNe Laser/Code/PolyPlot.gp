set datafile separator ","

set term svg size 1100,600
set output outputname
set tics font "Times New Roman,30"
set key font "Times New Roman,30"
set xlabel font "Times New Roman,30" offset 0,-1
set ylabel font "Times New Roman,30" offset -5,0
set title font "Times New Roman,30"

set lmargin 20
set rmargin 10
set bmargin 5
set tmargin 5

a = 1
b = 1
c = 1
d = 1
e = 1
f = 1
g = 1
h = 1

f(x) = a*x**7 + b*x**6 + c*x**5 + d*x**4 + e*x**3 + f*x**2 + g*x + h

fit f(x) filename using xline:yline via a, b, c ,d, e, f, g, h

plot filename using xline:yline ps 2 title legname, \
     f(x) with lines lc rgb "red" lw 3 title "poly. fit 7. order"