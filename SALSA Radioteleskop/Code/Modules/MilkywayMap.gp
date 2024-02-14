set datafile separator " "

set encoding utf8

set term pdf size 23cm,23cm
set output outputname
unset xtics
unset ytics
set tics font "Times New Roman,30"
set ttics font "Times New Roman,30"
set colorbox vertical user origin 0.9,0.2 size 0.04,0.6
set key font "Times New Roman,20"
set xlabel font "Times New Roman,30" offset 0,-3
set ylabel font "Times New Roman,30" offset -10,0
set title font "Times New Roman,30"

set lmargin 15
set rmargin 20
set bmargin 10
set tmargin 10
set key top right

set xlabel "x rel. to sun (kpc)"
set ylabel "y rel. to sun (kpc)"

set palette defined (0 "blue", 1 "green", 2 "yellow", 3 "red")

# >-------- Set tics --------<
if (GPVAL_ENCODING eq "utf8") {
    set ttics add ("π/2" 180, "0" 90, "π" 270)
} else {
    set ttics add ("pi" 180, "pi/2" 90, "3pi/2" 270)
}

# >-------- Set Name Tics -------<
set ttics add ("Ori (0)" 90, "CMa" 120, "Pup" 150, "Vel\n(π/2)" 180)

# >-------- Set coordinate system --------<
unset border
set polar
set angles degrees
set grid polar 30 lw 3
# set trange [0:360]

# >-------- Variablen --------<
R0 = 8.5
V0 = 220

# >-------- Funktionen --------<
gal_radius(v,l) = R0 * V0 * sin(l) / (V0 * sin(l) + v)
sun_radius_plus(R,l) = sqrt(R**2 - R0**2 * sin(l)**2) + R0 * cos(l)

vel_to_rad(v,l) = sun_radius_plus(gal_radius(v,l),l)

# >-------- Translation --------<
rotate_phi(phi) = phi - 90

x_coord(r,l) = r * cos(rotate_phi(l))
y_coord(r,l) = r * sin(rotate_phi(l))
y_coord_corr(r,l) = r * sin(rotate_phi(l)) + R0


# >-------- Polarkoordinatentransformation --------<
polar_r(r,l) = sqrt((x_coord(r,l))**2 + (y_coord(r,l))**2)
polar_phi(r,l) = atan2(y_coord(r,l),x_coord(r,l))

# >-------- Plot --------<
# plot peakfile u (x_coord(vel_to_rad($1,$3),$3)):(y_coord(vel_to_rad($1,$3),$3)):1 lc palette ps 2 title "points"

plot peakfile u (rotate_phi($3)):(vel_to_rad($1,$3)):1 lc palette pt 1 lw 3 ps 2 t "points", \
    "<echo '270 8.5'"   w p ps 2 pt 7 lc rgb "black" t "Sagittarius A^*", \
    "<echo '0 0'" w p ps 1.5 pt 7 lc rgb "orange" t "Sun"

# plot peakfile u (polar_r(vel_to_rad($1,$3),$3)):(polar_phi(vel_to_rad($1,$3),$3)):1 lc palette ps 2 notitle, \
#     peakfile u (rotate_phi($3)):(vel_to_rad($1,$3)):1 ps 1 lc rgb "#BDBDBD" notitle