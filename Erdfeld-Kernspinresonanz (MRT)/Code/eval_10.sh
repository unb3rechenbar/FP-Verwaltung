# get the current directory
DIR="$(pwd)"
echo "Looking for files in: $DIR"

rm -f "T2_times.txt"

for f in */; do
	(
		echo ">-------------<"
		echo "Ordner: $DIR/$f"
		cd "$DIR/$f"

		rm -f *info* *tmp*
		rm -f *_sin*

		FID=$(ls | grep *FID.txt)
		echo "FID: $FID"

		gnuplot -e "data='data_comma.txt'; \
                fid='FID.txt'; \
                dataleg='amplitudes.txt'; \
                fidleg='FID.txt'; \
                paramname='fp_fid_data.txt'; \
                set title 'Max Amplituden bei Anregungszeiten gegen FID'; \
                set xlabel 'Frequency [Hz]'; \
                set ylabel 'Signal U [uV]'; \
                outputname='FID_data.svg'" \
            "$CODEMRI"/BasicDualPlot.gp 2> fp_fid_data.txt

		sh "$CODEMRI"/plot.sh -f -lr 850 > "FID_info.txt"

		# # remove x Values up to start
    	# awk '$1 >= '850' {print $0}' "$FID" > "${FID%.*}"_tmp

		# gnuplot -e "filename='${FID%.*}_tmp'; \
		# 			legname='datapoints'; \
		# 			set title 'FID'; \
		# 			set xlabel 'Time [s]'; \
		# 			set ylabel 'Signal U [uV]'; \
		# 			outputname='FID_sin.svg'" \
		# 		"$CODEMRI"/sinebellPlot.gp 2> "FID_sin_info.txt"


		echo "$f" >> "$DIR/T2_times.txt"

		grep -n "b               = " "$DIR/$f/fp_fid_data.txt" >> "$DIR/T2_times.txt"
	)
done

echo "\n>--------Results---------<"
cat "$DIR/T2_times.txt"

echo "\n>--------copying---------<

for f in */; do
	(
		echo ">--------file: $f---------<"
		cd "$DIR/$f"
		echo "   converting to $FPMRT/Vorschriebe/Bilddateien/${f%/}.svg ..."
		inkscape -w 4000 -h 2400 "FID_data.svg" -o "$FPMRT/Vorschriebe/Bilddateien/${f%/}.png"
		echo "   done"
	)
done