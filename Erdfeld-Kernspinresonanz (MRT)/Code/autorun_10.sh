mkdir unusable && mv *.par  *.pt1 unusable

mv T2Fit.txt T2_fit.txt
mv T2withErrors.txt T2_withError.txt
mv T2withError.txt T2_withError.txt

sed 's/\t/,/g' data.txt > data_comma.txt

gnuplot -p -e "filename='data_comma.txt'; outputname='data.svg'; legname='data'" "$CODEMRI"/DotPlot.gp
gnuplot -p -e "filename='T2_fit.txt'; outputname='T2_fit.svg'; legname='T2 Fit'" "$CODEMRI"/BasicPlot.gp

sh "$CODEMRI/plot.sh" -ep
sh "$CODEMRI/plot.sh" -f -lr 100000000
sh "$CODEMRI/plot.sh" -s -lr 50
