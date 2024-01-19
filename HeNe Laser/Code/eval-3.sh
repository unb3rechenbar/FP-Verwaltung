


echo "> Plotting power over deplacement .."
gnuplot -e "filename='power-over-deplacement.csv'; \
                legname='Datapoints'; \
                set xlabel '∆L [cm]'; \
                set ylabel 'P(HeNe) [mW]'; \
                outputname='P(HeNe)overDx.svg'; \
                xline=2; \
                yline=4; \
                xerror=3; \
                yerror=5; \
                set key right top; \
            " "$CODEHENE/ErrorPlot.gp"

echo "-> Converting to png .."
inkscape -w 4000 -h 2400 "P(HeNe)overDx.svg" -o "$FPHENE/Versuchsbericht/Bilddateien/3/P(HeNe)overDx.png"


# >------- ANALYSIS -------<
echo "> Fitting inverse square function to power plot .."
gnuplot -e "filename='power-over-deplacement.csv'; \
                legname='Datapoints'; \
                set xlabel '∆L [cm]'; \
                set ylabel 'P(HeNe) [mW]'; \
                outputname='P(HeNe)overDx-inverse-square.svg'; \
                xline=2; \
                yline=4; \
                xerror=3; \
                yerror=5; \
                rescale=1; \
                offset=0; \
                aguess = 1; \
                bguess = 1; \
                cguess = 0.1; \
                dguess = 50; \
                set key right top; \
            " "$CODEHENE/fx-fit-invsq-e.gp"

echo "> Fitting exponential function to power plot .."
gnuplot -e "filename='power-over-deplacement.csv'; \
                legname='Datapoints'; \
                set xlabel '∆L [cm]'; \
                set ylabel 'P(HeNe) [mW]'; \
                outputname='P(HeNe)overDx-exp.svg'; \
                xline=2; \
                yline=4; \
                xerror=3; \
                yerror=5; \
                rescale=1; \
                offset=0; \
                aguess = 50; \
                bguess = -5; \
                cguess = 0.1; \
                dguess = 60; \
                set key right top; \
            " "$CODEHENE/fx-fit-exp-e.gp"