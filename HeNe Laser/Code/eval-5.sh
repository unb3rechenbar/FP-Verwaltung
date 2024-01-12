


for f in */; do
    (
        cd $f

        echo "Processing folder $f .."

        gnuplot -e "filename='${f%/}.txt'; \
                    legname='Datenpunkte'; \
                    set xlabel 'Wavelenght [nm]'; \
                    set ylabel 'Intensity [Counts]'; \
                    outputname='${f%/}.svg'; \
                " "$CODEHENE/BasicPlot.gp"
    )
done