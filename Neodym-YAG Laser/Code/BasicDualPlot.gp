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

set ytics nomirror
set y2tics nomirror

plot filename1 every ::1 using xline:yline:yerror with yerrorbars title legname1 axis x1y1, \
    filename2 every ::1 using xline:yline:yerror w yerrorbars title legname2 axis x1y2