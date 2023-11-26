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

        if [[ $f =~ "Auto" ]]; then 
            echo "Evaluating AutoShim"
            
            FID=$(ls | grep *FID.txt)
            Spectrum=$(ls | grep *Spectrum.txt)

            echo "FID: $FID"
            echo "Spectrum: $Spectrum"

        # evaluate the FID
            plotandinfoFID $FID 1000000

        # evaluate the spectrum
            plotandinfoSpectrum $Spectrum 25

        # evaluate the max amplitude per iteration data
            gnuplot -e "filename='Iteration.txt'; \
                        legname='max Amplitude per Iteration'; \
                        set title 'Max Amplitude per Iteration'; \
                        set xlabel 'Iteration'; \
                        set ylabel 'Amplitude'; \
                        outputname='Iteration.svg'" \
                    "$CODEMRI"/BasicPlot.gp 2> "Iteration_info.txt"

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

        # evaluate the spectrum
            plotandinfoSpectrum $Spectrum 350

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
            "$CODEMRI"/ErrorPlot.gp

            inkscape -w 4000 -h 2400 "$Error_name.svg" -o "$FPMRT/Vorschriebe/Bilddateien/${f%/}_${Error_name}.png"

            gnuplot -e "filename='"$Error"'; \
                legname='datapoints'; \
                set title '$Error_name_space'; \
                set xlabel 'B1 duration [ms]'; \
                set ylabel 'Amplitude [uV]'; \
                outputname='${Error_name}_poly.svg'" \
            "$CODEMRI"/PolyPlot.gp 2> "${Error_name}_poly.txt"

            inkscape -w 4000 -h 2400 "${Error_name}_poly.svg" -o "$FPMRT/Vorschriebe/Bilddateien/${f%/}_${Error_name}_poly.png"

        fi
    )
done