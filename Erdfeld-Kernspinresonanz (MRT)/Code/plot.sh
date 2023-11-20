# Shell Script for plotting data from MRI
#
# conciders: 
#	-> *FID.txt
#	-> *Spectrum.txt
#

# ------------------- Settings -------------------

# Pre-SETTINGS
linerange=100

# check for user flags
while [[ $# -gt 0 ]]; do
    case "$1" in 
        -lr|--linerange)
            linerange="$2"
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
echo "Code directory: $CODEDIR"

# remove possible temporary files from previous runs
rm *_plotlines 2> /dev/null
rm *_tmp* 2> /dev/null

# get the files
FID=$(ls | grep *FID.txt)
Spectrum=$(ls | grep *Spectrum.txt)


# check if files exist and execute accordingly
# ------------------- FID -------------------

if [ -z "$FID" ]; then
    echo "No FID.txt found!"
else
    echo "Found FID.txt: $FID"

    # strip the file endings and replace '_' with ' '
    FID_name=${FID%.*}
    FID_name=${FID_name//_/ }

    # plot the files
    gnuplot -e "filename='$FID'; \
                legname='$FID_name'; \
                set title '$FID_name'; \
                set xlabel 'Time [s]'; \
                set ylabel 'Signal U [uV]'; \
                outputname='FID_plot.svg'" \
            "$CODEDIR"/BasicPlot.gp
fi


# ------------------- Spectrum -------------------

if [ -z "$Spectrum" ]; then
    echo "No Spectrum.txt found!"
else
    echo "Found Spectrum.txt: $Spectrum"

    Spectrum_name=${Spectrum%.*}
    Spectrum_name=${Spectrum_name//_/ }

    # remove negative x values from spectrum
    awk '$1 >= 0 {print $0}' "$Spectrum" > "$Spectrum"_tmp
    
    # get maximum value of Spectrum
    max=$(awk -F',' 'BEGIN{max=0} {if ($2+0>max+0) {max=$2; xvalue=$1}} END {print xvalue,max}' "$Spectrum"_tmp)
    echo "Maximum value of Spectrum: $max"

    # manipulate max string for search
    maxsearch=${max// /,}
    echo "Searching for: $maxsearch"

    # get line of maximum value
    maxline=$(grep -n "$maxsearch" "$Spectrum"_tmp | awk -F':' '{print $1}')
    echo "Line of max in dataset: $maxline"

    # set range for sed
    negrange=$((($maxline-$linerange>0) ? $maxline-$linerange : 1))
    posrange=$(($maxline+$linerange))

    echo "using lines $negrange to $posrange"

    # get the lines for plotting
    sed -n "$negrange,$posrange p" "$Spectrum"_tmp > "$Spectrum"_plotlines

    gnuplot -e "filename='"$Spectrum"_plotlines'; \
                legname='$Spectrum_name'; \
                set title '$Spectrum_name'; \
                set xlabel 'Frequency [Hz]'; \
                set ylabel 'Signal U [uV]'; \
                outputname='Spectrum_plot.svg'" \
            "$CODEDIR"/BasicPlot.gp

    # remove temporary file
    rm "$Spectrum"_plotlines
    rm "$Spectrum"_tmp
fi
