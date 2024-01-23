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

f(x) = a * log(b * x + c) + d

fit f(x) filename using (d(column(xline))):yline:xerror:yerror xyerrors via a, b, c, d

plot filename using (d(column(xline))):yline:xerror:yerror ps 2 with xyerrorbars title legname, \
     f(x) with lines lc rgb "red" lw 3 title "log fit"

fit_zero = (exp(-d / a) - c) / b
fit_zero_err = fit_zero * sqrt((d_err / d) ** 2 + (a_err / a) ** 2 + (c_err / c) ** 2 + (b_err / b) ** 2)
print sprintf("Nullstelle: %.4f +/- %.4f", fit_zero, fit_zero_err)