# get the current directory
DIR="$(pwd)"
echo "Looking for files in: $DIR"



for f in */; do
    (
        echo ">-------------<"
        echo "Ordner: $DIR/$f"
        cd "$DIR/$f"

        # clean all temp and info files


        FID=$(ls | grep *FID.txt)
        T1=$(ls | grep *withError.txt)

        echo "FID: $FID"
        echo "T1: $T1"

    # evaluate the FID
        sh "$CODEMRI/plot.sh" -f -lr 1000000 > "${FID%.*}_info.txt"

        
    # evaluate T1
        gnuplot -e "filename='$T1'; \
                    legname='datapoints'; \
                    set title 'T1 with exponential fit'; \
                    set xlabel 'Time [s]'; \
                    set ylabel 'Attenuation [uV]'; \
                    outputname='${T1%.*}_exp.svg'; \
                " "$CODEMRI/oneminusexpPlot.gp" 2> "${T1%.*}_exp_info.txt"

        if [[ $f =~ "20steps" ]]; then
            inkscape -w 4000 -h 2400 "${T1%.*}_exp.svg" -o "$FPMRT/Vorschriebe/Bilddateien/8/ ${f%/}_exp.png"
        fi

    )
done