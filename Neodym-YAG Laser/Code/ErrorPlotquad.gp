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

set bars small
set style fill solid

a=1
b=1
c=1

f(x) = a*x**2 + b*x + c

fit f(x) filename using xline:yline via a,b,c

plot filename every ::1 using xline:yline:yerror with yerrorbars title legname, \
    f(x) with lines lc rgb "red" lw 3 title "lin. fit"