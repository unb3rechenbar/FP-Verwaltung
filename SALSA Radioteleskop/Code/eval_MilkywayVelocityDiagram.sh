# Skript zur Erzeugung der Geschwindigkeitsverteilung über die galaktische Länge der Milchstraße


# >------------------ VARIABLEN ------------------<
source="$FPSALSA/Versuchsdaten/Teleskopmessungen"
target="$FPSALSA/Auswertungsdaten/MilkywayMaxVelocity"

submit="$FPSALSA/Versuchsbericht/Bilddateien/MilkyVelocity"

relevant_spectrums_min="64938"
relevant_spectrums_max="64950"

gallactic_length=(30 35 40 45 50 55 60 65 70 75 80 85 90)

index=0

# >------------------ FUNKTIONEN ------------------<
function get_relavant_velocity() {
    echo $(tail -n +8 "$1" | awk '{print $1}')
}
function get_relevant_intensity() {
    echo $(tail -n +8 "$1" | awk '{print $2}')
}

# >------------------ VORBEREITUNG ------------------<
rm "$target/max_intensity_velocity.txt" "$target/max_intensity_velocity_smoothed.txt" 2> /dev/null


# >------------------ HAUPTPROGRAMM ------------------<

for folder in "$source"/*; do
    # check if folder number is in relevant range
    folder_name=$(basename "$folder")
    folder_number=$(echo "$folder_name" | cut -d "_" -f 2)
    
    if [ "$folder_number" -lt "$relevant_spectrums_min" ] || [ "$folder_number" -gt "$relevant_spectrums_max" ]; then
        continue
    fi

    datafile="$folder/$(basename "$folder").txt"
    filename=$(basename "$datafile")
    sdatafile="$folder/smoothed_$filename"
    fsdatafile="$folder/fit_smoothed_$filename"
    pdatafile="$folder/peaks_smoothed_$filename"
    fparafile="$folder/fit_parameters_smoothed_$filename"

    echo "\n<--> processing $filename <-->"

    velocitys=$(awk '{print $2}' "$fparafile")
    intensitys=$(awk '{print $1}' "$datafile")

    # get max from absolute values of velocitys
    max_velocity=$(echo $velocitys | tr '\n' ' ' | xargs -n1 | sort -n | tail -n 1)

    echo "velocitys: $velocitys"
    echo "max intensity: $max_velocity"

    # 1.3 write to file
    echo "  \033[0;36m${index}.3\033[0m writing to file"
    echo "1,$max_velocity,${gallactic_length[$index]}" >> "$target/max_intensity_velocity.txt"

    index=$((index+1))
done


# >-- Plotting --<

gnuplot -e "filename='$target/max_intensity_velocity.txt'; \
            outputname='$target/max_intensity_velocity.svg'; \
            xline=1; \
            yline=2; \
            legname='data'; \
            set datafile separator ','; \
        " "$SHELLC/Universität/Fortgeschrittenenpraktikum/Auswertung/Gnuplot/DotPlot.gp"


gnuplot -e "filename='$target/max_intensity_velocity.txt'; \
            outputname='$target/velocity_radius.pdf'; \
            iline=1; \
            vline=2; \
            lline=3; \
            legname='data'; \
            set datafile separator ','; \
        " "$FPSALSA/Code/Modules/MilkywayVelocity.gp"



# >-- Submit --<
cp "$target/velocity_radius.pdf" "$submit/velocity_radius.pdf"