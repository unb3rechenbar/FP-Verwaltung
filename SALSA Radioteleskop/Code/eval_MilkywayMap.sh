# Skript zur Erzeugung der Karte der Milchstraße


# >------------------ VARIABLEN ------------------<
source="$FPSALSA/Versuchsdaten/Teleskopmessungen"
target="$FPSALSA/Auswertungsdaten/MilkywayMap"

relevant_spectrums_min="64938"
relevant_spectrums_max="64992"

gallactic_length=(30 35 40 45 50 55 60 65 70 75 80 85 90 90 100 110 120 130 140 150 160 170 180 190 200 210 215)

index=1

# >------------------ FUNKTIONEN ------------------<


# >------------------ FLAGS ------------------<
while [[ $# -gt 0 ]]; do 
    case "$1" in
        --eval)
            evalflag=true
            ;;
        --plot)
            plotflag=true
            ;;
        --all)
            evalflag=true
            plotflag=true
            ;;
        *)
            echo "Unknown flag: $1"
            exit 1
            ;;
    esac
    shift
done

# >------------------ VORBEREITUNG ------------------<
if [ "$evalflag" = true ]; then
    rm "$target/peaks.txt" 2> /dev/null

    mkdir -p "$target/pngs"
    mkdir -p "$target/svgs"
fi


# >------------------ HAUPTPROGRAMM ------------------<
if [ "$evalflag" = true ]; then
    for folder in "$source"/*; do
        # -> set up names
        folder_name=$(basename "$folder")
        folder_number=$(echo "$folder_name" | cut -d "_" -f 2)
        filename=$folder_name.txt
        file_path=$folder/$filename

        sfilename=smoothed_$filename
        sfile_path=$folder/$sfilename

        fsfilename=fit_$sfilename
        fsfile_path=$folder/$fsfilename

        pfilename=peaks_$sfilename
        pfile_path=$folder/$pfilename

        paramfilename=fit_parameters_$sfilename
        paramfile_path=$folder/$paramfilename

        # check if folder number is in relevant range
        if [ "$folder_number" -lt "$relevant_spectrums_min" ] || [ "$folder_number" -gt "$relevant_spectrums_max" ]; then
            continue
        fi

        echo "\n<--> processing $filename <-->"

        # 1.1 smoothen data
        echo "  \033[0;36m${index}.1\033[0m smoothening data .."
        if [ $((relevant_spectrums_min - 1 + index)) -lt 64979 ]; then
            python3.11 "$FPSALSA/Code/Modules/smoothing.py" --input "$file_path" --sigma 1
        else
            python3.11 "$FPSALSA/Code/Modules/smoothing.py" --input "$file_path" --sigma 1
        fi

        # 1.2 plot smoothened data
        echo "  \033[0;36m${index}.2\033[0m plotting smoothened data .."
        gnuplot -e "filename='$sfile_path'; \
                    outputname='$folder/${sfilename%.*}.svg'; \
                    xline=1; \
                    yline=2; \
                    legname='Datenpunkte'; \
                    xlabel='Geschwindigkeit (km/s)'; \
                    ylabel='Intensität (arb. u.)'; \
                    " "$SHELLC/Universität/Fortgeschrittenenpraktikum/Auswertung/Gnuplot/BasicPlot.gp"

        # 1.3 fit multiple gauusians
        echo "  \033[0;36m${index}.3\033[0m fitting multiple gaussians .."
        python3.11 "$FPSALSA/Code/Modules/gaussian_sum_fit.py" --input "$sfile_path" --galactic-length "${gallactic_length[$index-1]}"

        # 1.4 plot gaussian sum
        echo "  \033[0;36m${index}.4\033[0m plotting gaussian sum .."
        gnuplot -e "filename='$fsfile_path'; \
                    outputname='$folder/${fsfilename%.*}.svg'; \
                    xline=1; \
                    yline=2; \
                    legname='Datenpunkte'; \
                    xlabel='Geschwindigkeit (km/s)'; \
                    ylabel='Intensität (arb. u.)'; \
                    set datafile separator ' '; \
                    " "$SHELLC/Universität/Fortgeschrittenenpraktikum/Auswertung/Gnuplot/BasicPlot.gp"

        # 1.5 combine with previous data
        echo "  \033[0;36m${index}.5\033[0m combining with previous data .."

        awk -v var="${gallactic_length[$index-1]}" '{print $0, var}' "$pfile_path" >> "$target/peaks.txt"

        # "$(cat "$pfile_path") ${gallactic_length[$index-1]}" >> "$target/peaks.txt"

        # i.6 generate svg
        echo "  \033[0;36m${index}.6\033[0m generating svg .."

        gnuplot -e "fspectrum='$file_path'; \
                    fsmooth='$sfile_path'; \
                    ffit='$fsfile_path'; \
                    outputname='$target/svgs/${folder_name%.*}.svg'; \
                    " "$FPSALSA/Code/Modules/MilkywayCombinedPeaks.gp"

        cp "$FPSALSA/Code/Modules/MilkywayCombinedPeaks.gp" /tmp/MilkywayCombinedPeaks.gp

        lines=$(wc -l "$paramfile_path" | awk '{print $1}')
        echo "lines: $lines"

        findex=1
        cat "$paramfile_path" | while read zeile; do
            amplitude=$(awk '{print $1}' <<< "$zeile")
            center=$(awk '{print $2}' <<< "$zeile")
            sigma=$(awk '{print $3}' <<< "$zeile")

            # check if amplitude is greater than 0
            if [ $(echo "$center >= 0" | bc -l) -eq 1 ]; then
                fnct="$amplitude*exp(-((x-$center)**2/(2*($sigma)**2)))"
            else
                fnct="$amplitude*exp(-((x-$center)**2/(2*($sigma)**2)))"
            fi

            if [ $findex -lt $lines ]; then
                echo "$fnct w l lw 2 notitle, \\" >> /tmp/MilkywayCombinedPeaks.gp
            else
                echo "$fnct w l lw 2 notitle" >> /tmp/MilkywayCombinedPeaks.gp
            fi

            findex=$((findex + 1))
        done

        gnuplot -e "fspectrum='$file_path'; \
                    fsmooth='$sfile_path'; \
                    ffit='$fsfile_path'; \
                    outputname='$target/pdfs/combined_${folder_name%.*}.pdf'; \
                " /tmp/MilkywayCombinedPeaks.gp 

        rm /tmp/MilkywayCombinedPeaks.gp

        # 1.7 generate pngs
        # echo "  \033[0;36m${index}.7\033[0m generating png .."
        # svg2png -w 4000 -h 2400 "$target/svgs/${folder_name%.*}.svg" > "$target/pngs/${folder_name%.*}.png"

        index=$((index + 1))
    done
fi



# >------------------ Plot of the Milkyway ------------------<
if [ "$plotflag" = true ]; then
    echo "\n>------------------ Plot of the Milkyway ------------------<"
    gnuplot -e "peakfile='$target/peaks.txt'; \
                outputname='$target/MilkywayMap.pdf'; \
                " "$FPSALSA/Code/Modules/MilkywayMap.gp"

    svg2png -w 4000 -h 2400 "$target/MilkywayMap.svg" > "$target/MilkywayMap.png"
fi
            
