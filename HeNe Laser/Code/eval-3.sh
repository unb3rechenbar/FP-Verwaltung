

gnuplot -e "filename='power-over-deplacement.csv'; \
                legname='Datenpunkte'; \
                set xlabel '∆L [cm]'; \
                set ylabel 'P(HeNe) [mW]'; \
                outputname='P(HeNe)overDx.svg'; \
                xline=2; \
                yline=4; \
                xerror=3; \
                yerror=5; \
                set key right bottom; \
            " "$CODEHENE/ErrorPlot.gp"