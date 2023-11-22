# get the current directory
DIR="$(pwd)"
echo "Looking for files in: $DIR"

for f in */; do
    (
        echo ">-------------<"
        echo "Ordner: $DIR/$f"
        cd "$DIR/$f"

        rm -f "rms_noise_info.txt"
        rm -f "Noise_Spectrum_info.txt"

        gnuplot -e "filename='rms_noise.txt'; \
                    legname='rms noise'; \
                    set title 'RMS Noise'; \
                    set xlabel 'Time [s]'; \
                    set ylabel 'Signal U [uV]'; \
                    outputname='rms_noise.svg'" \
                "$CODEMRI"/BasicPlot.gp

        sh "$CODEMRI/plot.sh" -s -lr 1050 -sw 1000 > "Noise_Spectrum_info.txt"

        echo "\n >-------Details zu x-------<" >> "Noise_Spectrum_info.txt"
        echo "\n >-------Details zu x-------<" >> "rms_noise_info.txt"

        gnuplot -e "set datafile separator ','; stats \"rms_noise.txt\" using 1" 2>> "rms_noise_info.txt"
        gnuplot -e "set datafile separator ','; stats \"Noise_Spectrum.txt\" using 1" 2>> "Noise_Spectrum_info.txt"

        echo "\n >-------Details zu y-------<" >> "Noise_Spectrum_info.txt"
        echo "\n >-------Details zu y-------<" >> "rms_noise_info.txt"

        gnuplot -e "set datafile separator ','; stats \"rms_noise.txt\" using 2" 2>> "rms_noise_info.txt"
        gnuplot -e "set datafile separator ','; stats \"Noise_Spectrum.txt\" using 2" 2>> "Noise_Spectrum_info.txt"
    )
done



echo "\n>--------copying---------<"

for f in */; do
    (
        echo ">--------file: $f---------<"
        cd "$DIR/$f"
        echo "   converting to $FPMRT/Vorschriebe/Bilddateien/${f%/}.svg ..."
        inkscape -w 4000 -h 2400 "rms_noise.svg" -o "$FPMRT/Vorschriebe/Bilddateien/${f%/}_rms_noise.png"
        inkscape -w 4000 -h 2400 "Noise_Spectrum.svg" -o "$FPMRT/Vorschriebe/Bilddateien/${f%/}_Noise_Spectrum.png"
        echo "   done"
    )
done