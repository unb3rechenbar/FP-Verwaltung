# get the current directory
DIR="$(pwd)"
echo "Looking for files in: $DIR"

rm -f "Lamour_values.txt"

for f in */; do
    (
        echo ">-------------<"
        echo "Ordner: $DIR/$f"
        cd "$DIR/$f"

        FID=$(ls | grep *FID.txt)
        Spectrum=$(ls | grep *Spectrum.txt)

        FIDNAME=${FID%.*}
        SPECNAME=${Spectrum%.*}

        echo "$SPECNAME"

        sh "$CODEMRI/plot.sh" -f -lr 1000000 > "$FIDNAME"_info.txt
        sh "$CODEMRI/plot.sh" -s -lr 25 > "$SPECNAME"_info.txt

        echo "\n >-------Details zu x-------<" >> "$FIDNAME"_info.txt
        echo "\n >-------Details zu x-------<" >> "$SPECNAME"_info.txt

        gnuplot -e "set datafile separator ','; stats \"$FID\" using 1" 2>> "$FIDNAME"_info.txt
        gnuplot -e "set datafile separator ','; stats \"$Spectrum\" using 1" 2>> "$SPECNAME"_info.txt


        echo "\n >-------Details zu y-------<" >> "$FIDNAME"_info.txt
        echo "\n >-------Details zu y-------<" >> "$SPECNAME"_info.txt

        gnuplot -e "set datafile separator ','; stats \"$FID\" using 2" 2>> "$FIDNAME"_info.txt
        gnuplot -e "set datafile separator ','; stats \"$Spectrum\" using 2" 2>> "$SPECNAME"_info.txt

        echo "$f" >> "$DIR/Lamour_values.txt"
        grep -n "Maximum found at " "$SPECNAME"_info.txt >> "$DIR/Lamour_values.txt"

        # gnuplot -e "filename='$Spectrum'; \
        #             legname='datapoints'; \
        #             set title 'Lorentzian Fit'; \
        #             set xlabel 'Frequency [Hz]'; \
        #             set ylabel 'Signal U [uV]'; \
        #             outputname='${Spectrum%.*}_lorentz.svg'; \
        #         " "$CODEMRI/LorentzPlot.gp"

    )
done

echo "\n>--------Results---------<"
cat "$DIR/Lamour_values.txt"

echo "\n>--------copying---------<"

for f in */; do
    (
        echo ">--------file: $f---------<"
        cd "$DIR/$f"
        echo "   converting to $FPMRT/Vorschriebe/Bilddateien/2/${f%/}.svg ..."
        FID=$(ls | grep *FID.txt)
        Spectrum=$(ls | grep *Spectrum.txt)

        FIDNAME=${FID%.*}
        SPECNAME=${Spectrum%.*}

        inkscape -w 4000 -h 2400 "$FIDNAME.svg" -o "$FPMRT/Vorschriebe/Bilddateien/2/${f%/}_FID.png"
        inkscape -w 4000 -h 2400 "$SPECNAME.svg" -o "$FPMRT/Vorschriebe/Bilddateien/2/${f%/}_Spectrum.png"
        echo "   done"
    )
done

