

gnuplot -e "filename='outputpower-over-cavity-displacement.csv'; \
                legname='Datenpunkte'; \
                set xlabel '∆x [cm]'; \
                set ylabel 'P(HeNe) [mW]'; \
                outputname='P(HeNe)overDL.svg'; \
                xline=2; \
                yline=4; \
                xerror=3; \
                yerror=5; \
                set key right top; \
            " "$CODEHENE/ErrorPlot.gp"

gnuplot -e "filename='outputpower-over-cavity-displacement.csv'; \
                legname='Datenpunkte'; \
                set xlabel '∆x [cm]'; \
                set ylabel 'P(HeNe) [mW]'; \
                outputname='P(HeNe)overDL_linfit.svg'; \
                xline=2; \
                yline=4; \
                xerror=3; \
                yerror=5; \
                set key right top; \
            " "$CODEHENE/ErrorPlotlin.gp"