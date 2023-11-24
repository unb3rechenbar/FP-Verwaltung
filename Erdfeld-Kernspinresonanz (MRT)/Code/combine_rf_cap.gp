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

l = 0.01
c = 2000

f(x) = 1/sqrt(l * (x + c))

fit f(x) filename u 1:2 via l, c

plot filename u 1:2 w p title legname, \
    f(x) w l title "f(C,L) fit" lw 3