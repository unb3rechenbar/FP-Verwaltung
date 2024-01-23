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

d(x,y) = x - y
ud(x,y) = sqrt(x**2 + y**2)

plot filename every ::1 using xline:(d(column(yline),column(6))):(ud(column(yerror),column(7))) ps 2 with yerrorbars title legname