mkdir -p "$FPNDYAG/Versuchsbericht/Bilddateien/6"

for f in *.csv; do
    echo "Plotting $f..."

    if [[ "$f" =~ "450" ]]; then
        gnuplot -e "filename='$f'; \
            legname='Datenpunkte'; \
            set xlabel 'Zeit [s]'; \
            set ylabel 'Spannung [V]'; \
            outputname='${f%.*}.svg'; \
            xline=1; \
            yline=3; \
            set xrange [-0.0055:-0.002]; \
            set key right bottom; \
            a=5.000000e-06; \
            b=-6.0e-03; \
        " "$CODENDYAG/fxLinePlot.gp" 2> "${f%.*}_plotinfo.txt"
    else
        gnuplot -e "filename='$f'; \
            legname='Datenpunkte'; \
            set xlabel 'Zeit [s]'; \
            set ylabel 'Spannung [V]'; \
            outputname='${f%.*}.svg'; \
            xline=1; \
            yline=3; \
            set xrange [-0.0035:-0.002]; \
            set key right bottom; \
            a=5.000000e-06; \
            b=-6.0e-03; \
        " "$CODENDYAG/fxLinePlot.gp" 2> "${f%.*}_plotinfo.txt"
    fi

    echo "-> Converting svg to png and moving .."
    inkscape -w 4000 -h 2400 "${f%.*}.svg" -o "$FPNDYAG/Versuchsbericht/Bilddateien/6/${f%.*}.png"

done