mkdir -p "$FPNDYAG/Versuchsbericht/Bilddateien/5-1"

echo "Plotting P(NDYAG)overP(Pump)..."
gnuplot -e "filename='P(NDYAG)overP(Pump).csv'; \
            legname='Datenpunkte'; \
            set xlabel 'P(Pump) [mW]'; \
            set ylabel 'P(ND:YAG) [mW]'; \
            outputname='P(NDYAG)overP(Pump).svg'; \
            xline=1; \
            yline=3; \
            xerror=2; \
            yerror=4; \
            set key right bottom; \
            f(x) = a * (x-b) + c; \
            vars='a, b, c'; \
        " "$CODENDYAG/ErrorPlotlin.gp" 2> "P(NDYAG)overP(Pump)_plotinfo.txt"

echo "-> Converting svg to png and moving .."

inkscape -w 4000 -h 2400 "P(NDYAG)overP(Pump).svg" -o "$FPNDYAG/Versuchsbericht/Bilddateien/5-1/P(NDYAG)overP(Pump).png"


echo "Plotting Verlust..."

gnuplot -e "legname='Funktionspunkte'; \
            set xlabel 'Verlust'; \
            set ylabel 'Quantenausbeute'; \
            outputname='VerlustAusbeute.svg'; \
        " "$CODENDYAG/custom5-1.gp"

echo "-> Converting svg to png and moving .."

inkscape -w 4000 -h 2400 "VerlustAusbeute.svg" -o "$FPNDYAG/Versuchsbericht/Bilddateien/5-1/VerlustAusbeute.png"
