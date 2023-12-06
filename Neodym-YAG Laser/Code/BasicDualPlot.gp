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

plot filename1 every ::1 using xline:yline:yerror with yerrorbars title legname1, \
    filename2 every ::1 using xline:yline:xerror:yerror w yerrorbars title legname2