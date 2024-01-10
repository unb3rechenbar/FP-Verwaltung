


for f in *.txt; do
    echo "Processing file $f .."

    gnuplot -e "filename='$f'; \
                    legname='Datenpunkte'; \
                    set xlabel 'Wavelenght [nm]'; \
                    set ylabel 'Intensity [Counts]'; \
                    outputname='${f%.*}.svg'; \
                " "$CODEHENE/BasicPlot.gp"

done