if [[ "$(basename "$(pwd)")" != "i-Geschwindigkeitskurve" ]]; then
    echo "Please run this script from the i-Geschwindigkeitskurve directory."
    exit 1
fi

start_num="0073"
end_num="0085"

log_path="$FPSALSA/Versuchsdaten"
log_name="Datensatzdokumentation.csv"

eval_path="$FPSALSA/Auswertungsdaten/i-Geschwindigkeitskurve"
eval_name="PowerOverAltitude.csv"

echo ">------------- EVALUATE VELOCITYCURVE MILKYWAY --------------<"
echo "-> Start number: $start_num, end number: $end_num"

echo "-> getting relevant datapoints .."
awk -F ',' -v start_num="$start_num" -v end_num="$end_num" '($1 + 0 == 0) || ($1 + 0 >= start_num + 0 && $1 + 0 <= end_num + 0) {print $0}' "$log_path/$log_name" > "$eval_path/$eval_name"



echo ">------------- PLOTTING --------------<"
echo "-> plotting measured power over altitude .."

gnuplot -e "set xlabel 'ΔAlt (deg)'; \
            set ylabel 'Leistung (W)'; \
            xline=9; \
            yline=11; \
            filename='$eval_path/$eval_name'; \
            outputname='$eval_path/${eval_name}_plot.svg'; \
            legname='Datenpunkte'; \
        " "$SHELLC/Universität/Fortgeschrittenenpraktikum/Auswertung/Gnuplot/BasicPlot.gp"

            