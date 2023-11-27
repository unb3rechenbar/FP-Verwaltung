# Shell Script for plotting data from MRI
#
# conciders: 
#	-> *FID.txt
#	-> *Spectrum.txt
#

# ------------------- Settings -------------------

# Pre-SETTINGS
linerange=100
plot_spectrum=0
plot_fid=0
plot_error=0
min_ratio_FID=0.01
start=0

# check for user flags
while [[ $# -gt 0 ]]; do
    case "$1" in 
        -lr|--linerange)
            linerange="$2"
            ;;
        -s|--spectrum)
            plot_spectrum=1
            ;;
        -f|--fid)
            plot_fid=1
            ;;
        -ep|--errorplot)
            plot_error=1
            ;;
        -sw|--start)
            start="$2"
            ;;
        *)
            echo "Unknown flag: $1"
            ;;
    esac
    shift
done

# ------------------- Preparation -------------------
# get the current directory
DIR="$(pwd)"
echo "Looking for files in: $DIR"

# get code directory
CODEDIR="$(dirname "$0")"
echo "Code directory: $CODEDIR\n"

# remove possible temporary files from previous runs
rm *_plotlines 2> /dev/null
rm *_tmp* 2> /dev/null

# get the files
FID=$(ls | grep *FID.txt)
Spectrum=$(ls | grep *Spectrum.txt)
Error=$(ls | grep *_withError.txt)


# check if files exist and execute accordingly
# ------------------- FID -------------------

if [ -z "$FID" ] && [ "$plot_fid" = 1 ]; then
    echo "No FID.txt found!"
elif [ $plot_fid = 1 ]; then
    echo "Found FID.txt: $FID"

    # strip the file endings and replace '_' with ' '
    FID_name=${FID%.*}
    FID_name_space=${FID_name//_/ }

    # get maximum value of FID
    max_FID=$(awk -F',' 'BEGIN{max_FID=0} {if ($2+0>max_FID+0) {max_FID=$2; xvalue=$1}} END {print xvalue,max_FID}' "$FID")
    echo "Maximum value of FID: $max_FID"

    # manipulate max_FID string for search
    maxsearch=${max_FID// /,}

    # remove x Values up to start
    awk '$1 >= '"$start"' {print $0}' "$FID" > "$FID_name"_tmp

    # get line of maximum value
    maxline=$(grep -n "$maxsearch" "$FID_name"_tmp | awk -F':' '{print $1}')
    echo "Line of max_FID in dataset: $maxline"

    # set range for sed
    negrange=$((($maxline-$linerange>0) ? $maxline-$linerange : 1))
    posrange=$(($maxline+$linerange))
    echo "using lines $negrange to $posrange (range = $linerange)"

    # get the lines for plotting
    sed -n "$negrange,$posrange p" "$FID" > "$FID_name"_tmp

    # plot the files
    gnuplot -e "filename='"$FID_name"_tmp'; \
                legname='datapoints'; \
                set title '$FID_name_space'; \
                set xlabel 'Time [s]'; \
                set ylabel 'Signal U [uV]'; \
                outputname='$FID_name.svg'" \
            "$CODEDIR"/BasicPlot.gp

    # remove temporary file
    rm "$FID_name"_tmp
fi

# ------------------- Spectrum -------------------

if [ -z "$Spectrum" ] && [ "$plot_spectrum" = 1 ]; then
    echo "No Spectrum.txt found!"
elif [ $plot_spectrum = 1 ]; then
    echo "\n Found Spectrum.txt: $Spectrum"

    Spectrum_name=${Spectrum%.*}
    Spectrum_name_space=${Spectrum_name//_/ } 

    # remove negative x values from spectrum (or more)
    awk -F',' '$1 >= '"$start"' {print $0}' "$Spectrum" > "$Spectrum"_tmp
    
    # get maximum value of Spectrum
    max_SPEC=$(awk -F',' 'BEGIN{max_SPEC=0} {if ($2+0>max_SPEC+0) {max_SPEC=$2; xvalue=$1}} END {print xvalue,max_SPEC}' "$Spectrum"_tmp)

    max_x_SPEC=$(echo "$max_SPEC" | awk -F' ' '{print $1}')
    max_y_SPEC=$(echo "$max_SPEC" | awk -F' ' '{print $2}')

    echo "Maximum found at $max_x_SPEC, $max_y_SPEC"

    # manipulate max_SPEC string for search
    maxsearch=${max_SPEC// /,}
    echo "Searching for: $maxsearch"

    # get line of maximum value
    maxline=$(grep -n "$maxsearch" "$Spectrum"_tmp | awk -F':' '{print $1}')
    echo "Line of max_SPEC in dataset: $maxline"

    # set range for sed
    negrange=$((($maxline-$linerange>0) ? $maxline-$linerange : 1))
    posrange=$(($maxline+$linerange))

    echo "using lines $negrange to $posrange (range = $linerange)"

    # get the lines for plotting
    sed -n "$negrange,$posrange p" "$Spectrum"_tmp > "$Spectrum"_plotlines

    gnuplot -e "filename='"$Spectrum"_plotlines'; \
                legname='datapoints'; \
                set title '$Spectrum_name_space'; \
                set xlabel 'Frequency [Hz]'; \
                set ylabel 'Signal U [uV]'; \
                outputname='$Spectrum_name.svg'" \
            "$CODEDIR"/BasicPlot.gp

    # remove temporary file
    rm "$Spectrum"_plotlines
    rm "$Spectrum"_tmp
fi

# ------------------- Ratios -------------------
if [ -z "$Error" ] && [ "$plot_error" = 1 ]; then
    echo "No *_withError.txt found!"
elif [ $plot_error = 1 ]; then
    echo "\n Found *_withError.txt: $Error"

    Error_name=${Error%.*}
    Error_name_space=${Error_name//_/ }

    # get maximum value of Spectrum
    max_SPEC=$(awk -F',' 'BEGIN{max_SPEC=0} {if ($2+0>max_SPEC+0) {max_SPEC=$2; xvalue=$1}} END {print xvalue,max_SPEC}' "$Error"_tmp)

    max_x_SPEC=$(echo "$max_SPEC" | awk -F' ' '{print $1}')
    max_y_SPEC=$(echo "$max_SPEC" | awk -F' ' '{print $2}')

    echo "Maximum found at $max_x_SPEC, $max_y_SPEC"

    rm -f "$Error"_tmp

    gnuplot -e "filename='"$Error"'; \
                legname='datapoints'; \
                set title '$Error_name_space'; \
                set xlabel 'Frequency [Hz]'; \
                set ylabel 'Amplitude E/E_0 [uV]'; \
                outputname='$Error_name.svg'" \
            "$CODEDIR"/ErrorPlot.gp

fi
