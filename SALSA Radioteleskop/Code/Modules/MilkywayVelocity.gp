set datafile separator ","

set term pdf size 29.7cm, 17cm
set output outputname
set xtics font "Times New Roman,30" offset 0,-0.7
set ytics font "Times New Roman,30" offset -0.7,0
set key font "Times New Roman,30"
set xlabel font "Times New Roman,30" offset 0,-2
set ylabel font "Times New Roman,30" offset -7,0
set title font "Times New Roman,30"

set lmargin 20
set rmargin 10
set bmargin 7
set tmargin 5

set key right top

set angles degrees

set xlabel "radius R(l) [kpc]"
set ylabel "velocity V(l,Vmax) [km/s]"

R0 = 8.5
V0 = 220

fx(l) = sin(l) * R0
fy(y,l) = y + V0 * sin(l)

f(x) = m * x + c
const(x) = d

fit f(x) filename using (fx(column(lline))):(fy(column(vline),column(lline))) via m,c
fit const(x) filename using (fx(column(lline))):(fy(column(vline),column(lline))) via d

plot filename using (fx(column(lline))):(fy(column(vline),column(lline))) ps 2 title legname, \
        f(x) w l title sprintf("V(l) = %.2f * R(l) + %.2f", m, c), \
        const(x) w l title sprintf("V_{max} = %.2f km/s", d)