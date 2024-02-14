set datafile separator ","

set term svg size 1100,600
set output outputname
set tics font "Helvetica,25"
set key font "Helvetica,25"
set xlabel font "Helvetica,25" offset 0,-1
set ylabel font "Helvetica,25" offset -5,0
set title font "Helvetica,25"

set xlabel "ΔAlt (deg)"
set ylabel "ΔAz (deg)"

set palette rgbformulae 7,5,15
set view map

mx=0.5
my=0.5

dx(x)=floor(x/mx)
dy(y)=floor(y/my)

plot filename using (dx($9)):(dy($10)):($11) every ::1 with image