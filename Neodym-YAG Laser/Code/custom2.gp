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

set xrange [-0.0007:0.002]
set yrange [0.048:0.066]

m=5.000000e-06
y0=-2.930000e-03

f(x)=m*x+y0
g(x)=a*exp(-x/t)+c

plot filename every ::2 using (f($1)):2 title legname, \
    g(x) w l title "exp. Fit"