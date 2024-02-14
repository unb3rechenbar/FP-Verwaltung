# Skript zur Dokumentation der Messungen im Rahmen des Salsa Versuchs.
# 
# Tom Folgmann, 30.01.2024
# 

log_path=$FPSALSA/Versuchsdaten
log_name=Datensatzdokumentation.csv
plot_path=$log_path/Plots
fit_path=$log_path/Fits
fit_info_path=$log_path/FitInfo


# >------------- FLAGS --------------<
while [[ $# -gt 0 ]]; do
    case "$1" in
        --autotime)
            year=$(date +"%Y")
            month=$(date +"%m")
            day=$(date +"%d")
            hour=$(date +"%H")
            minute=$(date +"%M")
            second=$(date +"%S")
            autotime=true
            shift
            ;;
        --today)
            year=$(date +"%Y")
            month=$(date +"%m")
            day=$(date +"%d")
            shift
            ;;
        --thishour)
            hour=$(date +"%H")
            shift
            ;;
        -fn|--filename)
            filename="$2"
            shift
            shift
            ;;
        -y|--year)
            year="$2"
            shift
            shift
            ;;
        -m|--month)
            month="$2"
            shift
            shift
            ;;
        -d|--day)
            day="$2"
            shift
            shift
            ;;
        -h|--hour)
            hour="$2"
            shift
            shift
            ;;
        -thismin)
            minute=$(date +"%M")
            shift
            ;;
        -min|--minute)
            minute="$2"
            shift
            shift
            ;;
        -s|--second)
            second="$2"
            shift
            shift
            ;;
        -dalt|--displacement_altitude)
            displacement_altitude="$2"
            shift
            shift
            ;;
        -daz|--displacement_azimuth)
            displacement_azimuth="$2"
            shift
            shift
            ;;
        -tp|--total_power)
            total_power="$2"
            shift
            shift
            ;;
        -intt)
            int_time="$2"
            shift
            shift
            ;;
        --notes)
            notes="$2"
            shift
            shift
            ;;
    esac
done

echo "Flags read"

# >------------- DOCUMENTATION --------------<
echo "\n>------------- PREPARATION --------------<"
echo "-> getting last measurement number"
current_number=$(awk -F ',' 'END{print $1}' "$log_path/$log_name")
next_number=$(expr $current_number + 1)
str_next_number=$(printf "%04d" $next_number)


echo "\n>------------- DOCUMENTATION --------------<"
echo "--> Current number: $current_number, next number: $str_next_number\n"

echo "Details der Messung:"
echo "-> Dateiname im Archiv: $filename"
echo "-> Datum: $day.$month.$year"
echo "-> Uhrzeit: $hour:$minute:$second"
echo "-> Verschiebung in Höhe: $displacement_altitude"
echo "-> Verschiebung in Azimut: $displacement_azimuth"
echo "-> Integrationszeit: $int_time"s

if [ "$notes" != "" ]; then
    echo "-> Notizen: $notes"
fi

if [ "$autotime" = true ]; then
    read -p "-> Gemessene Sonnenleistung: " total_power
else
    echo "-> Gemessene Sonnenleistung: $total_power\n"
fi


echo "-> Speichere Messung ab .."
echo "$str_next_number,$filename,$year,$month,$day,$hour,$minute,$second,$displacement_altitude,$displacement_azimuth,$total_power,$int_time,$notes" >> "$log_path/$log_name"


# >------------- PLOTTING --------------<
echo "\n>------------- PLOTTING --------------<"
echo "-> Plotte Messung .."
gnuplot -e "filename='$log_path/$log_name'; \
            outputname='$plot_path/${log_name}_plot.svg'; \
        " "$FPSALSA/Code/live_colorplot_sunpower.gp"

echo "-> Plotte x-z Daten .."
gnuplot -e "set xlabel 'ΔAlt (deg)'; \
            set ylabel 'Intensität'; \
            filename='$log_path/$log_name'; \
            outputname='$plot_path/${log_name}_plot_altitude.svg'; \
            legname='Datenpunkte'; \
            xline=9; \
            yline=11; \
            " "$SHELLC/Universität/Fortgeschrittenenpraktikum/Auswertung/Gnuplot/BasicPlot.gp"

echo "-> Plotte y-z Daten .."
gnuplot -e "set xlabel 'ΔAz (deg)'; \
            set ylabel 'Intensität'; \
            filename='$log_path/$log_name'; \
            outputname='$plot_path/${log_name}_plot_azimuth.svg'; \
            legname='Datenpunkte'; \
            xline=10; \
            yline=11; \
            " "$SHELLC/Universität/Fortgeschrittenenpraktikum/Auswertung/Gnuplot/BasicPlot.gp"


# >------------- FITTING --------------<
echo "\n>------------- FITTING --------------<"
echo "-> Fitting der x-z Daten mittels Gaußfunktion .."
gnuplot -e "set xlabel 'ΔAlt (deg)'; \
            set ylabel 'Intensität'; \
            filename='$log_path/$log_name'; \
            outputname='$fit_path/${log_name}_fit_altitude.svg'; \
            legname='Datenpunkte'; \
            xline=9; \
            yline=11; \
            aguess=1; \
            bguess=1; \
            cguess=1; \
            " "$SHELLC/Universität/Fortgeschrittenenpraktikum/Auswertung/Gnuplot/BasicFit.gp" 2> "$fit_info_path/${log_name}_fitinfo_altitude.txt"

echo "-> Fitting der y-z Daten mittels Gaußfunktion .."
gnuplot -e "set xlabel 'ΔAz (deg)'; \
            set ylabel 'Intensität'; \
            filename='$log_path/$log_name'; \
            outputname='$fit_path/${log_name}_fit_azimuth.svg'; \
            legname='Datenpunkte'; \
            xline=10; \
            yline=11; \
            aguess=1; \
            bguess=1; \
            cguess=1; \
            " "$SHELLC/Universität/Fortgeschrittenenpraktikum/Auswertung/Gnuplot/BasicFit.gp" 2> "$fit_info_path/${log_name}_fitinfo_azimuth.txt"

# >------------- BACKUP --------------<
echo "\n>------------- BACKUP --------------<"
echo "-> Backup der Messung"

now=$(date +"%Y_%m_%d_%H_%M_%S")
cp "$log_path/$log_name" "$log_path/Backup/$now.csv"