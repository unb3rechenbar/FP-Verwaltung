mkdir -p "$FPNDYAG/Versuchsbericht/Bilddateien/6"

for f in *.csv; do
    echo "Plotting $f..."

    

    gnuplot -e "filename='$f'; \
            legname='datapoints'; \
            set title '${f%.*}'; \
            set xlabel 'Zeit [s]'; \
            set ylabel 'Spannung [V]'; \
            outputname='${f%.*}.svg'; \
            xline=1; \
            yline=3; \
            set key right bottom; \
            a=5.000000e-06; \
            b=-6.0e-03; \
        " "$CODENDYAG/fxLinePlot.gp" 2> "${f%.*}_plotinfo.txt"

done