# Skript zur Erzeugung der Karte der Milchstraße


# >------------------ VARIABLEN ------------------<
source="$FPSALSA/Versuchsdaten/Teleskopmessungen"
target="$FPSALSA/Auswertungsdaten/Signal"

relevant_spectrums_min="64931"
relevant_spectrums_max="64937"

gallactic_length=100

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
index=0

time=("1s" "3s" "10s" "30s" "100s" "300s" "10s (signal mode data)")


# >------------------ HAUPTPROGRAMM ------------------<
if [ "$evalflag" = true ]; then
    for folder in "$source"/*; do
        #i.0 set names
        folder_name=$(basename "$folder")
        folder_number=$(echo "$folder_name" | cut -d "_" -f 2)

        filename=$folder_name.txt
        file_path=$folder/$filename

        target_path=$target/$folder_name.pdf

        #i.1 check if folder number is in relevant range
        if [ "$folder_number" -lt "$relevant_spectrums_min" ] || [ "$folder_number" -gt "$relevant_spectrums_max" ]; then
            continue
        fi

        #i.2 plot every spectrum
        gnuplot -e "filename='$file_path'; \
                    outputname='$target_path'; \
                    set xlabel 'rel. velocity (km/s)'; \
                    set ylabel 'intensity (arbitrary units)'; \
                    xline=1; \
                    yline=2; \
                    legname='δt=${time[$index]}'; \
                    set datafile separator ' '; \
                    " "$SHELLC/Universität/Fortgeschrittenenpraktikum/Auswertung/Gnuplot/BasicPlot.gp"

        index=$((index+1))
    done
fi


echo "Plotting 64931 and 64936 together .."
gnuplot -e "filename1='$source/spectrum_64931/spectrum_64931.txt'; \
            filename2='$source/spectrum_64936/spectrum_64936.txt'; \
            outputname='$target/spectrum_64931_64936.pdf'; \
            set xlabel 'rel. velocity (km/s)'; \
            set ylabel 'intensity (arbitrary units)'; \
            xline1=1; \
            yline1=2; \
            xline2=1; \
            yline2=2; \
            legname1='δt=1s'; \
            legname2='δt=300s'; \
            set datafile separator ' '; \
            " "$SHELLC/Universität/Fortgeschrittenenpraktikum/Auswertung/Gnuplot/BasicDualPlot.gp"




