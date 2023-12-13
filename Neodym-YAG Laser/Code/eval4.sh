mkdir -p "$FPNDYAG/Versuchsbericht/Bilddateien/4"
rm *-comp.csv *.txt

for f in */; do
    (
        cd $f
        data=$(ls *.csv)
        voltage=$(echo ${f%/} | sed 's/.*_//g')

        echo "-> Plotting $f.."
        gnuplot -e "filename='$data'; \
                legname='datapoints'; \
                set title 'Leistung des Nd:YAG Lasers in Abhängigkeit der Temperatur'; \
                set xlabel 'Temperatur [deg C]'; \
                set ylabel 'Leistung [mW]'; \
                outputname='${data%.csv}.svg'; \
                xline=1; \
                yline=3; \
                xerror=2; \
                yerror=4; \
            " "$CODENDYAG/ErrorPlot.gp"

        echo "-> Converting svg to png and moving .."
        inkscape -w 4000 -h 2400 "${data%.csv}.svg" -o "$FPNDYAG/Versuchsbericht/Bilddateien/4/${f%/}.png"

        echo "-> Calculating stats for $data.."

        echo "\n >-------Details zu x-------<" >> "${data%.*}_info.txt"
        gnuplot -e "set datafile separator ','; stats '"$data"' using 1" 2> "${data%.*}_info.txt"

        echo "\n >-------Details zu y-------<" >> "${data%.*}_info.txt"
        gnuplot -e "set datafile separator ','; stats '"$data"' using 3" 2>> "${data%.*}_info.txt"

        cp "$FPNDYAG/Versuchsdaten/1-1/TransmissionOverTemperature${voltage}/TransmissionOverTemperature${voltage}.csv" ${data%.*}-comp.csv

        echo "-> Comparing to equivalent data from 1-1.."
        gnuplot -e "filename1='$data'; \
                    filename2='${data%.*}-comp.csv'; \
                    legname1='Datenpunkt'; \
                    legname2='Vergleichswerte 1-1'; \
                    set title 'Temperaturabhängigkeit des Transmissionsspektrums'; \
                    set xlabel 'Temperatur [deg C]'; \
                    set ylabel 'Ausgabeleistung [mW]'; \
                    outputname='${data%.csv}_comp.svg'; \
                    set xrange [14.5:]; \
                    set yrange [-10:]; \
                    xline=1; \
                    yline=3; \
                    xerror=2; \
                    yerror=4; \
                    set key right bottom; \
                " "$CODENDYAG/BasicDualPlot.gp"

        echo "-> Converting svg to png and moving .."
        inkscape -w 4000 -h 2400 "${data%.csv}_comp.svg" -o "$FPNDYAG/Versuchsbericht/Bilddateien/4/${f%/}_comp.png"

        rm *-comp.csv
    )
done