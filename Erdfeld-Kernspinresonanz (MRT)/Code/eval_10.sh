# get the current directory
DIR="$(pwd)"
echo "Looking for files in: $DIR"

rm -f "T2_times.txt"

for f in */; do
	(
		echo ">-------------<"
		echo "Ordner: $DIR/$f"
		cd "$DIR/$f"
		sh "$CODEMRI/combine_FID_data_10.sh" 2> fp_fid_data.txt

		echo "$f" >> "$DIR/T2_times.txt"

		grep -n "b               = " "$DIR/$f/fp_fid_data.txt" >> "$DIR/T2_times.txt"
	)
done

echo "\n>--------Results---------<"
cat "$DIR/T2_times.txt"
