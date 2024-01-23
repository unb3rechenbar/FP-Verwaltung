if [[ "$(basename "$(pwd)")" != "2-Changing-Input-Current" ]]; then
    echo "Please execute this script from the 2-Changing-Input-Current directory!"
    exit 1
fi 


echo "Evaluating 2. Experiment .."

echo "> Plotting P(HeNe) over I(in) .."
gnuplot -e "filename='out-power-over-in-current.csv'; \
                legname='Datapoints'; \
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
inkscape -w 4000 -h 2400 "P(HeNe)overI(in).svg" -o "$FPHENE/Versuchsbericht/Bilddateien/2/P(HeNe)overI(in).png"

echo "> Converting Current to Power and replotting .."
gnuplot -e "filename='out-power-over-in-current.csv'; \
                legname='Datapoints'; \
                set xlabel 'P(in) [W]'; \
                set ylabel 'P(HeNe) [mW]'; \
                outputname='P(HeNe)overP(in).svg'; \
                xline=1; \
                yline=3; \
                xerror=2; \
                yerror=4; \
                a=2; \
                b=0; \
                ub=0.1; \
                set key right bottom; \
            " "$CODEHENE/fxErrorPlot.gp"
                
echo "-> Converting to png .."
inkscape -w 4000 -h 2400 "P(HeNe)overP(in).svg" -o "$FPHENE/Versuchsbericht/Bilddateien/2/P(HeNe)overP(in).png"



# >------- ANALYSIS -------<
echo "\n >------- ANALYSIS -------<"

echo "> Fitting sqrt function to power plot .."
gnuplot -e "filename='out-power-over-in-current.csv'; \
                legname='Datapoints'; \
                set xlabel 'P(in) [W]'; \
                set ylabel 'P(HeNe) [mW]'; \
                outputname='P(HeNe)overP(in)-sqrt.svg'; \
                xline=1; \
                yline=3; \
                xerror=2; \
                yerror=4; \
                rescale=2; \
                offset=0; \
                ub=0.1; \
                aguess = 1; \
                bguess = 1; \
                cguess = 5; \
                dguess = 100; \
                set key right bottom; \
            " "$CODEHENE/fx-fit-sqrt-e.gp" 2> "fitparam-sqrt.txt"
                
echo "-> Converting to png .."
inkscape -w 4000 -h 2400 "P(HeNe)overP(in)-sqrt.svg" -o "$FPHENE/Versuchsbericht/Bilddateien/2/P(HeNe)overP(in)-sqrt.png"

echo "--> $(grep "Nullstelle: " "fitparam-sqrt.txt")"


echo "> Fitting log function to power plot .."
gnuplot -e "filename='out-power-over-in-current.csv'; \
                legname='Datapoints'; \
                set xlabel 'P(in) [W]'; \
                set ylabel 'P(HeNe) [mW]'; \
                outputname='P(HeNe)overP(in)-log.svg'; \
                xline=1; \
                yline=3; \
                xerror=2; \
                yerror=4; \
                rescale=2; \
                offset=0; \
                ub=0.1; \
                aguess = 1; \
                bguess = 1; \
                cguess = 5; \
                dguess = 100; \
                set key right bottom; \
            " "$CODEHENE/fx-fit-log-e.gp" 2> "fitparam-log.txt"

echo "-> Converting to png .."
inkscape -w 4000 -h 2400 "P(HeNe)overP(in)-log.svg" -o "$FPHENE/Versuchsbericht/Bilddateien/2/P(HeNe)overP(in)-log.png"

echo "--> $(grep "Nullstelle: " "fitparam-log.txt")"


echo "> Fitting linear function to power plot .."
gnuplot -e "filename='out-power-over-in-current.csv'; \
                legname='Datapoints'; \
                set xlabel 'P(in) [W]'; \
                set ylabel 'P(HeNe) [mW]'; \
                outputname='P(HeNe)overP(in)-linear.svg'; \
                xline=1; \
                yline=3; \
                xerror=2; \
                yerror=4; \
                rescale=2; \
                offset=0; \
                aguess = 5; \
                bguess = 1; \
                set key right bottom; \
            " "$CODEHENE/fx-fit-lin-e.gp" 2> "fitparam-lin.txt"

echo "-> Converting to png .."
inkscape -w 4000 -h 2400 "P(HeNe)overP(in)-linear.svg" -o "$FPHENE/Versuchsbericht/Bilddateien/2/P(HeNe)overP(in)-linear.png"

echo "--> $(grep "Nullstelle: " "fitparam-lin.txt")"



# >------- WIRKUNGSGRAD -------<
echo "\n >------- WIRKUNGSGRAD -------<"

echo "> Plotting efficiency over used current .."
gnuPlot -e "filename='out-power-over-in-current.csv'; \
                legname='Datapoints'; \
                set xlabel 'I(in) [mA]'; \
                set ylabel 'η'; \
                outputname='efficiency-over-in-current.svg'; \
                xline=1; \
                yline=3; \
                xerror=2; \
                yerror=4; \
                rescale=2000; \
                offset=0; \
                set key right top; \
            " "$CODEHENE/fx-quotient,gp" 2> "fitparam-quotient.txt"

echo "-> Converting to png .."
inkscape -w 4000 -h 2400 "efficiency-over-in-current.svg" -o "$FPHENE/Versuchsbericht/Bilddateien/2/efficiency-over-in-current.png"