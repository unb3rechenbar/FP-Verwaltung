
if [[ -z $1 ]]; then 
    echo "No argument given. Please specify the folder path from which to extract the data."
    exit 1
fi

vName=$1

# get current date and time
now=$(date +"%d.%m.%Y %H.%M")

mkdir "$FPMRT/Versuchsbericht/Version $now"

# copy all files in vName to the new folder
cp -r "$vName/" "$FPMRT/Versuchsbericht/Version $now/"



(
    cd "$FPMRT/Versuchsbericht/Version $now/"

    echo "\t compiling the latex file... (it. 1/3)"
    pdflatex -interaction=nonstopmode main.tex > "$FPMRT/Versuchsbericht/Version $now/latex_log_1.txt"
    wait 

    echo "\t creating the bibtex file..."
    bibtex main > "$FPMRT/Versuchsbericht/Version $now/bibtex_log.txt"
    wait

    echo "\t compiling the latex file... (it. 2/3)"
    pdflatex -interaction=nonstopmode main.tex > "$FPMRT/Versuchsbericht/Version $now/latex_log_2.txt"
    wait
    
    echo "\t compiling the latex file... (it. 3/3)"
    pdflatex -interaction=nonstopmode main.tex > "$FPMRT/Versuchsbericht/Version $now/latex_log_3.txt"
    wait
)

echo "Done. The pdf is located at: $FPMRT/Versuchsbericht/Version $now/main.pdf"