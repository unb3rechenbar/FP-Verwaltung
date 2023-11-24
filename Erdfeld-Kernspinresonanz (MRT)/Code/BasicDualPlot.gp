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

a = 10
b = 100
d = 1

f(x) = a * exp(-x / b) + d

fit f(x) data using 1:2 via a, b, d

plot data using 1:2 title dataleg, \
    fid every ::1 using 1:2 w lines title fidleg, \
    f(x) w lines title "exp. fit"