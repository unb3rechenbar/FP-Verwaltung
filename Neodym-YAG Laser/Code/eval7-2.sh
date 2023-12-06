

gnuplot -e "filename='P(NDYAG)overP(Pump).csv'; \
            legname='datapoints'; \
            set title 'P_ND:YAG in Abhängigkeit von P_Pump'; \
            set xlabel 'P_Pump [mW]'; \
            set ylabel 'P_ND:YAG [mW]'; \
            outputname='P(NDYAG)overP(Pump).svg'; \
            xline=1; \
            yline=3; \
            xerror=2; \
            yerror=4; \
            set key right bottom; \
        " "$CODENDYAG/ErrorPlotquad.gp" 2> "P(NDYAG)overP(Pump)_plotinfo.txt"
