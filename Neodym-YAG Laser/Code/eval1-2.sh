mkdir -p "$FPNDYAG/Versuchsbericht/Bilddateien/1-2"
rm *_info

# >------- Evaluate T set and I spectrum for minima -------<
(
    echo "> Evaluing Rasterung_EvalMin.."
    cd "Rasterung_EvalMin_chgTmp"

    for f in */; do
        (
            cd "$f"
            dataset=$(ls *.csv)

            echo "-> Evaluating folder $f"
            echo "--> Plotting.."
            gnuplot -e "filename='$dataset'; \
                    legname='datapoints'; \
                    set xlabel 'Strom [mA]'; \
                    set ylabel 'Ausgabeleistung [mW]'; \
                    outputname='${dataset%.csv}.svg'; \
                    xline=1; \
                    yline=3; \
                    xerror=2; \
                    yerror=4; \
                " "$CODENDYAG/ErrorPlot.gp"

            echo "--> Converting svg to png and moving .."
            
            inkscape -w 4000 -h 2400 "${dataset%.csv}.svg" -o "$FPNDYAG/Versuchsbericht/Bilddateien/1-2/Rasterung_${f%/}.png"
        )
    done
)
echo "> Done with Rasterung_EvalMin for fixed T and variable I\n"

# >------- Evaluate I set and T spectrum for minima -------<
(
    echo "> Evaluate T Scan"
    cd "Rasterung_EvalMin_chgI"

    echo "-> Plotting.."
    gnuplot -e "filename='Rasterung_EvalMin_chgI.csv'; \
            legname='datapoints'; \
            set xlabel 'Leistung [mW]'; \
            set ylabel 'Temperatur [deg C]'; \
            outputname='Rasterung_EvalMin_chgI.svg'; \
            xline=1; \
            yline=3; \
            xerror=2; \
            yerror=4; \
            set key right top; \
            set xrange [40:560]; \
        " "$CODENDYAG/ErrorPlotlin.gp" 2> "Rasterung_EvalMin_chgI_plotinfo.txt"

    echo "--> Converting svg to png and moving .."
    inkscape -w 4000 -h 2400 "Rasterung_EvalMin_chgI.svg" -o "$FPNDYAG/Versuchsbericht/Bilddateien/1-2/Rasterung_EvalMin_chgI.png"
)
echo "> Done with Rasterung_EvalMin for fixed I and variable T\n"

echo "> Evaluating I(T)"

# >------- Plotting and Converting -------<
gnuplot -e "filename='InjectioncurrentOverTemperature.csv'; \
            legname='datapoints'; \
            set xlabel 'Temperatur [deg C]'; \
            set ylabel 'Injektionsstrom [mA]'; \
            outputname='InjectioncurrentOverTemperature.svg'; \
            set xrange [19.5:]; \
            set yrange [0:]; \
            xline=1; \
            yline=3; \
            xerror=2; \
            yerror=4; \
            set key right bottom; \
        " "$CODENDYAG/ErrorPlotlin.gp" 2> "InjectioncurrentOverTemperature_plotinfo.txt"

echo "--> Converting svg to png and moving .."
inkscape -w 4000 -h 2400 "InjectioncurrentOverTemperature.svg" -o "$FPNDYAG/Versuchsbericht/Bilddateien/1-2/InjectioncurrentOverTemperature.png"

# >------- Statistics -------<
echo "--> Calculating stats for InjectioncurrentOverTemperature.csv.."

echo "\n >-------Details zu x-------<" >> "InjectioncurrentOverTemperature_info.txt"

gnuplot -e "set datafile separator ','; stats 'InjectioncurrentOverTemperature.csv' using 1" 2>> "InjectioncurrentOverTemperature_info.txt"

echo "\n >-------Details zu y-------<" >> "InjectioncurrentOverTemperature_info.txt"

gnuplot -e "set datafile separator ','; stats 'InjectioncurrentOverTemperature.csv' using 3" 2>> "InjectioncurrentOverTemperature_info.txt"


echo "> Done with I(T)"