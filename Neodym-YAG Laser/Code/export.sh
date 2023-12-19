# Export Skript für einen FP Bericht
# 
# 19.12.2023, Tom Folgmann
# 

# >------- Variablen -------<
export_path="$FPNDYAG/Berichtversionen"

now=$(date +"%d.%m.%Y %H.%M")

# >------- Export -------<
mkdir -p "$export_path/$now"

echo "> Copying files to $now.."
cp -r "$FPNDYAG/Versuchsbericht/" "$export_path/$now/"

(
    cd "$export_path/$now"

    echo "-> compiling latex file .. (it. 1/3)"
    pdflatex -interaction=nonstopmode main.tex > "$export_path/$now/latex_comp_1.txt"
    wait

    echo "-> creating bibtex file .."
    bibtex main > "$export_path/$now/bibtex_comp.txt"
    wait

    echo "-> compiling latex file .. (it. 2/3)"
    pdflatex -interaction=nonstopmode main.tex > "$export_path/$now/latex_comp_2.txt"
    wait

    echo "-> compiling latex file .. (it. 3/3)"
    pdflatex -interaction=nonstopmode main.tex > "$export_path/$now/latex_comp_3.txt"
    wait
)

echo "> Compressing pdf file if necessary.."
(
    cd "$export_path/$now"

    possible_modes=(
        "screen",
        "ebook",
        "printer",
        "prepress",
        "default"
    )

    if [[ $(stat -f%z main.pdf) -gt 10000000 ]]; then
        echo "-> PDF is larger than 10MB. Trying to compress.."

        for mode in "${possible_modes[@]}"; do
            echo "--> Trying mode $mode.."

            gs -sDEVICE=pdfwrite -dCompatibilityLevel=1.4 -dPDFSETTINGS=/$mode -dNOPAUSE -dQUIET -dBATCH -sOutputFile=main_compressed.pdf main.pdf
            if [[ $(stat -c%s main_compressed.pdf) -lt 10000000 ]]; then
                echo "--> Compression successful. PDF size is $(du -h main_compressed.pdf | awk '{print $1}')"

                mv main_compressed.pdf main.pdf
                break
            fi

            echo "--> Compression not effective enough, trying next mode.."
        done
    else
        echo "-> PDF size is $(du -h main.pdf | awk '{print $1}') < 10M, no compression necessary."
        continue
    fi
)

echo "Done. The PDF is located at $export_path/$now/main.pdf"
