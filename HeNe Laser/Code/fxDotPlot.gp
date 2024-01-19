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

a=5.000000e-06
b=-2.930000e-03

f(x)=a*x+b

plot filename every ::2 using (f($xline)):yline title legname