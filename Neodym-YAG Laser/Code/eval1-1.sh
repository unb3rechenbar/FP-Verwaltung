mkdir -p "$FPNDYAG/Versuchsbericht/Bilddateien/1-1"


for d in */; do
    if [[ "$d" =~ "skip" ]]; then
        echo "> Skipping $d\n"
        continue
    else 
        echo "> Evaluating $d"
    fi

    (
        cd "$d"
        rm *_info.txt *_plotinfo.txt
        data=$(ls *.csv)

        echo "--> Plotting $data.."

        gnuplot -e "filename='$data'; \
                legname='datapoints'; \
                set title 'Temperaturabhängigkeit des Transmissionsspektrums'; \
                set xlabel 'Temperatur [deg C]'; \
                set ylabel 'Ausgabeleistung [mW]'; \
                outputname='${data%.csv}.svg'; \
                set xrange [14.5:]; \
                set yrange [0:]; \
                xline=1; \
                yline=3; \
                xerror=2; \
                yerror=4; \
                set key right bottom; \
            " "$CODENDYAG/ErrorPlot.gp"

        echo "--> Converting svg to png and moving .."
        inkscape -w 4000 -h 2400 "${data%.csv}.svg" -o "$FPNDYAG/Versuchsbericht/Bilddateien/1-1/${d%/}.png"

        echo "--> Calculating stats for $data.."

        # find min and argmin
        echo "\n >-------Minima-------<" >> "${data%.*}_info.txt"
        echo "x  f(x)" >> "${data%.*}_info.txt"
        echo $(tail -n +2 "$data" | awk -F',' 'BEGIN{min_SPEC=1000} {if ($3+0<min_SPEC+0) {min_SPEC=$3; xvalue=$1}} END {print xvalue,min_SPEC}') >> "${data%.*}_info.txt"

        echo "\n >-------Details zu x-------<" >> "${data%.*}_info.txt"
        gnuplot -e "set datafile separator ','; stats '"$data"' using 1" 2>> "${data%.*}_info.txt"

        echo "\n >-------Details zu y-------<" >> "${data%.*}_info.txt"
        gnuplot -e "set datafile separator ','; stats '"$data"' using 3" 2>> "${data%.*}_info.txt"

        echo "--> Polyfitting $data with degree 7.."
        gnuplot -e "filename='$data'; \
                    legname='datapoints'; \
                    set title 'Temperaturabhängigkeit des Transmissionsspektrums'; \
                    set xlabel 'Temperatur [deg C]'; \
                    set ylabel 'Ausgabeleistung [mW]'; \
                    outputname='${data%.csv}_polyfit.svg'; \
                    set xrange [14.5:]; \
                    set yrange [0:]; \
                    xline=1; \
                    yline=3; \
                    xerror=2; \
                    yerror=4; \
                " "$CODENDYAG/PolyPlot.gp" 2> "${data%.*}_plotinfo.txt"
    )

    echo "> Done with $d\n"
done


