mkdir -p "$FPNDYAG/Versuchsbericht/Bilddateien/2"

data="spontane_emission_data.csv"

# remove negative x values from spectrum (or more)
tail -n +2 "$data" | awk -F',' '{ result = 5.000000e-06 * $1 - 2.930000e-03; if (result >= 0 && result < 0.001) print result,$2,$3}' | sed 's/,/./g' > "${data%.*}"_tmp

sed 's/ /,/g' "${data%.*}"_tmp > "${data%.*}_t.csv"

# plot raw data
gnuplot -e "filename='$data'; \
            legname='Datenpunkte'; \
            set xlabel 'Zeititeration'; \
            set ylabel 'Anregung [V]'; \
            outputname='${data%.csv}_it.svg'; \
            xline=1; \
            yline=2; \
        " "$CODENDYAG/DotPlot.gp"

# plot exp curve fit
gnuplot -e "filename='${data%.*}_t.csv'; \
            legname='Datenpunkte'; \
            set xlabel 'Zeit [s]'; \
            set ylabel 'Anregung [V]'; \
            outputname='${data%.csv}_t_exp.svg'; \
            xline=1; \
            yline=2; \
        " "$CODENDYAG/expPlot.gp" 2> "${data%.*}_t_plotinfo.txt"

inkscape -w 4000 -h 2400 "${data%.csv}_t_exp.svg" -o "$FPNDYAG/Versuchsbericht/Bilddateien/2/${data%.csv}_t_expfit.png"

# get fit parameters
a=$(grep -n "a               = " "${data%.*}_t_plotinfo.txt" | sed 's/.*= \([0-9.]*\).*/\1/')
t=$(grep -n "t               = " "${data%.*}_t_plotinfo.txt" | sed 's/.*= \([0-9.]*\).*/\1/')
c=$(grep -n "c               = " "${data%.*}_t_plotinfo.txt" | sed 's/.*= \([0-9.]*\).*/\1/')


echo "-> f(x) = $a * exp(-x/$t) + $c"

# plot time data in combination with exp curve fit
gnuplot -e "filename='$data'; \
            legname='Datenpunkte'; \
            set xlabel 'Zeit [s]'; \
            set ylabel 'Anregung [V]'; \
            outputname='${data%.csv}_t.svg'; \
            xline=1; \
            yline=2; \
            a=$a; \
            t=$t; \
            c=$c; \
        " "$CODENDYAG/custom2.gp"
inkscape -w 4000 -h 2400 "${data%.csv}_t.svg" -o "$FPNDYAG/Versuchsbericht/Bilddateien/2/${data%.csv}_t.png"




# delete tmp files
rm "${data%.*}"_tmp
