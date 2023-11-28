# get current directory
DIR="$(pwd)"


# define plotting and info function
plotandinfoFID() {
    sh "$CODEMRI/plot.sh" -f -lr "$2" > "${1%.*}_info.txt"

    echo "\n >-------Details zu x-------<" >> "${1%.*}_info.txt"
    gnuplot -e "set datafile separator ','; stats '"$1"' using 1" 2>> "${1%.*}_info.txt"
    
    echo "\n >-------Details zu y-------<" >> "${1%.*}_info.txt"
    gnuplot -e "set datafile separator ','; stats '"$1"' using 2" 2>> "${1%.*}_info.txt"
}

# define plotting and info function for Spectrum
plotandinfoSpectrum() {
    sh "$CODEMRI/plot.sh" -s -lr "$2" > "${1%.*}_info.txt"

    echo "\n >-------Details zu x-------<" >> "${1%.*}_info.txt"
    gnuplot -e "set datafile separator ','; stats '"$1"' using 1" 2>> "${1%.*}_info.txt"
    
    echo "\n >-------Details zu y-------<" >> "${1%.*}_info.txt"
    gnuplot -e "set datafile separator ','; stats '"$1"' using 2" 2>> "${1%.*}_info.txt"
}

for f in */; do
    (
        echo ">-------------<"
        echo "Ordner: $f"
        cd "$DIR/$f"

        # clean all temp and info files
        rm -f *tmp*
        rm -f *info*

    # ----------------- AutoShim -----------------

        if [[ $f =~ "Shim2" ]]; then 
            echo "Evaluating AutoShim"
            
            FID=$(ls | grep *FID.txt)
            Spectrum=$(ls | grep *Spectrum.txt)

            echo "FID: $FID"
            echo "Spectrum: $Spectrum"

        # evaluate the FID
            plotandinfoFID $FID 1000000

            inkscape -w 4000 -h 2400 "${FID%.*}.svg" -o "$FPMRT/Vorschriebe/Bilddateien/5/${f%/}_FID.png"

        # evaluate the spectrum
            plotandinfoSpectrum $Spectrum 25

            inkscape -w 4000 -h 2400 "${Spectrum%.*}.svg" -o "$FPMRT/Vorschriebe/Bilddateien/5/${f%/}_Spectrum.png"

        # evaluate the max amplitude per iteration data
            gnuplot -e "filename='Iteration.txt'; \
                        legname='datapoints'; \
                        set title 'Max Amplitude per Iteration'; \
                        set xlabel 'Iteration'; \
                        set ylabel 'Amplitude in [uV]'; \
                        outputname='Iteration.svg'" \
                    "$CODEMRI"/BasicPlot.gp 2> "Iteration_info.txt"

            inkscape -w 4000 -h 2400 "Iteration.svg" -o "$FPMRT/Vorschriebe/Bilddateien/5/${f%/}_Iteration.png"

            echo "\n >-------Details zu x-------<" >> "Iteration_info.txt"
            gnuplot -e "set datafile separator ','; stats \"Iteration.txt\" using 1" 2>> "Iteration_info.txt"

            echo "\n >-------Details zu y-------<" >> "Iteration_info.txt"
            gnuplot -e "set datafile separator ','; stats \"Iteration.txt\" using 2" 2>> "Iteration_info.txt"

    # ----------------- FID_Explore -----------------

        elif [[ $f =~ "Explore_FID" ]]; then 
            echo "Evaluating Explore_FID"

            FID=$(ls | grep *FID.txt)
            Spectrum=$(ls | grep *Spectrum.txt)

            echo "FID: $FID"
            echo "Spectrum: $Spectrum"

        # evaluate the FID
            plotandinfoFID $FID 1000000



        # evaluate the spectrum
            plotandinfoSpectrum $Spectrum 25
        
        elif [[ $f =~ "C_Opti" ]]; then
            echo "Evaluating C_Opti"

            FID=$(ls | grep *FID.txt)
            Spectrum=$(ls | grep *Spectrum.txt)

            echo "FID: $FID"
            echo "Spectrum: $Spectrum"

        # evaluate the FID
            plotandinfoFID $FID 400

            inkscape -w 4000 -h 2400 "${FID%.*}.svg" -o "$FPMRT/Vorschriebe/Bilddateien/5/${f%/}_FID.png"

        # evaluate the spectrum
            plotandinfoSpectrum $Spectrum 350

            inkscape -w 4000 -h 2400 "${Spectrum%.*}.svg" -o "$FPMRT/Vorschriebe/Bilddateien/5/${f%/}_Spectrum.png"

        elif [[ $f =~ "B1_Opti" ]]; then
            echo "Evaluating B_Opti"

            FID=$(ls | grep *FID.txt)
            Spectrum=$(ls | grep *Spectrum.txt)

            echo "FID: $FID"
            echo "Spectrum: $Spectrum"

        # evaluate the FID
            plotandinfoFID $FID 400

        # evaluate the spectrum
            plotandinfoSpectrum $Spectrum 350

            inkscape -w 4000 -h 2400 "${Spectrum%.*}.svg" -o "$FPMRT/Vorschriebe/Bilddateien/5/${f%/}_Spectrum.png"



        elif [[ $f =~ "B1DurationFast" ]]; then
            echo "Evaluating B1DurationFast"

            FID=$(ls | grep *FID.txt)
            Spectrum=$(ls | grep *Spectrum.txt)
            Error=$(ls | grep *_withError.txt)

            Error_name=${Error%.*}
            Error_name_space=${Error_name//_/ }

            echo "FID: $FID"
            echo "Spectrum: $Spectrum"
            echo "FID amplitude over B1 duration: $Error"

        # evaluate the FID
            plotandinfoFID $FID 1000000

            gnuplot -e "filename='$FID'; \
                        legname='FID data'; \
                        set title 'FID exp. fit'; \
                        set xlabel 'Time [s]'; \
                        set ylabel 'Signal U [uV]'; \
                        outputname='FID_expfit.svg'" \
                    "$CODEMRI"/expPlot.gp 2> "FID_expfit_info.txt"

        # evaluate the spectrum
            plotandinfoSpectrum $Spectrum 250

        # evaluate FIDamp vs B1 Duration


            gnuplot -e "filename='"$Error"'; \
                legname='datapoints'; \
                set title '$Error_name_space'; \
                set xlabel 'B1 duration [ms]'; \
                set ylabel 'Amplitude [uV]'; \
                outputname='$Error_name.svg'" \
            "$CODEMRI"/ErrorPlot.gp 2> "${Error_name}_info.txt"

            # get maximum value of Spectrum
            max_SPEC=$(awk -F',' 'BEGIN{max_SPEC=0} {if ($2     +0>max_SPEC+0) {max_SPEC=$2; xvalue=$1}} END {print     xvalue,max_SPEC}' "$Error")
        
            max_x_SPEC=$(echo "$max_SPEC" | awk -F' ' '{print $1}')
            max_y_SPEC=$(echo "$max_SPEC" | awk -F' ' '{print $2}')
        
            echo "Maximum found at $max_x_SPEC, $max_y_SPEC" > "${Error_name}_info.txt"

            echo "\n >-------Details zu x-------<" >> "${Error_name}_info.txt"
            gnuplot -e "set datafile separator ','; stats '"$Error"' using 1" 2>> "${Error_name}_info.txt"

            echo "\n >-------Details zu y-------<" >> "${Error_name}_info.txt"
            gnuplot -e "set datafile separator ','; stats '"$Error"' using 2" 2>> "${Error_name}_info.txt"

            inkscape -w 4000 -h 2400 "$Error_name.svg" -o "$FPMRT/Vorschriebe/Bilddateien/5/${f%/}_${Error_name}.png"

            gnuplot -e "filename='"$Error"'; \
                legname='datapoints'; \
                set title '$Error_name_space'; \
                set xlabel 'B1 duration [ms]'; \
                set ylabel 'Amplitude [uV]'; \
                outputname='${Error_name}_poly.svg'" \
            "$CODEMRI"/PolyPlot.gp 2> "${Error_name}_poly.txt"

            inkscape -w 4000 -h 2400 "${Error_name}_poly.svg" -o "$FPMRT/Vorschriebe/Bilddateien/5/${f%/}_${Error_name}_poly.png"

        fi
    )
done