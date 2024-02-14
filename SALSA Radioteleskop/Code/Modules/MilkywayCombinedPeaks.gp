set datafile separator " "

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

set xlabel "rel. velocity (km/s)"
set ylabel "intensity (arbitrary units)"



plot fspectrum u 1:2 every::9 ps 1 title "spectrum", \
    fsmooth u 1:2 w l lw 2 title "smoothed spectrum", \
    ffit u 1:2 w l lw 2 title "gaussian sum", \
