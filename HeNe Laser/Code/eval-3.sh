if [[ "$(basename "$(pwd)")" != "3-Power-Dependency-on-medium-position" ]]; then
    echo "Please execute this script from the 2-Changing-Input-Current directory!"
    exit 1
fi 


echo ">------- PLOTTING -------<"
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
svg2png -w 4000 -h 2400 "P(HeNe)overDx.svg" > "$FPHENE/Versuchsbericht/Bilddateien/3/P(HeNe)overDx.png"
# inkscape -w 4000 -h 2400 "P(HeNe)overDx.svg" -o "$FPHENE/Versuchsbericht/Bilddateien/3/P(HeNe)overDx.png"


echo "> Plotting adjusted power over deplacement .."
gnuplot -e "filename='power-over-deplacement.csv'; \
                legname='Datapoints'; \
                set xlabel '∆L [cm]'; \
                set ylabel 'P(HeNe) [mW]'; \
                outputname='P(HeNe)overDx-adjusted.svg'; \
                xline=2; \
                yline=4; \
                xerror=3; \
                yerror=5; \
                set key right top; \
            " "$CODEHENE/custom3-ErrorPlot.gp"

echo "-> Converting to png .."
svg2png -w 4000 -h 2400 "P(HeNe)overDx-adjusted.svg" > "$FPHENE/Versuchsbericht/Bilddateien/3/P(HeNe)overDx-adjusted.png"
# inkscape -w 4000 -h 2400 "P(HeNe)overDx-adjusted.svg" -o "$FPHENE/Versuchsbericht/Bilddateien/3/P(HeNe)overDx-adjusted.png"

# >------- ANALYSIS -------<
echo "\n >------- ANALYSIS -------<"

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
                set yrange [40:180]; \
                set key right top; \
            " "$CODEHENE/fx-fit-invsq-e.gp" 2> "fitparam-inverse-square.txt"

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
                set yrange [40:180]; \
                set key right top; \
            " "$CODEHENE/fx-fit-exp-e.gp" 2> "fitparam-exp.txt"