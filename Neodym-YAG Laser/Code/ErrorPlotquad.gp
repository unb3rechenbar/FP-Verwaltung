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

set errorbars large

a=1
b=1
c=1

f(x) = a * (x - b)**2 + c

fit f(x) filename using xline:yline via a,b,c

plot filename every ::1 using xline:yline:yerror with yerrorbars title legname, \
    f(x) with lines lc rgb "red" lw 3 title "quad. fit"
