# get corrent directory
DIR="$(pwd)"



for f in */; do
    (
        echo ">-------------<"
        echo "Ordner: $DIR/$f"
        cd "$DIR/$f"

        gnuplot -e "filename='Resonance_Freq_vs_Capacitance.txt'; \
            legname='datapoints'; \
            set title 'Resonance Frequency over Capacitance'; \
            set xlabel 'Capacitance [nF]'; \
            set ylabel 'Frequency [Hz]'; \
            outputname='Resonance_Freq_vs_Capacitance.svg'" \
        "$CODEMRI"/combine_rf_cap.gp 2> "Resonance_Freq_vs_Capacitance_info.txt"
    )
done

echo "\n>--------copying---------<"

for f in */; do
    (
        echo ">--------file: $f---------<"
        cd "$DIR/$f"
        echo "   converting to $FPMRT/Vorschriebe/Bilddateien/4/${f%/}.svg ..."
        inkscape -w 4000 -h 2400 "Resonance_Freq_vs_Capacitance.svg" -o "$FPMRT/Vorschriebe/Bilddateien/4/${f%/}_Resonance_Freq_vs_Capacitance.png"
        echo "   done"
    )
done