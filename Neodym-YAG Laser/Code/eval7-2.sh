mkdir -p "$FPNDYAG/Versuchsbericht/Bilddateien/7-2"

echo "> Evaluating 7-2.."

    echo "-> Plotting P(NDYAG)overP(Pump) and fitting quadratic function..."

    gnuplot -e "filename='P(NDYAG)overP(Pump).csv'; \
                legname='Datenpunkte'; \
                set title 'P(ND:YAG) in Abhängigkeit von P(Pump)'; \
                set xlabel 'P_Pump [mW]'; \
                set ylabel 'P_ND:YAG [mW]'; \
                outputname='P(NDYAG)overP(Pump).svg'; \
                xline=1; \
                yline=3; \
                xerror=2; \
                yerror=4; \
                set key right bottom; \
            " "$CODENDYAG/ErrorPlotquad.gp" 2> "P(NDYAG)overP(Pump)_plotinfo.txt"

    echo "-> Converting svg to png and moving .."
    inkscape -w 4000 -h 2400 "P(NDYAG)overP(Pump).svg" -o "$FPNDYAG/Versuchsbericht/Bilddateien/7-2/P(NDYAG)overP(Pump).png"
