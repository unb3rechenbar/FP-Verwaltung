

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