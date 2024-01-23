if [[ "$(basename "$(pwd)")" != "6-Changing-Input-Power-CurvedMirror" ]]; then
    echo "Please execute this script from the 2-Changing-Input-Current directory!"
    exit 1
fi 

echo "> Plotting P(HeNe) over I(in) .."
gnuplot -e "filename='out-power-over-in-current.csv'; \
                legname='Datenpunkte'; \
                set xlabel 'I(in) [mA]'; \
                set ylabel 'P(HeNe) [mW]'; \
                outputname='P(HeNe)overI(in).svg'; \
                xline=1; \
                yline=3; \
                xerror=2; \
                yerror=4; \
                set key right bottom; \
            " "$CODEHENE/ErrorPlot.gp"

echo "-> Converting to png .."
inkscape -w 4000 -h 2400 "P(HeNe)overI(in).svg" -o "$FPHENE/Versuchsbericht/Bilddateien/6/P(HeNe)overI(in).png"