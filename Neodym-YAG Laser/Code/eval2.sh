mkdir -p "$FPNDYAG/Versuchsbericht/Bilddateien/2"

data="spontane_emission_data.csv"

# remove negative x values from spectrum (or more)
tail -n +2 "$data" | awk -F',' '{ result = 5.000000e-06 * $1 - 2.930000e-03; if (result >= 0 && result < 0.001) print result,$2,$3}' | sed 's/,/./g' > "${data%.*}"_tmp

sed 's/ /,/g' "${data%.*}"_tmp > "${data%.*}_t.csv"

# plot raw data
gnuplot -e "filename='$data'; \
            legname='datapoints'; \
            set title 'Abtastung der Anregung'; \
            set xlabel 'Zeititeration'; \
            set ylabel 'Anregung [V]'; \
            outputname='${data%.csv}_it.svg'; \
            xline=1; \
            yline=2; \
        " "$CODENDYAG/DotPlot.gp"

# plot time data
gnuplot -e "filename='$data'; \
            legname='datapoints'; \
            set title 'Abtastung der Anregung'; \
            set xlabel 'Zeit [s]'; \
            set ylabel 'Anregung [V]'; \
            outputname='${data%.csv}_t.svg'; \
            xline=1; \
            yline=2; \
            a=5.000000e-06
            b=-2.930000e-03
        " "$CODENDYAG/fxDotPlot.gp"
inkscape -w 4000 -h 2400 "${data%.csv}_t.svg" -o "$FPNDYAG/Versuchsbericht/Bilddateien/2/${data%.csv}_t.png"

# plot exp curve fit
gnuplot -e "filename='${data%.*}_t.csv'; \
            legname='datapoints'; \
            set title 'Abtastung der Anregung'; \
            set xlabel 'Zeit [s]'; \
            set ylabel 'Anregung [V]'; \
            outputname='${data%.csv}_t_exp.svg'; \
            xline=1; \
            yline=2; \
        " "$CODENDYAG/expPlot.gp" 2> "${data%.*}_t_plotinfo.txt"

inkscape -w 4000 -h 2400 "${data%.csv}_t_exp.svg" -o "$FPNDYAG/Versuchsbericht/Bilddateien/2/${data%.csv}_t_expfit.png"


# delete tmp files
rm "${data%.*}"_tmp
