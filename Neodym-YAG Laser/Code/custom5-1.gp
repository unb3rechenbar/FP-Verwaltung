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

set xrange [0:1]

m=5.000000e-06
y0=-2.930000e-03

alphaS=0.0925
E41=808
E32=1064
T=0.2

f(x) = alphaS * 808/1064 * (T + x)/T 

plot f(x) w l t legname